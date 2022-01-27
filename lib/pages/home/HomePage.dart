import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/colors.dart';

import 'AIAnalysisPage.dart';
import 'FollowPage.dart';
import 'HomeDetailPage.dart';
import 'SPClassHomePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  List spProTabMatchTitles = ['关注', '足球', '篮球', 'AI分析'];
  TabController spProTabMatchController; //顶部导航栏
  int spProTabMatchIndex = 1; //顶部栏的下标

  @override
  void initState() {
    spProTabMatchController = TabController(
        length: spProTabMatchTitles.length, initialIndex: 1, vsync: this);
    spProTabMatchController.addListener(() {
      setState(() {

      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0,
        ),
        preferredSize: Size.fromHeight(0),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              color: MyColors.main1,
              height: width(48),
              padding: EdgeInsets.only(
                // top: height(14),
                // bottom: height(8),
                  left: width(18),
                  right: width(18)),
              child: Container(
                height: width(30),
                child: TabBar(
                    labelColor: MyColors.main1,
                    labelPadding: EdgeInsets.zero,
                    indicatorColor: Colors.transparent,
                    indicatorPadding: EdgeInsets.zero,
                    unselectedLabelColor: Colors.white,
                    unselectedLabelStyle: GoogleFonts.notoSansSC(
                      fontSize: sp(17),
                    ),
                    isScrollable: false,
                    // indicatorSize:TabBarIndicatorSize.tab,
                    labelStyle: GoogleFonts.notoSansSC(
                      fontSize: sp(17),
                      fontWeight: FontWeight.w500,
                    ),
                    controller: spProTabMatchController,
                    tabs: spProTabMatchTitles.map((key) {
                      return Container(
                        width: width(65),
                        height: width(27),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:spProTabMatchController.index==spProTabMatchTitles.indexOf(key)?Colors.white: MyColors.main1,
                          borderRadius: BorderRadius.circular(width(150)),
                        ),
                        child: Text(key),
                      );
                      // return Tab(
                      //   text: key,
                      // );
                    }).toList()),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: spProTabMatchController,
                children: <Widget>[
                  FollowPage(),
                  HomeDetailPage(type: 0,),
                  HomeDetailPage(type: 1,),
                  AIAnalysis(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
