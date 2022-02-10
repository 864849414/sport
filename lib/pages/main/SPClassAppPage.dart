
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_huawei_push/flutter_plugin_huawei_push.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/app/SPClassGlobalNotification.dart';
import 'package:sport/contants/SPClassSharedPreferencesKeys.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassSchemeDetailEntity.dart';
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/pages/common/SPClassShareView.dart';
import 'package:sport/pages/competition/SPClassMatchListSettingPage.dart';
import 'package:sport/pages/competition/detail/SPClassMatchDetailPage.dart';
import 'package:sport/pages/competition/scheme/SPClassExpertApplyPage.dart';
import 'package:sport/pages/competition/scheme/SPClassSchemeDetailPage.dart';
import 'package:sport/pages/dialogs/SPClassPrivacyDialogDialog.dart';
import 'package:sport/pages/expert/SPClassExpertHomePage.dart';
import 'package:sport/pages/game/SPClassGamePage.dart';
import 'package:sport/pages/home/HomePage.dart';
import 'package:sport/pages/home/SPClassHomePage.dart';
import 'package:sport/pages/hot/SPClassHotHomePage.dart';
import 'package:sport/pages/news/SPClassWebPageState.dart';
import 'package:sport/pages/score/SPClassCompetitionHomePage.dart';
import 'package:sport/pages/user/SPClassContactPage.dart';
import 'package:sport/pages/user/SPClassUserPage.dart';
import 'package:sport/pages/user/setting/SPClassVersionCheckDialog.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/widgets/Qnav/SPClassQNavBar.dart';
import 'package:sport/widgets/Qnav/SPClassQNavButton.dart';
import 'package:sport/utils/SPClassToastUtils.dart';

class SPClassAppPage extends StatefulWidget
{
  @override

  SPClassAppPageState createState()=>SPClassAppPageState();

}

class SPClassAppPageState extends State<SPClassAppPage>
{
  List<Widget> spProPageList =  List();
  List<SPClassQNavTab> tabs=List();
  int spProIndex = 0;

  var spProExpertIndex=-1;
  PageController controller;

