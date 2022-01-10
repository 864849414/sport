import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/contants/SPClassSharedPreferencesKeys.dart';

class SPClassUtil{

  // 申请权限
  static Future<PermissionStatus> spFunRequestPermission() async {
    await PermissionHandler().requestPermissions(
        [PermissionGroup.storage, PermissionGroup.phone]);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    //申请imei的权限
    //SharedPreferences.getInstance().then((sp)=>sp.setBool(SPClassSharedPreferencesKeys.KEY_APP_PRIVICY, true));

    var imei = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    if(!SPClassStringUtils.spFunIsEmpty(imei)){
      SPClassApplicaion.spProImei = imei;
      SharedPreferences.getInstance().then((sp)=>sp.setString(SPClassSharedPreferencesKeys.KEY_IMEI, imei));
    }
    return permission;
  }
}