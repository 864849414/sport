
import 'package:flutter/material.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassConfRewardEntity.dart';
import 'package:sport/model/SPClassShowPListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/colors.dart';
import 'package:sport/utils/common.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'SPClassRechargeDiamondPage.dart';
import 'package:sport/utils/SPClassImageUtil.dart';


class SPClassNewUserWalFarePage extends StatefulWidget{
    @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return SPClassNewUserWalFarePageState();
    }

}

class SPClassNewUserWalFarePageState extends State<SPClassNewUserWalFarePage>{
    bool spProIsRegister=false;
    @override
    void initState() {
        // TODO: implement initState
        super.initState();

       SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "new_user_reward",);

       if(SPClassApplicaion.spProShowPListEntity==null){
         SPClassApiManager.spFunGetInstance().spFunShowPConfig(spProCallBack: SPClassHttpCallBack<SPClassShowPListEntity>(
             spProOnSuccess: (result){
               SPClassApplicaion.spProShowPListEntity=result;
               setState(() {});
             }
         ));
       }
       if(SPClassApplicaion.spProConfReward==null) {
         SPClassApiManager.spFunGetInstance().spFunConfReward<SPClassConfRewardEntity>(spProCallBack:SPClassHttpCallBack(
             spProOnSuccess: (value){
               SPClassApplicaion.spProConfReward=value;
               setState(() {});
             }
         ));
       }


    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body: Stack(
          children: <Widget>[
            SPClassEncryptImage.asset(
              SPClassImageUtil.spFunGetImagePath("fuli_bg"),
              width: MediaQuery.of(context).size.width,
            ),
           Column(
             children: <Widget>[
               SizedBox(
                 height: MediaQuery.of(context).padding.top,
               ),
               Commons.getAppBar(title: '新人好礼',appBarLeft: GestureDetector(
                 child: SPClassEncryptImage.asset(
                   SPClassImageUtil.spFunGetImagePath("arrow_right"),
                   width: width(23),
                 ),
                 onTap: (){Navigator.of(context).pop();},)),
               SizedBox(height: width(161),),
               GestureDetector(
                 onTap: (){
                   if(spFunIsLogin(context: context)){
                     SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage());

                   }
                 },
                 child: Container(
                   child: SPClassEncryptImage.asset(
                     SPClassImageUtil.spFunGetImagePath("fuli_1"),
                     width: MediaQuery.of(context).size.width-54,
                   ),
                 ),
               ),
               SizedBox(height: width(7),),
               GestureDetector(
                 onTap: (){
                   if(spFunIsLogin(context: context)){
                     SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage(spProMoneySelect: 168,));
                   }
                 },
                 child: Container(
                   child: SPClassEncryptImage.asset(
                     SPClassImageUtil.spFunGetImagePath("fuli_2"),
                     width: MediaQuery.of(context).size.width-54,
                   ),
                 ),
               ),
               SizedBox(height: width(7),),
               GestureDetector(
                 onTap: (){
                   if(spFunIsLogin(context: context)){
                     SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage(spProMoneySelect: 388,));
                   }
                 },
                 child: Container(
                   child: SPClassEncryptImage.asset(
                     SPClassImageUtil.spFunGetImagePath("fuli_3"),
                     width: MediaQuery.of(context).size.width-54,
                   ),
                 ),
               ),
               SizedBox(height: width(7),),
               GestureDetector(
                 onTap: (){
                   if(spFunIsLogin(context: context)){
                     SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage(spProMoneySelect: 888,));
                   }
                 },
                 child: Container(
                   child: SPClassEncryptImage.asset(
                     SPClassImageUtil.spFunGetImagePath("fuli_4"),
                     width: MediaQuery.of(context).size.width-54,
                   ),
                 ),
               ),
               SizedBox(height: width(22),),
               Text('更多福利敬请期待...',style: TextStyle(fontSize: sp(15),color: MyColors.grey_66),)
             ],
           )

          ],
        ),
      );
        // TODO: implement build
        return Scaffold(
                appBar: SPClassToolBar(
                  context,title: "新人福利",
                  spProBgColor: MyColors.main1,
                  iconColor: 0xffffffff,
                ),
          body: Container(
                color: Color(0xFFF1F1F1),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[


                    GestureDetector(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left:width(13) ,right:width(13),top: width(13) ),
                            decoration: BoxDecoration(
                              boxShadow:[BoxShadow(
                                offset: Offset(0.1,0.5),
                                color: Color(0x1a000000),
                                blurRadius:width(6,),
                              )],
                            ),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("bg_my_prize"),
                              height: height(83),
                              fit: BoxFit.fill,
                              width: width(333),
                            ),
                          ),
                          Positioned(
                            left: width(13),
                            right: width(13),
                            bottom: 0,
                            child: Container(
                              height: height(83),
                              padding: EdgeInsets.only(left:width(16) ,right:width(16) ),

                              child: Row(
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_diamond_first_rechart"),
                                    width: width(48),
                                    height: width(48),
                                  ),
                                  SizedBox(width: 10,),
                                  Flexible(
                                    flex: 1,
                                    fit:FlexFit.tight ,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("18元",style: TextStyle(fontSize:sp(20),color: Color(0xFF333333),fontWeight: FontWeight.w500),),
                                        Text("首充18元即可翻倍获得",style: TextStyle(fontSize:sp(10),color: Color(0xFF999999)),)

                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width(75),
                                    height: height(35),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width(3)),
                                      color: MyColors.main1
                                    ),
                                    child: Text("领取",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                  )


                                ],
                              ),

                            ),
                          ),
                          Positioned(
                            top:  height(12),
                            left: width(13),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_lable_first_rechart"),
                              width: width(34),
                              height: width(34),
                            ),
                          )
                        ],
                      ),
                      onTap: (){
                        if(spFunIsLogin(context: context)){
                            SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage());

                        }
                      },
                    ),

                    GestureDetector(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left:width(13) ,right:width(13),top: width(13) ),
                            decoration: BoxDecoration(
                              boxShadow:[BoxShadow(
                                offset: Offset(0.1,0.5),
                                color: Color(0x1a000000),
                                blurRadius:width(6,),
                              )],
                            ),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("bg_my_prize"),
                              height: height(83),
                              fit: BoxFit.fill,
                              width: width(333),
                            ),
                          ),
                          Positioned(
                            left: width(13),
                            right: width(13),
                            bottom: 0,
                            child: Container(
                              height: height(83),
                              padding: EdgeInsets.only(left:width(16) ,right:width(16) ),

                              child: Row(
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_diamond_first_rechart"),
                                    width: width(48),
                                    height: width(48),
                                  ),
                                  SizedBox(width: 10,),
                                  Flexible(
                                    flex: 1,
                                    fit:FlexFit.tight ,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("20元",style: TextStyle(fontSize:sp(20),color: Color(0xFF333333),fontWeight: FontWeight.w500),),
                                        Text("限时充值168元即可赠送价值20元钻石",style: TextStyle(fontSize:sp(10),color: Color(0xFF999999)),)

                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width(22),),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width(75),
                                    height: height(35),
                                    color: MyColors.main1,
                                    child: Text("领取",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                  )


                                ],
                              ),

                            ),
                          ),
                          Positioned(
                            top:  height(12),
                            left: width(13),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_lab_limit"),
                              width: width(34),
                              height: width(34),
                            ),
                          )
                        ],
                      ),
                      onTap: (){
                        if(spFunIsLogin(context: context)){
                            SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage(spProMoneySelect: 168,));
                        }
                      },
                    ),

                    GestureDetector(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left:width(13) ,right:width(13),top: width(13) ),
                            decoration: BoxDecoration(
                              boxShadow:[BoxShadow(
                                offset: Offset(0.1,0.5),
                                color: Color(0x1a000000),
                                blurRadius:width(6,),
                              )],
                            ),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("bg_my_prize"),
                              height: height(83),
                              fit: BoxFit.fill,
                              width: width(333),
                            ),
                          ),
                          Positioned(
                            left: width(13),
                            right: width(13),
                            bottom: 0,
                            child: Container(
                              height: height(83),
                              padding: EdgeInsets.only(left:width(16) ,right:width(16) ),

                              child: Row(
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_diamond_first_rechart"),
                                    width: width(48),
                                    height: width(48),
                                  ),
                                  SizedBox(width: 10,),
                                  Flexible(
                                    flex: 1,
                                    fit:FlexFit.tight ,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("40元",style: TextStyle(fontSize:sp(20),color: Color(0xFF333333),fontWeight: FontWeight.w500),),
                                        Text("限时充值388元即可赠送价值40元钻石",style: TextStyle(fontSize:sp(10),color: Color(0xFF999999)),)

                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width(22),),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width(75),
                                    height: height(35),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width(3)),
                                      color: MyColors.main1,
                                    ),
                                    child: Text("领取",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                  )


                                ],
                              ),

                            ),
                          ),
                          Positioned(
                            top:  height(12),
                            left: width(13),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_lab_limit"),
                              width: width(34),
                              height: width(34),
                            ),
                          )
                        ],
                      ),
                      onTap: (){
                        if(spFunIsLogin(context: context)){
                            SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage(spProMoneySelect: 388,));
                        }
                      },
                    ),

                    GestureDetector(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left:width(13) ,right:width(13),top: width(13) ),
                            decoration: BoxDecoration(
                              boxShadow:[BoxShadow(
                                offset: Offset(0.1,0.5),
                                color: Color(0x1a000000),
                                blurRadius:width(6,),
                              )],
                            ),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("bg_my_prize"),
                              height: height(83),
                              fit: BoxFit.fill,
                              width: width(333),
                            ),
                          ),
                          Positioned(
                            left: width(13),
                            right: width(13),
                            bottom: 0,
                            child: Container(
                              height: height(83),
                              padding: EdgeInsets.only(left:width(16) ,right:width(16) ),

                              child: Row(
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_diamond_first_rechart"),
                                    width: width(48),
                                    height: width(48),
                                  ),
                                  SizedBox(width: 10,),
                                  Flexible(
                                    flex: 1,
                                    fit:FlexFit.tight ,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("100元",style: TextStyle(fontSize:sp(20),color: Color(0xFF333333),fontWeight: FontWeight.w500),),
                                        Text("限时充值888元即可赠送价值100元钻石",style: TextStyle(fontSize:sp(10),color: Color(0xFF999999)),)

                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width(22),),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width(75),
                                    height: height(35),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width(3)),
                                      color: MyColors.main1,
                                    ),
                                    child: Text("领取",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                  )


                                ],
                              ),

                            ),
                          ),
                          Positioned(
                            top:  height(12),
                            left: width(13),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_lab_limit"),
                              width: width(34),
                              height: width(34),
                            ),
                          )
                        ],
                      ),
                      onTap: (){
                        if(spFunIsLogin(context: context)){
                            SPClassNavigatorUtils.spFunPushRoute(context,  SPClassRechargeDiamondPage(spProMoneySelect: 888,));
                        }
                      },
                    ),
                  ],
                ),
      ),
          bottomNavigationBar: Container(
            alignment: Alignment.center,
            height: height(40),
            child: Text("更多福利，敬请期待...",style: TextStyle(color: Color(0xFFB7B7B7),fontSize: sp(10)),),
          ),
    );
    }







}