
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassExpertInfo.dart';
import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/SPClassLogUtils.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/pages/dialogs/SPClassExpertRuluTipDialog.dart';
import 'package:sport/pages/home/SPClassSchemeItemView.dart';
import 'package:sprintf/sprintf.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sport/utils/SPClassImageUtil.dart';

class SPClassExpertDetailPage extends StatefulWidget{
  SPClassExpertInfo info;
  bool spProIsStatics;
  SPClassExpertDetailPage(this.info,{this.spProIsStatics:true});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassExpertDetailPageState();
  }

}

class SPClassExpertDetailPageState extends State<SPClassExpertDetailPage> with TickerProviderStateMixin{
  int page=1;
  List<SPClassSchemeListSchemeList> spProSchemeHistory=List();
  List<SPClassSchemeListSchemeList> spProSchemeList=List();
  List<SPClassChartData> spProChartData=List();

  List<int> spProDates;

  Container spProChartsCon;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunGetRecentReport();

    spFunOnRefreshSelf();

    if(widget.spProIsStatics){
      SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "view_expert",targetId:widget.info.spProUserId);
    }


    
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          elevation: 0,
          leading: FlatButton(
           child: Icon(Icons.arrow_back_ios,size: width(20),color: Colors.white,),
          onPressed: (){Navigator.of(context).pop();},
          ),
         centerTitle: true,
          title: Text("${widget.info.spProNickName}"+
              "专家",style: TextStyle(fontSize:  sp(16)),),
    ),
       body: Stack(
         children: <Widget>[
           Container(
             color: Color(0xFFF1F1F1),
             width: ScreenUtil.screenWidth,
             height: ScreenUtil.screenHeight,
           ),
           Positioned(
             top: 0,
             right: 0,
             left: 0,
             child: Container(
               color: Theme.of(context).primaryColor,
               height: height(60),
             ),
           ),

           Positioned(
             right: 0,left: 0,top: 0,bottom: 0,
             child: Container(
               width: ScreenUtil.screenWidth,
               height: ScreenUtil.screenHeight,
               child: SingleChildScrollView(
                 child: Column(
                   children: <Widget>[
                     Container(
                       padding: EdgeInsets.all(width(10)),
                       margin: EdgeInsets.only(left: width(13),right: width(13),bottom: height(8)),
                       decoration: BoxDecoration(
                           color: Colors.white,
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
                           borderRadius: BorderRadius.circular(width(7))
                       ),
                       width: ScreenUtil.screenWidth,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Expanded(
                                 child:  Row(
                                   children: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                           border: Border.all(width: 0.4,color: Colors.grey[200]),
                                           borderRadius: BorderRadius.circular(width(20))),
                                       child:  ClipRRect(
                                         borderRadius: BorderRadius.circular(width(20)),
                                         child:( widget.info?.spProAvatarUrl==null||widget.info.spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                                           SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                                           width: width(40),
                                           height: width(40),
                                         ):Image.network(
                                           widget.info.spProAvatarUrl,
                                           width: width(40),
                                           height: width(40),
                                           fit: BoxFit.fill,
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: width(5),),
                                     Expanded(
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: <Widget>[
                                           SizedBox(width: 5,),
                                           Row(
                                             children: <Widget>[
                                               Text(widget.info.spProNickName,style: TextStyle(fontSize: sp(14),color: Color(0xFF333333)),maxLines: 1,),
                                               SizedBox(width: 5,),
                                               Visibility(
                                                 child: Container(
                                                   padding: EdgeInsets.only(left: width(5),right:  width(5),top: width(0.8)),
                                                   alignment: Alignment.center,
                                                   height: width(16),
                                                   constraints: BoxConstraints(
                                                       minWidth: width(52)
                                                   ),
                                                   decoration: BoxDecoration(
                                                     gradient: LinearGradient(
                                                         colors: [Color(0xFFF2150C),Color(0xFFF24B0C)]
                                                     ),
                                                     borderRadius: BorderRadius.circular(100),
                                                   ),
                                                   child:Text("近"+
                                                       "${widget.info.spProLast10Result.length.toString()}"+
                                                       "中"+
                                                       "${widget.info.spProLast10CorrectNum}",style: TextStyle(fontSize: sp(9),color: Colors.white,letterSpacing: 1),),
                                                 ),
                                                 visible:  (widget.info.spProSchemeNum!=null&&(double.tryParse(widget.info.spProLast10CorrectNum)/double.tryParse(widget.info.spProLast10Result.length.toString()))>=0.6),
                                               ),
                                               SizedBox(width: 3,),
                                               int.tryParse( widget.info.spProCurrentRedNum)>2?  Stack(
                                                 children: <Widget>[
                                                   SPClassEncryptImage.asset(widget.info.spProCurrentRedNum.length>1  ? SPClassImageUtil.spFunGetImagePath("ic_recent_red2"):SPClassImageUtil.spFunGetImagePath("ic_recent_red"),
                                                     height:width(16) ,
                                                     fit: BoxFit.fitHeight,
                                                   ),
                                                   Positioned(
                                                     left: width(widget.info.spProCurrentRedNum.length>1  ? 5:7),
                                                     bottom: 0,
                                                     top: 0,
                                                     child: Container(
                                                       alignment: Alignment.center,
                                                       child: Text("${widget.info.spProCurrentRedNum}",style: GoogleFonts.roboto(textStyle: TextStyle(color:Color(0xFFDE3C31) ,fontSize: sp(14.8),fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
                                                     ),
                                                   ),
                                                   Positioned(
                                                     right: width(7),
                                                     bottom: 0,
                                                     top: 0,
                                                     child: Container(
                                                       padding: EdgeInsets.only(top: width(0.8)),
                                                       alignment: Alignment.center,
                                                       child: Text("连红",style: TextStyle(color:Colors.white ,fontSize: sp(9),fontStyle: FontStyle.italic)),
                                                     ),
                                                   )
                                                 ],
                                               ):SizedBox()
                                             ],
                                           ),
                                           Row(children: <Widget>[
                                             Visibility(
                                               child: Text(sprintf("粉丝数：%s   ",[widget.info.spProFollowerNum]),style: TextStyle(fontSize: sp(11),color: Color(0xFF999999)),),
                                               visible: widget.info.spProFollowerNum!=null&&double.tryParse(widget.info.spProFollowerNum)>0,
                                             ),
                                           ],)
                                         ],
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                               GestureDetector(
                                   child:  Container(
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(width(2)),
                                       gradient: LinearGradient(
                                           colors: widget.info.spProIsFollowing? [Color(0xFFC6C6C6),Color(0xFFC6C6C6)]:[Color(0xFFF2150C),Color(0xFFF24B0C)]
                                       ),
                                       boxShadow:widget.info.spProIsFollowing?null:[
                                         BoxShadow(
                                           offset: Offset(3,3),
                                           color: Color(0x4DF23B0C),
                                           blurRadius:width(5,),),
                                         BoxShadow(
                                           offset: Offset(-2,1),
                                           color: Color(0x4DF23B0C),
                                           blurRadius:width(5,),),
                                       ],
                                     ),
                                     width: width(58),
                                     height: width(27),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: <Widget>[
                                         Icon(widget.info.spProIsFollowing? Icons.check:Icons.add,color: Colors.white,size: width(15),),
                                         Text( widget.info.spProIsFollowing? "已关注":"关注",style: TextStyle(fontSize: sp(11),color: Colors.white),),

                                       ],
                                     ),
                                   ),
                                   onTap: (){
                                     if(spFunIsLogin(context: context)){
                                       SPClassApiManager.spFunGetInstance().spFunFollowExpert(isFollow: !widget.info.spProIsFollowing,spProExpertUid: widget.info.spProUserId,context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                           spProOnSuccess: (result){
                                             if(!widget.info.spProIsFollowing){
                                               SPClassToastUtils.spFunShowToast(msg: "关注成功");
                                               widget.info.spProIsFollowing=true;
                                             }else{
                                               widget.info.spProIsFollowing=false;
                                             }
                                             if(mounted){
                                               setState(() {});
                                             }
                                           }
                                       ));
                                     }
                                   }
                               ),
                             ],
                           ),
                           SizedBox(height: 3,),
                           Text("${SPClassStringUtils.spFunMaxLength(widget.info.intro,length: 50)}",style: TextStyle(fontSize: sp(12),color: Color(0xFF666666))),

                         ],
                       ),
                     ),


                     Container(
                       padding: EdgeInsets.all(width(10)),
                       margin: EdgeInsets.only(left: width(13),right: width(13)),
                       decoration: BoxDecoration(
                           color: Colors.white,
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
                           borderRadius: BorderRadius.circular(width(7))
                       ),
                       width: ScreenUtil.screenWidth,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Container(
                                 width: height(4),
                                 height: height(14),
                                 decoration: BoxDecoration(
                                     color: Color(0xFFDE3C31),
                                     borderRadius: BorderRadius.circular(100)
                                 ),
                               ),
                               SizedBox(width: 4,),
                               Text("近期胜率",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(15)),),
                               Expanded(
                                 child: SizedBox(),
                               ),
                               GestureDetector(
                                 behavior: HitTestBehavior.opaque,
                                 child: Container(
                                   padding: EdgeInsets.all(3),
                                   child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_rulu_tip"),width: width(12),),
                                 ),
                                 onTap: (){
                                   showDialog(context: context,child: SPClassExpertRuluTipDialog());
                                 },
                               )

                             ],
                           ),


                           spProChartData.length==0? SizedBox():
                           spFunBuildCharts(),
                           SizedBox(height: 7,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Expanded(
                                 child: Container(
                                   height: width(47),
                                   decoration: BoxDecoration(
                                       color: Color(0xFFF6F6F6),
                                       borderRadius: BorderRadius.circular(width(3))
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: <Widget>[
                                       Text("${(double.tryParse(widget.info.spProRecentProfitSum)*100).toStringAsFixed(0)}%",style: GoogleFonts.roboto(fontSize: sp(16),textStyle: TextStyle(color: Color(0xFFE3494B)),fontWeight: FontWeight.w500),),
                                       Text("近10场回报率",style: TextStyle(fontSize: sp(10),color: Color(0xFF666666)),),
                                     ],
                                   ),
                                 ),
                               ),
                               SizedBox(width: width(7),),
                               Expanded(
                                 child:Container(
                                   height: width(47),
                                   decoration: BoxDecoration(
                                       color: Color(0xFFF6F6F6),
                                       borderRadius: BorderRadius.circular(width(3))
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: <Widget>[
                                       Text("${widget.info.spProRecentAvgOdds}",style: GoogleFonts.roboto(fontSize: sp(16),textStyle: TextStyle(color: Color(0xFFE3494B)),fontWeight: FontWeight.w500),),
                                       Text("SP均值",style: TextStyle(fontSize: sp(10),color: Color(0xFF666666)),),

                                     ],
                                   ),
                                 ) ,
                               ),
                               SizedBox(width: width(7),),
                               Expanded(
                                 child: Container(
                                   height: width(47),
                                   decoration: BoxDecoration(
                                       color: Color(0xFFF6F6F6),
                                       borderRadius: BorderRadius.circular(width(3))
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: <Widget>[
                                       Text("${widget.info.spProCurrentRedNum}",style: GoogleFonts.roboto(fontSize: sp(16),textStyle: TextStyle(color: Color(0xFFE3494B)),fontWeight: FontWeight.w500),),
                                       Text("最近连红",style: TextStyle(fontSize: sp(10),color: Color(0xFF666666)),),

                                     ],
                                   ),
                                 ),
                               ),
                               SizedBox(width: width(7),),
                               Expanded(
                                 child: Container(
                                   height: width(47),
                                   decoration: BoxDecoration(
                                       color: Color(0xFFF6F6F6),
                                       borderRadius: BorderRadius.circular(width(3))
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: <Widget>[
                                       Text("${widget.info.spProMaxRedNum}",style: GoogleFonts.roboto(fontSize: sp(16),textStyle: TextStyle(color: Color(0xFFE3494B)),fontWeight: FontWeight.w500),),
                                       Text("历史最高连红",style: TextStyle(fontSize: sp(10),color: Color(0xFF666666)),),

                                     ],
                                   ),
                                 ),
                               )
                             ],
                           ),


                         ],

                       ),
                     ),

                     spProSchemeList.length==0?SizedBox():  Container(
                       margin: EdgeInsets.only(left: width(13),right:  width(13),top:width(8) ),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(width(7)),
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
                       width: ScreenUtil.screenWidth,

                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Container(
                             height: height(35),
                             padding: EdgeInsets.only(left: width(13),right: width(13)),
                             decoration: BoxDecoration(
                                 border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                             ),
                             child: Row(
                               children: <Widget>[
                                 Container(
                                   width: height(4),
                                   height: height(14),
                                   decoration: BoxDecoration(
                                       color: Color(0xFFDE3C31),
                                       borderRadius: BorderRadius.circular(100)
                                   ),
                                 ),
                                 SizedBox(width: 4,),
                                 Text("正在推荐",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(15)),),

                               ],
                             ),
                           ),
                           ListView.builder(
                               physics: NeverScrollableScrollPhysics(),
                               shrinkWrap: true,
                               padding: EdgeInsets.only(bottom: width(5)),
                               itemCount: spProSchemeList.length,
                               itemBuilder: (c,index){
                                 var item=spProSchemeList[index];
                                 return SPClassSchemeItemView(item,spProCanClick: false,spProShowLine:spProSchemeList.length>(index+1));
                               })
                         ],
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(left: width(13),right:  width(13),top:width(8),bottom:width(8) ),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(width(7)),
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
                       width: ScreenUtil.screenWidth,

                       child:spProSchemeHistory.length==0?SizedBox(): Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Container(
                             height: height(35),
                             padding: EdgeInsets.only(left: width(13),right: width(13)),
                             decoration: BoxDecoration(
                                 border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                             ),
                             child: Row(
                               children: <Widget>[
                                 Container(
                                   width: height(4),
                                   height: height(14),
                                   decoration: BoxDecoration(
                                       color: Color(0xFFDE3C31),
                                       borderRadius: BorderRadius.circular(100)
                                   ),
                                 ),
                                 SizedBox(width: 4,),
                                 Text("历史推荐",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: sp(15)),),

                               ],
                             ),
                           ),
                           ListView.builder(
                               physics: NeverScrollableScrollPhysics(),
                               shrinkWrap: true,
                               padding: EdgeInsets.only(bottom: width(5)),
                               itemCount: spProSchemeHistory.length,
                               itemBuilder: (c,index){
                                 var item=spProSchemeHistory[index];
                                 return Stack(
                                   children: <Widget>[
                                     SPClassSchemeItemView(item,spProShowRate: false,spProShowLine:spProSchemeHistory.length>(index+1),),
                                     Positioned(
                                       top: 10,
                                       right:  width(13) ,
                                       child: SPClassEncryptImage.asset(
                                         (item.spProIsWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_result_red"):
                                         (item.spProIsWin=="0")? SPClassImageUtil.spFunGetImagePath("ic_result_hei"):
                                         (item.spProIsWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_result_zou"):"",
                                         width: width(40),
                                       ),
                                     ),
                                   ],
                                 );
                               })
                         ],
                       ),
                     ),


                   ],
                 ),
               ),
             ),
           )
         ],
       ));
  }



  void spFunOnRefreshSelf() {
    SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"expert_uid":widget.info.spProUserId,"page":"1","fetch_type":"expert"},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){
          list.spProSchemeList.forEach((itemx){
            if(itemx.spProIsOver=="1"){
             spProSchemeHistory.add(itemx);
            }else{
              spProSchemeList.add(itemx);

            }
          });
          if(mounted){
            setState(() {
         });
          }
        },
        onError: (value){
        }
    ));
  }

  void spFunGetRecentReport() {
      spProDates=  SPClassMatchDataUtils.spFunCalcDateCount(widget.info.spProLast10Result);
      spProDates.sort((left,right)=>right.compareTo(left));
      spProDates.forEach((item){
        spProChartData.add(SPClassChartData((SPClassMatchDataUtils.spFunCalcCorrectRateByDate(widget.info.spProLast10Result,item)*100).roundToDouble(),"近"+
            "${item.toString()}"+
                "场"));
       });

      if(spProChartData.length==1){
        spProChartData.add(SPClassChartData(spProChartData[0].y,""));

      }

      setState(() {});

  }

  spFunBuildCharts() {

     if(spProChartsCon==null){
       spProChartsCon= Container(
         height:width(150),
         child:SfCartesianChart(
           plotAreaBorderWidth: 0,
           onTooltipRender: (TooltipArgs args) {
             final NumberFormat format = NumberFormat.decimalPattern();
            var text=  format.format(args.dataPoints[args.pointIndex].y).toString();
            SPClassLogUtils.spFunPrintLog("text：${text.toString()}");
           },
           title: ChartTitle(text: ""),
           legend: Legend(
               isVisible: false,
               overflowMode: LegendItemOverflowMode.wrap),
           primaryXAxis: CategoryAxis(
               labelPlacement: LabelPlacement.onTicks,
               majorGridLines: MajorGridLines(width: 0.4)),
           primaryYAxis: NumericAxis(
               maximum: 100,
               labelFormat: '{value}%',
               interval: 25,
               axisLine: AxisLine(width: 0),
               majorTickLines: MajorTickLines(color: Colors.transparent)),
           series: <AreaSeries<SPClassChartData, String>>[
             AreaSeries<SPClassChartData, String>(
                 animationDuration: 2500,
                 enableTooltip: true,
                 gradient:LinearGradient(colors:[Colors.white.withOpacity(0.5),Colors.red.withOpacity(0.5)],begin: Alignment.bottomCenter,end: Alignment.topCenter),
                 dataSource: spProChartData,
                 borderColor: Colors.red,
                 borderWidth: 1,
                 xValueMapper: (SPClassChartData sales, _) => sales.x,
                 yValueMapper: (SPClassChartData sales, _) => sales.y,
                 name: "近期胜率",
                 markerSettings: MarkerSettings(
                     isVisible: true, color:Colors.red,borderColor: Colors.white)),


           ],
           tooltipBehavior: TooltipBehavior(enable: true,color: Colors.red,borderColor:Colors.cyan ),
         ),
       );
     }
     return spProChartsCon;
  }


}

class SPClassChartData {
  SPClassChartData( this.y,this.x,);
   String x;
   double y;
   String z="xsdsadsa";

}



