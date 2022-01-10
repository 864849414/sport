import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassCoupon.dart';
import 'package:sport/pages/user/SPClassNewTurntableHistoryPage.dart';
import 'package:sport/pages/user/prizeDraw/SPClassPrizeDrawPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sprintf/sprintf.dart';

class SPClassPriceDrawHistoryDialog extends StatefulWidget{



  SPClassPriceDrawHistoryDialog();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassPriceDrawHistoryDialogState();
  }

}

class SPClassPriceDrawHistoryDialogState extends State<SPClassPriceDrawHistoryDialog> with TickerProviderStateMixin{
  TabController spProTabController;
  var spProTabTitles=["中奖记录","抽奖记录"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProTabController=TabController(length: spProTabTitles.length,vsync: this);
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
            Container(
              width: width(269),
              height: height(400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(width(5))
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:BorderRadius.vertical(top:Radius.circular(width(5))),
                    ),
                    child: TabBar(
                        labelColor: Color(0xFFE3494B),
                        unselectedLabelColor: Color(0xFF666666),
                        isScrollable: false,
                        indicatorColor: Color(0xFFE3494B),
                        labelStyle: TextStyle(fontSize: sp(14),fontWeight: FontWeight.bold),
                        unselectedLabelStyle: TextStyle(fontSize: sp(14),fontWeight: FontWeight.w400),
                        controller: spProTabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs:spProTabTitles.map((spProTabTitle){
                          return Container(
                            alignment: Alignment.center,
                            height: width(35),
                            child:Text(spProTabTitle,style: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: sp(15)),),
                          );
                        }).toList()
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: spProTabController,
                      children: [SPClassNewTurntableHistoryPage(),SPClassNewTurntableHistoryPage(spProJustWin: "0",),],
                    ),
                  )
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
      ));
  }

}