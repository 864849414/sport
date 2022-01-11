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
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:ui';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassSchemeDetailPage extends StatefulWidget{
  SPClassSchemeDetailEntity spProSchemeDetail;

  SPClassSchemeDetailPage(this.spProSchemeDetail);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassSchemeDetailPageState();
  }


}

class SPClassSchemeDetailPageState extends State<SPClassSchemeDetailPage>{
  WebViewController spProWebViewController;
  double spProWebHeight=0.4;
  Timer spProTimer=null;
  StreamSubscription<String> spProUserSubscription;
  int Hour=0;
  int Mimuite=0;
  int Second=0;
  List<SPClassSchemeListSchemeList> spProSchemeListself=List();
  List<SPClassSchemeListSchemeList> spProSchemeListmatch=List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunDownCount();
    spProUserSubscription =SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="expert:follow"){
        spFunUpDataScheme();
      }
    });

    spFunOnRefreshSelf();
    spFunOnRefreshMatch();

    SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "view_scheme",targetId:widget.spProSchemeDetail.scheme.spProSchemeId);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();


    if(spProTimer!=null){
      spProTimer.cancel();
    }
    if(spProUserSubscription!=null){
      spProUserSubscription.cancel();
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios,size: width(20),color: Colors.white,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "方案详情",
          style: TextStyle(fontSize: sp(18)),
        ),
        actions: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(width(7)),
              alignment: Alignment.center,
              child:  SPClassEncryptImage.asset(
                widget.spProSchemeDetail.scheme.collected=="1" ? SPClassImageUtil.spFunGetImagePath('ic_match_favorite'):SPClassImageUtil.spFunGetImagePath('ic_match_un_favorite'),
                width: width(20),
                color: widget.spProSchemeDetail.scheme.collected=="1" ? Colors.white:null,
              ),
            ),
            onTap: (){
              if(widget.spProSchemeDetail.scheme.collected!="1"){
                SPClassApiManager.spFunGetInstance().spFunAddCollect(context: context,queryParameters: {"target_id":widget.spProSchemeDetail.scheme.spProSchemeId,"target_type":"scheme"},spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                    spProOnSuccess: (result){
                      SPClassToastUtils.spFunShowToast(msg:"关注成功");
                      setState(() {
                        widget.spProSchemeDetail.scheme.collected="1";
                      });
                    }
                ));

              }else{
                SPClassApiManager.spFunGetInstance().spFunCancelCollect(context: context,queryParameters: {"target_id":widget.spProSchemeDetail.scheme.spProSchemeId,"target_type":"scheme"},spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                    spProOnSuccess: (result){
                      setState(() {
                        widget.spProSchemeDetail.scheme.collected="0";
                      });
                    }
                ));
              }

            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: width(20),right: width(13)),
              child:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_sheme_sahre"),
                width: width(21),
              ),
            ),
            onTap: (){
              SPClassApiManager.spFunGetInstance().spFunShare(context: context,type: "scheme",spProSchemeId: widget.spProSchemeDetail.scheme.spProSchemeId,spProCallBack: SPClassHttpCallBack(
                  spProOnSuccess: (result){
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SPClassShareView(spProSchemeId:widget.spProSchemeDetail.scheme.spProSchemeId,title: result.title,spProDesContent: result.content,spProPageUrl: result.spProPageUrl,spProIconUrl: result.spProIconUrl,);
                        });
                  }
              ));
            },
          )
        ],
      ),
      body: Container(
        color: Color(0xFFF1F1F1),
        child: Stack(
          children: <Widget>[
            Container(
              width: ScreenUtil.screenWidth,
              height: MediaQuery.of(context).size.height,
              child: Column(
                  children: <Widget>[
                    Container(
                      height: width(132),
                      color: MyColors.main1,
                    )
                  ]
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child:  SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(width(10)),
                      margin: EdgeInsets.only(left: width(13),right:  width(13)),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child:GestureDetector(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.4,color: Colors.grey[200]),
                                                borderRadius: BorderRadius.circular(width(20))),
                                            child:  ClipRRect(
                                              borderRadius: BorderRadius.circular(width(20)),
                                              child:( widget.spProSchemeDetail.scheme.expert?.spProAvatarUrl==null||widget.spProSchemeDetail.scheme.expert.spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                                                SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                                                width: width(40),
                                                height: width(40),
                                              ):Image.network(
                                                widget.spProSchemeDetail.scheme.expert.spProAvatarUrl,
                                                width: width(40),
                                                height: width(40),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: width(5),),
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(widget.spProSchemeDetail.scheme.expert.spProNickName,style: TextStyle(fontSize: sp(14),color: Color(0xFF333333)),maxLines: 1,),
                                                    SizedBox(width: 5,),

                                                    Visibility(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: width(5),right:  width(5),top: width(0.8)),
                                                        alignment: Alignment.center,
                                                        height: width(16),
                                                        constraints: BoxConstraints(
                                                            minWidth: width(52)
                                                        ),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [Color(0xFFF2150C),Color(0xFFF24B0C)]
                                                          ),
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                        child:Text(("近"+widget.spProSchemeDetail.scheme.expert.spProLast10Result.length.toString()+"中"+widget.spProSchemeDetail.scheme.expert.spProLast10CorrectNum),
                                                          style: TextStyle(fontSize: sp(9),color: Colors.white,letterSpacing: 1),),
                                                      ),
                                                      visible:  (widget.spProSchemeDetail.scheme.expert.spProSchemeNum!=null&&(double.tryParse(widget.spProSchemeDetail.scheme.expert.spProLast10CorrectNum)/double.tryParse(widget.spProSchemeDetail.scheme.expert.spProLast10Result.length.toString()))>=0.6),
                                                    ),
                                                    SizedBox(width: 3,),
                                                    int.tryParse( widget.spProSchemeDetail.scheme.expert.spProCurrentRedNum)>2?  Stack(
                                                      children: <Widget>[
                                                        SPClassEncryptImage.asset(widget.spProSchemeDetail.scheme.expert.spProCurrentRedNum.length>1  ? SPClassImageUtil.spFunGetImagePath("ic_recent_red2"):SPClassImageUtil.spFunGetImagePath("ic_recent_red"),
                                                          height:width(16) ,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                        Positioned(
                                                          left: width(widget.spProSchemeDetail.scheme.expert.spProCurrentRedNum.length>1  ? 5:7),
                                                          bottom: 0,
                                                          top: 0,
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            child: Text(widget.spProSchemeDetail.scheme.expert.spProCurrentRedNum,style: GoogleFonts.roboto(textStyle: TextStyle(color:Color(0xFFDE3C31) ,fontSize: sp(14.8),fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: width(7),
                                                          bottom: 0,
                                                          top: 0,
                                                          child: Container(
                                                            padding: EdgeInsets.only(top: width(0.8)),

                                                            alignment: Alignment.center,
                                                            child: Text("连红",style: TextStyle(color:Colors.white ,fontSize: sp(9),fontStyle: FontStyle.italic)),
                                                          ),
                                                        )
                                                      ],
                                                    ):SizedBox()
                                                  ],
                                                ),
                                                Row(children: <Widget>[
                                                  Text(SPClassMatchDataUtils.spFunCalcBestCorrectRate(widget.spProSchemeDetail.scheme.expert.spProLast10Result)<0.7? "":("近期胜率: "+(SPClassMatchDataUtils.spFunCalcBestCorrectRate(widget.spProSchemeDetail.scheme.expert.spProLast10Result)*100).toStringAsFixed(0)+"%"),style: TextStyle(fontSize: sp(11),color: Color(0xFFDE3C31)),)
                                                ],)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                  onTap: (){
                                    if(spFunIsLogin(context: context)){
                                      SPClassApiManager.spFunGetInstance().spFunExpertInfo(queryParameters: {"expert_uid":widget.spProSchemeDetail.scheme.spProUserId},
                                          context:context,spProCallBack: SPClassHttpCallBack(
                                              spProOnSuccess: (info){
                                                SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertDetailPage(info));
                                              }
                                          ));
                                    }
                                  },
                                ),
                              )
                              ,Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(width(2)),
                                              gradient: LinearGradient(
                                                  colors: widget.spProSchemeDetail.scheme.expert.spProIsFollowing? [Color(0xFFC6C6C6),Color(0xFFC6C6C6)]:[Color(0xFFF2150C),Color(0xFFF24B0C)]
                                              ),
                                              boxShadow:widget.spProSchemeDetail.scheme.expert.spProIsFollowing?null:[
                                                BoxShadow(
                                                  offset: Offset(3,3),
                                                  color: Color(0x4DF23B0C),
                                                  blurRadius:width(5,),),
                                                BoxShadow(
                                                  offset: Offset(-2,1),
                                                  color: Color(0x4DF23B0C),
                                                  blurRadius:width(5,),),
                                              ],
                                            ),
                                            width: width(58),
                                            height: width(20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(widget.spProSchemeDetail.scheme.expert.spProIsFollowing? Icons.check:Icons.add,color: Colors.white,size: width(15),),
                                                Text( widget.spProSchemeDetail.scheme.expert.spProIsFollowing? "已关注":"关注",style: TextStyle(fontSize: sp(11),color: Colors.white),),

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
                                  SizedBox(height: 5,),
                                  // Text("粉丝数: +"widget.spProSchemeDetail.scheme.expert.spProFollowerNum,style: TextStyle(fontSize: sp(10),color: Color(0xFF999999)),)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Text(SPClassStringUtils.spFunMaxLength(widget.spProSchemeDetail.scheme.expert.intro,length: 50),style: TextStyle(fontSize: sp(12),color: Color(0xFF666666)))

                        ],
                      ),
                    ),


                    Container(
                      padding: EdgeInsets.only(top:width(10),bottom:width(10)),
                      margin: EdgeInsets.only(left: width(13),right:  width(13),top:width(8),bottom:width(8) ),
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
                            padding: EdgeInsets.only(left: width(10),right: width(10),bottom: width(10)),
                            margin: EdgeInsets.only(bottom:width(6) ),

                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Expanded(
                                    child:(widget.spProSchemeDetail.scheme.title==null||widget.spProSchemeDetail.scheme.title.isEmpty)? SizedBox():  Text(widget.spProSchemeDetail.scheme.title,style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(15)),),
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
                                padding: EdgeInsets.only(left:width(10),right:width(10)),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Row(
                                        children: <Widget>[
                                          Expanded(
                                flex:2,
                                            child:Text(widget.spProSchemeDetail.spProGuessMatch.spProLeagueName+
SPClassMatchDataUtils.spFunPayWayName(widget.spProSchemeDetail.scheme.spProGuessType,widget.spProSchemeDetail.scheme.spProMatchType,widget.spProSchemeDetail.scheme.spProPlayingWay)+((widget.spProSchemeDetail.scheme.spProPlayingWay=="总时长"||widget.spProSchemeDetail.scheme.spProPlayingWay=="总击杀")? ("第"+widget.spProSchemeDetail.scheme.spProBattleIndex+"局"):""),style:TextStyle(color:Color(0xFF333333),fontSize: width(12) ),),
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              (spProTimer==null||widget.spProSchemeDetail.spProCanViewAll==1)? SizedBox():
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("距开赛",style: TextStyle(fontSize: sp(12),color: Color(0xFF333333)),),
                                                  SizedBox(width: width(5),),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color:Color(0xFFDE3C31),
                                                        borderRadius: BorderRadius.circular(width(2))
                                                    ),
                                                    height: width(17),
                                                    width: width(17),
                                                    child:Text(Hour.toString(),style: TextStyle(fontSize: sp(12),color: Colors.white),),
                                                  ),
                                                  SizedBox(width: width(3),),
                                                  Text(":",style: TextStyle(fontSize: sp(12),color:Color(0xFFDE3C31))),
                                                  SizedBox(width: width(3),),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color:Color(0xFFDE3C31),
                                                        borderRadius: BorderRadius.circular(width(2))
                                                    ),
                                                    height: width(17),
                                                    width: width(17),
                                                    child:Text(Mimuite.toString(),style: TextStyle(fontSize: sp(12),color:  Colors.white),),
                                                  ),
                                                  SizedBox(width: width(3),),
                                                  Text(":",style: TextStyle(fontSize: sp(12),color:Color(0xFFDE3C31))),
                                                  SizedBox(width: width(3),),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color:Color(0xFFDE3C31),
                                                        borderRadius: BorderRadius.circular(width(2))
                                                    ),
                                                    height: width(17),
                                                    width: width(17),
                                                    child:Text(Second.toString(),style: TextStyle(fontSize: sp(12),color: Colors.white),),
                                                  ),
                                                ],)
                                            ],
                                          )
                                        ]
                                    ),
                                    SizedBox(height: height(13),),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      child:Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(height: height(5),),
                                                    widget.spProSchemeDetail.spProGuessMatch.spProIconUrlOne.isEmpty ?
                                                    SPClassEncryptImage.asset(
                                                      SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                                                      fit: BoxFit.cover,
                                                      width: width(30),
                                                      height: width(30),
                                                    ): Image.network(
                                                      widget.spProSchemeDetail.spProGuessMatch.spProIconUrlOne,
                                                      fit: BoxFit.cover,
                                                      width: width(30),
                                                      height: width(30),
                                                    ),
                                                    SizedBox(height: height(5),),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:     Text(widget.spProSchemeDetail.spProGuessMatch.spProTeamOne,style: TextStyle(fontSize: sp(13),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
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
                                                    Text(SPClassDateUtils.spFunDateFormatByString(widget.spProSchemeDetail.spProGuessMatch.spProStTime, "MM-dd HH:mm"),style: TextStyle(fontSize: sp(12),color: Color(0xFF888888)),),

                                                    Text(!(widget.spProSchemeDetail.spProGuessMatch.spProIsOver=="1") ?"VS":(widget.spProSchemeDetail.spProGuessMatch.spProScoreOne +"-"+ widget.spProSchemeDetail.spProGuessMatch.spProScoreTwo),style: TextStyle(fontSize: sp(20),fontWeight: FontWeight.bold,
                                                        color: !(widget.spProSchemeDetail.spProGuessMatch.spProIsOver=="1") ? Color(0xFF666666):Color(0xFFE3494B)),),
                                                    Container(
                                                      width: width(58),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color:Color(0xFFDE3C31),width: 0.4),
                                                          borderRadius: BorderRadius.circular(width(2))
                                                      ),
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(top: width(2),bottom: width(2)),
                                                      child: Text("赛事详情",style: TextStyle(fontSize: sp(10),color: Color(0xFFDE3C31)),),

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
                                                    SizedBox(height: height(5),),
                                                    widget.spProSchemeDetail.spProGuessMatch.spProIconUrlTwo.isEmpty ?
                                                    SPClassEncryptImage.asset(
                                                      SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                                                      fit: BoxFit.cover,
                                                      width: width(30),
                                                      height: width(30),
                                                    ): Image.network(
                                                      widget.spProSchemeDetail.spProGuessMatch.spProIconUrlTwo,
                                                      fit: BoxFit.cover,
                                                      width: width(30),
                                                      height: width(30),
                                                    ),
                                                    SizedBox(height: height(5),),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:     Text(widget.spProSchemeDetail.spProGuessMatch.spProTeamTwo,style: TextStyle(fontSize: sp(13),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
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
                                    ),

                                    Visibility(
                                      child:  Row(
                                        children: <Widget>[
                                          SizedBox(width: width(17),),
                                          Visibility(
                                            visible: (widget.spProSchemeDetail.scheme.spProPlayingWay.contains("让球")&&(widget.spProSchemeDetail.scheme.spProGuessType =="竞彩")),
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
                                          Expanded(
                                            child:Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(width(5)),
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
                                                child:Row(
                                                  children: <Widget>[
                                                    widget.spProSchemeDetail.scheme.spProPlayingWay.contains("大小") ?
                                                    Expanded(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(left:Radius.circular(width(3)) )
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
                                                                        Text("大",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")? Colors.white :Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")? Colors.white : Color(0xFF333333)),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFF6F6F6),
                                                                  border: Border(top: BorderSide(color: Colors.grey[300],width: 0.4),bottom:  BorderSide(color: Colors.grey[300],width: 0.4))
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
                                                                        Text(SPClassStringUtils.spFunSqlitZero(SPClassStringUtils.spFunPanKouData(widget.spProSchemeDetail.scheme.spProMidScore).replaceAll("+", ""))+(widget.spProSchemeDetail.scheme.spProMatchType=="足球"? "球":""),style: TextStyle(fontSize: sp(13),color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="0"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="0")? Colors.white : Color(0xFF333333)),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(right:Radius.circular(width(3)) )
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
                                                                        Text("小",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")? Colors.white : Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")? Colors.white :Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ):
                                                    (widget.spProSchemeDetail.scheme.spProPlayingWay=="让球胜负")?
                                                    Expanded(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(left:Radius.circular(width(3)) )
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
                                                                        Text("胜",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")? Colors.white :Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")? Colors.white : Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFF6F6F6),
                                                                  border: Border(top: BorderSide(color: Colors.grey[300],width: 0.4),bottom:  BorderSide(color: Colors.grey[300],width: 0.4))
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
                                                                        Text(SPClassStringUtils.spFunPanKouData(widget.spProSchemeDetail.scheme.spProAddScore),style: TextStyle(fontSize: sp(13),color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="0"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="0")? Colors.white : Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(right:Radius.circular(width(3)) )
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
                                                                        Text("负",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2")? Colors.white : Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2")? Colors.white :Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ):
                                                    (widget.spProSchemeDetail.scheme.spProPlayingWay=="让分胜负"||widget.spProSchemeDetail.scheme.spProPlayingWay=="让局胜负")?
                                                    Expanded(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(left:Radius.circular(width(3)) )
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
                                                                        Text(  widget.spProSchemeDetail.scheme.spProMatchType.toLowerCase()=="lol" ? (widget.spProSchemeDetail.spProGuessMatch.spProTeamOne):"主队",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")? Colors.white :Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")? Colors.white : Color(0xFF333333)),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFF6F6F6),
                                                                  border: Border(top: BorderSide(color: Colors.grey[300],width: 0.4),bottom:  BorderSide(color: Colors.grey[300],width: 0.4))
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
                                                                        Text(SPClassStringUtils.spFunSqlitZero(SPClassStringUtils.spFunPanKouData(widget.spProSchemeDetail.scheme.spProAddScore,)),style: TextStyle(fontSize: sp(13),color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="0"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="0")? Colors.white : Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(right:Radius.circular(width(3)) )
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
                                                                        Text(widget.spProSchemeDetail.scheme.spProMatchType.toLowerCase()=="lol" ?(widget.spProSchemeDetail.spProGuessMatch.spProTeamTwo):"客队",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2")? Colors.white : Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2")? Colors.white :Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),



                                                        ],
                                                      ),
                                                    ):
                                                    (widget.spProSchemeDetail.scheme.spProPlayingWay=="总时长"||widget.spProSchemeDetail.scheme.spProPlayingWay=="总击杀")?
                                                    Expanded(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(left:Radius.circular(width(3)) )
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
                                                                        Text( "大于",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")? Colors.white :Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")? Colors.white : Color(0xFF333333)),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFF6F6F6),
                                                                  border: Border(top: BorderSide(color: Colors.grey[300],width: 0.4),bottom:  BorderSide(color: Colors.grey[300],width: 0.4))
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
                                                                        Text((SPClassStringUtils.spFunSqlitZero(widget.spProSchemeDetail.scheme.spProMidScore)+(widget.spProSchemeDetail.scheme.spProPlayingWay=="总时长"? "分钟":"")),style: TextStyle(fontSize: sp(13),color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="0"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="0")? Colors.white : Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(right:Radius.circular(width(3)) )
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
                                                                        Text("小于",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1")? Colors.white : Color(0xFF999999)),),
                                                                       Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1")? Colors.white :Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),



                                                        ],
                                                      ),
                                                    ):
                                                    Expanded(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(left:Radius.circular(width(3)) )
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
                                                                        Text( widget.spProSchemeDetail.scheme.spProMatchType.toLowerCase()=="lol" ?widget.spProSchemeDetail.spProGuessMatch.spProTeamOne:"胜",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")? Colors.white :Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsOne).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="1"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="1")? Colors.white : Color(0xFF333333)),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="0"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="0")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border(top: BorderSide(color: Colors.grey[300],width: 0.4),bottom:  BorderSide(color: Colors.grey[300],width: 0.4))
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
                                                                        Text(widget.spProSchemeDetail.scheme.spProPlayingWay.contains("平")? "平":"",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="0"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="0")? Colors.white : Color(0xFF999999)),),
                                                                        Text(widget.spProSchemeDetail.scheme.spProDrawOdds,style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="0"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="0")? Colors.white : Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="0")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: width(43),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  gradient:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")?LinearGradient(
                                                                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                                                  ):null,
                                                                  border: Border.all(color: Colors.grey[300],width: 0.4),
                                                                  borderRadius: BorderRadius.horizontal(right:Radius.circular(width(3)) )
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
                                                                        Text( widget.spProSchemeDetail.scheme.spProMatchType.toLowerCase()=="lol" ?widget.spProSchemeDetail.spProGuessMatch.spProTeamTwo:"负",style: TextStyle(fontSize: sp(13),height:1.0,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")? Colors.white : Color(0xFF999999)),),
                                                                        Text(double.tryParse(widget.spProSchemeDetail.scheme.spProWinOddsTwo).toStringAsFixed(2),style: TextStyle(fontSize: sp(13),height:1.2,color:(widget.spProSchemeDetail.scheme.spProSupportWhich=="2"||widget.spProSchemeDetail.scheme.spProSupportWhich2=="2")? Colors.white :Color(0xFF333333)),),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: SPClassEncryptImage.asset(
                                                                      (widget.spProSchemeDetail.scheme.spProWhichWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_select_lab"):"",
                                                                      width: width(18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ) ),),
                                          SizedBox(width: width(17),),

                                        ],
                                      ),
                                      visible: widget.spProSchemeDetail.spProCanViewAll==1,
                                    ),
                                    SizedBox(height: height(13),),

                                    (widget.spProSchemeDetail.spProCanViewAll!=1)?

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
                                                    gradient: LinearGradient(
                                                        colors: [Color(0xFFF2150C),Color(0xFFF24B0C)]
                                                    ),
                                                  ),
                                                  width: width(136),
                                                  height: width(52),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.lock,color: Colors.white,size: width(20),),
                                                      Text(widget.spProSchemeDetail.scheme.spProDiamond+"钻石购买方案",style: TextStyle(fontSize: sp(12),color: Colors.white),),
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
                                          Icon(Icons.info_outline,color: Color(0xFFF1A65A),size: width(15),),
                                          SizedBox(width: width(5),height:width(20)),
                                          Text("文章内容仅供参考，并不代表平台观点，投注需谨慎。",style: TextStyle(color: Color(0xFFF1A65A),fontSize: sp(10)),),
                                          SizedBox(width: width(3),),
                                          Expanded(
                                            child: SizedBox(),
                                          ),
                                          GestureDetector(
                                            child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_compain"),width: width(12),color: Color(0xFF999999)),
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

                    spProSchemeListself.length==0?SizedBox():   Container(
                      margin: EdgeInsets.only(left: width(13),right:  width(13),bottom:width(8) ),
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
                    ),

                    spProSchemeListmatch.length==0?SizedBox(): Container(
                      margin: EdgeInsets.only(left: width(13),right:  width(13),bottom:width(8) ),
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
                                Text("其他专家本场次推荐",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(16)),),
                                Text(" "+spProSchemeListmatch.length.toString(),style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(14),textStyle: TextStyle(color: Color(0xFFDE3C31))),),

                              ],
                            ),
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
                    ),




                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void spFunShowConfirmDialog() {

    SPClassDialogUtils.spFunShowConfirmDialog(context,RichText(
      text: TextSpan(
        text: "确认后将扣除",
        style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
        children: <TextSpan>[
          TextSpan(text: widget.spProSchemeDetail.scheme.spProDiamond, style: TextStyle(fontSize: 16, color: Color(0xFFE3494B))),
          TextSpan(text: "钻石"),
        ],
      ),
    ), (){
       SPClassApiManager.spFunGetInstance().spFunSchemeBuy(queryParameters: {"scheme_id":widget.spProSchemeDetail.scheme.spProSchemeId},context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
         spProOnSuccess: (value){
           spFunUpDataScheme();
         },
         onError: (value){
           if( value.code=="200"){
               SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage());

           }
         }
       ));
    });
  }


  void spFunDownCount() {


    spProTimer=  Timer.periodic(Duration(seconds: 1), (timer){
      spFunRefreshTimer();
    });
   spFunRefreshTimer();


  }

  void spFunUpDataScheme() {
    SPClassApiManager.spFunGetInstance().spFunSchemeDetail(
        queryParameters: {"scheme_id":widget.spProSchemeDetail.scheme.spProSchemeId},
        context: context,spProCallBack:SPClassHttpCallBack<SPClassSchemeDetailEntity>(
        spProOnSuccess: (value){
          if(mounted){
            setState(() {
              widget.spProSchemeDetail=value;
            });
          }
        }
    ));
  }

  void spFunRefreshTimer() {

    DateTime nowTime= DateTime.now();

    Duration duration =DateTime.parse(widget.spProSchemeDetail.spProGuessMatch.spProStTime).difference(nowTime);

    Hour=(duration.inHours);
    Mimuite=(duration.inMinutes-((duration.inHours*60)));
    Second=(duration.inSeconds-(duration.inMinutes*60));

    if(Hour<=0&&Mimuite<=0&&Second<=0){
      spProTimer.cancel();
      this.spProTimer=null;
    }
    if(mounted){
      setState(() {

      });
    }
  }

  void spFunOnRefreshSelf() {
    SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"expert_uid":widget.spProSchemeDetail.scheme.spProUserId,"page":"1","is_over":"0","fetch_type":"expert"},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){
          var item;
          list.spProSchemeList.forEach((itemx){
             if(itemx.spProSchemeId==widget.spProSchemeDetail.scheme.spProSchemeId){
               item =itemx;
             }
          });
          if(item!=null) {list.spProSchemeList.remove(item);}
          if(mounted){
            setState(() {
              spProSchemeListself=list.spProSchemeList;
            });
          }
        },
        onError: (value){
        }
    ));
  }

  void spFunOnRefreshMatch() {
    SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"guess_match_id":widget.spProSchemeDetail.scheme.spProGuessMatchId,"page":"1","is_over":"0","fetch_type":"guess_match"},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){
          var item;
          list.spProSchemeList.forEach((itemx){
             if(itemx.spProSchemeId==widget.spProSchemeDetail.scheme.spProSchemeId){
               item =itemx;
             }
          });
          if(item!=null) {list.spProSchemeList.remove(item);}
          if(mounted){
            setState(() {
              spProSchemeListmatch=list.spProSchemeList;
            });
          }
        },
        onError: (value){
        }
    ));
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