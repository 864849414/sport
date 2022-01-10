import 'package:sport/utils/SPClassCommonMethods.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/pages/common/SPClassDialogUtils.dart';
import 'package:sport/pages/common/SPClassLoadingPage.dart';
import 'package:sport/pages/user/SPClassUnionPlatDetailPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';


class SPClassLoginWebPage extends StatefulWidget
{
   String value;
   SPClassLoginWebPage(this.value);

   SPClassLoginWebPageState createState()=>SPClassLoginWebPageState();
}

class SPClassLoginWebPageState extends State<SPClassLoginWebPage>
{
  bool spProIsHide=true;
  var spProWebUrl="";
  WebViewController spProWebViewController;

  var spProCanGoback=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var params=SPClassApiManager.spFunGetInstance().spFunGetCommonParams();
    params.putIfAbsent("model_type", ()=>widget.value);
    spProWebUrl=SPClassNetConfig.spFunGetBasicUrl()+"user/bcw/login?"+Transformer.urlEncodeMap(params);
    if(SPClassApplicaion.spProJsMap==null){
      spFunDomainJs(null);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
      floatingActionButton:(spProWebViewController!=null)? GestureDetector(
        child: Container(
          width: width(50),
          height: width(50),
          child: Icon(
           spProCanGoback? Icons.chevron_left:Icons.refresh,color: Colors.white,
          ),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle
          ),
        ),
        onTap: (){
          if(spProCanGoback){
            spProWebViewController.goBack();
          }else{
            spProWebViewController.reload();
          }
        },
      ):SizedBox(),
       backgroundColor: Color(0xFFF1F1F1),
      body: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
        ),
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        alignment: Alignment.center,
        child:Stack(
          children: <Widget>[
            WebView(
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
              initialUrl: spProWebUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller){
                spProWebViewController=controller;
              },
              onPageStarted: (url){
                setState(() {spProIsHide=true;});

              },
              onPageFinished:(url){
                setState(() {spProIsHide=false;});
                if(SPClassApplicaion.spProJsMap!=null){
                  SPClassApplicaion.spProJsMap.forEach((key,value){
                    if(url.contains(key.replaceAll("m.", "")))
                    {
                      spProWebViewController.evaluateJavascript(value);
                    }
                  });
                }
                spProWebViewController.canGoBack().then((value){
                  setState(() {
                   spProCanGoback=value;
                  });
                });

              } ,
              navigationDelegate: (NavigationRequest request) {

                if (request.url.contains("union_pay_callback")) {
                  var url =Uri.parse(request.url);
                  var spProDiamond=double.tryParse(url.queryParameters["diamond"]);
                  var spProMoney=double.tryParse(url.queryParameters["money"]);
                  var unionOrderNum=url.queryParameters["union_order_num"].toString();
                  var unionPlat=url.queryParameters["union_plat"].toString();
                  if(spProDiamond>=spProMoney){
                    SPClassDialogUtils.spFunShowConfirmDialog(context,RichText(
                      text: TextSpan(
                        text: "确认后将扣除",
                        style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
                        children: <TextSpan>[
                          TextSpan(text: spProMoney.toString(), style: TextStyle(fontSize: 16, color: Color(0xFFE3494B))),
                          TextSpan(text: "钻石"),
                        ],
                      ),
                    ), (){
                      SPClassApiManager.spFunGetInstance().spFunUnionPay<SPClassBaseModelEntity>(context:context,unionOrderNum: unionOrderNum,unionPlat: unionPlat,spProCallBack: SPClassHttpCallBack(
                        spProOnSuccess: (value){
                          SPClassToastUtils.spFunShowToast(msg: "支付成功");
                          spProWebViewController.reload();
                        },
                        onError: (value){
                        }
                      ));
                    });
                  }else{
                    SPClassNavigatorUtils.spFunPushRoute(context, SPClassUnionPlatDetailPage(callback: (){
                       SPClassApiManager.spFunGetInstance().spFunUnionPay<SPClassBaseModelEntity>(context:context,unionOrderNum: unionOrderNum,unionPlat: unionPlat,spProCallBack: SPClassHttpCallBack(
                        spProOnSuccess: (value){
                          SPClassToastUtils.spFunShowToast(msg: "支付成功");
                          spProWebViewController.reload();
                        }, onError: (value){}
                      ));
                    },spProDiamond: 0,spProOrderMoney: spProMoney,));
                  }
                  return NavigationDecision.prevent;
                }
                if(request.url.contains(".apk")){
                   launch(request.url);
                  return NavigationDecision.prevent;

                }
                return NavigationDecision.navigate;
              },
            ),
            spProIsHide? Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: SPClassLoadingPage(),
            ):SizedBox()
          ],
        ),
      ),
    );

  }



  void spFunDomainJs(String autoString) async{
    SPClassApiManager.spFunGetInstance().spFunDomainJs(spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
      SPClassApplicaion.spProJsMap=result.data;
    }));

  }
}


