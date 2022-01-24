
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/utils/colors.dart';

class SPClassBottomPickAndSearchList extends StatefulWidget{
  List<String> list;
  ValueChanged<int> changed;
  String spProDialogTitle;
  SPClassBottomPickAndSearchList({this.list,this.changed,this.spProDialogTitle});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassBottomPickAndSearchListState();
  }

}

class SPClassBottomPickAndSearchListState extends State<SPClassBottomPickAndSearchList>{
  List<String> spProShowList=[];
  var spProSelectIndex=-1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProShowList=widget.list.map((e) => e.trim()).toList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Container(
         width: ScreenUtil.screenWidth,
         height: ScreenUtil.screenHeight,
         alignment: Alignment.bottomCenter,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.end,
           children: <Widget>[
              Expanded(
                child:  GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(),
                  onTap: ()=>Navigator.of(context).pop(),
                ),
              ),
             Container(
               width: ScreenUtil.screenWidth,
               decoration: BoxDecoration(
                 color: Color(0xFFF7F7F7),
               ),
               child: Row(
                 children: <Widget>[
                   GestureDetector(
                     behavior: HitTestBehavior.opaque,
                     child: Container(
                       width: width(50),
                       height: width(40),
                       alignment: Alignment.center,
                       child: Text("取消",style: TextStyle(color: Color(0xFF666666),fontSize: sp(15)),),
                     ),
                     onTap: ()=>Navigator.of(context).pop(),
                   ),
                   Expanded(
                     child: Center(
                       child: Text("请选择"+widget.spProDialogTitle,style: TextStyle(color: Color(0xFF666666),fontSize: sp(15)),),

                     ),
                   ),
                   GestureDetector(
                     behavior: HitTestBehavior.opaque,
                     child: Container(
                       width: width(50),
                       height: width(40),
                       alignment: Alignment.center,
                       child: Text("确定",style: TextStyle(color: Color(0xFF666666),fontSize: sp(15)),),
                     ),
                     onTap:() {
                       if(spProSelectIndex==-1){
                         SPClassToastUtils.spFunShowToast(msg: "请选择");
                         return;
                       }

                       if(widget.changed!=null){
                         widget.changed(widget.list.indexOf(spProShowList[spProSelectIndex]));
                       }
                       Navigator.of(context).pop();

                     },
                   ),
                 ],
               ),
             ),
             Container(
               width: ScreenUtil.screenWidth,
               color: Colors.white,
               child: Container(
                 margin: EdgeInsets.all( width(13)),
                 padding: EdgeInsets.only( left: width(10)),
                 decoration: BoxDecoration(
                   color: Color(0xFFEBEBEB),
                   borderRadius: BorderRadius.circular(width(7))
                 ),
                 child: Row(
                   children: <Widget>[
                     SPClassEncryptImage.asset(
                       SPClassImageUtil.spFunGetImagePath("ic_search"),
                       width: width(16),
                       color: Color(0xFFDDDDDD),
                     ),
                     SizedBox(width: width(5),),
                     Expanded(
                       child: TextField(
                         textInputAction: TextInputAction.search,//设置跳到下一个选项
                         onSubmitted: (value){
                           spProSelectIndex=-1;
                           spProShowList.clear();
                           if(value.isEmpty){
                             spProShowList=widget.list.map((e) => e.trim()).toList();
                           }else{
                             widget.list.forEach((element) {
                               if(element.contains(value)){
                                 spProShowList.add(element);
                               }
                             });

                           }

                           setState(() {
                           });
                         },
                         style: TextStyle(fontSize: sp(13)),
                         decoration: InputDecoration(
                             border: InputBorder.none,
                             hintText: "请输入"+widget.spProDialogTitle+"名"
                         ),
                       ),
                     )
                   ],
                 ),
               ),
             ),
             Container(
               width: ScreenUtil.screenWidth,
               height: width(220),
                 color: Colors.white,
                 child:spProShowList.length==0? SPClassNoDataView(
                   height:  width(220),iconSize:Size(width(100),width(60)) ,)
                     : ListView.builder(
                   padding: EdgeInsets.zero,
                   itemCount: spProShowList.length,
                   itemBuilder: (c,index){
                   return GestureDetector(
                     behavior: HitTestBehavior.opaque,
                     child:  Container(
                       decoration: BoxDecoration(
                           color:spProSelectIndex==index? MyColors.main1:Colors.white,
                           border: Border(bottom: BorderSide(width: 0.5,color: Colors.grey[300]))
                       ),
                       width: ScreenUtil.screenWidth,
                       height: width(44),
                       alignment: Alignment.centerLeft,
                       padding: EdgeInsets.only(left: width(15)),
                       child: Text(spProShowList[index],style: TextStyle(
                           color:spProSelectIndex==index? Colors.white:Colors.black,
                           fontSize: sp(14)),),
                     ),
                     onTap: (){
                       setState(() {
                         spProSelectIndex=index;
                       });
                     },

                   );
               }),

             ),

             Container(
               width: ScreenUtil.screenWidth,
               height: ScreenUtil.bottomBarHeight,
               color: Colors.white,
             ),
           ],
         ),
      ),
    );
  }
  
}