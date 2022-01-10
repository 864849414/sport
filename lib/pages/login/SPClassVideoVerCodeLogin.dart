import 'dart:async';
import 'dart:ui';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassUserLoginInfo.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:video_player/video_player.dart';

import 'SPClassVideoPhonePwdPage.dart';

class SPClassVideoVerCodeLogin extends StatefulWidget{
  VideoPlayerController spProVideoPlayerController;
  String spProPhoneNum;
  String spProCodeType;
  String spProBindSid;

  SPClassVideoVerCodeLogin({@required this.spProCodeType,this.spProVideoPlayerController, this.spProPhoneNum,this.spProBindSid});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassVideoVerCodeLoginState();
  }

}


class SPClassVideoVerCodeLoginState extends State<SPClassVideoVerCodeLogin> with WidgetsBindingObserver{
  static const int RESET_TIME=60;
  bool spProIsKeyBoardShow=false;
  int spProVerCodeCount=6;
  String spProVerCode="";
  List<FocusNode> spProFocusNodes=List();
  Timer timer;
  int spProDownCount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    while(spProFocusNodes.length<spProVerCodeCount){
      spProFocusNodes.add(new FocusNode());
    }

   spFunInitTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel();
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
                            child: Text("输入验证码",style: TextStyle(fontSize: sp(20),color: Colors.white),),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("已发送验证码至 +86 "+widget.spProPhoneNum,style: TextStyle(fontSize: sp(12),color: Color(0xFF999999)),),
                          ),
                          SizedBox(height: height(27),),
                         /* GridView.count(crossAxisCount: spProVerCodeCount,children:buildTextFiel(),shrinkWrap: true,
                          crossAxisSpacing: width(15),
                          ),*/
                          PinInputTextField(
                            pinLength: spProVerCodeCount,
                            decoration: BoxLooseDecoration(
                                textStyle: GoogleFonts.roboto(fontSize: sp(16),textStyle: TextStyle(color: Colors.white)),
                                strokeColor: Colors.transparent,
                                radius: Radius.circular(width(5)),
                                solidColor: Colors.white.withOpacity(0.3)
                            ),
                            autoFocus: true,
                            textInputAction: TextInputAction.go,
                            onChanged: (pin) {
                              setState(() {
                                spProVerCode=pin;
                              });
                            },
                          ),

                          GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: height(25)),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors:spProVerCode.length==spProVerCodeCount ? [Color(0xFFF1585A),Color(0xFFF77273)]:[Color(0x99F1585A),Color(0x99F77273)]
                                    ),
                                    borderRadius: BorderRadius.circular(400)
                                ),
                                height: height(48),
                                alignment: Alignment.center,
                                child: Text("确定",style: TextStyle(color: Colors.white,fontSize: sp(16)),),
                              ),onTap: (){
                            if(spProVerCode.length!=spProVerCodeCount){
                              SPClassToastUtils.spFunShowToast(msg: "请输入正确"+spProVerCodeCount.toString()+"位验证码!");
                              return;
                            }
                            if(widget.spProCodeType=="login"){
                              SPClassApiManager.spFunGetInstance().spFunLoginByCode(spProPhoneNumber: widget.spProPhoneNum,spProPhoneCode: spProVerCode,context: context,spProCallBack: SPClassHttpCallBack<SPClassUserLoginInfo>(
                                  spProOnSuccess: (loginInfo){
                                    SPClassApplicaion.spProUserLoginInfo =loginInfo;
                                    SPClassApplicaion.spFunSaveUserState();
                                    SPClassApplicaion.spFunInitUserState();
                                    SPClassApplicaion.spFunGetUserInfo();
                                    SPClassToastUtils.spFunShowToast(msg: "登录成功");
                                    SPClassApplicaion.spFunSavePushToken();
                                    SPClassNavigatorUtils.spFunPopAll(context);
                                  }
                              ));
                            } else if (widget.spProCodeType=="change_pwd" ){
                               SPClassNavigatorUtils.spFunPushRoute(context, SPClassVideoPhonePwdPage(spProVideoPlayerController: widget.spProVideoPlayerController,spProPhoneType: 1,spProVerCode: spProVerCode,spProPhoneNum: widget.spProPhoneNum,));
                            }else if (widget.spProCodeType=="bind" ){
                               SPClassNavigatorUtils.spFunPushRoute(context, SPClassVideoPhonePwdPage(spProVideoPlayerController: widget.spProVideoPlayerController,spProPhoneType: 0,spProVerCode: spProVerCode,spProPhoneNum: widget.spProPhoneNum,spProBindSid: widget.spProBindSid,));
                            }
                          }
                          ),
                          SizedBox(height: height(13),),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("重新获取"+(spProDownCount>0 ? "("+spProDownCount.toString()+")":""),style: TextStyle(fontSize: sp(12),color: Colors.white),),
                            ),
                            onTap: (){

                              if(spProDownCount==0){
                                SPClassApiManager.spFunGetInstance().spFunSendCode(context: context,spProPhoneNumber: widget.spProPhoneNum,spProCodeType:widget.spProCodeType,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                    spProOnSuccess: (result){
                                      spFunInitTimer();
                                    }
                                ));
                              }

                            },
                          )

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

  spFunBuildTextFiel() {

    List<Widget> boders=List();
    for(var i=0;i<spProVerCodeCount;i++){
      boders.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width(5)),
          color: Colors.white.withOpacity(0.4)
        ),
        alignment: Alignment.center,
        child: TextField(
          focusNode: spProFocusNodes[i],
          controller: TextEditingController()..text= i==0 ? "":"-",
          autofocus: i==0,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none
          ),
          textInputAction: TextInputAction.next,//设置跳到下一个选项
          onTap: (){
            spProFocusNodes[i].unfocus();
            spProFocusNodes[spProVerCode.length].requestFocus();
          },
          cursorColor: Colors.white,
          style: GoogleFonts.roboto(fontSize: sp(16),textStyle: TextStyle(color: Colors.white,textBaseline: TextBaseline.alphabetic),),
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly, //只输入数字
            LengthLimitingTextInputFormatter(1) //限制长度
          ],
          onChanged: (value){



              if(value.isEmpty){
                if(i==0){

                }else{
                  spProFocusNodes[i].unfocus();
                  spProFocusNodes[i-1].requestFocus();
                }

              }else{
                if(value!="-"){
                  spProVerCode=spProVerCode.trim()+value;
                  spProFocusNodes[i].unfocus();
                  spProFocusNodes[i+1].requestFocus();
                }
              }


            print(spProVerCode);
          },
        ),
      ));
    }

    return boders;
  }

  void spFunInitTimer() {
    spProDownCount=RESET_TIME;
    timer=Timer.periodic(Duration(seconds: 1), (timer){
      if(RESET_TIME-spProDownCount!=RESET_TIME){
        setState(() {
          spProDownCount--;
        });
      }else{
        timer.cancel();
      }
    });
  }

}