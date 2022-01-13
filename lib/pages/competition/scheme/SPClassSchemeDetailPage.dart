import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassSchemeDetailEntity.dart';
import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/pages/common/SPClassDialogUtils.dart';
import 'package:sport/pages/common/SPClassShareView.dart';
import 'package:sport/pages/competition/detail/SPClassMatchDetailPage.dart';
import 'package:sport/pages/home/SPClassSchemeItemView.dart';
import 'package:sport/pages/hot/SPClassComplainPage.dart';
import 'package:sport/pages/user/SPClassRechargeDiamondPage.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:sport/utils/colors.dart';
import 'package:sport/utils/common.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:ui';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassSchemeDetailPage extends StatefulWidget {
  SPClassSchemeDetailEntity spProSchemeDetail;

  SPClassSchemeDetailPage(this.spProSchemeDetail);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassSchemeDetailPageState();
  }
}

class SPClassSchemeDetailPageState extends State<SPClassSchemeDetailPage> {
  WebViewController spProWebViewController;
  double spProWebHeight = 0.4;
  Timer spProTimer = null;
  StreamSubscription<String> spProUserSubscription;
  int Hour = 0;
  int Mimuite = 0;
  int Second = 0;
  List<SPClassSchemeListSchemeList> spProSchemeListself = List();
  List<SPClassSchemeListSchemeList> spProSchemeListmatch = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunDownCount();
    spProUserSubscription =
        SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if (event == "expert:follow") {
        spFunUpDataScheme();
      }
    });

    spFunOnRefreshSelf();
    spFunOnRefreshMatch();

    SPClassApiManager.spFunGetInstance().spFunLogAppEvent(
        spProEventName: "view_scheme",
        targetId: widget.spProSchemeDetail.scheme.spProSchemeId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (spProTimer != null) {
      spProTimer.cancel();
    }
    if (spProUserSubscription != null) {
      spProUserSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              width: ScreenUtil.screenWidth,
              child: SPClassEncryptImage.asset(
                SPClassImageUtil.spFunGetImagePath("ditu1"),
              ),
            ),
            Column(
              children: <Widget>[
                // 导航栏
                appBarWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: width(15),right: width(15),bottom: width(23)),
                            child: Column(
                              children: <Widget>[
                                autoInfo(),
                                SizedBox(height: width(12),),
                                ///
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(width(7)),
                                    boxShadow:[
                                      BoxShadow(
                                        offset: Offset(2,5),
                                        color: Color(0x0D000000),
                                        blurRadius:width(6,),),
                                      BoxShadow(
                                        offset: Offset(-5,1),
                                        color: Color(0x0D000000),
                                        blurRadius:width(6,),
                                      )
                                    ],
                                  ),
                                  width: ScreenUtil.screenWidth,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top:width(15),bottom:width(15),left:width(15),right: width(15) ),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:[
                                              Expanded(
                                                child:(widget.spProSchemeDetail.scheme.title==null||widget.spProSchemeDetail.scheme.title.isEmpty)? SizedBox():  Text(widget.spProSchemeDetail.scheme.title,style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: sp(15)),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                              ),

                                            ]
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                                        ),

                                      ),
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left:width(15),right:width(15),top: width(26),bottom: width(12)),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                matchInfoTop(),
                                                SizedBox(height: width(18),),
                                                matchInfoWidget(),
                                                scoreWidget(),
                                                schemeContent(),
                                                Visibility(
                                                  visible: widget.spProSchemeDetail.scheme.spProCanReturn&&(widget.spProSchemeDetail.spProCanViewAll!=1),
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: width(15)),
                                                    child: RichText(
                                                      text: TextSpan(
                                                          style: TextStyle(fontSize: sp(12),color: MyColors.grey_99),
                                                          text: "此方案享有不中退特权，若比赛结果方案不一致，在比赛后",
                                                          children: [
                                                            TextSpan(
                                                                text: "两小时自动返回",
                                                              style: TextStyle(fontSize: sp(12),color: Color(0xFFEB3E1C)),
                                                            ),
                                                            TextSpan(
                                                                text: "账户，请注意查收。",
                                                              style: TextStyle(fontSize: sp(12),color: MyColors.grey_99),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                (widget.spProSchemeDetail.spProCanViewAll!=1&&double.parse(widget.spProSchemeDetail.scheme.spProBuyUserNum)>0)?Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(widget.spProSchemeDetail.scheme.spProBuyUserNum+"人付费",style: TextStyle(color: Color(0xFF888888),fontSize: sp(12)),),
                                                    SizedBox(width: width(5),),

                                                    spFunBuildImagesStack(widget.spProSchemeDetail.scheme.spProBuyUserList),

                                                    SizedBox(width: (width(10.5)*(widget.spProSchemeDetail.scheme.spProBuyUserList.length>10?10:widget.spProSchemeDetail.scheme.spProBuyUserList.length))),
                                                    Text(widget.spProSchemeDetail.scheme.spProBuyUserList.length>10?"・・・":"",style: TextStyle(color: Color(0xFF888888),fontSize: sp(12)),),

                                                  ],
                                                ):SizedBox(),
                                                Container(
                                                  padding: EdgeInsets.only(top: width(10)),
                                                  margin: EdgeInsets.only(top: width(10)),
                                                  decoration: BoxDecoration(
                                                      border:Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.info_outline,color: Color(0xFF303133),size: width(15),),
                                                      SizedBox(width: width(4),height:width(20)),
                                                      Text("文章供参考，不代表平台观点，投注需谨慎",style: TextStyle(color: Color(0xFF303133),fontSize: sp(10)),),
                                                      SizedBox(width: width(3),),
                                                      Expanded(
                                                        child: SizedBox(),
                                                      ),
                                                      GestureDetector(
                                                        child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_compain"),width: width(17),color: Color(0xFF999999)),
                                                              SizedBox(width: width(3),),
                                                              Text("举报",style: TextStyle(fontSize: sp(12),color: Color(0xFF999999)))]),
                                                        onTap: (){
                                                          if(spFunIsLogin(context:context)){
                                                            SPClassNavigatorUtils.spFunPushRoute(context, SPClassComplainPage(spProComplainType: "scheme",spProComplainedId: widget.spProSchemeDetail.scheme.spProSchemeId,));
                                                          }
                                                        },)
                                                    ],

                                                  ),
                                                )

                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right:  width(13) ,
                                            child: SPClassEncryptImage.asset(
                                              (widget.spProSchemeDetail.scheme.spProIsWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_result_red"):
                                              (widget.spProSchemeDetail.scheme.spProIsWin=="0")? SPClassImageUtil.spFunGetImagePath("ic_result_hei"):
                                              (widget.spProSchemeDetail.scheme.spProIsWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_result_zou"):"",
                                              width: width(40),
                                            ),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(height: width(6),color: Color(0xFFF2F2F2),),
                          ///该专家其他推荐
                          // recommendOtherScheme(),
                          ///其他专家本场推荐
                          recommendOtherExpert(),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomWidget(),
    );
    // TODO: implement build
  }

  Widget appBarWidget(){
    return Container(
      margin:
      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Commons.getAppBar(
        title: '方案详情',
        appBarLeft: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            size: width(20),
            color: Colors.white,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        appBarRight: Row(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.all(width(7)),
                alignment: Alignment.center,
                child: SPClassEncryptImage.asset(
                  widget.spProSchemeDetail.scheme.collected == "1"
                      ? SPClassImageUtil.spFunGetImagePath(
                      'ic_match_favorite')
                      : SPClassImageUtil.spFunGetImagePath(
                      'ic_match_un_favorite'),
                  width: width(23),
                  color:
                  widget.spProSchemeDetail.scheme.collected ==
                      "1"
                      ? Colors.white
                      : null,
                ),
              ),
              onTap: () {
                if (widget.spProSchemeDetail.scheme.collected !=
                    "1") {
                  SPClassApiManager.spFunGetInstance()
                      .spFunAddCollect(
                      context: context,
                      queryParameters: {
                        "target_id": widget.spProSchemeDetail
                            .scheme.spProSchemeId,
                        "target_type": "scheme"
                      },
                      spProCallBack: SPClassHttpCallBack<
                          SPClassBaseModelEntity>(
                          spProOnSuccess: (result) {
                            SPClassToastUtils.spFunShowToast(
                                msg: "关注成功");
                            setState(() {
                              widget.spProSchemeDetail.scheme
                                  .collected = "1";
                            });
                          }));
                } else {
                  SPClassApiManager.spFunGetInstance()
                      .spFunCancelCollect(
                      context: context,
                      queryParameters: {
                        "target_id": widget.spProSchemeDetail
                            .scheme.spProSchemeId,
                        "target_type": "scheme"
                      },
                      spProCallBack: SPClassHttpCallBack<
                          SPClassBaseModelEntity>(
                          spProOnSuccess: (result) {
                            setState(() {
                              widget.spProSchemeDetail.scheme
                                  .collected = "0";
                            });
                          }));
                }
              },
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: width(16), right: width(15)),
                child: SPClassEncryptImage.asset(
                  SPClassImageUtil.spFunGetImagePath(
                      "ic_sheme_sahre"),
                  width: width(23),
                ),
              ),
              onTap: () {
                SPClassApiManager.spFunGetInstance().spFunShare(
                    context: context,
                    type: "scheme",
                    spProSchemeId: widget
                        .spProSchemeDetail.scheme.spProSchemeId,
                    spProCallBack: SPClassHttpCallBack(
                        spProOnSuccess: (result) {
                          showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SPClassShareView(
                                  spProSchemeId: widget
                                      .spProSchemeDetail
                                      .scheme
                                      .spProSchemeId,
                                  title: result.title,
                                  spProDesContent: result.content,
                                  spProPageUrl: result.spProPageUrl,
                                  spProIconUrl: result.spProIconUrl,
                                );
                              });
                        }));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget autoInfo(){
    return GestureDetector(
      onTap: () {
        if (spFunIsLogin(context: context)) {
          SPClassApiManager.spFunGetInstance()
              .spFunExpertInfo(
              queryParameters: {
                "expert_uid": widget
                    .spProSchemeDetail.scheme.spProUserId
              },
              context: context,
              spProCallBack: SPClassHttpCallBack(
                  spProOnSuccess: (info) {
                    SPClassNavigatorUtils.spFunPushRoute(
                        context,
                        SPClassExpertDetailPage(info));
                  }));
        }
      },
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              // border: Border.all(width: 2,color: Colors.white),
              borderRadius:
              BorderRadius.circular(width(150)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(width(2)),
            child: ClipOval(
              child: (widget.spProSchemeDetail.scheme
                  .expert?.spProAvatarUrl ==
                  null ||
                  widget.spProSchemeDetail.scheme
                      .expert.spProAvatarUrl.isEmpty)
                  ? SPClassEncryptImage.asset(
                SPClassImageUtil.spFunGetImagePath(
                    "ic_default_avater"),
                width: width(46),
                height: width(46),
              )
                  : Image.network(
                widget.spProSchemeDetail.scheme
                    .expert.spProAvatarUrl,
                width: width(46),
                height: width(46),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: width(6)),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.spProSchemeDetail.scheme.expert
                        .spProNickName,
                    style: TextStyle(
                        fontSize: sp(15),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: width(4),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${widget.spProSchemeDetail.scheme.expert.intro}',
                          style: TextStyle(
                            fontSize: sp(12),
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: width(9)),
                        color: Colors.white,
                        height: height(width(8)),
                        width: width(0.5),
                      ),
                      Text(
                        '粉丝：${widget.spProSchemeDetail.scheme.expert.spProFollowerNum}',
                        style: TextStyle(
                          fontSize: sp(12),
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // 关注
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width(13),vertical: width(6)),
                decoration: BoxDecoration(
                    color: widget.spProSchemeDetail.scheme.expert.spProIsFollowing?Colors.transparent:Colors.white,
                    borderRadius: BorderRadius.circular(width(13)),
                    border: Border.all(width: width(1),color: widget.spProSchemeDetail.scheme.expert.spProIsFollowing?Color.fromRGBO(255, 255, 255, 0.6):Colors.transparent)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(widget.spProSchemeDetail.scheme.expert.spProIsFollowing? Icons.check:Icons.add,color: widget.spProSchemeDetail.scheme.expert.spProIsFollowing?Color.fromRGBO(255, 255, 255, 0.6):MyColors.main1,size: width(12),),
                    Text( widget.spProSchemeDetail.scheme.expert.spProIsFollowing? "已关注":"关注",style: TextStyle(fontSize: sp(12),color:widget.spProSchemeDetail.scheme.expert.spProIsFollowing? Color.fromRGBO(255, 255, 255, 0.6):MyColors.main1),),

                  ],
                ),
              ),
              onTap: (){
                if(spFunIsLogin(context: context)){
                  SPClassApiManager.spFunGetInstance().spFunFollowExpert(isFollow: !widget.spProSchemeDetail.scheme.expert.spProIsFollowing,spProExpertUid: widget.spProSchemeDetail.scheme.spProUserId,context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                      spProOnSuccess: (result){
                        if(!widget.spProSchemeDetail.scheme.expert.spProIsFollowing){
                          SPClassToastUtils.spFunShowToast(msg: "关注成功");
                          widget.spProSchemeDetail.scheme.expert.spProIsFollowing=true;
                        }else{
                          widget.spProSchemeDetail.scheme.expert.spProIsFollowing=false;
                        }
                        if(mounted){
                          setState(() {});
                        }
                      }
                  ));
                }
              }
          ),
        ],
      ),
    );
  }

