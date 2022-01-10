import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/pages/user/SPClassNewUserWalFarePage.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassInviteRuluDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassInviteRuluDialogState();
  }

}

class SPClassInviteRuluDialogState extends State<SPClassInviteRuluDialog>{
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
              width: width(227),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width(8))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_invite_title"),width: width(143),),
                   SizedBox(height: 10,),
                   Container(
                     padding: EdgeInsets.only(left: width(12),right: width(12)),
                     child: Text("1.被邀请人通过用户分享平台上的任意链接注册成功，分享者可获得奖励，单日无上限。"+
                         "\n "+
                         "\n "+
                         "2.每成功邀请一位好友，将会获得"+
                             SPClassApplicaion.spProConfReward.spProInviteUser??""+
                             "钻石奖励。"+
                             " \n"+
                             " \n"+
                         "3.被邀请人需在注册时填写分享者的邀请码才算邀请成功 "+
                             "\n"+
                             " \n"+
                         "4.本次活动红胜体育官方具有解释权，任何以不正当手段获得利益红胜体育官方有权收回。",
                       style: TextStyle(fontSize: sp(12)),),
                   )

                ],
              ),
            ),
            SizedBox(height: height(32),),
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

              },
            )
          ],
        ),
      ),
      onWillPop:() async{
        return false;
      },
    );
  }

}