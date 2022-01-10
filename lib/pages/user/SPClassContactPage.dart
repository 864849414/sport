
import "dart:typed_data";
import "package:dio/dio.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:fluwx/fluwx.dart" as fluwx;
import "package:image_gallery_saver/image_gallery_saver.dart";
import "package:sport/SPClassEncryptImage.dart";
import "package:sport/app/SPClassApplicaion.dart";
import "package:sport/utils/SPClassImageUtil.dart";
import "package:sport/utils/api/SPClassApiManager.dart";
import "package:sport/utils/api/SPClassHttpCallBack.dart";
import "package:sport/utils/SPClassToastUtils.dart";
import "package:sport/utils/SPClassLogUtils.dart";
import "package:sport/utils/SPClassCommonMethods.dart";

import "package:sport/pages/common/SPClassDialogUtils.dart";
import "package:sport/widgets/SPClassToolBar.dart";

class SPClassContactPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassContactPageState();
  }

}

class  SPClassContactPageState extends State<SPClassContactPage>
{

  String  spProWxId="";
  String  spProWxQrcode="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunGetConfCs();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,title: "联系客服",),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        color: Color(0xFFF1F1F1),
        child:spProWxQrcode.isEmpty? Container(): Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${SPClassApplicaion.spProAppName}:$spProWxId",style: TextStyle(fontSize: 20,color: Colors.black),),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child:  Image.network(spProWxQrcode,
                width: MediaQuery.of(context).size.width/2,
              ),
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child:Text("复制微信号",style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor),),
                  onTap: (){
                    try{
                      ClipboardData data = new ClipboardData(text:spProWxId);
                      Clipboard.setData(data);
                      SPClassToastUtils.spFunShowToast(msg: "复制成功");
                    }on PlatformException{
                      SPClassToastUtils.spFunShowToast(msg: "复制失败");
                    }
                  },
                ),
                Container(width: 0.4,height: 15,color: Colors.grey,margin: EdgeInsets.only(left: 15,right: 15),),
                GestureDetector(
                  child:Text("保存二维码",style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor),),
                  onTap: () async {
                    try {
                      SPClassDialogUtils.spFunShowLoadingDialog(context,barrierDismissible: false,content:"保存中");
                      var response = await Dio().get(spProWxQrcode, options: Options(responseType: ResponseType.bytes));
                          ImageGallerySaver.saveImage(Uint8List.fromList(response.data)).then((result){
                            SPClassLogUtils.spFunPrintLog(result.toString());
                           Navigator.of(context).pop();
                           if(result.toString().isNotEmpty){
                             SPClassToastUtils.spFunShowToast(msg: "保存成功");
                           }else{
                             SPClassToastUtils.spFunShowToast(msg: "保存失败");
                           }
                         });
                    } on PlatformException {
                      Navigator.of(context).pop();
                      SPClassToastUtils.spFunShowToast(msg: "保存失败");
                    }
                  },
                )

              ],
            )

          ],
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
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SPClassEncryptImage.asset(
                    SPClassImageUtil.spFunGetImagePath("ic_wx_login"),
                    fit: BoxFit.contain,
                    color: Colors.white,
                    width: height(22),
                  ),
                  SizedBox(width: 10,),
                  Text("去微信添加",style: TextStyle(fontSize: sp(15),color: Colors.white),)
                ],
              ),
            ) ,
          ),
          onTap: () async {
            fluwx.openWeChatApp().then((value){
              SPClassLogUtils.spFunPrintLog(value.toString());
            });
          },
        ),
      ),
    );
  }

  void spFunGetConfCs() {

     SPClassApiManager.spFunGetInstance().spFunGetConfCs(context:context,spProCallBack: SPClassHttpCallBack(
       spProOnSuccess: (result){
         spProWxId=result.data["wx_id"];
         spProWxQrcode=result.data["wx_qrcode"];
         setState(() {});
       }
     ));
  }

}