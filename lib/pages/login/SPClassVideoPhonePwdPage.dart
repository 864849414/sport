import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassUserLoginInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:video_player/video_player.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassVideoPhonePwdPage extends StatefulWidget{
  VideoPlayerController spProVideoPlayerController;
  int spProPhoneType; //0== 绑定手机号 1==找回密码
  String spProBindSid;
  String spProPhoneNum;
  String spProVerCode;
  SPClassVideoPhonePwdPage({this.spProVideoPlayerController, this.spProPhoneType,this.spProBindSid,this.spProPhoneNum,this.spProVerCode});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassVideoPhonePwdPageState();
  }

}


class SPClassVideoPhonePwdPageState extends State<SPClassVideoPhonePwdPage> with WidgetsBindingObserver{
  bool spProIsKeyBoardShow=false;
  bool spProIsShowPassWord=false;
  bool spProIsShowPassWord2=false;
  String spProPhonePwd="";
  String spProPhonePwd2="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        spProIsKeyBoardShow=(MediaQuery.of(context).viewInsets.bottom>0);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Container(
        child: Stack(
          children: <Widget>[
            Container(
                child: widget.spProVideoPlayerController.value.initialized ?
                VideoPlayer(widget.spProVideoPlayerController) : SizedBox(width:ScreenUtil.screenWidth,height: ScreenUtil.screenHeight)),
            BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: spProIsKeyBoardShow ?25:0, sigmaY: spProIsKeyBoardShow ?25:0),
              child: new Container(
                width: ScreenUtil.screenWidth,
                height: ScreenUtil.screenHeight,
                color: Colors.black45,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SPClassToolBar(context,spProBgColor: Colors.transparent,iconColor: 0xFFFFFFFF),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: width(37),right:  width(37)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("确认密码",style: TextStyle(fontSize: sp(20),color: Colors.white),),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: width(20)),
                            margin: EdgeInsets.only(top: height(13)),
                            decoration: BoxDecoration(
                                color: Color(0x4DDDDDDD),
                                borderRadius: BorderRadius.circular(400)
                            ),
                            height: height(48),
                            child:  TextField(
                              obscureText: !spProIsShowPassWord,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: GoogleFonts.roboto(fontSize: sp(18),textStyle: TextStyle(color: Colors.white ,textBaseline: TextBaseline.alphabetic)),
                              decoration: InputDecoration(
                                hintText: "请输入密码",
                                hintStyle: TextStyle(color: Color(0xFFC6C6C6),fontSize: sp(14)),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  padding: EdgeInsets.only(right: width(24)),
                                  icon: SPClassEncryptImage.asset(
                                    !spProIsShowPassWord
                                        ? SPClassImageUtil.spFunGetImagePath('ic_login_uneye')
                                        : SPClassImageUtil.spFunGetImagePath('ic_eye_pwd'),
                                    fit: BoxFit.contain,
                                    color: Colors.white,
                                    width: width(18),
                                    height: width(18),
                                  ),
                                  onPressed: ()=> setState(() {spProIsShowPassWord = !spProIsShowPassWord;}),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  spProPhonePwd = value;
                                });
                              },

                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: width(20)),
                            margin: EdgeInsets.only(top: height(13)),
                            decoration: BoxDecoration(
                                color: Color(0x4DDDDDDD),
                                borderRadius: BorderRadius.circular(400)
                            ),
                            height: height(48),
                            child:  TextField(
                              obscureText: !spProIsShowPassWord2,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: GoogleFonts.roboto(fontSize: sp(18),textStyle: TextStyle(color: Colors.white ,textBaseline: TextBaseline.alphabetic)),
                              decoration: InputDecoration(
                                hintText: "请确认密码",
                                hintStyle: TextStyle(color: Color(0xFFC6C6C6),fontSize: sp(14)),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  padding: EdgeInsets.only(right: width(24)),
                                  icon: SPClassEncryptImage.asset(
                                    !spProIsShowPassWord2
                                        ? SPClassImageUtil.spFunGetImagePath('ic_login_uneye')
                                        : SPClassImageUtil.spFunGetImagePath('ic_eye_pwd'),
                                    fit: BoxFit.contain,
                                    color: Colors.white,
                                    width: width(18),
                                    height: width(18),
                                  ),
                                  onPressed: ()=> setState(() {spProIsShowPassWord2 = !spProIsShowPassWord2;}),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  spProPhonePwd2 = value;
                                });
                              },

                            ),
                          ),

                          GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: height(25)),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors:(spProPhonePwd.isNotEmpty&&spProPhonePwd2.isNotEmpty) ? [Color(0xFFF1585A),Color(0xFFF77273)]:[Color(0x99F1585A),Color(0x99F77273)]
                                    ),
                                    borderRadius: BorderRadius.circular(400)
                                ),
                                height: height(48),
                                alignment: Alignment.center,
                                child: Text( "确定",style: TextStyle(color: Colors.white,fontSize: sp(16)),),
                              ),onTap: ()
                          {

                            if(spProPhonePwd.trim().isEmpty||spProPhonePwd2.trim().isEmpty){
                              SPClassToastUtils.spFunShowToast(msg: "请输入密码！");
                              return;
                            }
                            if(spProPhonePwd.trim()!=spProPhonePwd2.trim()){
                              SPClassToastUtils.spFunShowToast(msg: "两次密码不一致！");
                              return;
                            }

                            switch(widget.spProPhoneType){
                              case 0:
                                SPClassApiManager.spFunGetInstance().spFunUserRegister(context: context,queryParameters:{"phone_number":widget.spProPhoneNum,"phone_code":widget.spProVerCode,"bind_sid":widget.spProBindSid,"bind_type":"WX"},spProBodyParameters: {"pwd":spProPhonePwd},
                                    spProCallBack: SPClassHttpCallBack<SPClassUserLoginInfo>(
                                        spProOnSuccess: (loginInfo){
                                          SPClassApplicaion.spProUserLoginInfo=loginInfo;
                                          SPClassApplicaion.spFunSaveUserState();
                                          SPClassApplicaion.spFunInitUserState();
                                          SPClassApplicaion.spFunGetUserInfo();
                                          SPClassToastUtils.spFunShowToast(msg: "登录成功");
                                          SPClassApplicaion.spFunSavePushToken();
                                          SPClassNavigatorUtils.spFunPopAll(context);
                                        }
                                    ));
                              break;
                              case 1:
                                SPClassApiManager.spFunGetInstance().spFunUserChangePwd(context:context ,queryParameters:{"phone_number":widget.spProPhoneNum,"phone_code":widget.spProVerCode,"change_method":"phone_code"},spProBodyParameters:{"pwd":spProPhonePwd},
                                spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                spProOnSuccess: (result){
                                  SPClassApiManager().spFunUserLogin(queryParameters:{"username": widget.spProPhoneNum},spProBodyParameters:{"pwd": spProPhonePwd},context: context,spProCallBack: SPClassHttpCallBack<SPClassUserLoginInfo>(
                                      spProOnSuccess: (loginInfo){
                                        SPClassApplicaion.spProUserLoginInfo =loginInfo;
                                        SPClassApplicaion.spFunSaveUserState();
                                        SPClassApplicaion.spFunInitUserState();
                                        SPClassApplicaion.spFunGetUserInfo();
                                        SPClassApplicaion.spFunSavePushToken();
                                        SPClassToastUtils.spFunShowToast(msg: "登录成功",gravity: ToastGravity.CENTER);
                                        SPClassNavigatorUtils.spFunPopAll(context);
                                      }
                                  ));
                                }
                               ));
                              break;
                            }
                          }
                          ),

                        ],
                      ),
                    ),
                  )

                ],
              ),
            )
          ],
        ),
      ) ,
    );
  }



}