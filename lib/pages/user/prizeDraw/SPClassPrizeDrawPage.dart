import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/main.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassListEntity.dart';
import 'package:sport/model/SPClassPrizeDrawInfo.dart';
import 'package:sport/pages/common/SPClassShareView.dart';
import 'package:sport/pages/competition/detail/SPClassMatchDetailPage.dart';
import 'package:sport/pages/dialogs/SPClassDrawPriceResultDialog.dart';
import 'package:sport/pages/dialogs/SPClassPriceDrawHistoryDialog.dart';
import 'package:sport/pages/dialogs/SPClassPriceDrawRuluDialog.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/widgets/SPClassAnimationPoint.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassPrizeDrawPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassPrizeDrawPageState();
  }

}

class SPClassPrizeDrawPageState extends State<SPClassPrizeDrawPage> with TickerProviderStateMixin{
  List<SPClassPrizeDrawInfo> spProPrizeDrawList =[];
  List<String> spProMsgList=[];
  AnimationController spProScaleAnimation;
  AnimationController spProStartAnimation;
  ScrollController spProMsgScrollController;
  var timer;

  var spProIsSignIn=false;
  var signList=[
    {"title":"签","sign":false},
    {"title":"+1","sign":false},
    {"title":"签","sign":false},
    {"title":"签","sign":false},
    {"title":"+2","sign":false},
    {"title":"签","sign":false},
    {"title":"+3","sign":false},
    ];

  var animIndex=-1;
  bool remindSign=false;
  int resultIndex=0;
  SPClassPrizeDrawInfo drawInfoResult;

  var spProSeqNum=0;//连续打卡天数
  var timesLeft=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProMsgScrollController=ScrollController(initialScrollOffset: width(20));
    timer=   Timer.periodic(Duration(seconds: 2), (timer){
      if(spProMsgScrollController.positions.isNotEmpty){
        spProMsgScrollController.animateTo(spProMsgScrollController.offset+20, duration: Duration(seconds: 2), curve: Curves.linear);
      }
    });
    spProScaleAnimation= AnimationController(duration: const Duration(milliseconds: 500),reverseDuration:const Duration(milliseconds: 500) , vsync: this,lowerBound: 1.0,upperBound: 1.2);
    spProScaleAnimation.repeat(reverse: true);



    spProStartAnimation=AnimationController(duration: const Duration(seconds: 8), vsync: this);
    var animation= CurvedAnimation(
        parent: Tween<double>(begin: 0, end:1,).animate(spProStartAnimation), curve: Curves.easeOutQuad);
    animation.addListener(() {
      var value=(animation.value*(32)+resultIndex).round()%8;
      if(value>=4){
        animIndex=value+1;
      }else{
        animIndex=value;
      }
      setState(() {
      });
    });
    animation.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        spProScaleAnimation.reset();
        spProScaleAnimation.repeat(reverse: true);



