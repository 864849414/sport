
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/model/SPClassSsOddsList.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';


class SPClassLolOddsPage extends StatefulWidget{
  Map<String,dynamic> params;
  String spProGuessId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassLolOddsPageState();
  }

  SPClassLolOddsPage(this.params,this.spProGuessId);

}

class SPClassLolOddsPageState extends State<SPClassLolOddsPage> with AutomaticKeepAliveClientMixin{
  SPClassSsOddsList spProOddsList;
  var spProIndex=0;
  var spProOddTypes=["",""];
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
           width: width(213),
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
                     child: Text("全场胜负",style: TextStyle(fontSize: sp(14),color: spProIndex==0? Colors.white :Color(0xFFDE3C31)),),
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
                         borderRadius: BorderRadius.only(bottomRight:Radius.circular(width(5)),topRight: Radius.circular(width(5))),
                         border: Border.all(color: Color(0xFFDE3C31),width: 0.4),
                         color: spProIndex==1? Color(0xFFDE3C31):Colors.white
                     ),
                     alignment: Alignment.center,
                     child: Text("让分胜负",style: TextStyle(fontSize: sp(14),color: spProIndex==1? Colors.white :Color(0xFFDE3C31)),),
                   ),
                   onPressed: (){
                     setState(() {
                       spProIndex=1;
                     });
                   },
                 ),
               ),
             ],
           ),
         ),
         Flexible(
           fit: FlexFit.tight,
           flex: 1,
           child: SingleChildScrollView(
             child: Column(
               children: <Widget>[
                 Container(
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(width(3)),
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
                   ),
                   child: Column(
                     children: <Widget>[
                       Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.vertical(top: Radius.circular(width(3))),
                             color: Color(0xFF999999)
                         ),
                         width: width(340),
                         height: height(37),
                         child: Row(
                           children: <Widget>[
                             Container(
                               width: width(80),
                               alignment: Alignment.center,
                               child: Text("公司",style: TextStyle(color: Colors.white,fontSize: sp(12)),),
                             ),
                             Expanded(
                               child:  Container(
                                 alignment: Alignment.center,
                                 child: Text("初盘",style: TextStyle(color: Colors.white,fontSize: sp(12)),),
                               ),
                             ),
                             Expanded(
                               child:  Container(
                                 alignment: Alignment.center,
                                 child: Text("即盘",style: TextStyle(color: Colors.white,fontSize: sp(12)),),
                               ),
                             )

                           ],
                         ),
                       ),
                       (spProOddsList==null||spProOddsList.getListItemLOL(spProIndex).length==0) ? SizedBox(height: height(20),):Column(
                         children: spProOddsList.getListItemLOL(spProIndex).map((item){
                           var index =spProOddsList.getListItemLOL(spProIndex).indexOf(item);
                           return Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(width(5)),
                               color:index%2==0 ? Colors.white:Color(0xFFF7F7F7)
                             ),
                             width: width(336),
                             height: height(33),
                             child: Row(
                               children: <Widget>[
                                 Container(
                                   width: width(80),
                                   alignment: Alignment.center,
                                   child: Text(item.company,style: TextStyle(color: Color(0xFF333333),fontSize: sp(10)),),
                                 ),
                                 Expanded(
                                   child:  Container(
                                     alignment: Alignment.center,
                                     child: Row(
                                       children: <Widget>[
                                         Expanded(
                                         child: Container(
                                             alignment: Alignment.center,
                                             child: Text("${spFunInitEmpText(item.spProInitWinOddsOne)}",style: TextStyle(fontSize: sp(12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                           ),
                                         ),
                                         Expanded(
                                         child: Container(
                                           alignment: Alignment.center,
                                           child: Text( "${spFunInitEmpText(item.spProInitDrawOdds)}",style: TextStyle(fontSize: sp(spProIndex==1 ?10:12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                           ),
                                         ),
                                         Expanded(
                                           child: Container(
                                             alignment: Alignment.center,
                                             child: Text("${spFunInitEmpText(item.spProInitWinOddsTwo)}",style: TextStyle(fontSize: sp(12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child:  Container(
                                     alignment: Alignment.center,
                                     child: Row(
                                       children: <Widget>[
                                         Expanded(
                                           child: Container(
                                             alignment: Alignment.center,
                                             child: Text("${spFunInitEmpText(item.spProWinOddsOne)}",style: TextStyle(fontSize: sp(12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                           ),
                                         ),
                                         Expanded(
                                           child: Container(
                                             alignment: Alignment.center,
                                             child: Text( "${spFunInitEmpText(item.spProDrawOdds)}",style: TextStyle(fontSize: sp(spProIndex==1 ?10:12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                           ),
                                         ),
                                         Expanded(
                                           child: Container(
                                             alignment: Alignment.center,
                                             child: Text("${spFunInitEmpText(item.spProWinOddsTwo)}",style: TextStyle(fontSize: sp(12),color: Color(0xFF333333),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),

                               ],
                             ),
                           );
                         }).toList(),
                       ),

                     ],
                   ),
                 ),

               ],
             ),
           ),
         ),
       ],
     ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  spFunGetOddsColor(String spProWinOddsOne, String spProInitWinOddsOne) {
    if(spProWinOddsOne.isEmpty||spProInitWinOddsOne.isEmpty){
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
     if(spProWinOddsOne.isEmpty||spProInitWinOddsOne.isEmpty){
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

  spFunInitEmpText(String spProInitDrawOdds) {

    if(spProInitDrawOdds==null||spProInitDrawOdds.isEmpty){
      return "-";
    }

    return spProInitDrawOdds;
  }



}