//  详情的顶部
  Widget matchInfoTop(){
    return  Row(
        children: <Widget>[
          Expanded(
            flex:2,
            child:Text(widget.spProSchemeDetail.spProGuessMatch.spProLeagueName+ ((widget.spProSchemeDetail.scheme.spProPlayingWay=="总时长"||widget.spProSchemeDetail.scheme.spProPlayingWay=="总击杀")? ("第"+widget.spProSchemeDetail.scheme.spProBattleIndex+"局"):""),style:TextStyle(color:MyColors.grey_99,fontSize: width(12) ),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              (spProTimer==null||widget.spProSchemeDetail.spProCanViewAll==1)? SizedBox():
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("距开赛",style: TextStyle(fontSize: sp(12),color: MyColors.grey_99),),
                  SizedBox(width: width(5),),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:MyColors.grey_66,
                        borderRadius: BorderRadius.circular(width(4))
                    ),
                    height: width(17),
                    width: width(17),
                    child:Text(Hour.toString(),style: TextStyle(fontSize: sp(12),color: Colors.white),),
                  ),
                  SizedBox(width: width(3),),
                  Text(":",style: TextStyle(fontSize: sp(12),color:MyColors.grey_66,)),
                  SizedBox(width: width(3),),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:MyColors.grey_66,
                        borderRadius: BorderRadius.circular(width(4))
                    ),
                    height: width(17),
                    width: width(17),
                    child:Text(Mimuite.toString(),style: TextStyle(fontSize: sp(12),color:  Colors.white),),
                  ),
                  SizedBox(width: width(3),),
                  Text(":",style: TextStyle(fontSize: sp(12),color:MyColors.grey_66,)),
                  SizedBox(width: width(3),),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:MyColors.grey_66,
                        borderRadius: BorderRadius.circular(width(4))
                    ),
                    height: width(17),
                    width: width(17),
                    child:Text(Second.toString(),style: TextStyle(fontSize: sp(12),color: Colors.white),),
                  ),
                ],)
            ],
          )
        ]
    );
  }

  Widget matchInfoWidget(){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child:Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.spProSchemeDetail.spProGuessMatch.spProIconUrlOne.isEmpty ?
                    SPClassEncryptImage.asset(
                      SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                      fit: BoxFit.cover,
                      width: width(54),
                      height: width(54),
                    ): Image.network(
                      widget.spProSchemeDetail.spProGuessMatch.spProIconUrlOne,
                      fit: BoxFit.cover,
                      width: width(54),
                      height: width(54),
                    ),
                    SizedBox(height: width(5),),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child:Text(widget.spProSchemeDetail.spProGuessMatch.spProTeamOne,style: TextStyle(fontSize: sp(15),color: Color(0xFF333333),fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: width(6),right: width(6)),
                child: Column(
                  children: <Widget>[
                    Text(SPClassDateUtils.spFunDateFormatByString(widget.spProSchemeDetail.spProGuessMatch.spProStTime, "MM-dd HH:mm"),style: TextStyle(fontSize: sp(12),color: MyColors.grey_99),),

                    Text(!(widget.spProSchemeDetail.spProGuessMatch.spProIsOver=="1") ?"VS":(widget.spProSchemeDetail.spProGuessMatch.spProScoreOne +"-"+ widget.spProSchemeDetail.spProGuessMatch.spProScoreTwo),style: TextStyle(fontSize: sp(17),fontWeight: FontWeight.w500,
                        color: !(widget.spProSchemeDetail.spProGuessMatch.spProIsOver=="1") ? Color(0xFF666666):Color(0xFFE3494B)),),
                    SizedBox(height: width(7),),
                    Container(
                      padding: EdgeInsets.only(left: width(8),right: width(8)),
                      decoration: BoxDecoration(
                        // border: Border.all(color: SPClassMatchDataUtils.getFontColors(widget.spProSchemeDetail.scheme.spProGuessType, widget.spProSchemeDetail.scheme.spProMatchType, widget.spProSchemeDetail.scheme.spProPlayingWay),width: 0.5),
                          color: SPClassMatchDataUtils.getColors(widget.spProSchemeDetail.scheme.spProGuessType, widget.spProSchemeDetail.scheme.spProMatchType, widget.spProSchemeDetail.scheme.spProPlayingWay),
                          borderRadius: BorderRadius.circular(width(4))
                      ),
                      child: Text("${SPClassMatchDataUtils.spFunPayWayName(widget.spProSchemeDetail.scheme.spProGuessType, widget.spProSchemeDetail.scheme.spProMatchType, widget.spProSchemeDetail.scheme.spProPlayingWay)}",style: TextStyle(color:SPClassMatchDataUtils.getFontColors(widget.spProSchemeDetail.scheme.spProGuessType, widget.spProSchemeDetail.scheme.spProMatchType, widget.spProSchemeDetail.scheme.spProPlayingWay),fontSize: sp(13),),),
                    )

                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.spProSchemeDetail.spProGuessMatch.spProIconUrlTwo.isEmpty ?
                    SPClassEncryptImage.asset(
                      SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                      fit: BoxFit.cover,
                      width: width(54),
                      height: width(54),
                    ): Image.network(
                      widget.spProSchemeDetail.spProGuessMatch.spProIconUrlTwo,
                      fit: BoxFit.cover,
                      width: width(54),
                      height: width(54),
                    ),
                    SizedBox(height: width(4),),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child:Text(widget.spProSchemeDetail.spProGuessMatch.spProTeamTwo,style: TextStyle(fontSize: sp(15),color: Color(0xFF333333),fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height(13),),


        ],
      ),
      onTap: (){


        SPClassApiManager.spFunGetInstance().spFunSportMatchData<SPClassGuessMatchInfo>(loading: true,context: context,spProGuessMatchId:widget.spProSchemeDetail.scheme.spProGuessMatchId,dataKeys: "guess_match",spProCallBack: SPClassHttpCallBack(
            spProOnSuccess: (result) async {
              SPClassNavigatorUtils.spFunPushRoute(context, SPClassMatchDetailPage(result,spProMatchType:"guess_match_id",spProInitIndex: 1,));
            }
        ) );

      },
    );
  }

  //  比分
  Widget scoreWidget() {
    return Visibility(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: width(31)),
        child:  Row(
          children: <Widget>[
            Visibility(
              visible: (widget.spProSchemeDetail.scheme.spProPlayingWay.contains("让球")&&(widget.spProSchemeDetail.scheme.spProGuessType =="竞彩")),
              child: Container(
                margin: EdgeInsets.only(right: width(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(double.parse(widget.spProSchemeDetail.scheme.spProAddScore) ==0
                        ? "0": double.parse(widget.spProSchemeDetail.scheme.spProAddScore) >0
                        ? ("+"+SPClassStringUtils.spFunSqlitZero(widget.spProSchemeDetail.scheme.spProAddScore)): SPClassStringUtils.spFunSqlitZero(widget.spProSchemeDetail.scheme.spProAddScore),style: TextStyle(fontSize: sp(13),color: Color(0xFF333333),),)
                  ],
                ),
              ),
            ),
            Expanded(
              child:Container(
                alignment: Alignment.center,
                  child:widget.spProSchemeDetail.scheme.spProPlayingWay.contains("大小") ?
                  guessItem(
                      text1: '大',
                      value1: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),
                      text2: '总',
                      value2: SPClassStringUtils.spFunSqlitZero(SPClassStringUtils.spFunPanKouData(widget.spProSchemeDetail.scheme.spProMidScore).replaceAll("+", "")),
                      text3: '小',
                      value3: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),
                      supportWhich:widget.spProSchemeDetail.scheme.spProSupportWhich,
                      supportWhich2: widget.spProSchemeDetail.scheme.spProSupportWhich2,
                      whichWin: widget.spProSchemeDetail.scheme.spProWhichWin
                  )
                      :
                  (widget.spProSchemeDetail.scheme.spProPlayingWay=="让球胜负")?
                  guessItem(
                    text1: '主胜',
                    value1: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),
                    text2: '让',
                    value2: SPClassStringUtils.spFunPanKouData(widget.spProSchemeDetail.scheme.spProAddScore),
                    text3: '主负',
                    value3: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),
                    supportWhich:widget.spProSchemeDetail.scheme.spProSupportWhich,
                    supportWhich2: widget.spProSchemeDetail.scheme.spProSupportWhich2,
                    whichWin: widget.spProSchemeDetail.scheme.spProWhichWin
                  ):
                  (widget.spProSchemeDetail.scheme.spProPlayingWay=="让分胜负"||widget.spProSchemeDetail.scheme.spProPlayingWay=="让局胜负")?
                  guessItem(
                      text1: widget.spProSchemeDetail.scheme.spProMatchType.toLowerCase()=="lol" ? (widget.spProSchemeDetail.spProGuessMatch.spProTeamOne):"主队",
                      value1: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),
                      text2: '让',
                      value2: SPClassStringUtils.spFunSqlitZero(SPClassStringUtils.spFunPanKouData(widget.spProSchemeDetail.scheme.spProAddScore,)),
                      text3: widget.spProSchemeDetail.scheme.spProMatchType.toLowerCase()=="lol" ?(widget.spProSchemeDetail.spProGuessMatch.spProTeamTwo):"客队",
                      value3: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),
                      supportWhich:widget.spProSchemeDetail.scheme.spProSupportWhich,
                      supportWhich2: widget.spProSchemeDetail.scheme.spProSupportWhich2,
                      whichWin: widget.spProSchemeDetail.scheme.spProWhichWin
                  ) :
                  (widget.spProSchemeDetail.scheme.spProPlayingWay=="总时长"||widget.spProSchemeDetail.scheme.spProPlayingWay=="总击杀")?
                  guessItem(
                      text1: '大于',
                      value1: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),
                      text2: '',
                      value2: (SPClassStringUtils.spFunSqlitZero(widget.spProSchemeDetail.scheme.spProMidScore)+(widget.spProSchemeDetail.scheme.spProPlayingWay=="总时长"? "分钟":"")),
                      text3: '小于',
                      value3: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),
                      supportWhich:widget.spProSchemeDetail.scheme.spProSupportWhich,
                      supportWhich2: widget.spProSchemeDetail.scheme.spProSupportWhich2,
                      whichWin: widget.spProSchemeDetail.scheme.spProWhichWin
                  ):
                  guessItem(
                      text1: widget.spProSchemeDetail.scheme.spProMatchType.toLowerCase()=="lol" ?widget.spProSchemeDetail.spProGuessMatch.spProTeamOne:"胜",
                      value1: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),
                      text2: widget.spProSchemeDetail.scheme.spProPlayingWay.contains("平")? "平":"",
                      value2: widget.spProSchemeDetail.scheme.spProDrawOdds,
                      text3:  widget.spProSchemeDetail.scheme.spProMatchType.toLowerCase()=="lol" ?widget.spProSchemeDetail.spProGuessMatch.spProTeamTwo:"负",
                      value3: double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),
                      supportWhich:widget.spProSchemeDetail.scheme.spProSupportWhich,
                      supportWhich2: widget.spProSchemeDetail.scheme.spProSupportWhich2,
                      whichWin: widget.spProSchemeDetail.scheme.spProWhichWin
                  )
                ,),),
          ],
        ),
      ),
      visible: widget.spProSchemeDetail.spProCanViewAll==1,
    );
  }

  Widget schemeContent(){
    return (widget.spProSchemeDetail.spProCanViewAll!=1)?
    GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_text_blur"),
            width: ScreenUtil.screenWidth,
            height: width(93),
          ),
          Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width(7)),
                    color: MyColors.main1,
                  ),
                  width: width(132),
                  height: width(36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SPClassEncryptImage.asset(
                        SPClassImageUtil.spFunGetImagePath("lock"),
                        width: width(23),
                      ),
                      Text("购买方案",style: TextStyle(fontSize: sp(13),color: Colors.white),),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SPClassEncryptImage.asset(
                    (widget.spProSchemeDetail.scheme.spProCanReturn) ? SPClassImageUtil.spFunGetImagePath("ic_can_return"):"",
                    width: width(37),
                  ),
                ),

              ]
          )

        ],
      ),
      onTap: (){
        spFunShowConfirmDialog();
      },
    ):
    Padding(
      padding: EdgeInsets.symmetric(horizontal: width(9)),
      child:  MarkdownBody(
        shrinkWrap: true,
        fitContent: true,
        data: html2md.convert(widget.spProSchemeDetail.spProCanViewAll==1? widget.spProSchemeDetail.scheme.spProSchemeDetail:widget.spProSchemeDetail.scheme.summary),
      ),
    );
  }

  // 该专家其他推荐
  Widget recommendOtherScheme(){
    return spProSchemeListself.length==0?SizedBox():   Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width(7)),
        boxShadow:[
          BoxShadow(
            offset: Offset(2,5),
            color: Color(0x0D000000),
            blurRadius:width(6,),),
          BoxShadow(
            offset: Offset(-5,1),
            color: Color(0x0D000000),
            blurRadius:width(6,),
          )
        ],
      ),
      width: ScreenUtil.screenWidth,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: height(35),
            padding: EdgeInsets.only(left: width(13),right: width(13)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: height(4),
                  height: height(15),
                  decoration: BoxDecoration(
                      color: Color(0xFFDE3C31),
                      borderRadius: BorderRadius.circular(100)
                  ),
                ),
                SizedBox(width: 4,),
                Text("该专家的其他推荐",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(16)),),
                Text(" "+spProSchemeListself.length.toString(),style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(14),textStyle: TextStyle(color: Color(0xFFDE3C31))),),

              ],
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: width(5)),
              itemCount: spProSchemeListself.length,
              itemBuilder: (c,index){
                var item=spProSchemeListself[index];
                return SPClassSchemeItemView(item,spProShowLine:spProSchemeListself.length>(index+1) ,);
              })
        ],
      ),
    );
  }

