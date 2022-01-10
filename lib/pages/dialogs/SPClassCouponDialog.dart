import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassCoupon.dart';
import 'package:sport/pages/user/coupon/SPClassCouponPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassCouponDialog extends StatefulWidget{
  List<SPClassCoupon> coupon;

  SPClassCouponDialog({this.coupon});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassCouponDialogState();
  }

}

class SPClassCouponDialogState extends State<SPClassCouponDialog>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child:Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width(313),
              decoration: BoxDecoration(
                  gradient:LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF21E0F),
                        Color(0xFFF24A0C)
                      ]
                  ),
                  borderRadius: BorderRadius.circular(width(5))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      SPClassEncryptImage.asset(
                          SPClassImageUtil.spFunGetImagePath("ic_cupon_title",format: ".png"),
                          width: width(313),

                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            width: width(290),
                            margin: EdgeInsets.only(top: width(106),bottom:  width(12)),
                            height: width(232),
                            child: ListView(
                              children: widget.coupon.map((item) => Stack(
                                children: <Widget>[
                                  Container(
                                    height: width(63),
                                    margin: EdgeInsets.only(right: width(12),left: width(12),top:height(12) ),
                                    decoration: BoxDecoration(
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
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: AssetImage(
                                              SPClassImageUtil.spFunGetImagePath("bg_coupon_item"),
                                            )
                                        )
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          width: width(69),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  RichText(
                                                    text: TextSpan(
                                                        text: "￥",
                                                        style: TextStyle(color:Colors.white ,fontSize: sp(10),),
                                                        children: <InlineSpan>[
                                                          TextSpan(
                                                              text:item.spPromoney,
                                                              style: TextStyle(fontSize: sp(24))
                                                          )
                                                        ]
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: width(12)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(item.spProCouponName,style: TextStyle(fontSize: sp(15),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                Text(sprintf("满%s可用",[item.spProMinMoney],),style: TextStyle(fontSize: sp(10),color: Color(0xFFB4B4B4)),)

                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: height(12),
                                    right:  width(12),
                                    child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_lable_coupon"),width: width(32),),
                                  )
                                ],
                              )).toList(),
                            ),
                          ),

                          GestureDetector(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                SPClassEncryptImage.asset(
                                  SPClassImageUtil.spFunGetImagePath("ic_btn_reciver_price_draw"),
                                  width: width(117),
                                ),
                                Text("一键领取",style: TextStyle(color: Color(0xFFF57900),fontSize: sp(14),fontWeight: FontWeight.bold),)
                              ],
                            ),
                            onTap: (){
                              if(spFunIsLogin(context: context)){
                                var result= JsonEncoder().convert(widget.coupon.map((e) => e.spProCouponId).toList()).
                                replaceAll("[", "").replaceAll("]", "").replaceAll(",", ";").replaceAll("\"", "");
                                SPClassApiManager.spFunGetInstance().spFunCouponReceive<SPClassBaseModelEntity>(context:context,
                                  queryParameters: {"coupon_id":result},spProCallBack: SPClassHttpCallBack(
                                      spProOnSuccess: (result){
                                         Navigator.of(context).pop();
                                         SPClassNavigatorUtils.spFunPushRoute(context,SPClassCouponPage());
                                      }
                                  ),
                                );
                              }

                            },
                          ),

                          SizedBox(height: width(15),),
                        ],
                      )
                    ],
                  ),
                ],
              ),
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

              },
            )

          ],
        ),
      ),
      onWillPop:() async{
        return true;
      },
    );
  }

}