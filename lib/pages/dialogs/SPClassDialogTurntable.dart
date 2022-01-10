import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassPrizeDrawInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/common/SPClassDialogUtils.dart';
import 'package:sport/pages/dialogs/SPClassDialogOpenRedPakege.dart';
import 'package:sport/pages/user/SPClassNewTurntableHistoryPage.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassDialogTurntable extends StatefulWidget{
  VoidCallback callback;
  SPClassDialogTurntable(this.callback);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassDialogTurntableState();
  }

}

class SPClassDialogTurntableState extends State<SPClassDialogTurntable> with TickerProviderStateMixin{
  List<Color> colors=[Colors.black,Colors.blue,Colors.red,Colors.green,Colors.deepOrange,Colors.amberAccent];
  Animation<double> animation;
  AnimationController controller;
  var spProRateRadius=0.0;
  var price="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=AnimationController(duration: Duration(milliseconds: 6000),vsync: this);
    animation= Tween<double>(begin: 0, end:1,).animate(controller);
    controller.addListener(() {
      setState(() {

      });
    });
    controller.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        if(spProRateRadius==0){
           SPClassToastUtils.spFunShowToast(msg: "很遗憾！您与大奖擦肩而过了~别灰心，明天再来！");
        }
        if(spProRateRadius==0.5){
          SPClassDialogUtils.spFunShowConfirmDialog(context,RichText(
            text: TextSpan(
              text: "恭喜你！",
              style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
              children: <TextSpan>[
                TextSpan(text: "2钻石", style: TextStyle(fontSize: 16, color: Color(0xFFE3494B))),
                TextSpan(text: "!请到中奖记录查看~", style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
              ],
            ),
          ), (){},showCancelBtn: false);
        }

        if(spProRateRadius==0.675){
          Navigator.of(context).pop();

          showCupertinoModalPopup(context: context, builder: (c)=> SPClassDialogOpenRedPakege(price));
        }

      }
    });

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_turntable_title"),width: width(275),),

              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Transform.rotate(angle:animation.value*((pi*2)*spProRateRadius+(pi*6)),
                    child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_cicrcle_turntable"),
                    width: width(319,),
                      height: width(319,),),
                  ),
                  GestureDetector(
                    child:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_turntable_start"),width: width(117),),
                    onTap: (){
                      if(spFunIsLogin(context: context)){
                        SPClassApiManager.spFunGetInstance().spFunPrizeDraw<SPClassPrizeDrawInfo>(context: context,spProCallBack: SPClassHttpCallBack(
                            spProOnSuccess: (value){
                              if(double.tryParse(value.spProProductId)>0){
                                if(value.spProProductName.contains("钻石")){
                                  spProRateRadius=0.5;
                                } else if (value.spProProductName.contains("红包")){
                                  price=SPClassStringUtils.spFunSqlitZero(value.price);
                                  spProRateRadius=0.675;
                                }else{
                                  spProRateRadius=0;
                                }
                              }else{
                                spProRateRadius=0;
                              }
                              animation= CurvedAnimation(
                                  parent: Tween<double>(begin: 0, end:1,).animate(controller), curve: Curves.linearToEaseOut);
                              controller.forward();

                            },
                          onError: (value){

                          }
                        ));
                      }



                    },
                  ),
                ],
              ),
            SizedBox(height: height(30),),

             GestureDetector(
               child: Text("中奖记录",style: TextStyle(color: Color(0xFFFED376),fontSize: sp(16),decoration: TextDecoration.underline),),
               onTap: (){
                 if(spFunIsLogin(context: context)){
                   SPClassNavigatorUtils.spFunPushRoute(context,SPClassNewTurntableHistoryPage() );
                 }
               },
             ),

            SizedBox(height: height(30),),

            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(width(5)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                    border:Border.all(color: Colors.white,width: 2)
                ),
                child: Icon(Icons.close,color: Colors.white,size: 30,),
              ),
              onTap: (){
                Navigator.of(context).pop();

                if(widget.callback!=null){
                  widget.callback();
                }

              },
            )


          ],
        ),
      ),
    );
  }


}