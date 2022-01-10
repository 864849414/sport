import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassCoupon.dart';
import 'package:sport/pages/user/prizeDraw/SPClassPrizeDrawPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassPriceDrawDialog extends StatefulWidget{
  VoidCallback callback;



  SPClassPriceDrawDialog({this.callback});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassPriceDrawDialogState();
  }

}

class SPClassPriceDrawDialogState extends State<SPClassPriceDrawDialog>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body:Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SPClassEncryptImage.asset(
                  SPClassImageUtil.spFunGetImagePath("bg_price_draw_home"),
                  width: width(314),

                ),

                 Positioned(
                   child: GestureDetector(
                     child: Stack(
                       alignment: Alignment.center,
                       children: <Widget>[
                         SPClassEncryptImage.asset(
                           SPClassImageUtil.spFunGetImagePath("ic_btn_reciver_price_draw"),
                           width: width(117),
                         ),
                         Text("点击查看详情",style: TextStyle(color: Color(0xFFF57900),fontSize: sp(13),fontWeight: FontWeight.bold),)
                       ],
                     ),
                     onTap: (){

                       if(spFunIsLogin(context: context)){
                         Navigator.of(context).pop();
                         SPClassNavigatorUtils.spFunPushRoute(context, SPClassPrizeDrawPage());

                         if(widget.callback!=null){
                           widget.callback();
                         }
                       }


                     },
                   ),
                   bottom: width(10),
                 )
              ],
            ),

            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top: width(15)),
                width: width(23),
                height: width(23),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                    border:Border.all(color: Colors.white,width: 1)
                ),
                child: Icon(Icons.close,color: Colors.white,size: width(15),),
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
      ));
  }

}