  var spProLastPressedAt;
  var spProPopTimer= DateTime.now();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child:  Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children:spProPageList,
        ) ,
        bottomNavigationBar:SafeArea(
          bottom: true,
          child: SPClassQNavBar(spProNavTabs: tabs,spProPageChange: (value)=>spFunItemTapped(value),spProNavHeight: height(48),spProNavTextSize: width(10),spProSelectIndex: spProIndex,),
        ),
      ),
      onWillPop: () async{
        if(DateTime.now().difference(spProPopTimer).inSeconds>3){
          SPClassToastUtils.spFunShowToast(msg: "再按一次退出");
        }else{
          return true;
        }
        spProPopTimer=DateTime.now();
        return false;
      },
    );
  }

  void spFunCheckVersion() {

    SPClassApiManager.spFunGetInstance().spFunCheckUpdate(spProCallBack:SPClassHttpCallBack(
        spProOnSuccess: (result){
          if(result.spProNeedUpdate){
            showDialog<void>(
                context: context,
                builder: (BuildContext cx) {
                  return SPClassVersionCheckDialog(
                    result.spProIsForced??false,
                    result.spProUpdateDesc??'',
                    result.spProAppVersion??'',
                    spProDownloadUrl: result.spProDownloadUrl??'',
                    spProCancelCallBack: (){
                      Navigator.of(context).pop();
                      SPClassApplicaion.spFunShowUserDialog(context);
                    },
                  );
                });
          }else{
            SPClassApplicaion.spFunShowUserDialog(context);
          }
        },
      onError: (error){
        SPClassApplicaion.spFunShowUserDialog(context);

      }
    ) );

  }


  void spFunGetBcwUrl(String value){
    if(spFunIsLogin(context: context)){
      var params=SPClassApiManager.spFunGetInstance().spFunGetCommonParams();
      params.putIfAbsent("model_type", ()=>value);
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassWebPage( SPClassNetConfig.spFunGetBasicUrl()+"user/bcw/login?"+Transformer.urlEncodeMap(params),""));
    }
  }




  spFunGoRoutPage(String urlPage,String title,String spProMsgId,bool isDemo){
    if(spProMsgId!=null){
      SPClassApiManager.spFunGetInstance().spFunPushMsgClick(pushMsgId: spProMsgId,isDemo: isDemo,spProAutoLoginStr: spFunIsLogin()? SPClassApplicaion.spProUserLoginInfo.spProAutoLoginStr:"");
    }
    if(urlPage==null||urlPage.trim().isEmpty){
      return;
    }
    if(urlPage.startsWith("hs_sport:")){
      Uri url = Uri.parse(urlPage.replaceAll("hs_sport", "hssport"));
      if(urlPage.contains("scheme?")){
        if(spFunIsLogin(context: context)){
          SPClassApiManager.spFunGetInstance().spFunSchemeDetail(
              queryParameters: {"scheme_id":url.queryParameters["scheme_id"]},
              context: context,spProCallBack:SPClassHttpCallBack<SPClassSchemeDetailEntity>(
              spProOnSuccess: (value){
                SPClassNavigatorUtils.spFunPushRoute(context,  SPClassSchemeDetailPage(value));
              }
          ));
        }
      }
      if(urlPage.contains("expert?")){
        SPClassApiManager.spFunGetInstance().spFunExpertInfo(queryParameters: {"expert_uid":url.queryParameters["expert_uid"]},
            context:context,spProCallBack: SPClassHttpCallBack(
                spProOnSuccess: (info){
                  SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertDetailPage(info));
                }
            ));
      }
      if(urlPage.contains("guess_match?")){
        SPClassApiManager.spFunGetInstance().spFunSportMatchData<SPClassGuessMatchInfo>(loading: true,context: context,spProGuessMatchId:url.queryParameters["guess_match_id"],dataKeys: "guess_match",spProCallBack: SPClassHttpCallBack(
            spProOnSuccess: (result) async {
              SPClassNavigatorUtils.spFunPushRoute(context, SPClassMatchDetailPage(result,spProMatchType:"guess_match_id",spProInitIndex: 1,));
            }
        ) );
      }
      if(urlPage.contains("invite")){
        if(spFunIsLogin(context: context)){

          SPClassApiManager.spFunGetInstance().spFunShare(context: context,spProCallBack: SPClassHttpCallBack(
              spProOnSuccess: (result){
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SPClassShareView(title: result.title,spProDesContent: result.content,spProPageUrl: result.spProPageUrl??SPClassNetConfig.spFunGetShareUrl(),spProIconUrl: result.spProIconUrl,);
                    });
              }
          ));

        }
      }
      if(urlPage.contains("contact_cs")){
        SPClassNavigatorUtils.spFunPushRoute(context,  SPClassContactPage());
      }

      if(urlPage.contains("apply_expert")){
        if(spFunIsLogin(context: context)) {
          SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertApplyPage());
        }
      }

      if(urlPage.contains("big_data_report")){
        if(spFunIsLogin(context: context)) {
          spFunGetBcwUrl("bigDataReport");
        }
      }
      if(urlPage.contains("all_analysis")){
        if(spFunIsLogin(context: context)) {
          spFunGetBcwUrl("allAnalysis");
        }
      }

      if(urlPage.contains("odds_wave")){
        if(spFunIsLogin(context: context)) {
          spFunGetBcwUrl("oddsWave");
        }
      }
      if(urlPage.contains("dark_horse_analysis")){
        if(spFunIsLogin(context: context)) {
          spFunGetBcwUrl("coldJudge");
        }
      }
    }else{
      SPClassNavigatorUtils.spFunPushRoute(context,SPClassWebPage(urlPage,title));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=PageController();
    SPClassGlobalNotification.spFunGetInstance(buildContext: context);
    SPClassApplicaion.spFunSavePushToken();

//    if(SPClassApplicaion.spProShowMenuList.contains("match_odds")){
//      SPClassMatchListSettingPageState.SHOW_PANKOU=true;
//    }else{
//      SPClassMatchListSettingPageState.SHOW_PANKOU=false;
//    }


    if(SPClassApplicaion.spProShowMenuList.contains("home")){
      // spProPageList.add(SPClassHomePage());
      spProPageList.add(HomePage());
      tabs.add(SPClassQNavTab( spProTabText: "推荐",spProTabImage:SPClassImageUtil.spFunGetImagePath("ic_homepage")));
    }
    if(SPClassApplicaion.spProShowMenuList.contains("match")){
      spProPageList.add(SPClassCompetitionHomePage());
      tabs.add(SPClassQNavTab( spProTabText: "比分",spProTabImage:SPClassImageUtil.spFunGetImagePath("ic_score")),);
    }

    if(SPClassApplicaion.spProShowMenuList.contains("circle")){
      spProPageList.add(SPClassHotHomePage());
      tabs.add(SPClassQNavTab( spProTabText: "热门",spProTabImage:SPClassImageUtil.spFunGetImagePath("ic_tab_hot")));
    }
    if(SPClassApplicaion.spProShowMenuList.contains("expert")){
        spProPageList.add(SPClassExpertHomePage());
        tabs.add(SPClassQNavTab( spProTabText: "专家",spProTabImage:SPClassImageUtil.spFunGetImagePath("ic_match")));
        spProExpertIndex=spProPageList.length-1;
    }

    if(SPClassApplicaion.spProShowMenuList.contains("game")&&SPClassApplicaion.spProDEBUG == true){
      spProPageList.add(SPClassGamePage());
      tabs.add(SPClassQNavTab(spProTabText: '游戏',spProTabImage:SPClassImageUtil.spFunGetImagePath("ic_game")));
    }
       spProPageList.add(SPClassUserPage());
       tabs.add(SPClassQNavTab(spProTabText: "我的",spProTabImage:SPClassImageUtil.spFunGetImagePath("ic_tab_user"),badge:spFunIsLogin()? int.parse(SPClassApplicaion.spProUserLoginInfo.spProUnreadMsgNum):0));

      SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="tab:expert"){
        SPClassExpertHomePageState.index=1;
        if(spProExpertIndex>-1){
          spFunItemTapped(spProExpertIndex);
          //(spProPageList[spProExpertIndex] as ExpertHomePage).spProState.tapTopItem(1);
        }
      }
      if(event=="login:out"){
        SPClassGlobalNotification.spFunGetInstance().spFunCloseConnect();
        SPClassGlobalNotification.spFunGetInstance().spFunInitWebSocket();
        spFunItemTapped(0);
      }
      if(event=="tab:home"){
        spFunItemTapped(0);
      }
      if(event=="userInfo"){
        tabs[tabs.length-1].badge=spFunIsLogin()? int.parse(SPClassApplicaion.spProUserLoginInfo.spProUnreadMsgNum):0;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      spFunCheckVersion();
//      FlutterPluginHuaweiPush.notificationListener((url,msgID,isDemo){
//        spFunGoRoutPage(url,"",msgID,isDemo);
//      });

      if( SPClassApplicaion.spProJPush!=null){
        SPClassApplicaion.spProJPush.addEventHandler(
          // 点击通知回调方法。
          onOpenNotification: (Map<String, dynamic> message) async {
            var map= json.decode(message["extras"]["cn.jpush.android.EXTRA"]);
            spFunGoRoutPage(map["page_url"],message["title"],map["push_msg_id"].toString(),map["is_demo"].toString()=="1");
          },
        );
      }
    });
  }

  void spFunItemTapped(int index) {

    if((spProPageList[index] is SPClassUserPage)&&!spFunIsLogin(context: context)){
      setState(() {});
      return;
    }
    setState(() {
      spProIndex = index;
    });

    controller.jumpToPage(index);
    if(spProPageList[index] is SPClassHomePage){( spProPageList[index] as SPClassHomePage).spProState.spFunTabReFresh();}
    if(spProPageList[index] is SPClassCompetitionHomePage){( spProPageList[index] as SPClassCompetitionHomePage).spProState.spFunCurrentPage.spProState.spFunRefreshTab();}

    if((spProPageList[index] is SPClassUserPage)&&spFunIsLogin()){
      SPClassApplicaion.spFunGetUserInfo();
    }

  }
}