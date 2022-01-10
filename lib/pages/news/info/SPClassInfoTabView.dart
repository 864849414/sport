import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/contants/SPClassSharedPreferencesKeys.dart';
import 'package:sport/model/SPClassListEntity.dart';
import 'package:sport/model/SPClassSportTag.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';

import 'package:sport/pages/common/SPClassLoadingPage.dart';
import 'package:sport/pages/common/SPClassNetErrorPage.dart';

import 'SPClassInfoListViewPage.dart';

class SPClassInfoTabView extends StatefulWidget {
  String spProTabType;
  int spProTabTypeInt;
  SPClassInfoTabView(this.spProTabType,this.spProTabTypeInt);
  SPClassInfoTabViewState createState() => SPClassInfoTabViewState();
}

class SPClassInfoTabViewState extends State<SPClassInfoTabView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  List<SPClassInfoListViewPage> spProPages;
  List<SPClassSportTag> spProInfoTags = List();
  TabController spProTabController;
  TabBar spProTabBar;
  bool spProIsNetError = false;
  bool spProIsLoading = false;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunGetTabInfo();



  }




  @override
  Widget build(BuildContext context) {
    super.build(context);
    return spProIsLoading
        ? SPClassLoadingPage()
        : (spProIsNetError
            ? SPClassNetErrorPage(() {
                spFunGetTabInfo();
              })
            : Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    spFunBuildTabs(),
                    Container(
                      height: 0.5,
                      color: Colors.grey[200],
                    ),
                    Flexible(
                      flex: 1,
                      child: spProTabController == null
                          ? Container()
                          : TabBarView(
                              physics: PageScrollPhysics(),
                              controller: spProTabController,
                              children: spFunBuildInfoTabView(),
                            ),
                    )
                  ],
                ),
              ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  Future<void> spFunGetTabInfo() async {
    spProIsLoading = true;
    if (mounted) {
      setState(() {});
    }
    var sp =await SharedPreferences.getInstance();

    SPClassApiManager.spFunGetInstance().spFunSportTags<SPClassSportTag>(spProCallBack:SPClassHttpCallBack(
        spProOnSuccess: (result){
          spProIsLoading = false;
          spProIsNetError = false;
      sp.setString(
          SPClassSharedPreferencesKeys.KEY_TAB_JSON, jsonEncode(result.spProDataList));
      result.spProDataList.forEach((item) {
        if (item.tagType == widget.spProTabType) {
          spProInfoTags.add(item);
        }
      });
      setState(() {

      });
    },onError: (e){
      if (sp.getInt(SPClassSharedPreferencesKeys.KEY_TAB_TYPE) != null &&
          sp.getInt(SPClassSharedPreferencesKeys.KEY_TAB_TYPE) == widget.spProTabTypeInt) {
        if (sp.getString(SPClassSharedPreferencesKeys.KEY_TAB_JSON) !=
            null) {
          var jsonTab = json.decode(
              sp.getString(SPClassSharedPreferencesKeys.KEY_TAB_JSON));
          SPClassListEntity<SPClassSportTag>(key: "tag_list",object: new SPClassSportTag()).fromJson(jsonTab).tagList.forEach((item) {
            if (item.tagType == widget.spProTabType) {
              spProInfoTags.add(item);
            }
          });
        } else {
          spProIsNetError = true;
        }
      } else {
        spProIsNetError = true;
      }
     setState(() {

     });
    }));

  }

  Widget spFunBuildTabs() {
    if (spProInfoTags.length > 0) {
      if (spProTabBar == null) {
        spProTabController = TabController(length: spProInfoTags.length, vsync: this);
        spProTabBar = TabBar(
          labelColor: Color(0xFFE3494B),
          unselectedLabelColor: Color(0xFF333333),
          indicatorColor: Color(0xFFE3494B),
          isScrollable: true,
          labelStyle: TextStyle(fontSize: sp(15),),
          controller: spProTabController,
          tabs: spFunGetTabWidget(),
        );
      }
    
      return spProTabBar;
    } else {
      return Container();
    }
  }

  spFunGetTabWidget() {
    List<Widget> tabs = List();
    spProInfoTags.forEach((item) {
      tabs.add(Container(
        alignment: Alignment.center,
        height: height(30),
        child:Text(item.tag,style: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: sp(15)),),
      ));


    });
    return tabs;
  }

  spFunBuildInfoTabView() {
    spProPages = List();
    spProInfoTags.forEach((item) {
      spProPages.add(SPClassInfoListViewPage(item,widget.spProTabType));
    });
    return spProPages;
  }
}
