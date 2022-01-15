import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/colors.dart';

import 'AIAnalysisPage.dart';
import 'FollowPage.dart';
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
  static String spProHomeMatchType = "足球";
  static String spProHomeMatchTypeKey = "is_zq_expert";
  var spProTabMatchKeys = ['', "足球", "篮球"];
  var spProTabExpertKeys = ['', "is_zq_expert", "is_lq_expert", "is_es_expert"];

  @override
  void initState() {
    spProTabMatchController = TabController(
        length: spProTabMatchTitles.length, initialIndex: 1, vsync: this);
    spProTabMatchController.addListener(() {
      if (spProTabMatchIndex == spProTabMatchController.index) {
        return;
      }
      spProTabMatchIndex = spProTabMatchController.index;
      setState(() {});
      if (spProTabMatchTitles[spProTabMatchController.index] == 'AI分析' ||
          spProTabMatchTitles[spProTabMatchController.index] == '关注') {
        return;
      }
      spProHomeMatchType = spProTabMatchKeys[spProTabMatchController.index];
      spProHomeMatchTypeKey = spProTabExpertKeys[spProTabMatchController.index];

      SPClassApplicaion.spProEventBus.fire("scheme:refresh" +
          "${spProTabMatchKeys[spProTabMatchController.index]}");
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
              // padding:EdgeInsets.symmetric(vertical: height(11),horizontal: width(20)),
              padding: EdgeInsets.only(
                  top: height(13),
                  bottom: width(8),
                  left: width(20),
                  right: width(20)),
              child: Container(
                height: width(27),
                child: TabBar(
                    indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width(150))),
                    labelColor: MyColors.main1,
                    labelPadding: EdgeInsets.zero,
                    unselectedLabelColor: Colors.white,
                    indicatorColor: MyColors.main1,
                    unselectedLabelStyle: GoogleFonts.notoSansSC(
                      fontSize: sp(17),
                    ),
                    isScrollable: false,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: GoogleFonts.notoSansSC(
                      fontSize: sp(17),
                      fontWeight: FontWeight.w500,
                    ),
                    controller: spProTabMatchController,
                    tabs: spProTabMatchTitles.map((key) {
                      return Tab(
                        text: key,
                      );
                    }).toList()),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: spProTabMatchController,
                children: <Widget>[
                  FollowPage(),
                  SPClassHomePage(),
                  SPClassHomePage(),
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
