import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassCoupon.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/user/SPClassRechargeDiamondPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassCouponList extends StatefulWidget{
  String status;


  SPClassCouponList({this.status});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassCouponListState();
  }

}

class  SPClassCouponListState extends State<SPClassCouponList>{
  var page=1;
  EasyRefreshController spProEasyRefreshController;

  List<SPClassCoupon> coupons=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProEasyRefreshController=EasyRefreshController();
    spFunOnRefresh();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: EasyRefresh.custom(
        onRefresh: spFunOnRefresh,
        onLoad: spFunOnMore,
        header: SPClassBallHeader(
              textColor: Color(0xFF666666)
          ),
        footer: SPClassBallFooter(
              textColor: Color(0xFF666666)
          ),
          controller: spProEasyRefreshController,
          slivers:
       [

         SliverToBoxAdapter(
           child: Container(

             child: ListView(
               shrinkWrap: true,
               padding: EdgeInsets.zero,
               physics: NeverScrollableScrollPhysics(),
               children: coupons.map((item) => Container(
                 height: width(63),
                 margin: EdgeInsets.only(right: width(12),left: width(12),top:height(12) ),
                 decoration: BoxDecoration(
                     boxShadow:[
                       BoxShadow(
                         offset: Offset(2,5),
                         color: Color(0x0D000000),
                         blurRadius:width(6,),),
                       BoxShadow(
                         offset: Offset(-5,1),
                         color: Color(0x0D000000),
                         blurRadius:width(6,),
                       )
                     ],
                     image: DecorationImage(
                         fit: BoxFit.fitWidth,
                         image: AssetImage(
                           SPClassImageUtil.spFunGetImagePath("bg_coupon_item"),
                         )
                     )
                 ),
                 child: Row(
                   children: <Widget>[
                     Container(
                       alignment: Alignment.center,
                       width: width(89),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                               RichText(
                                 text: TextSpan(
                                     text: "￥",
                                     style: TextStyle(color:Colors.white ,fontSize: sp(10),),
                                     children: <InlineSpan>[
                                       TextSpan(
                                           text:item.spPromoney,
                                           style: TextStyle(fontSize: sp(24))
                                       )
                                     ]
                                 ),
                               ),
                             ],
                           ),
                           Text(sprintf("满%s可用",[item.spProMinMoney],),style: TextStyle(color: Colors.white,fontSize: sp(9)),)
                         ],
                       ),
                     ),
                     Container(
                       alignment: Alignment.centerLeft,
                       width: width(125),
                       padding: EdgeInsets.only(left: width(12)),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Text(item.spProCouponName,style: TextStyle(fontSize: sp(15),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                           Text(sprintf("%s-%s",[
                             SPClassDateUtils.spFunDateFormatByString(item.spProAddTime, "yyyy-MM-dd"),
                             SPClassDateUtils.spFunDateFormatByString(item.spProExpireTime, "yyyy-MM-dd")
                           ]),style: TextStyle(fontSize: sp(9),color: Color(0xFFB3B3B3)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                         ],
                       ),
                     ),
                     SPClassEncryptImage.asset(
                       SPClassImageUtil.spFunGetImagePath("ic_soil_line",format: ".png"),
                       height: width(50),

                     ),

                     GestureDetector(
                         child:  Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(width(2)),
                             gradient: LinearGradient(
                                 colors:item.status=="unused"?
                                 [Color(0xFF5E83F1),Color(0xFF6DB9F5)]:
                                 [Colors.grey,Colors.grey]
                             ),
                             boxShadow:item.status=="unused"?[
                               BoxShadow(
                                 offset: Offset(3,3),
                                 color: Color(0xFF6DB9F5).withOpacity(0.3),
                                 blurRadius:width(5,),),
                               BoxShadow(
                                 offset: Offset(-2,1),
                                 color: Color(0xFF6DB9F5).withOpacity(0.3),
                                 blurRadius:width(5,),),
                             ]:[],
                           ),
                           width: width(76),
                           height: width(33),
                           margin: EdgeInsets.only(left: width(18)),
                           alignment: Alignment.center,
                           child: Text(spFunGetStatusText(item.status),style: TextStyle(fontSize: sp(10),color: Colors.white),),
                         ),
                         onTap: (){
                           if(item.status=="unused"){
                             SPClassNavigatorUtils.spFunPushRoute(context, SPClassRechargeDiamondPage());
                           }
                         }
                     ),

                   ],
                 ),
               )).toList(),
             ),
           ),
         ),

           coupons.length==0? SliverFillRemaining(
             child: SPClassNoDataView(),
           ):SliverToBoxAdapter(),
      ]),
    );
  }


  Future<void>  spFunOnRefresh() async {
    page=1;

    return  SPClassApiManager.spFunGetInstance().spFunCouponMyList<SPClassCoupon>(queryParameters: {"page":page.toString(),"status":widget.status},spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (list){
          list.spProDataList.forEach((item) {
            item.status=widget.status;
          });
          setState(() {
            coupons=list.spProDataList;
          });
        },
        onError: (value){
          spProEasyRefreshController.finishRefresh(success: false);
        }
    ));
  }

  Future<void>  spFunOnMore() async {

    return  SPClassApiManager.spFunGetInstance().spFunCouponMyList<SPClassCoupon>(queryParameters: {"page":(page+1).toString(),"status":widget.status},spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (list){
          list.spProDataList.forEach((item) {
            item.status=widget.status;
          });
          if(list.spProDataList.length==0){
            spProEasyRefreshController.finishLoad(noMore: true);
          }else{
            page++;
            spProEasyRefreshController.finishLoad(noMore: false);

          }

            setState(() {
              coupons.addAll(list.spProDataList);
            });

        },
        onError: (value){
          spProEasyRefreshController.finishLoad(success: false);

        }
    ));

  }

  String spFunGetStatusText(String status) {
     if(status=="used"){
       return "已使用";
     }
     if(status=="expired"){
       return "已过期";
     }
    return "立即使用";
  }
}
