import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/SPClassEncryptImage.dart';


class SPClassComplainPage extends StatefulWidget{
  String spProComplainType ;
  String spProComplainedId ;

  SPClassComplainPage({this.spProComplainType, this.spProComplainedId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassComplainPageState();
  }

}

class SPClassComplainPageState extends State<SPClassComplainPage>{
  var ComplainList= ["方案内容存在抄袭网络方案嫌疑","方案内容与推荐比赛不符","方案内容与推荐结果不符"];
   int SelectIndex=0;
  String Content='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.spProComplainType=="circle_info"){
      ComplainList=["色情/低俗","广告营销","谣言/与事实不符","内容无营养","疑似抄袭","其它问题"];
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title: "举报",
        actions: <Widget>[

          IconButton(
            padding: EdgeInsets.zero,
            icon: Container(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width(2)),
                  gradient: LinearGradient(
                      colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                  ),
                  boxShadow:null,
                ),
                width: width(58),
                height: width(27),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("提交",style: TextStyle(fontSize: sp(11),color: Colors.white),),

                  ],
                ),
              ),
            ),
            onPressed: (){

               SPClassApiManager.spFunGetInstance().spFunComplain(queryParameters:
                {
                  "complain_type":widget.spProComplainType,
                  "complained_id":widget.spProComplainedId,
                  "complain_reason":ComplainList[SelectIndex]+"--"+Content,
                }
                ,context: context,spProCallBack:SPClassHttpCallBack<SPClassBaseModelEntity>(
                  spProOnSuccess: (value){
                    SPClassApplicaion.spProEventBus.fire("delete:circle");
                    SPClassToastUtils.spFunShowToast(msg: "举报成功");
                    Navigator.of(context).pop();
                  }
                ));
            },
          ),
          SizedBox(width: width(15),),
        ],
      ),
      body: Container(
        color: Colors.white,

         child: SingleChildScrollView(
           child: Column(
             children: <Widget>[
               Container(
                 height: width(10),
                 decoration: BoxDecoration(
                     color: Color(0xFFF5F5F5),
                     border: Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
                 ),
               ),
               ListView.builder(
                   padding: EdgeInsets.zero,
                   shrinkWrap: true,
                   physics: NeverScrollableScrollPhysics(),
                   itemCount: ComplainList.length,
                   itemBuilder: (c,index)=>Container(
                     padding: EdgeInsets.symmetric(horizontal: width(22)),
                     height: width(47),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                     ),
                    child: GestureDetector(
                      child: Row(
                        children: <Widget>[
                          SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath(index==SelectIndex? "ic_select":"ic_seleect_un"), width: width(15)),
                          SizedBox(width: width(5),),
                          Text(ComplainList[index],style: TextStyle(fontSize: sp(15),color: Colors.black),)

                        ],
                      ),
                      onTap: (){
                        setState(() {
                          SelectIndex=index;
                        });
                      },
                    ),
               )),
               Container(
                 height: width(10),
                 decoration: BoxDecoration(
                     color: Color(0xFFF5F5F5),
                     border: Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
                 ),
               ),
               Container(
                 padding: EdgeInsets.only(left: width(10)),
                 height: width(141),
                 color: Colors.white,
                 child: TextField(
                   onChanged: (value){
                     Content=value;
                   },
                   style: TextStyle(fontSize: sp(15)),
                   decoration: InputDecoration(
                     border: InputBorder.none,
                     hintText: "详细举报原因（选填）"
                   ),
                 ),
               )
             ],
           ),
         ),
      ),
    );
  }

}