

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassCircleInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassToastUtils.dart';

import 'package:sport/widgets/SPClassToolBar.dart';

class SPClassNewConmmentPage extends StatefulWidget{
  SPClassCircleInfo info;
  String spProReplyCommentId="";
  String spProReplyName;

  SPClassNewConmmentPage(this.info,{this.spProReplyCommentId,this.spProReplyName});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassNewConmmentPageState();
  }

}

class SPClassNewConmmentPageState extends State<SPClassNewConmmentPage>{
  String spProContent="";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:SPClassToolBar(
        context,
        title: "评论",
        actions: <Widget>[
          FlatButton(
            child: Text("发布",
                style: TextStyle(
                    fontSize: sp(15), color: Colors.black)),
            onPressed: () {

              if(spProContent.length<=5){
                SPClassToastUtils.spFunShowToast(msg: "请发布六个字以上");
                return;
              }

             /* if(widget.spProReplyCommentId==null){
                AppApi.getInstance().addComment(context, true, {"target_id":widget.info.spProCircleInfoId,"target_type":"circle_info","content":spProContent}).then((result){
                  if(result.isSuccess()){
                    ToastUtils.showToast(msg: "评论成功");
                    Application.spProEventBus.fire("comment:info");
                    Navigator.of(context).pop();
                  }
                });
              }else{
                AppApi.getInstance().addComment(context, true, {"target_id":widget.info.spProCircleInfoId,"target_type":"circle_info","content":spProContent,"reply_comment_id":widget.spProReplyCommentId}).then((result){
                  if(result.isSuccess()){
                    ToastUtils.showToast(msg: "回复成功");
                    Application.spProEventBus.fire("comment:info");
                    Navigator.of(context).pop();
                  }
                });
              }*/
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10,left: 10),
              height: height(170),
              child: TextField(
                onChanged: (value){
                  spProContent=value;
                },
                maxLength: 100,
                maxLines: 15,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.spProReplyCommentId==null? "说点什么" :"回复"+
                        '${widget.spProReplyName}'+
                            ':'
                ),
              ),
            ),
          ],

        ),
      ),
    );
  }

}