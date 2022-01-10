
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/SPClassEncryptImage.dart';

import 'package:sport/widgets/SPClassToolBar.dart';

class SPClassChangePwdPage extends StatefulWidget
{
  SPClassChangePwdPageState createState()=> SPClassChangePwdPageState();
}

class SPClassChangePwdPageState extends State<SPClassChangePwdPage>
{
  String spProPwdOrg = '';
  String spProPwd = '';
  String spProPwd2 = '';
  bool spProIsShowPassWord = false;
  int spProCurrentSecond = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar:SPClassToolBar(
          context,
          title: "修改密码",
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFFF1F1F1),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 35.0),
                  spFunBuildRegisterTextForm(),
                  SizedBox(height: 20.0),
                  spFunBuildRegisterButton(),
                ],
              ),
            ),
          ),
        ));
  }

  // 创建登录界面的Item
  Widget spFunBuildRegisterTextForm() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

           SPClassApplicaion.spProUserLoginInfo.spProHasPwd=="1"? Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SPClassEncryptImage.asset(
                      SPClassImageUtil.spFunGetImagePath('ic_login_pwd'),
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        obscureText: false,
                        style: TextStyle(fontSize: 16, color: Color(0xFF333333),textBaseline: TextBaseline.alphabetic),
                        decoration: InputDecoration(
                          hintText: "请输入原密码",
                          hintStyle: TextStyle(fontSize: 16, color: Color(0xFF999999),textBaseline: TextBaseline.alphabetic),
                          border: InputBorder.none,

                        ),
                        onChanged: (value) {
                          setState(() {
                            spProPwdOrg = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(5),),
                Container(
                  height: 0.4,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.grey[400],
                ),
              ],
            ):SizedBox(),
            SizedBox(height: height(5),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SPClassEncryptImage.asset(
                  SPClassImageUtil.spFunGetImagePath('ic_login_pwd'),
                  fit: BoxFit.contain,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    obscureText: !spProIsShowPassWord,
                    style: TextStyle(fontSize: 16, color: Color(0xFF333333),textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintText: "请输入新密码",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 16, color: Color(0xFF999999),textBaseline: TextBaseline.alphabetic),

                    ),
                    onChanged: (value) {
                      setState(() {
                        spProPwd = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: height(5),),
            Container(
              height: 0.4,
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.grey[400],
            ),
            SizedBox(height: height(5),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SPClassEncryptImage.asset(
                  SPClassImageUtil.spFunGetImagePath('ic_login_pwd'),
                  fit: BoxFit.contain,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    obscureText: !spProIsShowPassWord,
                    style: TextStyle(fontSize: 16, color: Color(0xFF333333),textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintText: "请确认密码",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 16, color: Color(0xFF999999),textBaseline: TextBaseline.alphabetic),

                    ),
                    onChanged: (value) {
                      setState(() {
                        spProPwd2 = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: height(5),),
            Container(
              height: 0.4,
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.grey[400],
            ),
          ],
        ));
  }

  // 创建登录界面的button
  Widget spFunBuildRegisterButton() {

   return  GestureDetector(
      child:  Container(
        margin: EdgeInsets.only(top: height(10)),
        height: height(53),
        alignment: Alignment.center,
        child:Container(
          alignment: Alignment.center,
          height: height(40),
          width: width(320),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width(3)),
            gradient: LinearGradient(
                colors: [Color(0xFFF2150C),Color(0xFFF24B0C)]
            ),
            boxShadow:[
              BoxShadow(
                offset: Offset(3,3),
                color: Color(0x4DF23B0C),
                blurRadius:width(5,),),

            ],

          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Text("确定",style: TextStyle(fontSize: sp(15),color: Colors.white),)
            ],
          ),
        ) ,
      ),
      onTap: () async {
        if(SPClassApplicaion.spProUserLoginInfo.spProHasPwd=="1"){
          if(spFunCheckTextOrg()){return;}
        }
        if(spFunCheckTextPwd()){return;}
        if(spFunCheckPwdRepeat()){return;}
        spFunDoRegister();
      },
    );

  }

// 点击控制密码是否显示
  void spFunShowPassWord() {
    setState(() {
      spProIsShowPassWord = !spProIsShowPassWord;
    });
  }


  bool spFunCheckTextOrg() {
    if (spProPwdOrg.isEmpty) {SPClassToastUtils.spFunShowToast(msg: "原密码不能为空");return true;}
    return false;
  }

  bool spFunCheckTextPwd() {
    if (spProPwd.isEmpty||spProPwd2.isEmpty) {SPClassToastUtils.spFunShowToast(msg: "新密码不能为空");return true;}
    return false;
  }


  bool spFunCheckPwdRepeat() {
    if (spProPwd!=spProPwd2) {SPClassToastUtils.spFunShowToast(msg: "两次密码不一致");return true;}
    return false;
  }

  Future spFunDoRegister() async {


    SPClassApiManager.spFunGetInstance().spFunUserChangePwd(context:context ,queryParameters:{"old_pwd":spProPwdOrg,"change_method":"old_pwd"},spProBodyParameters:{"pwd":spProPwd},
    spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
      spProOnSuccess: (result){
        SPClassToastUtils.spFunShowToast(msg: "修改成功,请重新登录");
        SPClassApplicaion.spFunClearUserState();
        SPClassApplicaion.spProEventBus.fire("login:out");
        SPClassNavigatorUtils.spFunPopAll(context);
      }
    )
    );

  }
}