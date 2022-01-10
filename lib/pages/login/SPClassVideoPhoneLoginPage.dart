import 'dart:ui';
import 'package:sport/utils/SPClassCommonMethods.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:video_player/video_player.dart';

import 'SPClassVideoVerCodeLogin.dart';

class SPClassVideoPhoneLoginPage extends StatefulWidget{
  VideoPlayerController spProVideoPlayerController;
  int spProPhoneType; //0== 绑定手机号 1==找回密码
  String spProBindSid;
  SPClassVideoPhoneLoginPage({this.spProVideoPlayerController, this.spProPhoneType,this.spProBindSid});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassVideoPhoneLoginPageState();
  }

}


class SPClassVideoPhoneLoginPageState extends State<SPClassVideoPhoneLoginPage> with WidgetsBindingObserver{
  bool spProIsKeyBoardShow=false;
  String spProPhoneNum="";
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
                  SPClassToolBar(context,spProBgColor: Colors.transparent,iconColor: 0xFFFFFFFF,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: width(37),right:  width(37)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.spProPhoneType==0 ? "绑定手机":"找回密码",style: TextStyle(fontSize: sp(20),color: Colors.white),),
                          ),

                          Container(
                            padding: EdgeInsets.only(left: width(20)),
                            margin: EdgeInsets.only(top: height(30)),
                            decoration: BoxDecoration(
                                color: Color(0x4DDDDDDD),
                                borderRadius: BorderRadius.circular(400)
                            ),
                            height: height(48),
                            child: Row(
                              children: <Widget>[
                                Text("+86",style: GoogleFonts.roboto(fontSize: sp(18),textStyle: TextStyle(color: Colors.white,textBaseline: TextBaseline.alphabetic)),),
                                SizedBox(width: width(8),),
                                Expanded(
                                    child:    TextField(
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(fontSize: sp(18),textStyle: TextStyle(color: Colors.white ,textBaseline: TextBaseline.alphabetic)),
                                      decoration: InputDecoration(
                                        hintText: "请输入手机号码",
                                        hintStyle: TextStyle(color: Color(0xFFC6C6C6),fontSize: sp(14)),
                                        border: InputBorder.none,
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter.digitsOnly, //只输入数字
                                        LengthLimitingTextInputFormatter(11) //限制长度
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          spProPhoneNum = value;
                                        });
                                      },

                                    )
                                )


                              ],
                            ),
                          ) ,

                          GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: height(25)),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors:spProPhoneNum.length==11 ? [Color(0xFFF1585A),Color(0xFFF77273)]:[Color(0x99F1585A),Color(0x99F77273)]
                                    ),
                                    borderRadius: BorderRadius.circular(400)
                                ),
                                height: height(48),
                                alignment: Alignment.center,
                                child: Text( "获取验证码",style: TextStyle(color: Colors.white,fontSize: sp(16)),),
                              ),onTap: (){
                            if(spProPhoneNum.length!=11){
                              SPClassToastUtils.spFunShowToast(msg: "请输入正确11位手机号码!");
                              return;
                            }

                              SPClassApiManager.spFunGetInstance().spFunSendCode(context: context,spProPhoneNumber: spProPhoneNum,spProCodeType:widget.spProPhoneType==0? "bind":"change_pwd",spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                  spProOnSuccess: (result){
                                    if(widget.spProPhoneType==1){
                                      SPClassNavigatorUtils.spFunPushRoute(context, SPClassVideoVerCodeLogin(spProCodeType: "change_pwd",spProVideoPlayerController: widget.spProVideoPlayerController,spProPhoneNum: spProPhoneNum,));
                                    }else{
                                      SPClassNavigatorUtils.spFunPushRoute(context, SPClassVideoVerCodeLogin(spProCodeType: "bind",spProVideoPlayerController: widget.spProVideoPlayerController,spProPhoneNum: spProPhoneNum,spProBindSid: widget.spProBindSid,));

                                    }
                                  }
                              ));


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