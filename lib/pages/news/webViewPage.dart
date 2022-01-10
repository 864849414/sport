import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/pages/common/SPClassDialogUtils.dart';
import 'package:sport/pages/common/SPClassLoadingPage.dart';
import 'package:sport/pages/user/SPClassUnionPlatDetailPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  String spProWebUrl;
  String spProWebTitle;
  String spProLocalFile;

  WebViewPage(this.spProWebUrl, this.spProWebTitle,{this.spProLocalFile});

  WebViewPageState createState()=>WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  bool spProIsHide=true;
//  WebViewController spProWebViewController;
  InAppWebViewController _controller;
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
          onPressed: (){_controller.goBack();},),
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
            InAppWebView(
              initialUrl: 'https://www.88lot.com/sports_web_h5/lianyun/allPrediction.html?token=2112271100187724957&secret=VvSowHZV&userId=2112271100187604956&channelId=2003121649526059007&pageType=4&bcw=7349',
              onLoadStart: (controller,url){
                setState(() {spProIsHide=true;});
                if (url.contains("union_pay_callback")) {
                  _controller.goBack();
                  var res =Uri.parse(url);
                  var spProDiamond=double.tryParse(res.queryParameters["diamond"]);
                  var spProMoney=double.tryParse(res.queryParameters["money"]);
                  var unionOrderNum=res.queryParameters["union_order_num"].toString();
                  var unionPlat=res.queryParameters["union_plat"].toString();
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
                            _controller.reload();
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
                            _controller.reload();
                          }, onError: (value){}
                      ));
                    },spProDiamond: 0,spProOrderMoney: spProMoney,));
                  }
                }
                if(url.contains(".apk")){
                  _controller.goBack();
                  launch(url);
                }
              },
              onLoadStop: (controller,url){
                setState(() {spProIsHide=false;});
                return;
              },
              onWebViewCreated: (controller){
                _controller=controller;
                if(widget.spProWebUrl == '' && widget.spProLocalFile != null){
                  spFunLoadHtmlFromAssets();
                }
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
    _controller.loadUrl(url: Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
//    _controller.loadUrl( Uri.dataFromString(
//        fileText,
//        mimeType: 'text/html',
//        encoding: Encoding.getByName('utf-8')
//    ).toString());
  }

  void spFunDomainJs(String autoString) async{

    SPClassApiManager.spFunGetInstance().spFunDomainJs(spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
      SPClassApplicaion.spProJsMap=result.data;
    }));

  }
}
