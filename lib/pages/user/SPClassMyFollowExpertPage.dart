import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassExpertListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/utils/colors.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/widgets/SPClassSkeletonList.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassMyFollowExpertPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMyFollowExpertPageState();
  }

}

class SPClassMyFollowExpertPageState  extends State<SPClassMyFollowExpertPage>{
  List<SPClassExpertListExpertList> spProMyFollowingList =List();
  EasyRefreshController controller;
  int page=1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=EasyRefreshController();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: EasyRefresh.custom(
        firstRefresh: true,
        controller:controller ,
        header: SPClassBallHeader(
            textColor: Color(0xFF666666)
        ),
        footer: SPClassBallFooter(
            textColor: Color(0xFF666666)
        ),
        firstRefreshWidget: SPClassSkeletonList(
            length: 10,
            builder: (c,index)=>
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.4,color: Colors.grey[300]),
                  ),
                  padding: EdgeInsets.only(top: height(11),bottom: height(11),left: width(17) ),
                  alignment: Alignment.center,
                  child:   Row(
                    children: <Widget>[
                      Container(
                        width: width(40),
                        height: width(40),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(width(20))),
                      ),
                      SizedBox(width: width(7),),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(height: height(10),width: width(60),color: Colors.red,),
                            SizedBox(height: height(5),),
                            Container(height: height(10),width: width(100),color: Colors.red,),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
        emptyWidget: spProMyFollowingList.length==0 ?SPClassNoDataView(content: '你还没有关注的专家',):null,
        onRefresh: spFunOnReFresh,
        onLoad: spFunOnLoad,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              // padding: EdgeInsets.only(top: width(12),bottom: width(12)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width(7))
              ),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: spProMyFollowingList.length,
                  itemBuilder: (c,index){
                    var item=spProMyFollowingList[index];
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: width(14),right: width(14),top: width(12),bottom: width(12)),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child:( item?.spProAvatarUrl==null||item.spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                                    width: width(46),
                                    height: width(46),
                                  ):Image.network(
                                    item.spProAvatarUrl,
                                    width: width(46),
                                    height: width(46),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child:(item.spProNewSchemeNum!="null"&&int.tryParse(item.spProNewSchemeNum)>0)? Container(
                                    alignment: Alignment.center,
                                    width: width(12),
                                    height: width(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width(6)),
                                      color: Color(0xFFE3494B),
                                    ),
                                    child:Text(item.spProNewSchemeNum,style: TextStyle(fontSize: sp(8),color: Colors.white),),
                                  ):Container(),
                                )
                              ],
                            ),
                            SizedBox(width: width(8),),
                            Expanded(
                              child: Text("${item.spProNickName}",style: TextStyle(fontSize: sp(17),color: Color(0xFF333333)),),
                            ),
                            Text("胜率${(SPClassMatchDataUtils.spFunCalcBestCorrectRate(item.spProLast10Result)*100).toStringAsFixed(0)}%",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                textStyle: TextStyle(
                                  letterSpacing: 0,
                                  wordSpacing: 0,
                                  fontSize: sp(17),
                                  color: Color(0xFFE3494B),),),
                            ),
                            SizedBox(width:width(15),),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: width(8),vertical: width(4)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color:item.spProIsFollowing?MyColors.grey_cc: MyColors.main1,width: 0.5),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(item.spProIsFollowing? Icons.check:Icons.add,color: item.spProIsFollowing?MyColors.grey_cc:MyColors.main1,size: width(15),),
                                  Text(item.spProIsFollowing? "已关注":"+关注",style: TextStyle(color:item.spProIsFollowing?MyColors.grey_cc: MyColors.main1,fontSize: sp(12)),)
                                ],
                              ),
                            ),


                            /*Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text("${item.spProNickName}",style: TextStyle(fontSize: sp(14),color: Color(0xFF333333)),),
                                                SizedBox(width: 3,),
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
                                                    child:Text("近"+
                                                        "${item.spProLast10Result.length.toString()}"+
                                                        "中"+
                                                        "${item.spProLast10CorrectNum}",style: TextStyle(fontSize: sp(9),color: Colors.white,letterSpacing: 1),),
                                                  ),
                                                  visible:  (item.spProSchemeNum!=null&&(double.tryParse(item.spProLast10CorrectNum)/double.tryParse(item.spProLast10Result.length.toString()))>=0.6),
                                                ),
                                                SizedBox(width: 3,),
                                                int.tryParse( item.spProCurrentRedNum)>2?  Stack(
                                                  children: <Widget>[
                                                    SPClassEncryptImage.asset(item.spProCurrentRedNum.length>1  ? SPClassImageUtil.spFunGetImagePath("ic_recent_red2"):SPClassImageUtil.spFunGetImagePath("ic_recent_red"),
                                                      height:width(16) ,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                    Positioned(
                                                      left: width(item.spProCurrentRedNum.length>1  ? 5:7),
                                                      bottom: 0,
                                                      top: 0,
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: Text("${item.spProCurrentRedNum}",style: GoogleFonts.roboto(textStyle: TextStyle(color:Color(0xFFDE3C31) ,fontSize: sp(14.8),fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
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
                                            SizedBox(height: width(2),),
                                            (item.spProGoodAtLeagues==null||item.spProGoodAtLeagues.isEmpty)?SizedBox(): Row(
                                              children: <Widget>[
                                                Text("擅长联赛：",style: TextStyle(fontSize: sp(11),color: Color(0xFF333333)),),
                                                Text("${item.spProGoodAtLeagues}",style: TextStyle(fontSize: sp(11),color: Color(0xFFDE3C31)),),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      double.tryParse(item.spProRecentProfit)<=0?SizedBox():   Stack(
                                        alignment: Alignment.topRight,
                                        children: <Widget>[
                                          SizedBox(height: width(40),child: Text("近10场盈利率",style: TextStyle(
                                              fontSize: sp(10),
                                              letterSpacing: 0,
                                              wordSpacing: 0,
                                              color: Colors.white)),),
                                          Text("${(double.tryParse(item.spProRecentProfit)*100).toStringAsFixed(0)}%",
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              textStyle: TextStyle(
                                                letterSpacing: 0,
                                                wordSpacing: 0,
                                                fontSize: sp(24),
                                                color: Color(0xFFE3494B),),),
                                          ),
                                          Positioned(
                                            child:  Text("近10场盈利率",style: TextStyle(
                                                fontSize: sp(10),
                                                letterSpacing: 0,
                                                wordSpacing: 0,
                                                color: Color(0xFF666666)),
                                            ),
                                            right: 0,
                                            bottom: 0,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height(5),),
                                  Text("${item.intro}",style: TextStyle(fontSize: sp(11),color: Color(0xFF666666)),maxLines: 2,overflow: TextOverflow.ellipsis,)

                                ],
                              ),
                            ),*/



                          ],
                        ),
                      ),
                      onTap: (){
                        SPClassApiManager.spFunGetInstance().spFunExpertInfo(queryParameters: {"expert_uid":item.spProUserId},
                            context:context,spProCallBack: SPClassHttpCallBack(
                                spProOnSuccess: (info){
                                  SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertDetailPage(info));
                                }
                            ));
                      },

                    );
                  }),
            ),
          ),
        ],
      ),
    );
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title:"我的关注",
        actions: <Widget>[

        ],
      ),
      body: Container(
        color: Color(0xFFF1F1F1),
        child: EasyRefresh.custom(
          firstRefresh: true,
          controller:controller ,
          header: SPClassBallHeader(
            textColor: Color(0xFF666666)
          ),
          footer: SPClassBallFooter(
              textColor: Color(0xFF666666)
          ),
          firstRefreshWidget: SPClassSkeletonList(
            length: 10,
              builder: (c,index)=>
                  Container(
                     margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.4,color: Colors.grey[300]),
                    ),
                    padding: EdgeInsets.only(top: height(11),bottom: height(11),left: width(17) ),
                    alignment: Alignment.center,
                    child:   Row(
                      children: <Widget>[
                       Container(
                         width: width(40),
                         height: width(40),
                          decoration: BoxDecoration(
                            color: Colors.red,
                              borderRadius: BorderRadius.circular(width(20))),
                        ),
                        SizedBox(width: width(7),),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                               Container(height: height(10),width: width(60),color: Colors.red,),
                              SizedBox(height: height(5),),
                              Container(height: height(10),width: width(100),color: Colors.red,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
          emptyWidget: spProMyFollowingList.length==0 ?SPClassNoDataView():null,
          onRefresh: spFunOnReFresh,
          onLoad: spFunOnLoad,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(width(10)),
                padding: EdgeInsets.only(top: width(5),bottom: width(5)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width(7))
                ),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: spProMyFollowingList.length,
                    itemBuilder: (c,index){
                      var item=spProMyFollowingList[index];
                      return GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(left: height(14),right: height(14),top: height(14)),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                          ),
                          height: width(102),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[

                                  Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(200),
                                        child:( item?.spProAvatarUrl==null||item.spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                                          SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                                          width: width(40),
                                          height: width(40),
                                        ):Image.network(
                                          item.spProAvatarUrl,
                                          width: width(40),
                                          height: width(40),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child:(item.spProNewSchemeNum!="null"&&int.tryParse(item.spProNewSchemeNum)>0)? Container(
                                          alignment: Alignment.center,
                                          width: width(12),
                                          height: width(12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(width(6)),
                                            color: Color(0xFFE3494B),
                                          ),
                                          child:Text(item.spProNewSchemeNum,style: TextStyle(fontSize: sp(8),color: Colors.white),),
                                        ):Container(),
                                      )
                                    ],
                                  ),

                                  SizedBox(height: height(6),),
                                  GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(width(2)),
                                          gradient: LinearGradient(
                                              colors: item.spProIsFollowing? [Color(0xFFC6C6C6),Color(0xFFC6C6C6)]:[Color(0xFFF2150C),Color(0xFFF24B0C)]
                                          ),
                                          boxShadow:item.spProIsFollowing?null:[
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
                                        width: width(47),
                                        height: width(20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(item.spProIsFollowing? Icons.check:Icons.add,color: Colors.white,size: width(10),),
                                            Text( item.spProIsFollowing? "已关注":"关注",style: TextStyle(fontSize: sp(10),color: Colors.white),),

                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        if(spFunIsLogin(context: context)){
                                          SPClassApiManager.spFunGetInstance().spFunFollowExpert(isFollow: !item.spProIsFollowing,spProExpertUid: item.spProUserId,context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                              spProOnSuccess: (result){
                                                if(!item.spProIsFollowing){
                                                  SPClassToastUtils.spFunShowToast(msg: "关注成功");
                                                  item.spProIsFollowing=true;
                                                }else{
                                                  item.spProIsFollowing=false;
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
                              SizedBox(width: width(6),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("${item.spProNickName}",style: TextStyle(fontSize: sp(14),color: Color(0xFF333333)),),
                                                  SizedBox(width: 3,),
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
                                                      child:Text("近"+
                                                          "${item.spProLast10Result.length.toString()}"+
                                                          "中"+
                                                          "${item.spProLast10CorrectNum}",style: TextStyle(fontSize: sp(9),color: Colors.white,letterSpacing: 1),),
                                                    ),
                                                    visible:  (item.spProSchemeNum!=null&&(double.tryParse(item.spProLast10CorrectNum)/double.tryParse(item.spProLast10Result.length.toString()))>=0.6),
                                                  ),
                                                  SizedBox(width: 3,),
                                                  int.tryParse( item.spProCurrentRedNum)>2?  Stack(
                                                    children: <Widget>[
                                                      SPClassEncryptImage.asset(item.spProCurrentRedNum.length>1  ? SPClassImageUtil.spFunGetImagePath("ic_recent_red2"):SPClassImageUtil.spFunGetImagePath("ic_recent_red"),
                                                        height:width(16) ,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                      Positioned(
                                                        left: width(item.spProCurrentRedNum.length>1  ? 5:7),
                                                        bottom: 0,
                                                        top: 0,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          child: Text("${item.spProCurrentRedNum}",style: GoogleFonts.roboto(textStyle: TextStyle(color:Color(0xFFDE3C31) ,fontSize: sp(14.8),fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
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
                                              SizedBox(height: width(2),),
                                              (item.spProGoodAtLeagues==null||item.spProGoodAtLeagues.isEmpty)?SizedBox(): Row(
                                                children: <Widget>[
                                                  Text("擅长联赛：",style: TextStyle(fontSize: sp(11),color: Color(0xFF333333)),),
                                                  Text("${item.spProGoodAtLeagues}",style: TextStyle(fontSize: sp(11),color: Color(0xFFDE3C31)),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        double.tryParse(item.spProRecentProfit)<=0?SizedBox():   Stack(
                                          alignment: Alignment.topRight,
                                          children: <Widget>[
                                            SizedBox(height: width(40),child: Text("近10场盈利率",style: TextStyle(
                                                fontSize: sp(10),
                                                letterSpacing: 0,
                                                wordSpacing: 0,
                                                color: Colors.white)),),
                                           Text("${(double.tryParse(item.spProRecentProfit)*100).toStringAsFixed(0)}%",
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w500,
                                                textStyle: TextStyle(
                                                  letterSpacing: 0,
                                                  wordSpacing: 0,
                                                  fontSize: sp(24),
                                                  color: Color(0xFFE3494B),),),
                                            ),
                                            Positioned(
                                              child:  Text("近10场盈利率",style: TextStyle(
                                                  fontSize: sp(10),
                                                  letterSpacing: 0,
                                                  wordSpacing: 0,
                                                  color: Color(0xFF666666)),
                                              ),
                                              right: 0,
                                              bottom: 0,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: height(5),),
                                    Text("${item.intro}",style: TextStyle(fontSize: sp(11),color: Color(0xFF666666)),maxLines: 2,overflow: TextOverflow.ellipsis,)

                                  ],
                                ),
                              ),
                              SizedBox(width: 3,),


                            ],
                          ),
                        ),
                        onTap: (){
                          SPClassApiManager.spFunGetInstance().spFunExpertInfo(queryParameters: {"expert_uid":item.spProUserId},
                              context:context,spProCallBack: SPClassHttpCallBack(
                                  spProOnSuccess: (info){
                                    SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertDetailPage(info));
                                  }
                              ));
                        },

                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> spFunOnReFresh() async {
    page=1;
    await  SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"fetch_type":"my_following","page":"1"},spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
      spProOnSuccess: (list){
         setState(() {
           spProMyFollowingList=list.spProExpertList;
         });

      },
      onError: (result){
      }
    ));
  }
  Future<void> spFunOnLoad() async{
    await  SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"fetch_type":"my_following","page":"${page+1}"},spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
      spProOnSuccess: (list){
        if(list.spProExpertList.length==0){
          controller.finishLoad(noMore: true);
        }else{
          page++;
        }
         setState(() {
           spProMyFollowingList.addAll(list.spProExpertList);
         });
      },
      onError: (result){
      }
    ));
  }



}