        var findItem=spProPrizeDrawList.firstWhere((item) => (item!=null&&item.spProProductId==drawInfoResult.spProProductId),orElse: ()=>null);
        if(drawInfoResult.spProProductId=="0"){
          SPClassToastUtils.spFunShowToast(msg: "很遗憾！您与大奖擦肩而过了~别灰心，明天再来！");
          if(findItem==null){
            animIndex=-1;
          }
          setState(() {});
        }else{
          showDialog(context: context,builder: (c)=>SPClassDrawPriceResultDialog(spProPrizeDrawInfo: findItem,callback: (){
            spFunStartPriceDraw();
          },));
        }



      }
    });


    spFunGetPrizeDrawList();

    SPClassApiManager.spFunGetInstance().spFunProductBroadcast<String>(spProCallBack:SPClassHttpCallBack(
        spProOnSuccess: (result){
          spProMsgList=result.spProDataList;
          if(spProMsgList.length>0){
            setState(() {
            });
          }
        }
    ));
    spFunGetSignList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFFECA50),
      appBar: AppBar(
        elevation: 0,
        title: Text("抽奖"),
        centerTitle: true,
        flexibleSpace:SPClassEncryptImage.asset(
          SPClassImageUtil.spFunGetImagePath("bg_draw_price_page",),
          //alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,),
       actions: <Widget>[
          GestureDetector(
            child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_share_price_draw",format: ".png"),width: width(24),),
            onTap: (){
              SPClassApiManager.spFunGetInstance().spFunShare(type: "prize_draw",context: context,spProCallBack: SPClassHttpCallBack(
                  spProOnSuccess: (result){
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SPClassShareView(title: result.title,spProDesContent: result.content,spProPageUrl: result.spProPageUrl??SPClassNetConfig.spFunGetShareUrl(),spProIconUrl: result.spProIconUrl,);
                        });
                  }
              ));
            },
          ),
         SizedBox(width: width(20),),
       ], 
      ),
      extendBodyBehindAppBar: true,
       body: SingleChildScrollView(
         child: Stack(
           children: <Widget>[
             SPClassEncryptImage.asset(
               SPClassImageUtil.spFunGetImagePath("bg_draw_price_page",),
               fit: BoxFit.fitWidth,),
             Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 SizedBox(height: kToolbarHeight+ScreenUtil.statusBarHeight,),
                 GestureDetector(
                   child:  Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Text("抽奖规则: 每天登录获得1次机会, 每天限参与10次",
                         style: TextStyle(color: Colors.white,fontSize: sp(12)),
                       ),
                       SizedBox(width: width(5),),
                       Container(
                         padding: EdgeInsets.only(left: width(9),right: width(2)),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(width(300)),
                             border: Border.all(width:1,color: Colors.white)
                         ),
                         child: Row(
                           children: <Widget>[
                             Text(
                               "详情",
                               style: TextStyle(color: Colors.white,fontSize: sp(12)),
                             ),
                             Icon(Icons.chevron_right,color: Colors.white,size: width(15),)
                           ],
                         ),
                       ),
                     ],
                   ),
                   onTap: (){
                         showDialog(context: context,builder: (c)=>SPClassPriceDrawRuluDialog());
                   },
                 ),
                 SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_turntable_title"),width: width(296),),

                 Stack(
                   alignment: Alignment.center,
                   children: <Widget>[
                     Container(
                       height: width(402),
                       decoration: BoxDecoration(
                           image: DecorationImage(
                               fit: BoxFit.contain,
                               image: AssetImage(
                                   SPClassImageUtil.spFunGetImagePath("bg_draw_price_boder")
                               )
                           )
                       ),
                       alignment: Alignment.center,
                       child: Stack(
                         alignment:Alignment.center,
                         children: <Widget>[
                           GridView.count(
                             crossAxisCount: 3,
                             shrinkWrap: true,
                             childAspectRatio: 1.0,
                             mainAxisSpacing: width(8),
                             primary: false,
                             crossAxisSpacing: width(8),
                             padding: EdgeInsets.only(left:width(38),right: width(38),top: width(15)),
                             physics: const NeverScrollableScrollPhysics(),
                             children:spProPrizeDrawList.map((item) =>
                             item==null? SizedBox():Container(
                               decoration:BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(width(10)),
                                   image: DecorationImage(
                                       fit: BoxFit.contain,
                                       image: AssetImage(
                                           SPClassImageUtil.spFunGetImagePath(
                                           spFunGetProductIndex(spProPrizeDrawList.indexOf(item))==animIndex?
                                           "bg_pruduct_draw_price":
                                           "bg_pruduct_draw")
                                       )
                                   )

                               ),
                               width: width(89),
                               height: width(89),
                               alignment: Alignment.center,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   Container(
                                     padding: EdgeInsets.all(width(8)),
                                     width: width(62),
                                     height: width(62),
                                     child: SPClassImageUtil.spFunNetWordImage(
                                         url: spProPrizeDrawList[spFunGetProductIndex(spProPrizeDrawList.indexOf(item))].spProIconUrl,
                                         fit: BoxFit.contain),
                                   ),
                                   Text(
                                       spProPrizeDrawList[spFunGetProductIndex(spProPrizeDrawList.indexOf(item))].spProProductName,
                                       style: TextStyle(fontSize: 10,color: Color(0xFFA4674B)))
                                 ],
                               ),
                             )).toList(),
                             semanticChildCount: spProPrizeDrawList.length,
                           ),


                           ScaleTransition(
                             scale: spProScaleAnimation,
                             child: GestureDetector(
                               behavior: HitTestBehavior.opaque,
                               onTap: (){
                                  spFunStartPriceDraw();
                               },
                               child: Container(
                                 margin: EdgeInsets.only(top: width(15)),
                                 decoration:BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(width(10)),

                                     image: DecorationImage(
                                         fit: BoxFit.contain,
                                         image: AssetImage(
                                             SPClassImageUtil.spFunGetImagePath("bg_btn_draw_price_start")
                                         )
                                     )

                                 ),
                                 width: width(89),
                                 height: width(89),
                                 alignment: Alignment.center,
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: <Widget>[
                                     Text("立即"+
                                         "\n"+
                                         "抽奖",style: TextStyle(fontSize: 23,color: Color(0xFF8F4B21),height: 1.0,fontWeight: FontWeight.bold),),

                                     RichText(text: TextSpan(
                                         text: "剩余",
                                         style: TextStyle(fontSize: 11,color: Color(0xFF333333)),
                                         children: [
                                           TextSpan(
                                               text: timesLeft.toString(),
                                               style: TextStyle(color: Color(0xFFEB3F39)),

                                           ),
                                           TextSpan(
                                             text: "次机会",

                                           )
                                         ]
                                     ),)
                                   ],
                                 ),
                               ),
                             ),
                           ),


                         ],
                       ),
                     ),
                     Positioned(
                       top: width(43),
                       left: 0,
                       right: 0,
                       child:  Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                         ],
                       ),
                     ),
                     Positioned(
                       bottom: width(28),
                       left: 0,
                       right: 0,
                       child:  Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(),
                           SizedBox(width: width(14),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                         ],
                       ),
                     ),
                     Positioned(
                       left: width(14),
                       top: width(43),
                       bottom: width(28),
                       child:  Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                         ],
                       ),
                     ),
                     Positioned(
                       right: width(14),
                       top: width(43),
                       bottom: width(28),
                       child:  Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(),
                           SizedBox(height: width(17),),
                           SPClassAnimationPoint(spProIsWhite: false,),
                         ],
                       ),
                     ),

                     Positioned(
                       left: width(18),
                       top: width(45),
                       child:  SPClassAnimationPoint(),
                     ),
                     Positioned(
                       right: width(18),
                       top: width(45),
                       child:  SPClassAnimationPoint(),
                     ),
                     Positioned(
                       right: width(18),
                       bottom: width(30),
                       child:  SPClassAnimationPoint(),
                     ),
                     Positioned(
                       left: width(18),
                       bottom: width(30),
                       child:  SPClassAnimationPoint(),
                     ),

                     Positioned(
                       child:
                       Text(sprintf("本活动最终解释权归%s团队所有",[SPClassApplicaion.spProAppName]),
                         style: TextStyle(fontSize: 9,color: Colors.white),
                         textAlign: TextAlign.center,),
                       bottom: width(13),
                     ),
                     Positioned(
                       child:
                       Text(sprintf("本活动最终解释权归%s团队所有",[SPClassApplicaion.spProAppName]),
                         style: TextStyle(fontSize: 9,color: Colors.white),
                         textAlign: TextAlign.center,),
                       bottom: width(13),
                     ),

                     Positioned(
                       top: width(15),
                       child: Container(
                         alignment: Alignment.center,
                         width: width(200),
                         height: width(23),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                             Icon(Icons.volume_up,color: Colors.white,size: width(20),),
                             SizedBox(width: 5,),
                             Expanded(
                               child:Container(
                                 alignment: Alignment.center,
                                 height: width(23),
                                 child: ScrollNotificationInterceptor(
                                   child:  ListView.builder(
                                       controller: spProMsgScrollController,
                                       primary: false,
                                       itemBuilder: (c,index){
                                         var pos=index%spProMsgList.length;
                                         return Container(
                                           margin: EdgeInsets.only(left: width(5)),
                                           alignment: Alignment.centerLeft,
                                           height: width(23),
                                           child: Text(spProMsgList[pos],style: TextStyle(color: Colors.white,fontSize: sp(12)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                         );
                                       }),
                                 ),
                               )  ,
                             )

                           ],
                         ),
                       ),
                     )
                   ],
                 ),
                 
                 GestureDetector(
                   child: Container(
                     margin: EdgeInsets.only(top:width(16)),
                     width: width(283),
                     height: width(38),
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.2),
                       border:Border.all(width: width(1),color: Colors.white) ,
                       borderRadius: BorderRadius.circular(width(500)),
                     ),
                     alignment: Alignment.center,
                     child: Text("查看我的中奖/抽奖记录",style: TextStyle(color: Colors.white),),
                   ),
                   onTap: (){
                     showCupertinoDialog(context: context, builder: (c)=>SPClassPriceDrawHistoryDialog());
                   },
                 ),

                 SizedBox(height: width(23),),

                 Stack(
                   alignment: Alignment.topCenter,
                   children: <Widget>[
                      Container(
                        margin:EdgeInsets.only(top: 10) ,
                        width:width(331) ,
                        height:width(217),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFEF1),
                          borderRadius: BorderRadius.circular(width(10))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height:width(48),),
                            Row(
                              children: <Widget>[
                                SizedBox(width: width(15),),
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                            style: TextStyle(color: Color(0xFF333333),fontSize:sp(14), ),
                                            text: "已连续打卡 ",
                                            children: [
                                              TextSpan(
                                                  style: TextStyle(color: Color(0xFFEB403A)),
                                                  text: spProSeqNum.toString()
                                              ),
                                              TextSpan(
                                                  text: " 天"
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("签到提示",style: TextStyle(fontSize: sp(12)),),
                                    SizedBox(width: width(3),),
                                    GestureDetector(
                                      child: Container(
                                        width: width(30),
                                        height: width(15),
                                        decoration: BoxDecoration(
                                          borderRadius:BorderRadius.circular(300),
                                          color:remindSign ? Theme.of(context).primaryColor:Color(0xFFEAE8EB),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:remindSign ? MainAxisAlignment.start:MainAxisAlignment.end ,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 2,right: 2),
                                              width: width(12),
                                              height: width(12),
                                              decoration: ShapeDecoration(
                                                  shadows: [
                                                    BoxShadow(
                                                        offset: Offset(1,1),
                                                        color: Colors.black.withOpacity(0.2)
                                                    ),
                                                  ],
                                                  shape: CircleBorder(),
                                                  color: Colors.white
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        setState(() {
                                          remindSign=!remindSign;
                                        });
                                        if(!remindSign){
                                          SPClassToastUtils.spFunShowToast(msg: "关闭提醒将容易错过各种福利哦");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(width: width(15),),
                              ],
                            ),
                            SizedBox(height:width(20),),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:signList.map((item) {
                                return Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFFEAB2),
                                                border: Border.all(width: 0.4,color: Color(0xFFE5AD6A)),
                                                shape: BoxShape.circle
                                            ),
                                            width: width(27),
                                            height: width(27),
                                            alignment: Alignment.center,
                                            child: Visibility(
                                              child:Text(item["title"],
                                                style: TextStyle(
                                                    color:Color(0xFFE5AD6A),
                                                    fontSize: sp(12)
                                                ),),
                                              replacement:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_sign_day")),
                                              visible: !item["sign"],
                                            ),
                                          ),
                                          SizedBox(height: width(5),),
                                          Text(
                                              sprintf("第%d天",[(signList.indexOf(item)+1)]),
                                              style:TextStyle(fontSize: sp(9)),
                                          
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal:width(3),vertical: width(13)),
                                          width: width(10),
                                          height: width(1),
                                          color: Color(0xFFE5AD6A),
                                        ),
                                        visible: signList.indexOf(item)<signList.length-1,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height:width(16),),

                            GestureDetector(
                              child:Visibility(
                                child:  SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_un_sign"),width: width(134),),
                                visible:!spProIsSignIn ,
                                replacement:  SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_signed"),width: width(134),),
                              ),
                              onTap: (){
                                if(!spProIsSignIn){
                                  SPClassApiManager.spFunGetInstance().spFunSignIn(context: context,spProCallBack: SPClassHttpCallBack(
                                      spProOnSuccess: (result){
                                          spProIsSignIn=true;
                                          spFunGetSignList();
                                          spFunGetPrizeDrawList();
                                      }
                                  ));
                                }

                              },
                            ),
                            SizedBox(height: width(3),),
                            Text("连续签到可增加抽奖次数",style: TextStyle(color: Color(0xFF333333),fontSize: sp(9)),)
                          ],
                        ),
                      ),
                     SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_title_sign"),width: width(239),),

                   ],
                 ),

                 SizedBox(height: width(23),),

                 Stack(
                   alignment: Alignment.topCenter,
                   children: <Widget>[
                     Container(
                       margin:EdgeInsets.only(top: 10) ,
                       width:width(331) ,
                       decoration: BoxDecoration(
                           color: Color(0xFFFFFEF1),
                           borderRadius: BorderRadius.circular(width(10))
                       ),
                       child: Column(
                         children: <Widget>[
                           SizedBox(height: width(50),),

                           Stack(
                             children: <Widget>[
                                SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_add_price_draw_count"),width: width(302),),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: width(58),
                                        alignment: Alignment.center,
                                        child: Text("方法一",style: TextStyle(
                                            color: Color(0xFF904B22),
                                            fontWeight: FontWeight.w600),),
                                      ),
                                      Container(
                                        width: width(145),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: width(13),right: width(15)),
                                        child:RichText(
                                          text: TextSpan(
                                              style: TextStyle(color: Color(0xFF333333),fontSize:sp(12), ),
                                              text: "邀请好友下载app，抽奖次数",
                                              children: [
                                                TextSpan(
                                                    style: TextStyle(color: Color(0xFFEB403A)),
                                                    text: "+1"
                                                ),
                                                TextSpan(
                                                    text: ", 每日上限"
                                                ),
                                                TextSpan(
                                                    style: TextStyle(color: Color(0xFFEB403A)),
                                                    text: "*3"
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            SPClassEncryptImage.asset(
                                              SPClassImageUtil.spFunGetImagePath("bg_btn_add_price_draw"),
                                              width: width(65),
                                            ),
                                            Text("去邀请",style: TextStyle(color: Color(0xFFF57900),fontSize: sp(14)),)
                                          ],
                                        ),
                                        onTap: (){
                                          SPClassApiManager.spFunGetInstance().spFunShare(type: "prize_draw",context: context,spProCallBack: SPClassHttpCallBack(
                                              spProOnSuccess: (result){
                                                showModalBottomSheet<void>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return SPClassShareView(title: result.title,spProDesContent: result.content,spProPageUrl: result.spProPageUrl??SPClassNetConfig.spFunGetShareUrl(),spProIconUrl: result.spProIconUrl,);
                                                    });
                                              }
                                          ));
                                        },
                                      ),
                                    ],
                                  ) ,
                                )
                             ],
                           ),

                           SizedBox(height: width(15),),

                           Stack(
                             children: <Widget>[
                               SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_add_price_draw_count"),width: width(302),),
                               Positioned(
                                 left: 0,
                                 right: 0,
                                 top: 0,
                                 bottom: 0,
                                 child: Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: <Widget>[
                                     Container(
                                       width: width(58),
                                       alignment: Alignment.center,
                                       child: Text("方法二",style: TextStyle(
                                           color: Color(0xFF904B22),
                                           fontWeight: FontWeight.w600),),
                                     ),
                                     Container(
                                       width: width(145),
                                       alignment: Alignment.center,
                                       margin: EdgeInsets.only(left: width(13),right: width(15)),
                                       child:RichText(
                                         text: TextSpan(
                                             style: TextStyle(color: Color(0xFF333333),fontSize:sp(12), ),
                                             text: "购买方案成功后，抽奖次数",
                                             children: [
                                               TextSpan(
                                                   style: TextStyle(color: Color(0xFFEB403A)),
                                                   text: "+1"
                                               ),

                                             ]
                                         ),
                                       ),
                                     ),
                                     GestureDetector(
                                       child: Stack(
                                         alignment: Alignment.center,
                                         children: <Widget>[
                                           SPClassEncryptImage.asset(
                                             SPClassImageUtil.spFunGetImagePath("bg_btn_add_price_draw"),
                                             width: width(65),
                                           ),
                                           Text("去购买",style: TextStyle(color: Color(0xFFF57900),fontSize: sp(14)),)
                                         ],
                                       ),
                                       onTap: (){
                                         SPClassApiManager.spFunGetInstance().spFunGuessMatchList<SPClassGuessMatchInfo>(buildContext: context,queryParams: {"fetch_type":"top_scheme_num"},spProCallBack: SPClassHttpCallBack(
                                             spProOnSuccess: (list){
                                               if(list.spProDataList.length>1){
                                                 SPClassNavigatorUtils.spFunPushRoute(context,  SPClassMatchDetailPage(list.spProDataList[0],spProMatchType:"guess_match_id",spProInitIndex: 3,));
                                               }else{
                                                 SPClassNavigatorUtils.spFunPopAll(context);
                                                 SPClassApplicaion.spProEventBus.fire("tab:home");

                                               }
                                             },
                                             onError: (result){
                                               SPClassNavigatorUtils.spFunPopAll(context);
                                               SPClassApplicaion.spProEventBus.fire("tab:home");
                                             }
                                         ));

                                       },
                                     ),
                                   ],
                                 ) ,
                               )
                             ],
                           ),

                           SizedBox(height: width(20),),

                         ],
                       ) ,
                     ),
                     SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_title_add_change"),width: width(239),),

                   ],
                 ),

                 SizedBox(height: width(23),),

               ],
             )
           ],
         ),
       ),
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  void spFunGetSignList() {
    SPClassApiManager.spFunGetInstance().spFunSignInSeqNum(spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (result){
           spProSeqNum= int.tryParse(result.data["seq_num"].toString());
          if(result.data["is_sign_in"].toString()=="1"){
            spProIsSignIn=true;
          }else{
            spProSeqNum--;
          }
          if(spProSeqNum>signList.length+1){
            spProSeqNum=signList.length+1;
          }


          for(var i=0;i<spProSeqNum;i++){
              signList[i]["sign"]=true;
          }
          setState(() {});
        }
    ));
  }

 int spFunGetProductIndex(int index) {

    if(index==3){
      return 8;
    }
    if(index==5){
      return 3;
    }
    if(index==6){
      return 7;
    }
    if(index==7){
      return 6;
    }
    if(index==8){
      return 5;
    }
    return index;

  }

  void spFunGetPrizeDrawList() {

    SPClassApiManager.spFunGetInstance().spFunPrizeDrawList<SPClassBaseModelEntity>(spProCallBack:SPClassHttpCallBack(
        spProOnSuccess: (result){
          var resultList=   SPClassListEntity<SPClassPrizeDrawInfo>(key: "product_list",object: new SPClassPrizeDrawInfo());
          resultList.fromJson(result.data);
          resultList.spProDataList.insert(4, null);
          spProPrizeDrawList=resultList.spProDataList;
          timesLeft=int.tryParse(result.data["times_left"]);
          setState(() {});
        }
    ));
  }

  void spFunStartPriceDraw() {
    spProScaleAnimation.stop();
    spProScaleAnimation.reset();
    SPClassApiManager.spFunGetInstance().spFunPrizeDraw<SPClassPrizeDrawInfo>(context: context,spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (value){
          drawInfoResult=value;
          var findItem=spProPrizeDrawList.firstWhere((item) => (item!=null&&item.spProProductId==drawInfoResult.spProProductId),orElse: ()=>null);
          if(drawInfoResult.spProProductId=="0"){
            if(findItem!=null){
              resultIndex=spFunGetProductIndex(spProPrizeDrawList.indexOf(findItem));
            }else{
              resultIndex=Random().nextInt(8);
            }
          }else{
            resultIndex=spFunGetProductIndex(spProPrizeDrawList.indexOf(findItem));
          }
          timesLeft--;
          spProStartAnimation.reset();
          spProStartAnimation.forward();

        },
        onError: (value){

        }
    ));
  }

}