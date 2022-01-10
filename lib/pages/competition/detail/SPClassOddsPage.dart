
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassListEntity.dart';
import 'package:sport/model/SPClassSchemePlayWay.dart';
import 'package:sport/model/SPClassSsOddsList.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';

import 'SPClassOddsHistoryDetail.dart';

class SPClassOddsPage extends StatefulWidget{
  Map<String,dynamic> params;
  String spProGuessId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassOddsPageState();
  }

  SPClassOddsPage(this.params,this.spProGuessId);

}

class SPClassOddsPageState extends State<SPClassOddsPage> with AutomaticKeepAliveClientMixin{
  SPClassSsOddsList spProOddsList;
  var spProIndex=0;
  var spProOddTypes=["欧赔","亚盘","大小"];

  List<SPClassSchemePlayWay> spProJcList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SPClassApiManager().spFunMatchOddsList(queryParameters:widget.params,spProCallBack: SPClassHttpCallBack<SPClassSsOddsList> (
      spProOnSuccess: (list){
          if(mounted){
            setState(() {
              spProOddsList=list;
            });
          }

      },onError: (result){
    }
    ));
   spFunGetPlayList();
  }

  void spFunGetPlayList() {

    SPClassApiManager.spFunGetInstance().spFunPlayingWayOdds<SPClassBaseModelEntity>(queryParameters: {"guess_match_id":widget.spProGuessId},
        spProCallBack: SPClassHttpCallBack(
            spProOnSuccess: (value){
              var spProOddsList=new SPClassListEntity<SPClassSchemePlayWay>(key: "playing_way_list",object: new SPClassSchemePlayWay());
              spProOddsList.fromJson(value.data);
              spProOddsList.spProDataList.forEach((item) {
                    if(item.spProGuessType=="竞彩"){
                      spProJcList.add(item);
                    }
                    setState(() {
                    });
                 });
            }
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return Container(
      color: Color(0xFFF1F1F1),
      width: ScreenUtil.screenWidth,
      child: Column(
       children: <Widget>[
         Container(
           margin: EdgeInsets.only(top: height(7),bottom: height(7)),
           width: width(320),
           height: width(33),
           child: Row(
             children: <Widget>[
               Expanded(
                 child: FlatButton(
                   padding: EdgeInsets.zero,
                   child: Container(
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(bottomLeft:Radius.circular(width(5)),topLeft: Radius.circular(width(5))),
                         border: Border.all(color: Color(0xFFDE3C31),width: 0.4),
                         color: spProIndex==0? Color(0xFFDE3C31):Colors.white
                     ),
                     alignment: Alignment.center,
                     child: Text("欧指",style: TextStyle(fontSize: sp(14),color: spProIndex==0? Colors.white :Color(0xFFDE3C31)),),
                   ),
                   onPressed: (){
                     setState(() {
                       spProIndex=0;
                     });
                   },
                 ),
               ),
               Expanded(
                 child: FlatButton(
                   padding: EdgeInsets.zero,
                   child: Container(
                     decoration: BoxDecoration(
                         border: Border(top: BorderSide(color: Color(0xFFDE3C31),width: 0.4),bottom: BorderSide(color: Color(0xFFDE3C31),width: 0.4)),
                         color: spProIndex==1? Color(0xFFDE3C31):Colors.white
                     ),
                     alignment: Alignment.center,
                     child: Text("亚指",style: TextStyle(fontSize: sp(14),color: spProIndex==1? Colors.white :Color(0xFFDE3C31)),),
                   ),
                   onPressed: (){
                     setState(() {
                       spProIndex=1;
                     });

                   },
                 ),
               ),
               Expanded(
                 child: FlatButton(
                   padding: EdgeInsets.zero,
                   child: Container(
                     decoration:spProJcList.length>0?BoxDecoration(
                         border: Border(
                             top: BorderSide(color: Color(0xFFDE3C31),width: 0.4),
                             left: BorderSide(color: Color(0xFFDE3C31),width: 0.4),
                             bottom: BorderSide(color: Color(0xFFDE3C31),width: 0.4)),
                         color: spProIndex==2? Color(0xFFDE3C31):Colors.white
                     ):BoxDecoration(
                         borderRadius: BorderRadius.only(bottomRight:Radius.circular(width(5)),topRight: Radius.circular(width(5))),
                         border: Border.all(color: Color(0xFFDE3C31),width: 0.4),
                         color: spProIndex==2? Color(0xFFDE3C31):Colors.white
                     ),
                     alignment: Alignment.center,
                     child: Text("大小",style: TextStyle(fontSize: sp(14),color: spProIndex==2? Colors.white :Color(0xFFDE3C31)),),
                   ),
                   onPressed: (){
                     setState(() {
                       spProIndex=2;
                     });

                   },
                 ),
               ),

               spProJcList.length>0?  Expanded(
                 child: FlatButton(
                   padding: EdgeInsets.zero,
                   child: Container(
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(bottomRight:Radius.circular(width(5)),topRight: Radius.circular(width(5))),
                         border: Border.all(color: Color(0xFFDE3C31),width: 0.4),
                         color: spProIndex==3? Color(0xFFDE3C31):Colors.white
                     ),
                     alignment: Alignment.center,
                     child: Text("竞彩",style: TextStyle(fontSize: sp(14),color: spProIndex==3? Colors.white :Color(0xFFDE3C31)),),
                   ),
                   onPressed: (){
                     setState(() {
                       spProIndex=3;
                     });

                   },
                 ),
               ):SizedBox(),
             ],
           ),
         ),
         spProOddsList!=null? Flexible(
           fit: FlexFit.tight,
           flex: 1,
           child: SingleChildScrollView(
             child:spProIndex==3?
             Container(
               margin: EdgeInsets.only(left: width(13),right: width(13),bottom: width(7)),
               decoration: BoxDecoration(
                   color: Colors.white,
                   border: Border.all(width: 0.4,color: Colors.grey[300]),
                   borderRadius: BorderRadius.all(Radius.circular(width(8)))
               ),
               child:Column(
                 children: <Widget>[
                   Container(
                     decoration: BoxDecoration(
                         color: Color(0xFFF7F7F7),
                         border: Border(bottom:BorderSide(color: Color(0xFFDDDDDD),width: 0.4))
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Expanded(
                           child: Container(
                             alignment: Alignment.center,
                             height: width(40),
                             child: Text("玩法",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                           ),
                         ) ,





                         Expanded(
                           child: Container(
                             alignment: Alignment.center,
                             height: width(40),
                             child: Text("主胜",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                           ),
                         ) ,


                         Expanded(
                           child: Container(
                             alignment: Alignment.center,
                             width: width(40),
                             child: Text("平",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                           ),
                         ) ,

                         Expanded(
                           child: Container(
                             alignment: Alignment.center,
                             width: width(40),
                             child: Text("客胜",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                           ),
                         ) ,


                       ],
                     ),
                   ),
                   Container(
                     child: Column(
                       children: spProJcList.map((item){
                         return Container(
                           decoration: BoxDecoration(
                               color: Colors.white,
                               border: Border(bottom:BorderSide(color: Color(0xFFDDDDDD),width: 0.4))
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Expanded(
                                 child: Container(
                                   alignment: Alignment.center,
                                   height: width(40),
                                   child: Text("让球"+SPClassStringUtils.spFunSqlitZero(item.spProAddScore),style: TextStyle(fontSize: sp(11)),),
                                 ),
                               ) ,




                               Expanded(
                                 child: Container(
                                   alignment: Alignment.center,
                                   height: width(40),
                                   child: Text(item.spProWinOddsOne,style: TextStyle(fontSize: sp(11)),),
                                 ),
                               ) ,

                               Expanded(
                                 child: Container(
                                   alignment: Alignment.center,
                                   height: width(40),
                                   child: Text(item.spProDrawOdds,style: TextStyle(fontSize: sp(11)),),
                                 ),
                               ) ,


                               Expanded(
                                 child: Container(
                                   alignment: Alignment.center,
                                   width: width(40),
                                   child: Text(item.spProWinOddsTwo,style: TextStyle(fontSize: sp(11)),),
                                 ),
                               ) ,


                             ],
                           ),
                         );
                       }).toList(),
                     ),
                   )
                 ],
               ),
             ):
             Column(
               children: spProOddsList.getListItem(spProIndex).map((item){
                 return GestureDetector(
                   child: Container(
                     margin: EdgeInsets.only(left: width(13),right: width(13),bottom: width(7)),
                     height: height(65),
                     decoration: BoxDecoration(
                         color: Colors.white,
                         border: Border.all(width: 0.4,color: Colors.grey[300]),
                         borderRadius: BorderRadius.all(Radius.circular(width(8)))
                     ),
                     child: Row(
                       children: <Widget>[
                         Container(
                           alignment: Alignment.centerLeft,
                           padding: EdgeInsets.only(left: width(13)),
                           width: width(93),
                           child: Text(item.company,style: TextStyle(fontSize: sp(12),color: Color(0xFF333333),),maxLines: 2,overflow: TextOverflow.ellipsis,),
                         ),
                         Flexible(
                           flex: 1,
                           fit: FlexFit.tight,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Row(
                                 children: <Widget>[
                                   Flexible(
                                     flex: 1,
                                     fit: FlexFit.tight,
                                     child: Container(
                                       child: Text("即指",style: TextStyle(fontSize: sp(12),color: Color(0xFF999999),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                     ),
                                   ),
                                   Flexible(
                                     flex: 1,
                                     fit: FlexFit.tight,
                                     child: Container(
                                       child: Text("${item.spProWinOddsOne} ${spFunGetOddsText(item.spProWinOddsOne,item.spProInitWinOddsOne)}" ,style: TextStyle(fontSize: sp(12),color:spFunGetOddsColor(item.spProWinOddsOne,item.spProInitWinOddsOne),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                     ),
                                   ),
                                   Flexible(
                                     flex: 1,
                                     fit: FlexFit.tight,
                                     child: Container(
                                       child: Text( spProIndex==0 ? "${item.spProDrawOdds} ${spFunGetOddsText(item.spProDrawOdds,item.spProInitDrawOdds)}": spProIndex==1 ? item.add_score_desc:item.mid_score_desc,style: TextStyle(fontSize: sp(spProIndex==1 ?10:12),color:spProIndex==0 ? spFunGetOddsColor(item.spProDrawOdds, item.spProInitDrawOdds): Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                     ),
                                   ),
                                   Flexible(
                                     flex: 1,
                                     fit: FlexFit.tight,
                                     child: Container(
                                       child: Text("${item.spProWinOddsTwo} ${spFunGetOddsText(item.spProWinOddsTwo,item.spProInitWinOddsTwo)}" ,style: TextStyle(fontSize: sp(12),color: spFunGetOddsColor(item.spProWinOddsTwo, item.spProInitWinOddsTwo),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: height(5),),
                               Row(
                                 children: <Widget>[
                                   Flexible(
                                     flex: 1,
                                     fit: FlexFit.tight,
                                     child: Container(
                                       child: Text("初指",style: TextStyle(fontSize: sp(12),color: Color(0xFF999999),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                     ),
                                   ),
                                   Flexible(
                                     flex: 1,
                                     fit: FlexFit.tight,
                                     child: Container(
                                       child: Text(item.spProInitWinOddsOne,style: TextStyle(fontSize: sp(12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                     ),
                                   ),
                                   Flexible(
                                     flex: 1,
                                     fit: FlexFit.tight,
                                     child: Container(
                                       child: Text( spProIndex==0 ? "${item.spProInitDrawOdds}": spProIndex==1 ? item.init_add_score_desc:item.init_mid_score_desc,style: TextStyle(fontSize: sp(spProIndex==1 ?10:12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                     ),
                                   ),
                                   Flexible(
                                     flex: 1,
                                     fit: FlexFit.tight,
                                     child: Container(
                                       child: Text(item.spProInitWinOddsTwo,style: TextStyle(fontSize: sp(12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ),
                         Icon(
                           Icons.chevron_right,
                           color: Color(0xFFBCBCBC),
                           size: width(20),
                         ),
                         SizedBox(width: 5,)
                       ],
                     ),
                   ),
                   onTap: (){
                        SPClassNavigatorUtils.spFunPushRoute(context, SPClassOddsHistoryDetail( spProOddsList.getListItem(spProIndex).map((item){
                          return item.company;
                        }).toList(),spProOddsList.getListItem(spProIndex).indexOf(item),spProOddTypes[spProIndex],widget.spProGuessId));
                   },
                 );
               }).toList(),
             ) ,
           ),
         ):Container(),
       ],
     ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  spFunGetOddsColor(String spProWinOddsOne, String spProInitWinOddsOne) {
    if(spProWinOddsOne.isEmpty||spProWinOddsOne.isEmpty){
      return Color(0xFF333333);
    }
    if( (double.tryParse(spProWinOddsOne)>double.tryParse(spProInitWinOddsOne))){
      return  Color(0xFFE3494B);
    }else if((double.tryParse(spProWinOddsOne)<double.tryParse(spProInitWinOddsOne))){
      return Color(0xFF3D9827);
    }else{
      return Color(0xFF333333);
    }
  }

  spFunGetOddsText(String spProWinOddsOne, String spProInitWinOddsOne) {
     if(spProWinOddsOne.isEmpty||spProWinOddsOne.isEmpty){
       return "";
     }

    if( (double.tryParse(spProWinOddsOne)>double.tryParse(spProInitWinOddsOne))){
      return "↑";
    }else if((double.tryParse(spProWinOddsOne)<double.tryParse(spProInitWinOddsOne))){
      return "↓";
    }else{
      return "";
    }
  }



}