//  其他专家本场推荐
  Widget recommendOtherExpert(){
    return spProSchemeListmatch.length==0?SizedBox(): Container(
      color: Colors.white,
      width: ScreenUtil.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: width(15),bottom: width(12),top: width(23)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
            ),
            child: Text("本场其他推荐",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.bold,fontSize: width(17)),),

          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: width(5)),
              itemCount: spProSchemeListmatch.length,
              itemBuilder: (c,index){
                var item=spProSchemeListmatch[index];
                return SPClassSchemeItemView(item,spProShowLine:spProSchemeListmatch.length>(index+1) ,);
              })
        ],
      ),
    );
  }

  Widget bottomWidget(){
    return (widget.spProSchemeDetail.spProCanViewAll!=1)?Container(
      color: Color(0xFFF5F6F7),
      height: width(46),
      child: Row(
        children: <Widget>[
          SizedBox(width:width(15) ,),
          Text('需支付:',style: TextStyle(fontSize: sp(15)),),
          SPClassEncryptImage.asset(
            SPClassImageUtil.spFunGetImagePath("zhuanshi"),
            width: width(17),
          ),
          Text(
            '${widget.spProSchemeDetail.scheme.spProDiamond}',
            style: TextStyle(
                color: MyColors.main1, fontSize: sp(13)),
          ),
          SizedBox(width:width(19) ,),
          Expanded(
            child: Text(
              widget.spProSchemeDetail.scheme.spProCanReturn&&(widget.spProSchemeDetail.spProCanViewAll!=1)?'不中包退':'',
              style: TextStyle(
                  color: Color(0xFFEB3E1C), fontSize: sp(15),fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: (){
              spFunShowConfirmDialog();
            },
            child: Stack(
              children: <Widget>[
                SPClassEncryptImage.asset(
                  SPClassImageUtil.spFunGetImagePath("zhifubg"),
                  height: width(46),
                ),
                Positioned(
                  right: width(21),
                  child: Container(
                    height: width(46),
                    alignment: Alignment.center,
                    child: Text(
                      '立即支付',
                      style: TextStyle(
                        color: Colors.white, fontSize: sp(15),),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ):null;
  }

  Widget guessItem({String text1,String value1,String text2,String value2,String text3,String value3,String supportWhich,String supportWhich2,String whichWin}){
    return Expanded(
      child: Row(
        children: <Widget>[
          Expanded(
            child:Container(
              height: width(43),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: supportWhich=="1"?MyColors.main1:Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.all(Radius.circular(4))
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: width(43),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("$text1",style: TextStyle(fontSize: sp(12),color:supportWhich=="1"? Colors.white :Color(0xFF303133)),),
                        Text("$value1",style: TextStyle(fontSize: sp(12),color:supportWhich=="1"? Colors.white : Color(0xFF303133)),),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SPClassEncryptImage.asset(
                      (whichWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                      width: width(18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: width(4),),
          Expanded(
            child: Container(
              height: width(43),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.all(Radius.circular(4))
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: width(43),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('$text2',style: TextStyle(fontSize: sp(12),color:(supportWhich=="0"||supportWhich2=="0")? Colors.white : Color(0xFF303133)),),
                        Text('$value2',style: TextStyle(fontSize: sp(12),color:(supportWhich=="0"||supportWhich2=="0")? Colors.white : Color(0xFF303133)),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: width(4),),
          Expanded(
            child: Container(
              height: width(43),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: (supportWhich=="2"||supportWhich2=="2")?MyColors.main1:Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.all(Radius.circular(4))
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: width(43),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("$text3",style: TextStyle(fontSize: sp(12),color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2")? Colors.white : Color(0xFF303133)),),
                        Text("$value3",style: TextStyle(fontSize: sp(12),color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2")? Colors.white :Color(0xFF303133)),),

                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SPClassEncryptImage.asset(
                      (whichWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                      width: width(18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  void spFunShowConfirmDialog() {
    SPClassDialogUtils.spFunShowConfirmDialog(
        context,
        Text('本次购买需消耗${widget.spProSchemeDetail.scheme.spProDiamond}钻石，是否确认购买？',style: TextStyle(fontSize: sp(17), color: Color(0xFF333333)),textAlign: TextAlign.center,)
        /*RichText(
          text: TextSpan(
            text: "确认后将扣除",
            style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
            children: <TextSpan>[
              TextSpan(
                  text: widget.spProSchemeDetail.scheme.spProDiamond,
                  style: TextStyle(fontSize: 16, color: Color(0xFFE3494B))),
              TextSpan(text: "钻石"),
            ],
          ),
        )*/, () {
      SPClassApiManager.spFunGetInstance().spFunSchemeBuy(
          queryParameters: {
            "scheme_id": widget.spProSchemeDetail.scheme.spProSchemeId
          },
          context: context,
          spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
              spProOnSuccess: (value) {
            spFunUpDataScheme();
          }, onError: (value) {
            if (value.code == "200") {
              SPClassNavigatorUtils.spFunPushRoute(
                  context, SPClassRechargeDiamondPage());
            }
          }));
    });
  }

  void spFunDownCount() {
    spProTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      spFunRefreshTimer();
    });
    spFunRefreshTimer();
  }

  void spFunUpDataScheme() {
    SPClassApiManager.spFunGetInstance().spFunSchemeDetail(
        queryParameters: {
          "scheme_id": widget.spProSchemeDetail.scheme.spProSchemeId
        },
        context: context,
        spProCallBack: SPClassHttpCallBack<SPClassSchemeDetailEntity>(
            spProOnSuccess: (value) {
          if (mounted) {
            setState(() {
              widget.spProSchemeDetail = value;
            });
          }
        }));
  }

  void spFunRefreshTimer() {
    DateTime nowTime = DateTime.now();

    Duration duration =
        DateTime.parse(widget.spProSchemeDetail.spProGuessMatch.spProStTime)
            .difference(nowTime);

    Hour = (duration.inHours);
    Mimuite = (duration.inMinutes - ((duration.inHours * 60)));
    Second = (duration.inSeconds - (duration.inMinutes * 60));

    if (Hour <= 0 && Mimuite <= 0 && Second <= 0) {
      spProTimer.cancel();
      this.spProTimer = null;
    }
    if (mounted) {
      setState(() {});
    }
  }

  void spFunOnRefreshSelf() {
    SPClassApiManager.spFunGetInstance().spFunSchemeList(
        queryParameters: {
          "expert_uid": widget.spProSchemeDetail.scheme.spProUserId,
          "page": "1",
          "is_over": "0",
          "fetch_type": "expert"
        },
        spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
            spProOnSuccess: (list) {
              var item;
              list.spProSchemeList.forEach((itemx) {
                if (itemx.spProSchemeId ==
                    widget.spProSchemeDetail.scheme.spProSchemeId) {
                  item = itemx;
                }
              });
              if (item != null) {
                list.spProSchemeList.remove(item);
              }
              if (mounted) {
                setState(() {
                  spProSchemeListself = list.spProSchemeList;
                });
              }
            },
            onError: (value) {}));
  }

  void spFunOnRefreshMatch() {
    SPClassApiManager.spFunGetInstance().spFunSchemeList(
        queryParameters: {
          "guess_match_id": widget.spProSchemeDetail.scheme.spProGuessMatchId,
          "page": "1",
          "is_over": "0",
          "fetch_type": "guess_match"
        },
        spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
            spProOnSuccess: (list) {
              var item;
              list.spProSchemeList.forEach((itemx) {
                if (itemx.spProSchemeId ==
                    widget.spProSchemeDetail.scheme.spProSchemeId) {
                  item = itemx;
                }
              });
              if (item != null) {
                list.spProSchemeList.remove(item);
              }
              if (mounted) {
                setState(() {
                  spProSchemeListmatch = list.spProSchemeList;
                });
              }
            },
            onError: (value) {}));
  }

  spFunBuildImagesStack(List<String> imageUrls) {
    if(imageUrls.length==0){
      return SizedBox();
    }
    imageUrls=imageUrls.take(10).toList();
    List<Widget> views=[];

    views.add(Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          border: Border.all(width: 0.4,color: Colors.white)
      ),
      child:  ClipRRect(
        borderRadius: BorderRadius.circular(300),
        child:Image.network(imageUrls[0],
          width: width(21),
          height: width(21) ,
          fit: BoxFit.cover,
        ),
      ),
    ));
    views.addAll(imageUrls.map((e) {
      return Positioned(
        left: width(imageUrls.indexOf(e)*10.5),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(300),
              border: Border.all(width: 0.4,color: Colors.white)
          ),
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(300),
            child:Image.network(e,
              width: width(21),
              height: width(21) ,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList());

    return Stack(
      overflow: Overflow.visible,
      children:views,
    );

  }
}
