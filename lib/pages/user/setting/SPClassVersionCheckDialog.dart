

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
import 'package:sport/utils/colors.dart';
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
                    width:width(268),
                    fit: BoxFit.fill,
                    height:width(380),
                  ),
                  Positioned(
                    top: width(39),
                    left: width(24),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("???????????????",style: TextStyle(fontSize: sp(21),color: Colors.white),),
                        Text('v${widget.spProVersion}',style: TextStyle(fontSize: sp(17),color: Colors.white),),

                      ],
                    ),
                  ),
                  Positioned(
                    top: width(150),
                    left: 0,
                    right: 0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height:width(144),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(width(10)),
                            child: Text(widget.spProContent,style: TextStyle(fontSize: sp(13),color: Color(0xFF333333)),),
                          ),

                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              FlatButton(
                                padding: EdgeInsets.zero,
                                child: Container(
                                  alignment: Alignment.center,
                                  height:width(45),
                                  width: width(206),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(150),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF1DBDF2),
                                        Color(0xFF1D99F2),
                                      ]
                                    )
                                  ),
                                  child: Text(spProDownProgress!=null? "?????????:${(spProDownProgress*100).toStringAsFixed(0)}%":"????????????",style: TextStyle(fontSize: sp(19),color: Colors.white),),
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
                                            spFunShowInstallFail("????????????????????????????????????????????????");
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
                              !widget.barrierDismissible? FlatButton(
                                padding: EdgeInsets.zero,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("????????????",style: TextStyle(fontSize: sp(15),color: Color(0xFF999999)),),
                                ),
                                onPressed: (){
                                  widget.spProCancelCallBack();
                                },
                              ):Container(),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),


               
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
        spFunShowInstallFail("??????????????????????????????????????????????????????");

      });
    } else {
      SPClassToastUtils.spFunShowToast(msg: "????????????????????????????????????");
      spFunShowInstallFail("??????????????????????????????????????????????????????");

    }
  }



}