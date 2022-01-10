

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/SPClassLogUtils.dart';

import 'package:sport/widgets/SPClassToolBar.dart';

class SPClassFeedbackPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StateFeedback();
  }

}

class StateFeedback extends State<SPClassFeedbackPage>{
  String spProContent="";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding:false,
      appBar: SPClassToolBar(
        context,title: "意见反馈",),
      body: Container(
        color: Color(0xFFF1F1F1),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(height: 0.4,color: Colors.grey[300],),
            Container(
              height: height(200),
              padding: EdgeInsets.only(right: width(10),left: width(24),bottom: height(10)),
              color: Colors.white,
                child: TextField(
                  style: TextStyle(fontSize: width(14),textBaseline:TextBaseline.alphabetic ),
                  onChanged: (value){
                    if(mounted){
                      setState(() {
                          spProContent=value;
                      });
                    }
                  },
                  maxLength: 500,
                  maxLines: 15,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "简要描述你要反馈的问题和意见",
                      hintStyle: TextStyle(fontSize: width(14),textBaseline:TextBaseline.alphabetic,color: Color(0xFF999999) )
                  ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
            SizedBox(height: 10,),
            GestureDetector(
              child:  Container(
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
                  child:Text("提交",style: TextStyle(fontSize: sp(15),color: Colors.white),),
                ) ,
              ),
              onTap: () async {
                if(spProContent.isEmpty){
                  SPClassToastUtils.spFunShowToast(msg: "提交内容不能为空");
                }else{
                  SPClassApiManager.spFunGetInstance().spFunGiveFeedback(context:context,queryParameters: {"content":spProContent,},spProCallBack: SPClassHttpCallBack(
                    spProOnSuccess: (result){
                      SPClassToastUtils.spFunShowToast(msg: "提交成功");
                      Navigator.of(context).pop();
                    }
                  ));
                }
              },
            ),
          ],

        ),
      ),
    );
  }

}