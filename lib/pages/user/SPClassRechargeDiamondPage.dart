import "package:flutter/cupertino.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sport/app/SPClassApplicaion.dart";
import "package:sport/model/SPClassBaseModelEntity.dart";
import "package:sport/model/SPClassCoupon.dart";
import "package:sport/model/SPClassCreatOrderEntity.dart";
import "package:sport/model/SPClassShowPListEntity.dart";
import "package:sport/pages/dialogs/SPClassPickCouponDialog.dart";
import "package:sport/utils/SPClassCommonMethods.dart";
import "package:sport/utils/SPClassImageUtil.dart";
import "package:sport/utils/SPClassNavigatorUtils.dart";
import "package:sport/utils/api/SPClassApiManager.dart";
import "package:sport/utils/api/SPClassHttpCallBack.dart";
import "package:sport/utils/SPClassStringUtils.dart";
import "package:sport/utils/SPClassToastUtils.dart";
import "package:sport/pages/user/SPClassContactPage.dart";
import 'package:sport/utils/colors.dart';
import "package:sport/widgets/SPClassPrecisionLimitFormatter.dart";
import "package:fluwx/fluwx.dart" as fluwx;
import "package:sport/widgets/SPClassToolBar.dart";
import "package:tobias/tobias.dart" as tobias;
import "package:url_launcher/url_launcher.dart";
import "SPClassDiamondHistoryPage.dart";
import "package:sport/SPClassEncryptImage.dart";

class SPClassRechargeDiamondPage extends StatefulWidget {
  double spProMoneySelect;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassRechargeDiamondPageState();
  }

  SPClassRechargeDiamondPage({this.spProMoneySelect:0});
}

class SPClassRechargeDiamondPageState extends State<SPClassRechargeDiamondPage> {
  int spProSelectIndex=0;
  TextEditingController spProTextEditingController;
  var rechargeString=[
    {"value_diamond":"18","value":"18","in_put":false,"double":false,"limit":false},
    {"value_diamond":"38","value":"38","in_put":false,"double":false,"limit":false},
    {"value_diamond":"88","value":"88","in_put":false,"double":false,"limit":false},
    {"value_diamond":"168","value":"168","in_put":false,"double":false,"limit":false},
    {"value_diamond":"388","value":"388","in_put":false,"double":false,"limit":false},
    {"value_diamond":"888","value":"888","in_put":false,"double":false,"limit":false},
  ];

  var spProPayType="weixin";
  var spProOrderNum="";
  var spProIsAliPayWeb="0";
  var spProIsWechatWeb="0";

  List<SPClassCoupon> coupons=[];

