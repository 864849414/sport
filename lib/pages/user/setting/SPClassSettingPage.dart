import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/login/SPClassChangePwdPage.dart';
import 'package:sport/pages/user/setting/SPClassVersionCheckDialog.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/pages/common/SPClassDialogUtils.dart';

class SPClassSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassSettingPageState();
  }
}

class SPClassSettingPageState extends State<SPClassSettingPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title: "设置",
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFF1F1F1),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 0.4,
                color: Color(0xFFDDDDDD),
              ),
              GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: height(48),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xFFDDDDDD), width: 0.4))),
                    padding: EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 15),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: width(10),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Text("修改密码",
                              style: TextStyle(
                                fontSize: sp(14),
                                color: Color(
                                  0xFF333333,
                                ),
                              )),
                        ),
                        SPClassEncryptImage.asset(
                          SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                          width: width(11),
                        ),
                        SizedBox(
                          width: width(10),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    if (spFunIsLogin(context: context)) {
                      SPClassNavigatorUtils.spFunPushRoute(
                          context, SPClassChangePwdPage());
                    }
                  }),
              GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: height(48),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xFFDDDDDD), width: 0.4))),
                    padding: EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 15),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: width(10),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Text("版本",
                              style: TextStyle(
                                fontSize: sp(14),
                                color: Color(
                                  0xFF333333,
                                ),
                              )),
                        ),
                        Text(
                          "${SPClassApplicaion.spProPackageInfo.version}",
                          style: TextStyle(
                              fontSize: sp(14), color: Color(0xFFD1D1D1)),
                        ),
                        SPClassEncryptImage.asset(
                          SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                          width: width(11),
                        ),
                        SizedBox(
                          width: width(10),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    SPClassApiManager.spFunGetInstance().spFunCheckUpdate(
                        context: context,
                        spProCallBack:
                            SPClassHttpCallBack(spProOnSuccess: (result) {
                          if (result.spProNeedUpdate) {
                            showDialog<void>(
                                context: context,
                                builder: (BuildContext cx) {
                                  return SPClassVersionCheckDialog(
                                    result.spProIsForced,
                                    result.spProUpdateDesc,
                                    result.spProAppVersion,
                                    spProDownloadUrl: result.spProDownloadUrl,
                                    spProCancelCallBack: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                });
                          } else {
                            SPClassToastUtils.spFunShowToast(
                                msg: "当前版本已经是最新版本",
                                gravity: ToastGravity.CENTER);
                          }
                        }));
                  }),
              SizedBox(
                height: width(39),
              ),
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  height: width(40),
                  alignment: Alignment.center,
                  child: Text(
                    "账号注销",
                    style: TextStyle(
                        fontSize: sp(14),
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                onTap: () {
                  SPClassDialogUtils.spFunShowConfirmDialog(
                      context,
                      RichText(
                        text: TextSpan(
                          text: "确认将个人信息销毁？如有疑问，请联系客服",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFF333333)),
                          children: <TextSpan>[
                            TextSpan(
                                text: "",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF333333))),
                          ],
                        ),
                      ), () {
                    SPClassApplicaion.spFunClearUserState();
                    SPClassApplicaion.spProEventBus.fire("login:out");
                    SPClassNavigatorUtils.spFunPopAll(context);
                  }, showCancelBtn: true);
                },
              ),
              SizedBox(
                height: width(20),
              ),
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  height: width(40),
                  alignment: Alignment.center,
                  child: Text(
                    "退出",
                    style: TextStyle(
                        fontSize: sp(14),
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                onTap: () {
                  SPClassApplicaion.spFunClearUserState();
                  SPClassApplicaion.spProEventBus.fire("login:gameout");
                  SPClassApplicaion.spProEventBus.fire("login:gamelist");
                  SPClassApplicaion.spProEventBus.fire("login:out");
                  SPClassNavigatorUtils.spFunPopAll(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
