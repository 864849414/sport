import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cipher2/cipher2.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_plugin_huawei_push/flutter_plugin_huawei_push.dart';
import 'package:flutter_toolplugin/flutter_toolplugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/contants/SPClassConstants.dart';
import 'package:sport/contants/SPClassSharedPreferencesKeys.dart';
import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassUserLoginInfo.dart';
import 'package:sport/model/SPClassConfRewardEntity.dart';
import 'package:sport/model/SPClassLogInfoEntity.dart';
import 'package:sport/pages/dialogs/SPClassPrivacyDialogDialog.dart';
import 'package:sport/splash_screen.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassIphoneDevices.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/SPClassUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/utils/SPClassLogUtils.dart';
import 'package:sport/pages/competition/SPClassMatchListSettingPage.dart';
import 'package:sport/pages/main/SPClassAppPage.dart';
import 'package:sport/pages/main/SPClassSplashPage.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter_phone_login/flutter_phone_login.dart';
import 'package:crypto/crypto.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/LocalStorage.dart';
import 'package:sport/utils/common.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.getInstance();
  runApp(new MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();

}

class MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  int spProThemeColor = 0xFF1B8DE0;
  bool spProGetPrivacy = false;
  bool spProIsPrivacy = false; //是否同意协议
  bool spProIsSplash = true;

  var spProPopTimer= DateTime.now();
  @override
   initState()  {
    // TODO: implement initState
    super.initState();
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
      spFunInitUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: SPClassApplicaion.spProAppName,
        theme: new ThemeData(
          fontFamily: '',
          brightness: Brightness.light,
          primaryColor: Color(this.spProThemeColor),
          backgroundColor: Colors.white,
          unselectedWidgetColor: Colors.white70,
          accentColor: Color(0xFF888888),
          textTheme: GoogleFonts.notoSansSCTextTheme(),
          iconTheme: IconThemeData(
            color: Color(this.spProThemeColor),
            size: 35.0,
          ),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
        home: WillPopScope(
          child:  Scaffold(body: SplashScreen()),
//          child:  Scaffold(body: spFunShowWelcomePage()),
          onWillPop: () async{
            if(DateTime.now().difference(spProPopTimer).inSeconds>3){
              SPClassToastUtils.spFunShowToast(msg: "再按一次退出");
            }else{
              return true;
            }
            spProPopTimer=DateTime.now();
            return false;
        },
        )
    );
  }



  spFunShowWelcomePage() {
    if(spProIsPrivacy){
      return SPClassPrivacyDialogDialog( (){
        spProIsPrivacy = false;
        spProGetPrivacy = true;
        SPClassUtil.spFunRequestPermission();
        setState(() {});
        spFunChangeSplash();
      });
    }else{
      if (spProIsSplash) {
        if(!spProGetPrivacy) {
          SharedPreferences.getInstance().then((sp) {
            // ForTest测试移除同意用户协议的标记
            //sp.remove(SPClassSharedPreferencesKeys.KEY_APP_PRIVICY);
            spProGetPrivacy = true;
            if (sp.getBool(SPClassSharedPreferencesKeys.KEY_APP_PRIVICY) !=
                null) {
              spProIsPrivacy = false;
            } else {
              spProIsPrivacy = true;
            }
            if(!spProIsPrivacy) {
              spFunChangeSplash();
            }
            setState(() {});
          });
        }
        return SPClassSplashPage(() {});
      } else {
        return SPClassAppPage();
      }
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
    Timer(Duration(seconds: 2), () {
      setState(() {
        spProIsSplash = false;
      });
    });
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
          } on PlatformException catch (e) {
          }
        }
        if(Platform.isIOS){
          FlutterToolplugin.saveKeyChainSyDiy(SPClassApplicaion.spProSydid);
        }
      }
    ));

  }

  Future spFunInitAndroid() async {
    // 申请权限
    //PermissionStatus permission = await SPClassUtil.spFunRequestPermission();
    // if (permission == PermissionStatus.granted) {
    //     spFunGetSydidCache();
    // } else {
    //    spFunInitData();
    // }
    spFunGetSydidCache();
    spFunInitData();
  }

  //将数据内容写入指定文件中
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
      var androidInfo=  await SPClassNetConfig.spProDeviceInfo.androidInfo;
      if(!androidInfo.manufacturer.toLowerCase().contains("huawei")||Platform.isIOS){
        SPClassApplicaion.spProJPush = new JPush();
        SPClassApplicaion.spProJPush .setup(
          appKey:SPClassApplicaion.spProChannelId=="2"? "13a7f0f109637413b2cc9c6d":"883e94b7fc3b1e8eae037188",
          channel: "theChannel",
          production: false,
          debug: SPClassApplicaion.spProDEBUG,
        );
      }


    if(Platform.isIOS){
      SPClassApplicaion.spProJPush.applyPushAuthority(new NotificationSettingsIOS(
          sound: true,
          alert: true,
          badge: true));
    }
    if(Platform.isAndroid){
      FlutterPluginHuaweiPush.pushToken.then((pushToken){
        print("token=====$pushToken");
        if(pushToken!=null&&pushToken.isNotEmpty){
          SPClassApplicaion.pushToken=pushToken;
        }
      });
    }
     FlutterPluginHuaweiPush.pushToken.then((pushToken){
       if(pushToken!=null&&pushToken.isNotEmpty){
         SPClassApplicaion.pushToken=pushToken;
       }
       print("token=====${SPClassApplicaion.pushToken}");
     });
  }

  /// 监听网络状态
  Future<Null> spFunInitConnectivity() async {
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
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
        if(Platform.isAndroid){
          SPClassApplicaion.spProShowMenuList= SPClassApplicaion.spProLogOpenInfo.spProMenuList;
        }
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
    var channels=["1","2","7","5","6","4","13"];
    if(channels.contains(SPClassApplicaion.spProChannelId)){
      SPClassApplicaion.spProShowMenuList=["circle","match"];
    }
  }



}



