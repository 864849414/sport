import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/pages/user/coupon/SPClassCouponList.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/widgets/SPClassToolBar.dart';

class SPClassCouponPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassCouponPageState();
  }

}

class SPClassCouponPageState  extends State<SPClassCouponPage> with TickerProviderStateMixin{
  TabController spProTabController;
  var spProTabTitle =["未使用","已使用","已过期"];
  var keys =["unused","used","used"];
  List<SPClassCouponList> views=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProTabController=TabController(length: spProTabTitle.length,vsync: this);

    views=keys.map((key) => SPClassCouponList(status:key ,)).toList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(context,title: "优惠券"),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
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
                  tabs:spProTabTitle.map((spProTabTitle){
                    return Container(
                      alignment: Alignment.center,
                      height: width(35),
                      width: width(55),
                      child:Text(spProTabTitle,style: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: sp(15)),),
                    );
                  }).toList()
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: spProTabController,
                children: views,
              ),
            )
          ],
        ),
      )
    );
  }

}