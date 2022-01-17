import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/pages/expert/SPClassExpertLeaderboardPage.dart';
import 'package:sport/pages/home/FollowPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/pages/anylise/SPClassSearchExpertPage.dart';
import 'package:sport/pages/expert/SPClassFollowHomePage.dart';
import 'package:sport/utils/colors.dart';
import 'package:sport/widgets/SPClassSwitchTabBar.dart';
import 'package:sport/widgets/SPClassToolBar.dart';

import 'SPClassExpertListPage.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassExpertHomePage extends StatefulWidget{
  SPClassExpertHomePageState spProState;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  spProState=SPClassExpertHomePageState();
  }

}

class SPClassExpertHomePageState extends State<SPClassExpertHomePage> with TickerProviderStateMixin ,AutomaticKeepAliveClientMixin{
  var titles=["关注","榜单","专家"];
  var spProTabTitle=["关注专家的方案","榜单"];
  List<Widget> views;
  static int index=1;
  PageController spProPageController;
  TabController spProTabMatchController;   //顶部导航栏
  List spProTabMatchTitles = ['关注', '足球', '篮球',];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProTabMatchController =
        TabController(length: spProTabMatchTitles.length,initialIndex: 1, vsync: this);
    spProPageController=PageController(initialPage: index);
    //views=[/*FollowHomePage(),*/SPClassExpertLeaderboardPage()/*,ExpertListPage()*/];
    views=[FollowPage(),SPClassExpertLeaderboardPage(matchType: 'is_zq_expert',),SPClassExpertLeaderboardPage(matchType: 'is_lq_expert',)];
    /*if(index==1){
      ApiManager.getInstance().logAppEvent(spProEventName: "view_expert_ranking",);
    }*/
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: PreferredSize(
          child: AppBar(
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: Column(
        children: <Widget>[
          Container(
            color: MyColors.main1,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: MyColors.main1,
                    // padding:EdgeInsets.symmetric(vertical: height(11),horizontal: width(20)),
                    padding: EdgeInsets.only(
                        top: height(14),
                        bottom: height(8),
                        left: width(20),
                        right: width(20)),
                    child: Container(
                      height: height(26),
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
                          indicatorSize:TabBarIndicatorSize.tab,
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
                ),
                Container(
                  margin: EdgeInsets.only(right: width(20)),
                  child: GestureDetector(
                    child: SPClassEncryptImage.asset(
                      SPClassImageUtil.spFunGetImagePath("ic_search"),
                      width: width(16),
                      fit: BoxFit.fitWidth,
                      color: Colors.white,
                    ),
                    onTap: (){
                      SPClassNavigatorUtils.spFunPushRoute(context, SPClassSearchExpertPage());
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: width(6),),
          Expanded(
            child: TabBarView(
              controller: spProTabMatchController,
              children: views,
            ),
          )
        ],
      ),
    );
    return Scaffold(
     appBar: SPClassToolBar(context,title: "专家",showLead: false,
     actions: <Widget>[
       Container(
         margin: EdgeInsets.only(right: width(20)),
         child: GestureDetector(
           child: SPClassEncryptImage.asset(
             SPClassImageUtil.spFunGetImagePath("ic_search"),
             width: width(16),
             fit: BoxFit.fitWidth,
             color: Color(0xFF333333),
           ),
           onTap: (){
             SPClassNavigatorUtils.spFunPushRoute(context, SPClassSearchExpertPage());
           },
         ),
       ),
     ],
     ),
      body:Container(
        color: Color(0xFFF1F1F1),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: spProPageController,
          children: views,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

 /* void tapTopItem(index){
    spProPageController.jumpToPage(index);
    setState(() {
      ExpertHomePageState.index=index;
    });
    if(index==1){
      ApiManager.getInstance().logAppEvent(spProEventName: "view_expert_ranking",);
    }
    if(index==2){
      ApiManager.getInstance().logAppEvent(spProEventName: "view_expert_list",);
    }
  }*/

}