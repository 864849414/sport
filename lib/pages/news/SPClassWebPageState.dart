import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/SPClassLogUtils.dart';

import 'package:sport/pages/common/SPClassDialogUtils.dart';
import 'package:sport/pages/common/SPClassLoadingPage.dart';
//import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:sport/pages/user/SPClassUnionPlatDetailPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:sport/utils/SPClassCommonMethods.dart';

class SPClassWebPage extends StatefulWidget
{
   String spProWebUrl;
   String spProWebTitle;
   String spProLocalFile;

   SPClassWebPage(this.spProWebUrl, this.spProWebTitle,{this.spProLocalFile});

   SPClassWebPageState createState()=>SPClassWebPageState();
}

class SPClassWebPageState extends State<SPClassWebPage>
{
  bool spProIsHide=true;
  WebViewController spProWebViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
     appBar: AppBar(
       elevation: 0,
       backgroundColor: Colors.white,
       titleSpacing: 0,
       leading:FlatButton(
         child: Icon(Icons.arrow_back_ios,size: width(20),color: Colors.black,),
         onPressed: (){spProWebViewController.goBack();},),
       centerTitle: true,
       brightness: Brightness.light,
       actions: <Widget>[
         SizedBox(width: kToolbarHeight,)
       ],
       title: Row(
         children: <Widget>[
           Container(
             constraints: BoxConstraints(
               maxWidth:kToolbarHeight,
               maxHeight: kToolbarHeight
             ),
             child:  GestureDetector(
               child: Icon(Icons.close,size: width(26),color: Colors.black,),
               onTap: (){Navigator.of(context).pop();},),
           ),

           Expanded(
             child: Container(
               alignment: Alignment.center,
               child: Text("${widget.spProWebTitle}",style: TextStyle(color: Color(0xFF333333),fontSize: width(16)),),
             ),
           ),
           SizedBox(width: kToolbarHeight,)
         ],
       ),
     ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
        ),
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        child: Stack(
          children: <Widget>[
            WebView(
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
              initialUrl: widget.spProWebUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller){
                spProWebViewController=controller;
                if(widget.spProWebUrl == '' && widget.spProLocalFile != null){
                  spFunLoadHtmlFromAssets();
                }
              },
              onPageStarted: (url){
                setState(() {spProIsHide=true;});

              },
              onPageFinished:(url){
                setState(() {spProIsHide=false;});
                if(SPClassApplicaion.spProJsMap!=null){
                  SPClassLogUtils.spFunPrintLog("onPageFinished:${widget.spProWebUrl} key:${SPClassApplicaion.spProJsMap}");
                  SPClassApplicaion.spProJsMap.forEach((key,value){
                    if(url.contains(key.replaceAll("m.", "")))
                    {
                      spProWebViewController.evaluateJavascript(value);
                    }
                  });
                }
                if(widget.spProWebTitle==null||widget.spProWebTitle.isEmpty)
                {
                  spProWebViewController.evaluateJavascript("document.title;").then((result){
                    if(result.toString().isNotEmpty){
                      setState(() {
                        widget.spProWebTitle=result.toString().replaceAll('"','');
                      });
                    }
                  });
                }
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
                          TextSpan(text: "${spProMoney.toString()}", style: TextStyle(fontSize: 16, color: Color(0xFFE3494B))),
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

  void spFunLoadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString(widget.spProLocalFile);
    spProWebViewController.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }

  void spFunDomainJs(String autoString) async{

    SPClassApiManager.spFunGetInstance().spFunDomainJs(spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
      SPClassApplicaion.spProJsMap=result.data;
    }));

  }
}


