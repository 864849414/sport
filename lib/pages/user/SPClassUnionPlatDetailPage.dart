import "package:flutter/cupertino.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sport/SPClassEncryptImage.dart";
import "package:sport/app/SPClassApplicaion.dart";
import "package:sport/model/SPClassBaseModelEntity.dart";
import "package:sport/model/SPClassCreatOrderEntity.dart";
import "package:sport/utils/SPClassCommonMethods.dart";
import "package:sport/utils/SPClassNavigatorUtils.dart";
import "package:sport/utils/api/SPClassApiManager.dart";
import "package:sport/utils/api/SPClassHttpCallBack.dart";
import "package:sport/utils/SPClassStringUtils.dart";
import "package:sport/utils/SPClassToastUtils.dart";
import "package:sport/pages/user/SPClassContactPage.dart";
import "package:fluwx/fluwx.dart" as fluwx;
import "package:sport/widgets/SPClassToolBar.dart";
import "package:tobias/tobias.dart" as tobias;
import "package:url_launcher/url_launcher.dart";
import "package:sport/utils/SPClassImageUtil.dart";

class SPClassUnionPlatDetailPage extends StatefulWidget {
  double spProOrderMoney;
  double spProDiamond;
  VoidCallback callback;
  SPClassUnionPlatDetailPage({this.spProOrderMoney, this.spProDiamond, this.callback});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassUnionPlatDetailPageState();
  }
}

class SPClassUnionPlatDetailPageState extends State<SPClassUnionPlatDetailPage> {
  var spProPayType="weixin";
  var spProOrderNum="";
  var spProIsAliPayWeb="1";
  var spProIsWechatWeb="1";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tobias.isAliPayInstalled().then((value){
      spProIsAliPayWeb=value? "0":"1";
    });
    fluwx.isWeChatInstalled.then((value){
      spProIsWechatWeb=value? "0":"1";
    });

