import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassExpertListEntity.dart';
import 'package:sport/model/SPClassExpertInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'dart:math' as math;
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/utils/colors.dart';


class SPClassHomeRangkingList extends StatefulWidget{
  String order_key;
  String spProMatchType ;
  SPClassHomeRangkingListState spProState;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState=SPClassHomeRangkingListState();
  }

  SPClassHomeRangkingList(this.order_key,this.spProMatchType);

}


class SPClassHomeRangkingListState extends State<SPClassHomeRangkingList> with AutomaticKeepAliveClientMixin<SPClassHomeRangkingList>,TickerProviderStateMixin<SPClassHomeRangkingList>{
  List<SPClassExpertListExpertList> spProExpertList=List();
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();

   onFunOnRefresh();
 }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);

    return Container(

      alignment: Alignment.center,
      height: height(100),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        //水平子Widget之间间距
        crossAxisSpacing:width(5),
        //垂直子Widget之间间距
        mainAxisSpacing:0,
        //GridView内边距
        padding: EdgeInsets.only(left: width(13),right: width(10)),
        //一行的Widget数量
        crossAxisCount: 5,
        //子Widget宽高比例
        childAspectRatio: (width(340)/5)/width(100),
        children:buildViews() ,
      ),
    );
  }

  buildViews() {
    List<Widget> views=List();
    views.addAll(spProExpertList.map((expertItem){
      return Container(
        decoration: BoxDecoration(
           color: Color(0xFFF7F7F7),
           borderRadius: BorderRadius.circular(4)
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Stack(
              //   alignment: Alignment.center,
              //   children: <Widget>[
              //     SizedBox(
              //       width: width(100),
              //       height: width(17),
              //     ),
              //     Positioned(
              //       bottom: 0,
              //       child: Transform(
              //         alignment: Alignment.center,
              //         transform: Matrix4.rotationZ((math.pi)/4),
              //         child: Container(
              //           height: width(4),
              //           width: width(4),
              //           color: const Color(0xFFF24B0C),
              //         ),
              //       ),
              //     ),
              //     Positioned(
              //       top: 0,
              //       child: Container(
              //         alignment: Alignment.center,
              //         width: width(45),
              //         height: width(15),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(300),
              //           gradient: LinearGradient(
              //             begin: Alignment.topCenter,
              //             end: Alignment.bottomCenter,
              //             colors: [Color(0xFFF2150C),Color(0xFFF24B0C)]
              //           ),
              //           boxShadow:[
              //             BoxShadow(
              //               offset: Offset(2,5),
              //               color: Color(0xFFF24B0C).withOpacity(0.2),
              //               blurRadius:width(5,),),
              //             BoxShadow(
              //               offset: Offset(0,1),
              //               color: Color(0xFFF24B0C).withOpacity(0.2),
              //               blurRadius:width(6,),
              //             )
              //           ],
              //         ),
              //         child: Text((widget.order_key=="hot" )?
              //         "近"+
              //          "${expertItem.spProLast10Result.length.toString()}"+
              //          "中"+
              //           "${expertItem.spProLast10CorrectNum}":
              //         (widget.order_key=="max_red_num" )?
              //         "${expertItem.spProMaxRedNum}"+
              //             "连红":
              //         "${expertItem.popularity}"+
              //             "人气"
              //           ,style: GoogleFonts.notoSansSC(textStyle: TextStyle(fontSize: sp(9),color: Colors.white),fontWeight: FontWeight.w500),maxLines: 1,),
              //       ) ,
              //     )
              //   ],
              // ),
              // SizedBox(height:height(2),),
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.4,color: Colors.grey[300]),
                        borderRadius: BorderRadius.circular(200)),
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child:( expertItem?.spProAvatarUrl==null||expertItem.spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                        SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                        width: width(40),
                        height: width(40),
                      ):Image.network(
                        expertItem.spProAvatarUrl,
                        width: width(40),
                        height: width(40),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -10,
                    child: Container(
                      alignment: Alignment.center,
                      width: width(45),
                      height: width(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFFF7F66),Color(0xFFFF4A26)]
                        ),
                      ),
                      child: Text((widget.order_key=="hot" )?
                      "近"+
                          "${expertItem.spProLast10Result.length.toString()}"+
                          "中"+
                          "${expertItem.spProLast10CorrectNum}":
                      (widget.order_key=="max_red_num" )?
                      "${expertItem.spProMaxRedNum}"+
                          "连红":
                      "${expertItem.popularity}"+
                          "人气"
                        ,style: GoogleFonts.notoSansSC(textStyle: TextStyle(fontSize: sp(9),color: Colors.white),fontWeight: FontWeight.w500),maxLines: 1,),
                    ),
                  )
                ],
              ),
              SizedBox(height:height(8),),
              Text("${expertItem.spProNickName}",style: TextStyle(fontSize: sp(11),color: MyColors.grey_99),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,)
            ],
          ),
          onTap: (){

            SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "view_hot_expert",targetId:expertItem.spProUserId);

            SPClassApiManager.spFunGetInstance().spFunExpertInfo(queryParameters: {"expert_uid":expertItem.spProUserId},
                context:context,spProCallBack: SPClassHttpCallBack(
                    spProOnSuccess: (info){
                      SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertDetailPage(info,spProIsStatics: false,));
                    }
                ));
          },
        ),
      );
    }).toList())  ;

    return views;
  }

  void onFunOnRefresh() {
    Map<String,dynamic> params;
   if(widget.order_key=="hot"){
     params= {"fetch_type":widget.order_key,"${widget.spProMatchType}":"1"};

   }else{
     params= {"order_key":widget.order_key,"ranking_type":"近7天","${widget.spProMatchType}":"1"};
   }
    SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters:params,spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
        spProOnSuccess: (list){
          if(list?.spProExpertList!=null&&list.spProExpertList.length>0){
            if(mounted){
              setState(() {
                spProExpertList=list.spProExpertList.take(5).toList();
              });
            }
          }
        }
    ));

  }





}