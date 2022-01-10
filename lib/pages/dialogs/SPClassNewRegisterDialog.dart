import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/pages/user/SPClassNewUserWalFarePage.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassNewRegisterDialog extends StatefulWidget{
  VoidCallback callback;

  SPClassNewRegisterDialog({this.callback});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassNewRegisterDialogState();
  }

}

class SPClassNewRegisterDialogState extends State<SPClassNewRegisterDialog>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child:Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: height(25),bottom:  height(15)),
              width: width(288),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SPClassEncryptImage.asset(
                    SPClassImageUtil.spFunGetImagePath("ic_register_title"),
                    width: height(194),
                  ),
                  SizedBox(height:height(3) ,),

                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: height(10)),
                        child: SPClassEncryptImage.asset(
                          SPClassImageUtil.spFunGetImagePath("bg_new_user_diamond"),
                          width: height(304),
                        ),
                      ),


                      Container(
                        width: width(240),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width(5)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xFFd16519),
                              Color(0xFFd16519),
                              Colors.transparent
                            ]
                          )
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(fontSize: sp(14),),
                            text: "注册即送"+
                                " \n",
                            children: [
                              TextSpan(
                                text: "价值178元钻石礼包"
                              )
                            ]
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child:GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_btn_fuli"),
                              width: height(147),
                            ),
                          ),
                          onTap: (){
                            Navigator.of(context).pop();
                            SPClassNavigatorUtils.spFunPushRoute(context, SPClassNewUserWalFarePage());
                          },
                        ) ,
                      )
                    ],
                  ),

                  SizedBox(height: height(15),),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(width(5)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:Border.all(color: Colors.white,width: 2)
                      ),
                      child: Icon(Icons.close,color: Colors.white,size: 20,),
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                      if(widget.callback!=null){
                        widget.callback();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop:() async{
        return false;
      },
    );
  }

}