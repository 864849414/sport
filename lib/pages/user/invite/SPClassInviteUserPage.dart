import 'dart:typed_data';
import 'dart:ui';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassShareModel.dart';
import 'package:sport/model/SPClassConfRewardEntity.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/pages/dialogs/SPClassInviteRuluDialog.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassInviteUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassInviteUserPageState();
  }
}

class SPClassInviteUserPageState extends State<SPClassInviteUserPage> {
  SPClassShareModel spProShare;
  int page=1;
  GlobalKey spProRootWidgetKey = GlobalKey();
  String spProUserNum="0";
  String spProInviteDiamond="0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "invite_user",);

    if(SPClassApplicaion.spProConfReward==null) {
      SPClassApiManager.spFunGetInstance().spFunConfReward<SPClassConfRewardEntity>(spProCallBack:SPClassHttpCallBack(
          spProOnSuccess: (value){
            SPClassApplicaion.spProConfReward=value;
            setState(() {});
          }
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title:"推荐有礼",
      ),
      body: Container(
        child:  Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SPClassEncryptImage.asset(
                    SPClassImageUtil.spFunGetImagePath("bg_invite_user"),
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                    child: Container(
                      color:Color(0xFFA00905) ,
                    ),
                  )
                ],
              ),
            ),


            Container(
              child: Column(children: <Widget>[
                SizedBox(height: width(120),),
                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: SPClassEncryptImage.asset(
                        SPClassImageUtil.spFunGetImagePath("bg_invite_red_dimond"),
                        width: width(325),

                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: width(30),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.end,
                                text: TextSpan(
                                    text: SPClassApplicaion.spProConfReward.spProInviteUser??"",
                                    style: GoogleFonts.roboto(fontSize: sp(60),textStyle: TextStyle(color: Color(0xFFDE3C31)),fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: "元",
                                        style: GoogleFonts.notoSansSC(fontSize: sp(25),textStyle: TextStyle(color: Color(0xFFDE3C31)),fontWeight: FontWeight.bold),
                                      )
                                    ]
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: width(40),),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.end,
                                text: TextSpan(
                                  text: "钻石",
                                  style: GoogleFonts.roboto(fontSize: sp(30),textStyle: TextStyle(color: Colors.white),fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: height(5),),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                text: "已邀请 ",
                                style:  TextStyle(color: Colors.white,fontSize: sp(16),),
                                children: [
                                  TextSpan(
                                    text: spProUserNum.toString(),
                                    style:  TextStyle(color: Color(0xFFFDC14C),fontSize: sp(16),),
                                  ),
                                  TextSpan(
                                    text: "人",
                                  )
                                ]
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(width: 0.2,height: height(8),color: Colors.grey[300],),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                text: "已获取得",
                                style:  TextStyle(color: Colors.white,fontSize: sp(16),),
                                children: [
                                  TextSpan(
                                    text: (double.parse(spProUserNum)*int.tryParse(SPClassApplicaion.spProConfReward.spProInviteUser??"")).toStringAsFixed(0),
                                    style:  TextStyle(color: Color(0xFFFDC14C),fontSize: sp(16),),
                                  ),
                                  TextSpan(
                                    text: "钻石",
                                  )
                                ]
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

              ],),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: width(70)),
              child: SPClassEncryptImage.asset(
                SPClassImageUtil.spFunGetImagePath("bg_invite_red_force"),
                fit: BoxFit.fitWidth,
                width: ScreenUtil.screenWidth,
              ),
            ),

            Container(
              child: Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: height(20)),
                  alignment: Alignment.center,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SPClassEncryptImage.asset(
                        SPClassImageUtil.spFunGetImagePath("ic_invite_user_title"),
                        width: width(311),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "每邀请一位好友注册即可获得价值",
                          style: TextStyle(color: Color(0xFFFAFBCD,),fontSize: sp(14)),
                          children: [
                            TextSpan(
                                text: SPClassApplicaion.spProConfReward.spProInviteUser??"",
                                style: TextStyle(color: Color(0xFFFAD647,),fontSize: sp(14))
                            ),
                            TextSpan(
                                text: "元钻石",
                              style: TextStyle(color: Color(0xFFFAFBCD,),fontSize: sp(14)),
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                ),




              ],),
            ),

            Positioned(bottom: height(30),right: 0,left: 0,
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width:50 ),
                      Expanded(
                        child: Container(
                          height: 0.2,
                          color: Colors.grey[300],
                        ),
                      ),
                      Text("  马上邀请好友得奖励  ",style: TextStyle(color: Colors.white,fontSize: sp(16),),),
                      Expanded(
                        child: Container(
                          height: 0.2,
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(width:50 ),

                    ],
                  ),
                  SizedBox(height: height(10),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          children: <Widget>[
                            SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_share_wx"),width: width(43),),
                            SizedBox(height: height(5),),
                            Text("微信",style: TextStyle(color: Colors.white,fontSize: sp(10),),),
                          ],
                        ),
                        onTap: (){
                        if(spFunIsLogin(context: context)){

                        }
                        },
                      )

                    ],
                  ),
                ],
              ),
            ),
            ),
            Positioned(
              top: height(10),
              right: 0,
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 1,bottom: 1),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(
                        offset: Offset(1.0,2.0),
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 5
                      )],
                      color: Color(0xFFFF513A),
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(15))
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: width(8),),
                      Text("规则",style: TextStyle(fontSize: sp(13),color:Colors.white,),),
                      SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                        width: width(11),
                        color: Colors.white,
                      ),
                      SizedBox(width: width(7),)
                    ],
                  ),
                ),
                onTap: (){
                  showDialog(context: context,child: SPClassInviteRuluDialog());
                },
              ) ,
            ),


          ],
        ),
      ),
    );
  }





 Future<Uint8List> spFunCapturePng() async {
    try {
      RenderRepaintBoundary boundary =
      spProRootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
