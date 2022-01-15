import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport/pages/expert/SPClassExpertLeaderboardPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/pages/anylise/SPClassSearchExpertPage.dart';
import 'package:sport/pages/expert/SPClassFollowHomePage.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProPageController=PageController(initialPage: index);
    //views=[/*FollowHomePage(),*/SPClassExpertLeaderboardPage()/*,ExpertListPage()*/];
    views=[SPClassExpertLeaderboardPage()];
    /*if(index==1){
      ApiManager.getInstance().logAppEvent(spProEventName: "view_expert_ranking",);
    }*/
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Scaffold(
     /* appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: SwitchTabBar(
          spProTabTitles:titles,
          index:index,
          fontSize: sp(16),
          width: width(67*titles.length),
          height: width(29),
          spProTabChanged: (index){
            tapTopItem(index);
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: width(20)),
            child:index==2 ? GestureDetector(
              child: SPClassEncryptImage.asset(
                ImageUtil.getImagePath("ic_search"),
                width: width(16),
                fit: BoxFit.fitWidth,
                color: Color(0xFF333333),
              ),
              onTap: (){
                NavigatorUtils.pushRoute(context, SearchExpertPage());
              },
            ):SizedBox(),
          ),
        ],
      ),*/
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