  SPClassCoupon selectCoupon;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "click_pay",);

    SPClassApiManager.spFunGetInstance().spFunShowPConfig(spProCallBack: SPClassHttpCallBack<SPClassShowPListEntity>(
        spProOnSuccess: (result){
          SPClassApplicaion.spProShowPListEntity=result;
          spFunInitConfig();
        }
    ));

    tobias.isAliPayInstalled().then((value){
      spProIsAliPayWeb=value? "0":"1";
    });
    fluwx.isWeChatInstalled.then((value){
      spProIsWechatWeb=value? "0":"1";
    });
    spProTextEditingController=TextEditingController();
    spProTextEditingController.addListener(() {
      setState(() {

      });
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
          SPClassToastUtils.spFunShowToast(msg: "???????????????"+response.errStr);
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


    spFunGetCoupon();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar:SPClassToolBar(
          context,
          title: "??????",
          spProBgColor: MyColors.main1,
          iconColor: 0xffffffff,
        ),
        body: Container(
          color: Color(0xFFF1F1F1),
          height: ScreenUtil.screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: width(15),right: width(15),top: width(12),bottom: width(12)),
                  margin: EdgeInsets.symmetric(vertical: width(6)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('??????:  ',style: TextStyle(fontSize: sp(13),color: MyColors.grey_99),),
                      Text('${SPClassStringUtils.spFunSqlitZero(SPClassApplicaion.spProUserInfo.spProDiamond)}',style: TextStyle(fontSize: sp(23),color: Color(0xFF1B8DE0),height: 0.9),),
                      SPClassEncryptImage.asset(
                        SPClassImageUtil.spFunGetImagePath("zhuanshi"),
                        width: width(17),
                      ),

                      Expanded(
                        child: SizedBox(),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(left: width(8),right: width(8),top: width(6),bottom: width(6)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width(15)),
                              border: Border.all(width: 0.4,color: MyColors.grey_99)
                          ),
                          child: Row(
                            children: <Widget>[
                              Text("????????????",style: TextStyle(color: MyColors.grey_99,fontSize: sp(12)),),
                              SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                                width: width(12),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){
                          SPClassNavigatorUtils.spFunPushRoute(context, SPClassDiamondHistoryPage());
                        },
                      )
                    ],
                  ),
                ),
                   Container(
                     color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '????????????',style: TextStyle(fontSize: sp(19),fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: width(15),vertical: width(10)),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.4,color:Color(0xFFF2F2F2),),)
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(width(13)),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                        ),
                        child: GridView.count(
                          shrinkWrap:true,
                          crossAxisCount: 3,
                          scrollDirection: Axis.vertical,
                          childAspectRatio:width(97)/width(48),
                          mainAxisSpacing:  height(13),
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisSpacing: width(12),
                          children: rechargeString.map((rechargeItem){
                            String rmb=rechargeItem["value"];
                            bool isInput=rechargeItem["in_put"];
                            bool canDouble=rechargeItem["double"];
                            bool limit=rechargeItem["limit"];
                            return FlatButton(
                              padding: EdgeInsets.zero,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: spProSelectIndex == rechargeString.indexOf(rechargeItem)
                                        ?Color(0xFFFFEAE6):Color(0xFFF7F7F7),
                                        border: Border.all(
                                            color: spProSelectIndex == rechargeString.indexOf(rechargeItem)
                                                ? Color(0xFFEB3E1C)
                                                : Colors.transparent,
                                            width: 0.5)),
                                    child: isInput ? TextField(
                                      textAlign: TextAlign.center,
                                      inputFormatters:SPClassApplicaion.spProDEBUG? [SPClassPrecisionLimitFormatter(2)]:[WhitelistingTextInputFormatter.digitsOnly],
                                      keyboardType: TextInputType.numberWithOptions(),
                                      style: TextStyle(
                                          fontSize: sp(12),
                                          color: Color(0xFF333333),textBaseline: TextBaseline.alphabetic),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "?????????",
                                        hintStyle: TextStyle(
                                            fontSize: sp(12),
                                            color: Color(0xFF999999),textBaseline: TextBaseline.alphabetic),
                                      ),
                                      controller:spProTextEditingController,
                                      onTap: (){
                                        if(mounted){
                                          setState(() {
                                            selectCoupon=null;
                                            spProSelectIndex=rechargeString.indexOf(rechargeItem);
                                          });

                                        }
                                      },
                                    ):Center(
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                rechargeItem["value_diamond"].toString(),
                                                style: TextStyle(
                                                    fontSize: sp(16),
                                                    fontWeight: FontWeight.w500,
                                                    color:  spProSelectIndex == rechargeString.indexOf(rechargeItem)
                                                        ? Color(0xFFE3494B)
                                                        :MyColors.main1
                                                ),
                                              ),
                                              SPClassEncryptImage.asset(
                                                SPClassImageUtil.spFunGetImagePath("zhuanshi"),
                                                width: width(17),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            // rechargeItem["value_diamond"].toString()+"??????",
                                            rmb+"???",
                                            style: TextStyle(
                                                fontSize: sp(11),
                                                color:  spProSelectIndex == rechargeString.indexOf(rechargeItem)
                                                    ? Color(0xFFE3494B)
                                                    :Color(0xFF999999)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   bottom: 0,
                                  //   right: 0,
                                  //   child:spProSelectIndex == rechargeString.indexOf(rechargeItem)
                                  //       ? SPClassEncryptImage.asset(
                                  //     SPClassImageUtil.spFunGetImagePath("ic_select_lab"),
                                  //     width: width(18),
                                  //   ):SizedBox(),
                                  // ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child:limit ? SPClassEncryptImage.asset(
                                      SPClassImageUtil.spFunGetImagePath("ic_recharge_limit"),
                                      width: width(25),
                                    ):SizedBox(),
                                  ),

                                  Positioned(
                                    top: 0.5,
                                    bottom: 0.5,
                                    left:0.5,
                                    child: canDouble ? Container(
                                      padding: EdgeInsets.all(width(2)),
                                      decoration: BoxDecoration(
                                          borderRadius:BorderRadius.horizontal(left: Radius.circular(3)),
                                          color:Color(0xFFE36649)),
                                      alignment: Alignment.center,
                                      width: width(15),
                                      child: Text(
                                          "????????????",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: sp(7),letterSpacing: 0,wordSpacing: 0, color: Colors.white
                                             ,)
                                      ),
                                    ):SizedBox(),
                                  ),
                                ],
                              ),
                              onPressed: (){
                                if(mounted){
                                  setState(() {
                                    selectCoupon=null;
                                    spProSelectIndex=rechargeString.indexOf(rechargeItem);
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
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
                      SizedBox(height: 10,),

                    ],

                  ),
                ),

                Container(
                  padding: EdgeInsets.all(width(15)),
                  child: RichText(
                    text: TextSpan(text: "????????????:"+
                        "\n\n",style: TextStyle(fontSize: sp(13),color: Color(0xFF888888)),
                        children: [
                          TextSpan(text: "1.????????????",style: TextStyle(fontSize: sp(12),color: Color(0xFF888888))),
                          TextSpan(text: "???????????????",style: TextStyle(fontSize: sp(12),color: Color(0xFFDE3C31))),
                          TextSpan(text: "????????????????????????????????????????????????????????????",style: TextStyle(fontSize: sp(12),color: Color(0xFF888888))),
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
        bottomNavigationBar:Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow:[BoxShadow(
                offset: Offset(1,1),
                color: Color(0x1a000000),
                blurRadius:width(6,),
              )]
          ),
          height: width(64)+ScreenUtil.bottomBarHeight,
          child:Column(
            children: <Widget>[
             /* Container(
                height: width(40),
                padding: EdgeInsets.symmetric(horizontal:width(23)),
                child: Row(
                  children: <Widget>[
                    RichText(text: TextSpan(
                        text: "????????? ",
                        style: TextStyle(fontSize: sp(13),color: Color(0xFF333333)),
                        children: [
                          TextSpan(
                            text: coupons.length.toString(),
                            style: TextStyle(color: Color(0xFFEB3F39)),

                          ),
                          TextSpan(
                            text: " ???",

                          )
                        ]
                    ),),
                    Expanded(
                      child:  GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            selectCoupon==null?  RichText(text: TextSpan(
                                text: "??????????????? ",
                                style: TextStyle(fontSize: sp(13),color: Color(0xFF333333)),
                                children: [
                                  TextSpan(
                                    text: getUseCouponList().length.toString(),
                                    style: TextStyle(color: Color(0xFFEB3F39)),

                                  ),
                                  TextSpan(
                                    text: " ???",

                                  )
                                ]
                            ),):RichText(text: TextSpan(
                                text: "?????? ",
                                style: TextStyle(fontSize: sp(13),color: Color(0xFF333333)),
                                children: [
                                  TextSpan(
                                    text: selectCoupon.money,
                                    style: TextStyle(color: Color(0xFFEB3F39)),
                                  ),
                                  TextSpan(
                                    text: " ???",

                                  )
                                ]
                            ),),
                            SPClassEncryptImage.asset(ImageUtil.getImagePath("ic_btn_right"),
                              width: width(11),
                            ),

                          ],
                        ),
                        onTap: (){
                          if(getUseCouponList().length>0){
                            showCupertinoModalPopup(context: context, builder:(c)=>
                                PickCouponDialog(
                                  coupons: getUseCouponList(),
                                  select: selectCoupon,
                                  spProValueChanged: (select){
                                    selectCoupon=select;
                                    setState(() {});
                                    FocusScope.of(context).requestFocus(FocusNode());

                                  },
                                ));
                          }else{
                            ToastUtils.showToast(msg: "??????????????????????????????");
                          }
                        },
                      ),
                    )

                  ],
                ),
              ),*/
              GestureDetector(
                child:  Container(
                  height: width(61),
                  alignment: Alignment.topCenter,
                  child:Container(
                    alignment: Alignment.center,
                    // height: height(41),
                      color: MyColors.main1,
                    child:Text("????????????",style: TextStyle(fontSize: sp(15),color: Colors.white),),
                  ) ,
                ),
                onTap: () async {


                  String value;
                  if(rechargeString[spProSelectIndex]["in_put"]){
                    value=spProTextEditingController.text;
                  }else{
                    value=rechargeString[spProSelectIndex]["value"];
                  }
                  if(value==null||value.isEmpty||double.tryParse(value)==0){
                    SPClassToastUtils.spFunShowToast(msg: "???????????????");
                    return;
                  }
                  spProOrderNum="";
                  SPClassApiManager.spFunGetInstance().spFunCreateOrder(queryParameters: {
                    "pay_type_key":spProPayType,
                    "coupon_id":selectCoupon==null? "":selectCoupon.spProCouponId,
                    "money":selectCoupon==null? value:(SPClassStringUtils.spFunSqlitZero((double.tryParse(value)-double.tryParse(selectCoupon.spPromoney)).toStringAsFixed(2))),
                    "is_web":spProPayType=="weixin"? spProIsWechatWeb:spProIsAliPayWeb},
                      context:context,
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
                                    SPClassToastUtils.spFunShowToast(msg: "???????????????"+value["memo"].toString());
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
              SizedBox(height: ScreenUtil.bottomBarHeight,),
            ],
          ),
        )

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

              }
            }
        )
    );
  }

  void spFunInitConfig() {
    if(SPClassApplicaion.spProShowPListEntity==null){
      return;
    }
    var result=SPClassApplicaion.spProShowPListEntity;
    rechargeString.clear();
    var spProExchangeRate=double.tryParse(result.spProExchangeRate);
    result.spProMoneyList.forEach((item){

      if(double.tryParse(item)==widget.spProMoneySelect){
        spProSelectIndex=result.spProMoneyList.indexOf(item);
      }
      var doubleRate=1;
      if(result.spProDoubleMoneys.contains(item)){doubleRate=2;}
      rechargeString.add({"value_diamond":SPClassStringUtils.spFunSqlitZero((double.tryParse(item)*spProExchangeRate*doubleRate).toString()), "value":item,"in_put":false,"double":false,"limit":false});
    });
    result.spProPayedMoneyList.forEach((item){
      rechargeString.forEach((map){
        if(map["double"]&&double.tryParse(item)==double.tryParse(map["value"])){
          map["value_diamond"]=(double.parse(map["value_diamond"])/2).toStringAsFixed(0);
        }
      });
    });
    result.spProMoney2Diamond.forEach((key,value){
      rechargeString.forEach((map){
        if(double.tryParse(key.toString())==double.tryParse(map["value"])){
          map["value_diamond"]=value.toString();
          map["limit"]=true;
        }
      });
    });

    if(SPClassApplicaion.spProDEBUG){
      rechargeString.add({"value_diamond":"0","value":"0","in_put":true,"double":false,"limit":false});
    }

    setState(() {});
  }

  spFunGetCoupon()  {

    SPClassApiManager.spFunGetInstance().spFunCouponMyList<SPClassCoupon>(queryParameters: {"status":"unused"},spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (list){
          setState(() {
            coupons=list.spProDataList;
          });
        },
        onError: (value){
        }
    ));
  }
  
  List<SPClassCoupon> spFunGetUseCouponList(){
    List<SPClassCoupon> list =[];
    var spProMoney=0.0;
    String value;
    if(rechargeString[spProSelectIndex]["in_put"]){
      value=spProTextEditingController.text;
    }else{
      value=rechargeString[spProSelectIndex]["value"];
    }

    if(value!=null&&value.isNotEmpty){
      spProMoney=double.tryParse(value);
    }

    coupons.forEach((item) {
       if(spProMoney>=double.tryParse(item.spProMinMoney)){
         list.add(item);
       }
    });

    return list;
  }
}
