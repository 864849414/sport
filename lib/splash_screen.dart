
import 'dart:convert';
import 'dart:io';

import 'package:cipher2/cipher2.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_login/flutter_phone_login.dart';
import 'package:flutter_plugin_huawei_push/flutter_plugin_huawei_push.dart';
import 'package:flutter_toolplugin/flutter_toolplugin.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/pages/competition/SPClassMatchListSettingPage.dart';
import 'package:sport/pages/dialogs/SPClassPrivacyDialogDialog.dart';
import 'package:sport/pages/main/SPClassAppPage.dart';
import 'package:sport/pages/main/SPClassSplashPage.dart';
import 'package:sport/utils/LocalStorage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassIphoneDevices.dart';
import 'package:sport/utils/SPClassLogUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/utils/common.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'app/SPClassApplicaion.dart';
import 'contants/SPClassConstants.dart';
import 'contants/SPClassSharedPreferencesKeys.dart';
import 'generated/json/base/json_convert_content.dart';
import 'model/SPClassBaseModelEntity.dart';
import 'model/SPClassConfRewardEntity.dart';
import 'model/SPClassLogInfoEntity.dart';
import 'model/SPClassUserLoginInfo.dart';
import 'package:crypto/crypto.dart';
import 'package:sport/utils/SPClassUtil.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SPClassSplashPage((){}),
    );
  }

  @override
  initState()  {
    // TODO: implement initState
    super.initState();

    if(LocalStorage.get(Commons.IS_AGREE_PRIVICY)!=null){
      init();
      Future.delayed(Duration(seconds: 3)).then((value) async{
        SPClassNavigatorUtils.pushAndRemoveAll(context, SPClassAppPage());
        SPClassUtil.spFunRequestPermission();
      });
    }else{
      Future.delayed(Duration(seconds: 3)).then((value) {
        showDialog(context: context,builder: (context){
          return SPClassPrivacyDialogDialog( ()async{
            await init();
            Future.delayed(Duration(milliseconds: 100)).then((value) {
              SPClassNavigatorUtils.pushAndRemoveAll(context, SPClassAppPage());
              SPClassUtil.spFunRequestPermission();
            });
          });
        });
      });
    }

    if(Platform.isAndroid){
      FlutterToolplugin.channelId.then((channel){
        SPClassApplicaion.spProChannelId=channel;
        if(SPClassApplicaion.spProChannelId=="2"){
          SPClassApplicaion.spProAndroidAppId="105";
        }
      });
    }else{
      SPClassApplicaion.spProShowMenuList=
      ["home","match","expert","info","match_scheme","match_analyse","game"];
    }
    spFunInitUserData();

  }

  Future<void> init() async{
    try{
      if(Platform.isAndroid){
        FlutterToolplugin.channelId.then((channel){
          SPClassApplicaion.spProChannelId=channel;
          if(SPClassApplicaion.spProChannelId=="2"){
            SPClassApplicaion.spProAndroidAppId="105";
          }
        });
      }else{
        SPClassApplicaion.spProShowMenuList=
        ["home","match","expert","info","match_scheme","match_analyse","game"];
      }
    }catch(e){
      SPClassLogUtils.spFunPrintLog(e.toString());
    }finally{
      spFunInitOneLogin();
      spFunInitConnectivity();
      spFunInitPush();
      spFunInitWx();
    }
  }

  void spFunInitData() async {

    SPClassApplicaion.spProPackageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      SPClassNetConfig.androidInfo = await SPClassNetConfig.spProDeviceInfo.androidInfo;
      try {
        SPClassApplicaion.spProImei = await SharedPreferences.getInstance().then((sp)=>sp.getString(SPClassSharedPreferencesKeys.KEY_IMEI));
        if(SPClassApplicaion.spProImei==null||SPClassApplicaion.spProImei.contains("Denied")){SPClassApplicaion.spProImei="";}
        SPClassApplicaion.spProDeviceName =SPClassNetConfig.androidInfo.model;
      } catch (e) {
      }
    } else if(Platform.isIOS){
      SPClassNetConfig.spProIosDeviceInfo = await SPClassNetConfig.spProDeviceInfo.iosInfo;
      SPClassApplicaion.spProDeviceName=new SPClassIphoneDevices().spFunDevicesString(SPClassNetConfig.spProIosDeviceInfo.utsname.machine);
    }
    spFunDoLogOpen();

    if(spFunIsLogin()){
      spFunDoLogin(SPClassApplicaion.spProUserLoginInfo.spProAutoLoginStr);
    }

    spFunDomainJs(null);
  }

  Future<void> spFunChangeSplash() async{
    await init();
  }

  void spFunDoLogOpen() {

    if(SPClassApplicaion.spProLogOpenInfo==null){
      spFunInitMenuList();
    }

    SPClassApiManager.spFunGetInstance().spFunConfReward<SPClassConfRewardEntity>(spProCallBack:SPClassHttpCallBack(
        spProOnSuccess: (value){
          SPClassApplicaion.spProConfReward=value;
        }
    ));
    SPClassApiManager.spFunGetInstance().spFunLogOpen<SPClassBaseModelEntity>(needSydid: "1",spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (result) async {
          var logOpen= JsonConvert.fromJsonAsT<SPClassLogInfoEntity>(result.data);
          print('??????????????????${logOpen.toJson()}');
          SPClassApplicaion.spProLogOpenInfo=logOpen;
          var md5Code=md5.convert(utf8.encode(AppId)).toString();
          if(Platform.isAndroid){
            if(result.data["app_sign"]==md5Code){
              SPClassApplicaion.spProShowMenuList=logOpen.spProMenuList;
              SharedPreferences.getInstance().then((sp)=>sp.setString(SPClassSharedPreferencesKeys.KEY_LOG_JSON, jsonEncode(logOpen)));
              SPClassApplicaion.spProShowMenuList.add('game');
            }else{
              spFunInitMenuList();
            }

          }

          if(SPClassApplicaion.spProSydid==logOpen.sydid){
            return;
          }
          SPClassApplicaion.spProSydid=logOpen.sydid;
          if(Platform.isAndroid){
            try {
              String encryptedString = await Cipher2.encryptAesCbc128Padding7(
                  logOpen.sydid, SPClassConstants.spProEncryptKey, SPClassConstants.spProEncryptIv);
              if (Platform.isAndroid) {
                String documentsPath =   await FlutterToolplugin.getExternalStorage();
                String appIdPath= SPClassApplicaion.spProAndroidAppId=="100" ? '/wbs/wbs.txt':("/wbs/"+SPClassApplicaion.spProAndroidAppId+"/wbs.txt");
                File file = new File(documentsPath+appIdPath);
                if (!file.existsSync()) {
                  file.createSync(recursive:true);
                }
                spFunWriteToFile( file, encryptedString);
              }
            } on PlatformException {
            }
          }
          if(Platform.isIOS){
            FlutterToolplugin.saveKeyChainSyDiy(SPClassApplicaion.spProSydid);
          }
        }
    ));

  }

  Future spFunInitAndroid() async {
    // ????????????
    //PermissionStatus permission = await SPClassUtil.spFunRequestPermission();
    // if (permission == PermissionStatus.granted) {
    //     spFunGetSydidCache();
    // } else {
    //    spFunInitData();
    // }
    spFunGetSydidCache();
    spFunInitData();
  }

  void spFunWriteToFile( File file, String notes) async {
    await file.writeAsString(notes);
  }

  spFunInitWx() async {
    fluwx.registerWxApi(
      appId:ChannelId=="2"? "wx3968d1915829705d":"wx55c3416a14860147",
      universalLink: "https://api.gz583.com/hongsheng/",
    );

  }

  void spFunDoLogin(String autoString) {
    SPClassApiManager.spFunGetInstance().spFunUserAuoLogin(spProAutoLoginStr: autoString,spProCallBack:SPClassHttpCallBack<SPClassUserLoginInfo>(
        spProOnSuccess: (result){
          SPClassApplicaion.spProUserLoginInfo=result;
          SPClassApplicaion.spFunSaveUserState();
        },
        onError: (error){
          if(error.code=="401"){
            SPClassApplicaion.spFunClearUserState();
          }
        }
    ));
  }

  void spFunDomainJs(String autoString) async{
    SPClassApiManager.spFunGetInstance().spFunDomainJs(spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
      SPClassApplicaion.spProJsMap=result.data;
    }));

  }

  void spFunGetSydidCache() async {

    if(Platform.isAndroid){
      String documentsPath = await FlutterToolplugin.getExternalStorage();
      String appIdPath= SPClassApplicaion.spProAndroidAppId=="100" ? '/wbs/wbs.txt':("/wbs/"+SPClassApplicaion.spProAndroidAppId+"/wbs.txt");
      File file = new File(documentsPath+appIdPath);
      bool exists =await file.exists();
      if(exists) {
        String wbs = await file.readAsString();
        String encryptedString = await Cipher2.decryptAesCbc128Padding7(wbs, SPClassConstants.spProEncryptKey, SPClassConstants.spProEncryptIv);
        SPClassApplicaion.spProSydid=encryptedString;
      }else{
        if(SPClassApplicaion.spProLogOpenInfo!=null){
          SPClassApplicaion.spProSydid=SPClassApplicaion.spProLogOpenInfo.sydid;
        }
      }
    }

    if(Platform.isIOS){
      SPClassApplicaion.spProSydid= await FlutterToolplugin.getKeyChainSyDid;
    }
    spFunInitData();

  }

  Future<void> spFunInitPush() async {
//    var androidInfo=  await SPClassNetConfig.spProDeviceInfo.androidInfo;
//    if(!androidInfo.manufacturer.toLowerCase().contains("huawei")||Platform.isIOS){
//      SPClassApplicaion.spProJPush = new JPush();
//      SPClassApplicaion.spProJPush .setup(
//        appKey:SPClassApplicaion.spProChannelId=="2"? "13a7f0f109637413b2cc9c6d":"883e94b7fc3b1e8eae037188",
//        channel: "theChannel",
//        production: true,
//        debug: true,
////        production: false,
////        debug: SPClassApplicaion.spProDEBUG,
//      );
//      if(Platform.isIOS){
//        SPClassApplicaion.spProJPush.applyPushAuthority(new NotificationSettingsIOS(
//            sound: true,
//            alert: true,
//            badge: true));
//      }
//    }else{
//      FlutterPluginHuaweiPush.pushToken.then((pushToken){
//        print("token=====$pushToken");
//        if(pushToken!=null&&pushToken.isNotEmpty){
//          SPClassApplicaion.pushToken=pushToken;
//        }
//      });
//    }??

    if(Platform.isIOS){
      SPClassApplicaion.spProJPush = new JPush();
      SPClassApplicaion.spProJPush .setup(
        appKey:SPClassApplicaion.spProChannelId=="2"? "13a7f0f109637413b2cc9c6d":"883e94b7fc3b1e8eae037188",
        channel: "theChannel",
        production: true,
        debug: true,
//        production: false,
//        debug: SPClassApplicaion.spProDEBUG,
      );
      SPClassApplicaion.spProJPush.applyPushAuthority(new NotificationSettingsIOS(
          sound: true,
          alert: true,
          badge: true));
    }else{
      var androidInfo=  await SPClassNetConfig.spProDeviceInfo.androidInfo;
      if(androidInfo.manufacturer.toLowerCase().contains("huawei")){
        FlutterPluginHuaweiPush.pushToken.then((pushToken){
          print("token=====$pushToken");
          if(pushToken!=null&&pushToken.isNotEmpty){
            SPClassApplicaion.pushToken=pushToken;
          }
        });
      }else{
        SPClassApplicaion.spProJPush = new JPush();
        SPClassApplicaion.spProJPush .setup(
          appKey:SPClassApplicaion.spProChannelId=="2"? "13a7f0f109637413b2cc9c6d":"883e94b7fc3b1e8eae037188",
          channel: "theChannel",
          production: true,
          debug: true,
//        production: false,
//        debug: SPClassApplicaion.spProDEBUG,
        );
      }
    }
  }

  /// ??????????????????
  Future<Null> spFunInitConnectivity() async {
    //????????????????????????????????????????????????Try/Catch PlatformException???
    try {
      _connectivity.checkConnectivity().then((result){
        spFunSetWifiName(result);
      });
      _connectivity.getWifiBSSID().then((reslut){
        if(reslut!=null&&reslut.isNotEmpty){
          SPClassApplicaion.spProMacAddress=reslut;
        }
      });
    }  catch (e) {
    }

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      spFunSetWifiName(result);
    });

  }

  void spFunSetWifiName(ConnectivityResult result){
    switch(result){
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        SPClassApplicaion.spProWifiName="";
        break;
      case ConnectivityResult.wifi:
        _connectivity.getWifiName().then((wifiName){
          if(wifiName!=null){
            SPClassApplicaion.spProWifiName=wifiName;
          }
          SPClassLogUtils.spFunPrintLog("connectionStatus: ${SPClassApplicaion.spProWifiName.toString()}");
        });
        break;
    }

    _connectivity.getWifiBSSID().then((reslut){
      if(reslut!=null&&reslut.isNotEmpty){
        SPClassApplicaion.spProMacAddress=reslut;
      }
    });
  }

  Future<void> spFunInitUserData() async {
    await  SharedPreferences.getInstance().then((sp) {
      SPClassApplicaion.spProDEBUG=sp.getBool("test")??SPClassApplicaion.spProDEBUG;
      SPClassMatchListSettingPageState.SHOW_PANKOU=sp.getBool(SPClassSharedPreferencesKeys.KEY_MATCH_PAN_KOU)??SPClassMatchListSettingPageState.SHOW_PANKOU;
      var logInfoJson=sp.getString(SPClassSharedPreferencesKeys.KEY_LOG_JSON);
      if(logInfoJson!=null){
        var jsonData=json.decode(logInfoJson);
        SPClassApplicaion.spProLogOpenInfo= SPClassLogInfoEntity().fromJson(jsonData);
//        if(Platform.isAndroid){
//          SPClassApplicaion.spProShowMenuList= SPClassApplicaion.spProLogOpenInfo.spProMenuList;
//        }
      }
    } );
    await SPClassApplicaion.spFunInitUserState();
    if(Platform.isAndroid){
      spFunInitAndroid();
    }
    if(Platform.isIOS){
      spFunGetSydidCache();
    }
    return null;
  }

  void spFunInitOneLogin() {
    if(SPClassApplicaion.spProChannelId=="2"){
      FlutterPhoneLogin.init(appId: "5abdca70b4e6e", appSecret: "14e354d0d7cb3c89ffb5590be87b04ee");
    }else{
      FlutterPhoneLogin.init(appId: "59dda2adae0c1", appSecret: "8c62e662895f9583dfa2aed777df8c08");
    }
  }

  void spFunInitMenuList() {
    var channels=["1","2","7","5","6","4","13",'9'];
    if(channels.contains(SPClassApplicaion.spProChannelId)){
      SPClassApplicaion.spProShowMenuList=["circle","match"];
    }
  }
}