    fluwx.weChatResponseEventHandler.listen((response){
      //do something
      switch(response.errCode){
        case 0:
         if(spProOrderNum.isNotEmpty){
            spFunQueryOrder();
         }
        break;
        case -1:
          SPClassToastUtils.spFunShowToast(msg: "???????????????"+
              "${response.errStr}");
          break;
        case -2:
          SPClassToastUtils.spFunShowToast(msg: "?????????");
          if(spProOrderNum.isNotEmpty){
            SPClassApiManager.spFunGetInstance().spFunCancelOrder(spProOrderNum:spProOrderNum,context: context);
          }
          break;
      }

    });

    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="userInfo"){
        if(mounted){
          setState(() {});
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar:SPClassToolBar(
          context,
          title: "????????????",
        ),
        body: Container(
          color: Color(0xFFF1F1F1),
          height: ScreenUtil.screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: width(123),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("??????:",style: TextStyle(fontSize: sp(12)),),
                      RichText(
                        text: TextSpan(text:"???",style: TextStyle(fontSize: sp(20),color: Color(0xFFE3494B)),
                            children: [
                              TextSpan(text: "${SPClassStringUtils.spFunSqlitZero((widget.spProOrderMoney-widget.spProDiamond).toString())}",style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: sp(50))) ),
                            ]
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: width(10),),
                Container(
                  padding: EdgeInsets.all(width(20)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                  ),
                  child: Row(
                    children: <Widget>[
                      Text("????????????",style: TextStyle(fontSize: sp(16),color: Color(0xFF333333)),),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text("${SPClassStringUtils.spFunSqlitZero(widget.spProOrderMoney.toString())}"+
                          "??????",style: TextStyle(fontSize: sp(17),color: Color(0xFFE3494B),),)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(width(20)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                  ),
                  child: Row(
                    children: <Widget>[
                      Text("????????????",style: TextStyle(fontSize: sp(16),color: Color(0xFF333333)),),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text("${SPClassStringUtils.spFunSqlitZero(widget.spProDiamond.toString())}"+
                          "??????",style: TextStyle(fontSize: sp(17),color: Color(0xFFE3494B),),)
                    ],
                  ),
                ),
                SizedBox(height: width(10),),
                Column(
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                        ),
                        padding: EdgeInsets.only(left: width(21),right: width(16)),
                        height: height(60),
                        child: Row(
                          children: <Widget>[
                            SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_pay_wx"),
                              width: width(37),
                              height: width(37),
                            ),
                            SizedBox(width: width(5),),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("????????????", style: TextStyle(fontSize: sp(16), color: Color(0xFF333333)),),
                                Text("????????????????????????", style: TextStyle(fontSize: sp(11), color: Color(0xFF999999)),)
                              ],
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    spProPayType=="weixin"? SPClassImageUtil.spFunGetImagePath("ic_select"):SPClassImageUtil.spFunGetImagePath("ic_un_select"),
                                    width: width(15),
                                    height: width(15),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: (){
                        if(mounted){
                          setState(() {
                            spProPayType="weixin";
                          });
                        }
                      },
                    ),
                    FlatButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: EdgeInsets.only(left: width(21),right: width(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        height: height(60),
                        child: Row(
                          children: <Widget>[
                            SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_pay_alipay"),
                              width: width(37),
                              height: width(37),
                            ),
                            SizedBox(width: width(5),),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("???????????????", style: TextStyle(fontSize: sp(16), color: Color(0xFF333333)),),
                                Text("??????????????????????????????????????????????????????????????????", style: TextStyle(fontSize: sp(11), color: Color(0xFF999999)),)
                              ],
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    spProPayType=="alipay"? SPClassImageUtil.spFunGetImagePath("ic_select"):SPClassImageUtil.spFunGetImagePath("ic_un_select"),
                                    width: width(15),
                                    height: width(15),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: (){
                        if(mounted){
                          setState(() {
                            spProPayType="alipay";
                          });
                        }
                      },
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(width(15)),
                  child: RichText(
                    text: TextSpan(text: "????????????:"+
                        "\n\n",style: TextStyle(fontSize: sp(13),color: Color(0xFF888888)),
                        children: [
                          TextSpan(text: "1.????????????",style: TextStyle(fontSize: sp(12),color: Color(0xFF888888))),
                          TextSpan(text: "???????????????",style: TextStyle(fontSize: sp(12),color: Color(0xFFDE3C31))),
                          TextSpan(text: "????????????????????????????????????????????????????????????????????????????????????????????????",style: TextStyle(fontSize: sp(12),color: Color(0xFF888888))),
                          TextSpan(text: "????????????????????????????????????"+
                              "\n\n",style: TextStyle(fontSize: sp(12),color: Color(0xFFDE3C31))),
                          TextSpan(text: "2.??????????????????????????????????????????????????????????????????????????????????????????????????????????????????",style: TextStyle(fontSize: sp(12),color: Color(0xFF888888))),
                          TextSpan(text: "kk_lzy",style: TextStyle(fontSize: sp(12),color: Color(0xFFDE3C31)),recognizer: new TapGestureRecognizer(
                          )..onTap=(){
                           SPClassNavigatorUtils.spFunPushRoute(context, SPClassContactPage());
                          } ),
                          TextSpan(text: ")"+
                              "\n\n",style: TextStyle(fontSize: sp(12),color: Color(0xFF888888))),
                          TextSpan(text: "3.??????????????????????????????????????????????????????",style: TextStyle(fontSize: sp(12),color: Color(0xFF888888))),

                        ]
                    ),
                  ),
                )

              ],
            ),
          ),
    ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              boxShadow:[BoxShadow(
                offset: Offset(1,1),
                color: Color(0x1a000000),
                blurRadius:width(6,),
              )]
          ),
          height: height(53),
          child:GestureDetector(
            child:  Container(
              color: Colors.white,
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
                child:Text("????????????",style: TextStyle(fontSize: sp(15),color: Colors.white),),
              ) ,
            ),
            onTap: () async {

              var value=widget.spProOrderMoney-widget.spProDiamond;
              SPClassApiManager.spFunGetInstance().spFunCreateOrder(queryParameters: {"pay_type_key":spProPayType,"money":value,"is_web":spProPayType=="weixin"? spProIsWechatWeb:spProIsAliPayWeb},context:context,
                  spProCallBack: SPClassHttpCallBack<SPClassCreatOrderEntity>(
                    spProOnSuccess: (value){
                      spProOrderNum=value.spProOrderNum;
                      if(spProPayType=="weixin"){
                        if(spProIsWechatWeb=="1"){
                          launch(value.url);
                        }else{
                          fluwx.payWithWeChat( appId: value.appid,
                            partnerId: value.partnerid,
                            prepayId: value.spProPrepayid,
                            packageValue: "Sign=WXPay",
                            nonceStr: value.noncestr,
                            timeStamp: value.timestamp,
                            sign: value.sign,
                          );
                         }
                      }else if(spProPayType=="alipay"){
                        if(spProIsAliPayWeb=="1"){
                          launch(value.url);
                        }else{
                          tobias.aliPay(value.spProOrderInfo).then((value){
                            switch(int.tryParse(value["resultStatus"].toString())){
                              case 9000:
                                if(spProOrderNum.isNotEmpty){
                                  spFunQueryOrder();
                                }
                                break;
                              case 8000:
                                break;
                              case 6002:
                                SPClassToastUtils.spFunShowToast(msg: "???????????????"+
                                    value["memo"]);
                                break;
                              case 6001:
                                SPClassToastUtils.spFunShowToast(msg: "?????????");
                                if(spProOrderNum.isNotEmpty){
                                  SPClassApiManager.spFunGetInstance().spFunCancelOrder(spProOrderNum:spProOrderNum,context: context);
                                }
                                break;
                            }
                          });
                        }

                      }


                    },
                  )
              );
            },
          ),
        ),

    );
  }

  void spFunQueryOrder() {

    SPClassApiManager.spFunGetInstance().spFunGetOrderStatus(spProOrderNum:spProOrderNum,context: context,
        spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
            spProOnSuccess: (value){
              if(value.response["data"]["status"]=="0"){
                spFunQueryOrder();
              }else if(value.response["data"]["status"]=="1"){
                SPClassToastUtils.spFunShowToast(msg: "????????????");
                SPClassApplicaion.spFunGetUserInfo();
                Navigator.of(context).pop();
                widget.callback();

              }
            }
        )
    );
  }
}
