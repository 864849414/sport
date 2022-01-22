import 'dart:convert';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/contants/SPClassSharedPreferencesKeys.dart';
import 'package:sport/model/SPClassUserInfo.dart';
import 'package:sport/model/SPClassUserLoginInfo.dart';
import 'package:sport/model/SPClassConfRewardEntity.dart';
import 'package:sport/model/SPClassLogInfoEntity.dart';
import 'package:sport/model/SPClassShowPListEntity.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/pages/dialogs/SPClassDialogTurntable.dart';
import 'package:sport/pages/dialogs/SPClassNewRegisterDialog.dart';
import 'package:sport/pages/login/SPClassVideoLoginPage.dart';

class SPClassApplicaion
{
  static var spProAppName="常胜体育";
  static String spProImei="";
  static String spProChannelId="11";
  static  String spProAndroidAppId="100";
  static const String spProIOSAppId="106";
  static String pushToken="";
  static PackageInfo spProPackageInfo;
  static String spProDeviceName="";
  static String spProSydid="";
  static String spProWifiName="";
  static String spProMacAddress="";
  static SPClassUserLoginInfo spProUserLoginInfo;
  static SPClassUserInfo spProUserInfo;
  static SPClassLogInfoEntity spProLogOpenInfo;
  static List<String> spProNewsHistory =List();
  static List<String> spProShowMenuList =["home","pk","match","expert","info","pay","match_scheme","match_analyse","match_odds","bcw_data","game"];
  static Map<String,dynamic> spProJsMap;
  static EventBus spProEventBus = EventBus();
  static bool spProDEBUG = false;
  static bool spProLOG_OPEN = false;
  static SPClassShowPListEntity spProShowPListEntity;//;
  static JPush spProJPush;
  static SPClassConfRewardEntity spProConfReward;
  static bool spProEncrypt = false;//是否启用加密




  //判断用户信息是否存在
  static bool spFunIsExistUserInfo()
  {
     return (spProUserInfo!=null);
  }

  //初始化状态
  static Future<void> spFunInitUserState() async {
  return   await  SharedPreferences.getInstance().then((sp){
     var loginInfoJson=sp.getString(SPClassSharedPreferencesKeys.KEY_LOGIN_INFO);
     if(loginInfoJson!=null){
       spProUserLoginInfo=new SPClassUserLoginInfo(json: json.decode(loginInfoJson));
     }
     var userInfoJson=sp.getString(SPClassSharedPreferencesKeys.KEY_USER_INFO);
     if(userInfoJson!=null){
       spProUserInfo=SPClassUserInfo(json: json.decode(userInfoJson));
     }
     return null;
   });

  }

  //清空登录状态
  static void spFunClearUserState(){
    SPClassApplicaion.spProUserLoginInfo=null;
    SPClassApplicaion.spProUserInfo=null;
    SharedPreferences.getInstance().then((sp){
      sp.remove(SPClassSharedPreferencesKeys.KEY_USER_INFO);
      sp.remove(SPClassSharedPreferencesKeys.KEY_LOGIN_INFO);
    });
    if(SPClassApplicaion.spProJPush!=null){
    //  Application.mJpush.deleteAlias();
    }
  }

  //保存并更新用户信息
  static void spFunSaveUserState({bool isFire:true}){
    SharedPreferences.getInstance().then((sp){
      if(spProUserLoginInfo!=null){
        sp.setString(SPClassSharedPreferencesKeys.KEY_LOGIN_INFO, jsonEncode(spProUserLoginInfo.toJson()));
        spProEventBus.fire("loginInfo");
      }
      if(spProUserInfo!=null){
        sp.setString(SPClassSharedPreferencesKeys.KEY_USER_INFO, jsonEncode(spProUserInfo.toJson()));
        if(isFire){spProEventBus.fire("userInfo");}
      }
    });
  }

  //获取最新用户信息
  static void spFunGetUserInfo({BuildContext context,bool isFire:true}) {
    if(!spFunIsLogin()){return;}
   SPClassApiManager.spFunGetInstance().spFunUserInfo(context: context,spProCallBack: SPClassHttpCallBack(
     spProOnSuccess: (value){
       spProUserInfo=value;
       spFunSaveUserState(isFire: isFire);
     }
   ));
  }

  static Future<void> spFunSavePushToken() async {
    var pakegeInfo= await PackageInfo.fromPlatform();
     if(pushToken.isNotEmpty&&SPClassNetConfig.androidInfo.manufacturer.toLowerCase().contains("huawei")){
       SPClassApiManager.spFunGetInstance().spFunSavePushToken(packName: pakegeInfo.packageName,pushToken:pushToken,tokenType: "huawei");
     }
     if(SPClassApplicaion.spProJPush!=null){
         if(SPClassApplicaion.spProSydid.isNotEmpty){
           print('极光Alias：${SPClassApplicaion.spProSydid}');
           SPClassApplicaion.spProJPush.setAlias(SPClassApplicaion.spProSydid);
         }
        var registrationId= await SPClassApplicaion.spProJPush.getRegistrationID();
        if(registrationId!=null&&registrationId.isNotEmpty){
          SPClassApiManager.spFunGetInstance().spFunSavePushToken(packName: pakegeInfo.packageName,pushToken:registrationId,tokenType: "jiguang",);
        }
     }
  }

  static Future<void> spFunShowUserDialog(BuildContext context ) async {
    if(!SPClassApplicaion.spProShowMenuList.contains("pay")){
      return;
    }
    var dialogShowTime;
    if(spFunIsLogin()){
      dialogShowTime = await  SharedPreferences.getInstance().then((sp){
        return sp.getString("dialog_turn${SPClassApplicaion.spProUserLoginInfo.spProUserId.toString()}");
      }); //
    }

    if( !spFunIsLogin()||(dialogShowTime==null||dialogShowTime!=SPClassDateUtils.dateFormatByDate(DateTime.now(), "yyyy-MM-dd")))
    {
      if(spFunIsLogin()){
        SharedPreferences.getInstance().then((sp){
          sp.setString("dialog_turn${SPClassApplicaion.spProUserLoginInfo.spProUserId.toString()}", SPClassDateUtils.dateFormatByDate(DateTime.now(), "yyyy-MM-dd"));
        });
      }
//      转盘
//      showCupertinoModalPopup(context: context, builder: (c)=> SPClassDialogTurntable((){
//        spFunShowNewUser(context);
//
//      }));
    }else{
      spFunShowNewUser(context);
    }


  }

  static bool spFunIsShowIosUI(){
    return false;
  }
}

Future<void> spFunShowNewUser(BuildContext context) async {
  var dialogShowTime;
    dialogShowTime = await  SharedPreferences.getInstance().then((sp){
      return sp.getString("dialog_register");
    }); //
  if(dialogShowTime==null)
  {

      SharedPreferences.getInstance().then((sp){
        sp.setString("dialog_register","show");
      });
      showDialog<void>(context: context,
          builder: (BuildContext context) {
            return SPClassNewRegisterDialog(callback: (){
            },);
          });
    return;
  }
}

 bool spFunIsLogin({BuildContext context}) {
  if (SPClassApplicaion.spProUserLoginInfo != null) {
    return true;
  } else {
    if (context != null) {
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassVideoLoginPage());
    }
    return false;
  }
}

SPClassUserLoginInfo get userLoginInfo=>SPClassApplicaion.spProUserLoginInfo;