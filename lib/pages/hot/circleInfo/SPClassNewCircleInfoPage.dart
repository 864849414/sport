

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';

import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';

import 'package:sport/widgets/SPClassToolBar.dart';

class SPClassNewCircleInfoPage extends StatefulWidget{
 String spProTopicTitle;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassNewCircleInfoPageState();
  }

 SPClassNewCircleInfoPage(this.spProTopicTitle,);


}

class SPClassNewCircleInfoPageState extends State<SPClassNewCircleInfoPage>{
  String spProContent="";
  String spProTitle="";
  @override
  List<File> spProPics=List();
  List<String> spProPicPaths=List();
  int spProWinOrLose=-1;
  int spProBigOrSmall=-1;
  TextEditingController controller;
  String spProTitleText;

  @override
  void initState() {
    super.initState();
    controller=TextEditingController();

  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SPClassToolBar(
        context,
        title: "发布",
        actions: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child:Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: width(20),left: width(20)),
              child:  Text("提交",style: TextStyle(color: Color(0xFF333333)),),
            ),
            onTap: (){
              spFunCommit();
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0xFFF1F1F1),
          border: Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: width(10)),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.4,color: Colors.grey[300])
              ),
              child: TextField(
                 style: TextStyle(fontSize: sp(13)),
                 onChanged: (value){
                   spProTitle=value;
                 },
                 decoration: InputDecoration(
                   hintText: "请输入标题",
                   border: InputBorder.none
                 ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: width(10),right: width(10)),
              color: Colors.white,
              alignment: Alignment.topLeft,
              child: TextField(
                controller: controller,
                onChanged: (value){
                  spProContent=value;
                },
                maxLength: 500,
                maxLines: 6,
                style: TextStyle(fontSize: sp(13)),
                decoration: InputDecoration(
                    border:InputBorder.none ,
                    hintText: "说点什么"
                ),
              ),
            ),
            Container(
              height: 0.4,
              color: Colors.grey[200],
            ),
            Container(
              padding: EdgeInsets.only(left:width(16),right: width(16)),
              alignment: Alignment.center,
              height:spProPics.length>5 ? height(105): height(60),
              color: Colors.white,
              child: GridView.count(
                crossAxisCount: 6,
                scrollDirection: Axis.vertical,
                childAspectRatio: 1,
                mainAxisSpacing:  width(4),
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: width(9),
                padding:  EdgeInsets.only(top: width(14),bottom: width(14)),
                children: spFunBuildPics()
              ),
            ),


          ],

        ),
      ),
    );
  }

  List<Widget> spFunBuildPics() {
    List<Widget> views=List();
    views.add(GestureDetector(
      child:Container(
        alignment: Alignment.center,
        child: SPClassEncryptImage.asset(
          SPClassImageUtil.spFunGetImagePath("ic_add_pic"),
          fit: BoxFit.fill,
          width:width(45),
          height:width(45),
        ),
      ),
      onTap: () async {

        if(spProPics.length>=9){
          SPClassToastUtils.spFunShowToast(msg: "最多选择九张图片");
          return;
        }
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        if(image==null||image.absolute.path.isEmpty){return;}
        setState(() {spProPics.add(image);});
      },
    ) ) ;

    views.addAll( spProPics.map((pic){
      return Stack(
        children: <Widget>[
          Container(
            width:width(55),
            height:width(55),
          ),
          Positioned(
              left: 0,
              right: 3,
              top: 3,
            child:
            Image.file(
              pic,
              fit: BoxFit.cover,
              width:width(50),
              height:width(50),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              child:Container(
                width: width(16),
                height: width(16),
                decoration: BoxDecoration(
                  color: Color(0xFF555555),
                  borderRadius:BorderRadius.circular(8)
                ),
                child: Icon(Icons.close,color: Colors.white,size: 12,),
              ),
              onTap: (){
              setState(() {
                spProPics.remove(pic);
              });
              },
            ),
          )
        ],
      );
    }).toList());

     return views;
  }

  spFunCommit(){
    if(spProTitle.isEmpty){
      SPClassToastUtils.spFunShowToast(msg: "标题不能为空");
      return;
    }
    if(spProContent.isEmpty){
      SPClassToastUtils.spFunShowToast(msg: "提交内容不能为空");
      return;
    }
     if(spProPics.length>4){
       SPClassToastUtils.spFunShowToast(msg: "至多只能添加四张图片");
       return;
     }
    if(spProPics.length>0){
      SPClassApiManager.spFunGetInstance().spFunUploadFiles(context: context,files: spProPics,params:{"is_multi":"1"},
          spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
              spProOnSuccess: (result){
                var images=List<String>();
                result.data.forEach((pic){
                  images.add(pic);
                });

                spProPicPaths.clear();
                images.forEach((pic){
                  spProPicPaths.add(pic);
                });

                String img_urls="";
                spProPicPaths.forEach((path){
                  if(img_urls.isEmpty){
                    img_urls=path;
                  }else{
                    img_urls=img_urls+";${path.toString()}";
                  }
                });

                SPClassApiManager.spFunGetInstance().spFunAddCircleInfo(context: context,queryParameters:{"title":spProTitle,"content":spProContent,"img_urls":img_urls,"topic_title":widget.spProTopicTitle},
                  spProCallBack: SPClassHttpCallBack(
                    spProOnSuccess: (result){
                      SPClassToastUtils.spFunShowToast(msg: "发布成功");
                      SPClassApplicaion.spProEventBus.fire("circle:refresh");
                      Navigator.of(context).pop();
                    }
                  )
                );


              }
          )
      );
    }else{
      SPClassApiManager.spFunGetInstance().spFunAddCircleInfo(context: context,queryParameters:{"title":spProTitle,"content":spProContent,"img_urls":"","topic_title":widget.spProTopicTitle},
          spProCallBack: SPClassHttpCallBack(
              spProOnSuccess: (result){
                SPClassToastUtils.spFunShowToast(msg: "发布成功");
                SPClassApplicaion.spProEventBus.fire("circle:refresh");
                Navigator.of(context).pop();
              }
          )
      );
    }
  }



}