
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/model/SPClassPrizeDrawInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/user/SPClassContactPage.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sport/SPClassEncryptImage.dart';


class SPClassNewTurntableHistoryPage extends StatefulWidget{
  String spProJustWin="1";

  SPClassNewTurntableHistoryPage({this.spProJustWin});

  @override
    State<StatefulWidget> createState() {
        // TODO: implement createState
        return SPClassNewTurntableHistoryPageState();
    }

}

class SPClassNewTurntableHistoryPageState extends State<SPClassNewTurntableHistoryPage>{
  List<SPClassPrizeDrawInfo> spProUserProductList=[];
  EasyRefreshController spProEasyRefreshController;
  int page=1;
  @override
    void initState() {
        // TODO: implement initState
        super.initState();
        spProEasyRefreshController=EasyRefreshController();
    }
    @override
    Widget build(BuildContext context) {
        // TODO: implement build
        return Scaffold(
          backgroundColor: Color(0xFFF1F1F1),
          appBar: SPClassToolBar(
            context,title: "中奖记录",),
          body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.all(Radius.circular(width(5))),
                ),
                child: EasyRefresh.custom(
                    onRefresh: onRefresh,
                    controller: spProEasyRefreshController,
                    onLoad: onLoad,
                    firstRefresh: true,
                    emptyWidget:spProUserProductList.length ==0? SPClassNoDataView(height: width(200),):null,
                    header: SPClassBallHeader(
                        textColor: Color(0xFF666666)
                    ),
                    footer: SPClassBallFooter(
                        textColor: Color(0xFF666666)
                    ),
                    slivers: [

                     SliverList(
                     delegate: SliverChildBuilderDelegate(
                           (context, index) {
                           var item  =spProUserProductList[index];
                         return Visibility(
                           child: GestureDetector(
                             child:Container(
                               margin: EdgeInsets.only(left:width(13) ,right:width(13),top: width(13) ),
                               decoration: BoxDecoration(
                                 boxShadow:[BoxShadow(
                                   offset: Offset(0.1,0.5),
                                   color: Color(0x1a000000),
                                   blurRadius:width(6,),
                                 )],
                               ),
                               child: Stack(
                                 children: <Widget>[
                                   SPClassEncryptImage.asset(
                                     SPClassImageUtil.spFunGetImagePath("bg_my_prize"),
                                     fit: BoxFit.contain,
                                   ),
                                   Positioned(
                                     left: width(13),
                                     right: width(13),
                                     top: 0,
                                     bottom: 0,
                                     child: Container(
                                       alignment: Alignment.center,
                                       child: Row(
                                         children: <Widget>[
                                           SPClassImageUtil.spFunNetWordImage(
                                             url:item.spProIconUrl,
                                             fit: BoxFit.contain,
                                             width: width(30),
                                           ),
                                           SizedBox(width: 10,),
                                           Flexible(
                                             flex: 1,
                                             fit:FlexFit.tight ,
                                             child: Column(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: <Widget>[
                                                 Text(item.spProProductName,style: TextStyle(fontSize:sp(12),color: Color(0xFF333333),fontWeight: FontWeight.w500),),
                                                 Text(item.spProAddTime,style: TextStyle(fontSize:sp(9),color: Color(0xFF999999)),)

                                               ],
                                             ),
                                           ),
                                           Container(
                                             alignment: Alignment.center,
                                             width: width(55),
                                             height: height(25),
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(width(3)),
                                               gradient: LinearGradient(
                                                   colors:(item.status=="sent"||item.status=="received") ? [Colors.grey[300],Colors.grey[300]]:[Color(0xFFF2150C),Color(0xFFF24B0C)]
                                               ),
                                               boxShadow:(item.status=="sent"||item.status=="received") ?[]:[
                                                 BoxShadow(
                                                   offset: Offset(3,3),
                                                   color: Color(0x4DF23B0C),
                                                   blurRadius:width(5,),),
                                               ],
                                             ),
                                             child: Text((item.status=="sent"||item.status=="received") ?"已领取":"待放发",style: TextStyle(color: Colors.white,fontSize: sp(11),fontWeight: FontWeight.bold),),
                                           )


                                         ],
                                       ),

                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             onTap: (){
                               if((item.status!="sent"&&item.status!="received") ){
                                 SPClassNavigatorUtils.spFunPushRoute(context,  SPClassContactPage());

                               }
                             },
                           ),
                           visible: widget.spProJustWin=="1",
                           replacement: Container(
                             padding: EdgeInsets.only(left: width(15)),
                             alignment: Alignment.centerLeft,
                             height: width(31),
                             color: index%2==0? Colors.white:Color(0xFFF3F3F3),
                             child: Text(
                                 sprintf("%s参与抽奖次数-1",
                                 [SPClassDateUtils.spFunDateFormatByString(item.spProAddTime, "yyyy-MM-dd")]),
                                 style: TextStyle(fontSize: sp(12)),
                             ),
                           ) ,
                         );
                       },
                       childCount: spProUserProductList.length,
                     ),
                   ),

                ]),
      ),

    );
    }



  Future<void> onRefresh()  {
     page=1;
    return SPClassApiManager.spFunGetInstance().spFunProductListOfUser<SPClassPrizeDrawInfo>(queryParameters: {"just_win":widget.spProJustWin,"page":page.toString()},spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (value){
         setState(() {
            spProUserProductList=value.spProDataList;
         });
        }
    ));
  }


  Future<void> onLoad() {
    return SPClassApiManager.spFunGetInstance().spFunProductListOfUser<SPClassPrizeDrawInfo>(queryParameters: {"just_win":widget.spProJustWin,"page":(page+1).toString()},spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (list){
          if(list.spProDataList.length==0){
            spProEasyRefreshController.finishLoad(noMore: true);
          }else{
            page++;
          }
          setState(() {
            spProUserProductList.addAll(list.spProDataList);
          });
        },
        onError: (result){
        }
    ));
  }


}

