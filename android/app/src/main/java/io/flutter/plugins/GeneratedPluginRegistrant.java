package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import xyz.luan.audioplayers.AudioplayersPlugin;
import com.shyandsy.cipher2.Cipher2Plugin;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
import io.flutter.plugins.deviceinfo.DeviceInfoPlugin;
import com.example.flutterimagecompress.FlutterImageCompressPlugin;
import com.pichillilorenzo.flutter_inappwebview.InAppWebViewFlutterPlugin;
import com.example.flutter_phone_login.FlutterPhoneLoginPlugin;
import io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin;
import com.example.flutter_plugin_huawei_push.FlutterPluginHuaweiPushPlugin;
import com.example.flutter_toolplugin.FlutterToolpluginPlugin;
import flutter.plugins.vibrate.VibratePlugin;
import io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin;
import com.jarvan.fluwx.FluwxPlugin;
import com.lykhonis.imagecrop.ImageCropPlugin;
import com.example.imagegallerysaver.ImageGallerySaverPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import com.rioapp.demo.imeiplugin.ImeiPlugin;
import com.zaihui.installplugin.InstallPlugin;
import com.jiguang.jpush.JPushPlugin;
import io.flutter.plugins.packageinfo.PackageInfoPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import com.jarvan.tobias.TobiasPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;
import io.flutter.plugins.videoplayer.VideoPlayerPlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AudioplayersPlugin.registerWith(registry.registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
    Cipher2Plugin.registerWith(registry.registrarFor("com.shyandsy.cipher2.Cipher2Plugin"));
    ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"));
    DeviceInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.deviceinfo.DeviceInfoPlugin"));
    FlutterImageCompressPlugin.registerWith(registry.registrarFor("com.example.flutterimagecompress.FlutterImageCompressPlugin"));
    InAppWebViewFlutterPlugin.registerWith(registry.registrarFor("com.pichillilorenzo.flutter_inappwebview.InAppWebViewFlutterPlugin"));
    FlutterPhoneLoginPlugin.registerWith(registry.registrarFor("com.example.flutter_phone_login.FlutterPhoneLoginPlugin"));
    FlutterAndroidLifecyclePlugin.registerWith(registry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
    FlutterPluginHuaweiPushPlugin.registerWith(registry.registrarFor("com.example.flutter_plugin_huawei_push.FlutterPluginHuaweiPushPlugin"));
    FlutterToolpluginPlugin.registerWith(registry.registrarFor("com.example.flutter_toolplugin.FlutterToolpluginPlugin"));
    VibratePlugin.registerWith(registry.registrarFor("flutter.plugins.vibrate.VibratePlugin"));
    FluttertoastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"));
    FluwxPlugin.registerWith(registry.registrarFor("com.jarvan.fluwx.FluwxPlugin"));
    ImageCropPlugin.registerWith(registry.registrarFor("com.lykhonis.imagecrop.ImageCropPlugin"));
    ImageGallerySaverPlugin.registerWith(registry.registrarFor("com.example.imagegallerysaver.ImageGallerySaverPlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    ImeiPlugin.registerWith(registry.registrarFor("com.rioapp.demo.imeiplugin.ImeiPlugin"));
    InstallPlugin.registerWith(registry.registrarFor("com.zaihui.installplugin.InstallPlugin"));
    JPushPlugin.registerWith(registry.registrarFor("com.jiguang.jpush.JPushPlugin"));
    PackageInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.packageinfo.PackageInfoPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    TobiasPlugin.registerWith(registry.registrarFor("com.jarvan.tobias.TobiasPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
    VideoPlayerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.videoplayer.VideoPlayerPlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
