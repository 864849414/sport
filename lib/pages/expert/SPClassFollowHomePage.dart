import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'SPClassFollowExpertPage.dart';
import 'SPClassFollowExpertSchemPage.dart';

class SPClassFollowHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassFollowHomePageState();
  }

}

class SPClassFollowHomePageState extends State<SPClassFollowHomePage> with TickerProviderStateMixin ,AutomaticKeepAliveClientMixin{
  var spProTabTitle=["关注专家的方案","关注的专家"];
  TabController spProTabController;
  List<Widget> views;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProTabController=TabController(length: spProTabTitle.length,vsync: this);
    views=[SPClassFollowExpertSchemPage(),SPClassFollowExpertPage()];
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Scaffold(

      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]),top: BorderSide(width: 0.4,color: Colors.grey[300]))
              ),
              child: TabBar(
                  labelColor: Color(0xFFE3494B),
                  unselectedLabelColor: Color(0xFF333333),
                  isScrollable: false,
                  indicatorColor: Color(0xFFE3494B),
                  labelStyle: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.bold),
                  unselectedLabelStyle: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w400),
                  controller: spProTabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs:spProTabTitle.map((spProTabTitle){
                    return Container(
                      alignment: Alignment.center,
                      height: height(35),
                      child:Text(spProTabTitle,style: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: sp(15)),),
                    );
                  }).toList()
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: spProTabController,
                children:views,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}