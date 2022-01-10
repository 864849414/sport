

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/common/SPClassDialogUtils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';

class SPClassVersionCheckDialog extends StatefulWidget{

  String spProDownloadUrl;
  bool barrierDismissible;
  String spProContent;
  String spProVersion;
  VoidCallback spProCancelCallBack;
  SPClassVersionCheckDialog(this.barrierDismissible,this.spProContent,this.spProVersion,{this.spProDownloadUrl,this.spProCancelCallBack});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassVersionCheckDialogState();
  }


}

class SPClassVersionCheckDialogState  extends State<SPClassVersionCheckDialog>{
  double spProDownProgress;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Dialog(
        elevation: 0,
          backgroundColor: Colors.transparent,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_version_up"),
                    width:width(260),
                    fit: BoxFit.fill,
                    height:height(133),
                  ),
                  Positioned(
                    top: height(39),
                    left: width(24),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("发现新版本",style: TextStyle(fontSize: sp(21),color: Colors.white),),
                        Text('v${widget.spProVersion}',style: TextStyle(fontSize: sp(17),color: Colors.white),),

                      ],
                    ),
                  )
                ],
              ),
              Container(
                width:width(260),
                height:height(144),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom:BorderSide(width: 0.4,color: Colors.grey[200])),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(width(10)),
                  child: Text(widget.spProContent,style: TextStyle(fontSize: sp(13),color: Color(0xFF333333)),),
                ),
                
              ),

              Container(
                width:width(260),
                height:height(45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(width(5)))
                  ),
                child: Row(
                  children: <Widget>[
                    !widget.barrierDismissible? Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          alignment: Alignment.center,
                          height:height(45),
                          child: Text("残忍拒绝",style: TextStyle(fontSize: sp(17),color: Color(0xFF333333)),),
                        ),
                        onPressed: (){
                         widget.spProCancelCallBack();
                        },
                      ),
                    ):Container(),
                    widget.barrierDismissible? Container(width: 0.4,
                      height:height(45),
                      color: Colors.grey[200],
                    ):Container(),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          alignment: Alignment.center,
                          height:height(45),
                          child: Text(spProDownProgress!=null? "下载中:${(spProDownProgress*100).toStringAsFixed(0)}%":"立即升级",style: TextStyle(fontSize: sp(17),color: Color(0xFFFF6034)),),
                        ),
                        onPressed: () async {

                          if(Platform.isAndroid){
                            if(spProDownProgress!=null){
                              return;
                            }
                            var tempDir = await getExternalStorageDirectory();
                            var installPath="${tempDir.path}/sport-v${widget.spProVersion}.apk";

                          var isDown= await File(installPath).exists();
                          if(isDown){
                            spFunInstallApk(installPath);
                          }else{
                            String  path = tempDir.path+"/sport.apk";
                            File file = File(path);
                            if (await file.exists()) await file.delete();
                            SPClassApiManager.spFunGetInstance().spFunDownLoad(url: widget.spProDownloadUrl,savePath: path,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                onError: (error){
                                  spFunShowInstallFail("下载失败，请跳转外部浏览器下载！");
                                },
                                spProOnProgress: (value){
                                  if(mounted){
                                    setState(() {spProDownProgress=value;});
                                  }
                                },
                                spProOnSuccess: (result) async {
                                  if(mounted){
                                    setState(() {spProDownProgress=null;});
                                  }
                                  file.rename(installPath);
                                  spFunInstallApk(installPath);
                                }
                            ));
                          }
                        }else{
                           var isLanch =await canLaunch(widget.spProDownloadUrl);
                           if(isLanch){
                             await launch(widget.spProDownloadUrl);
                           }
                          }
                          },
                      ),
                    ),
                  ],
                ),
              )
               
            ],
          ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  void spFunShowInstallFail(String title) {
    SPClassDialogUtils.spFunShowConfirmDialog(context,RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(fontSize: 16, color: Color(0xFF333333)),

      ),
    ), () async {
      var isLanch =await canLaunch(widget.spProDownloadUrl);
      if(isLanch){
        await launch(widget.spProDownloadUrl);
      }
    });
  }

  Future<void> spFunInstallApk( installPath) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      InstallPlugin.installApk(installPath, SPClassApplicaion.spProPackageInfo.packageName)
          .then((result) {
      }).catchError((error) {
        spFunShowInstallFail("安装失败，请跳转外部浏览器下载安装！");

      });
    } else {
      SPClassToastUtils.spFunShowToast(msg: "权限不足，请检查文件权限");
      spFunShowInstallFail("安装失败，请跳转外部浏览器下载安装！");

    }
  }



}