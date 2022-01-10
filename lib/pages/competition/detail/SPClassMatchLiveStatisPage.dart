import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassChartDoughnutData.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/SPClassEncryptImage.dart';

import 'package:sport/model/SPClassMatchEventEntity.dart';
import 'package:sport/model/SPClassMatchInjuryEntity.dart';
import 'package:sport/model/SPClassMatchLineupEntity.dart';
import 'package:sport/model/SPClassMatchLineupPlayerEntity.dart';
import 'package:sport/model/SPClassMatchStatListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/pages/common/SPClassLoadingPage.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sprintf/sprintf.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sport/model/SPClassMatchIntelligenceEntity.dart';
class SPClassMatchLiveStatisPage extends  StatefulWidget{
  SPClassGuessMatchInfo spProGuessInfo;

  SPClassMatchLiveStatisPage(this.spProGuessInfo,{this.callback});
  ValueChanged<SPClassGuessMatchInfo> callback;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMatchLiveStatisPageState();
  }

}

class SPClassMatchLiveStatisPageState extends State<SPClassMatchLiveStatisPage> with TickerProviderStateMixin<SPClassMatchLiveStatisPage> ,AutomaticKeepAliveClientMixin{
  List<SPClassMatchStatListMatchStat> spProMatchStatList= List();//技术统计
  List<SPClassMatchEventMatchEventItem> spProMatchEventList= List(); //比赛事件
  List<SPClassMatchEventMatchEventItem> spProOrgMatchEventList= List(); //比赛事件
  var spProEventImages=["ic_football_jin","ic_football_dq","ic_football_wl","ic_football_dqsb","ic_football_jiao","ic_football_h1p","ic_football_hp","ic_football_hr","ic_football_lhbh",];
  var spProEventTitles=["入球","点球","乌龙","射失点球","角球","黄牌","红牌","换人","两黄变红"];

  Timer spProTimer;
  int hour=0;
  int minute=0;
  int second=0;

  bool spProIsDispose=false;
  int spProGoalScoreOne=0;
  int spProGoalScoreTwo=0;
  int spProCornerScoreOne=0;
  int spProCornerScoreTwo=0;
  int spProMistakeScoreOne=0;
  int spProMistakeScoreTwo=0;
  int spProPenalScoreOne=0;
  int spProPenalScoreTwo=0;
  Map<String,int> spProEventRecords=Map();

  SPClassMatchLineupEntity spProMatchLineupEntity;
  SPClassMatchLineupPlayerEntity spProMatchLineupPlayerEntity;
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> spProStartingOnes;//首发主队
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> spProStartingTwos;//首发客队
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> spProSubstituteOnes;//替补客队
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> spProSubstituteTwos;//替补客队

  SPClassMatchInjuryEntity spProMatchInjuryEntity;
  var spProShowTeam=true;
  var spProShowJury=true;

  SPClassMatchIntelligenceMatchIntelligenceItem spProMatchIntelligenceItemOne;
  SPClassMatchIntelligenceMatchIntelligenceItem spProMatchIntelligenceItemTwo;
  var spProIsLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();






    SPClassApiManager.spFunGetInstance().spFunSportMatchData<SPClassBaseModelEntity>(
        context: context,spProGuessMatchId:widget.spProGuessInfo.spProGuessMatchId,
        dataKeys:"match_stat;match_lineup;match_lineup_player;match_injury;match_intelligence",
        spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (result) async {
          spProIsLoading=false;
          var matchStatListEntity= JsonConvert.fromJsonAsT<SPClassMatchStatListEntity>(result.data);
          var spProMatchLineupEntity= JsonConvert.fromJsonAsT<SPClassMatchLineupEntity>(result.data);
          var spProMatchLineupPlayerEntity= JsonConvert.fromJsonAsT<SPClassMatchLineupPlayerEntity>(result.data);
          var spProMatchInjuryEntity= JsonConvert.fromJsonAsT<SPClassMatchInjuryEntity>(result.data);
          var matchIntelligenceEntity= JsonConvert.fromJsonAsT<SPClassMatchIntelligenceEntity>(result.data);


          if(matchIntelligenceEntity.spProMatchIntelligence!=null&&matchIntelligenceEntity.spProMatchIntelligence.one!=null){
            spProMatchIntelligenceItemOne=matchIntelligenceEntity.spProMatchIntelligence.one[0];
          }
          if(matchIntelligenceEntity.spProMatchIntelligence!=null&&matchIntelligenceEntity.spProMatchIntelligence.two!=null){
            spProMatchIntelligenceItemTwo=matchIntelligenceEntity.spProMatchIntelligence.two[0];
          }

          if(matchStatListEntity!=null&&matchStatListEntity.spProMatchStat!=null){
           spProMatchStatList=matchStatListEntity.spProMatchStat;
          }
          if(spProMatchLineupEntity!=null&&spProMatchLineupEntity.spProMatchLineup!=null&&spProMatchLineupEntity.spProMatchLineup.length>0){
            List<SPClassMatchLineupMatchLineup> dealList=[];
            spProMatchLineupEntity.spProMatchLineup.forEach((item) {
               if(item.spProTeamOneLineup.isNotEmpty&&item.spProTeamTwoLineup.isNotEmpty){
                 dealList.add(item);
               }
            });
            spProMatchLineupEntity.spProMatchLineup=dealList;
            if(dealList.length>0){
              this.spProMatchLineupEntity=spProMatchLineupEntity;

            }
          }

          if(spProMatchLineupPlayerEntity!=null&&spProMatchLineupPlayerEntity.spProMatchLineupPlayer!=null&&
              (spProMatchLineupPlayerEntity.spProMatchLineupPlayer.one!=null
              ||spProMatchLineupPlayerEntity.spProMatchLineupPlayer.two!=null)
          ){
            spProStartingOnes=[];
            spProSubstituteOnes=[];
            spProStartingTwos=[];
            spProSubstituteTwos=[];
            if(spProMatchLineupPlayerEntity.spProMatchLineupPlayer.one!=null){
              spProMatchLineupPlayerEntity.spProMatchLineupPlayer.one.forEach((item){
              if(item.spProIsRegular=="1"){
                spProStartingOnes.add(item);
              }else{
                spProSubstituteOnes.add(item);
              }
            });
            }
            if(spProMatchLineupPlayerEntity.spProMatchLineupPlayer.two!=null){
              spProMatchLineupPlayerEntity.spProMatchLineupPlayer.two.forEach((item){
                if(item.spProIsRegular=="1"){
                  spProStartingTwos.add(item);
                }else{
                  spProSubstituteTwos.add(item);
                }
              });
            }
            this.spProMatchLineupPlayerEntity=spProMatchLineupPlayerEntity;
          }

          if(spProMatchInjuryEntity!=null&&spProMatchInjuryEntity.spProMatchInjury!=null){
              this.spProMatchInjuryEntity=spProMatchInjuryEntity;
          }
          setState(() {
          });
          spFunGetMatchEvent("");
        },onError: (e){
        spFunGetMatchEvent("");
      }
    )
    );


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(spProTimer!=null){
      spProTimer.cancel();
    }
    spProIsDispose=true;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
      return spProIsLoading? SPClassLoadingPage():SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: width(10),),

          (spProMatchStatList.length==0&&spProMatchEventList.length==0&&spProMatchLineupPlayerEntity==null&&spProMatchLineupEntity==null&&spProMatchInjuryEntity==null&&spProMatchIntelligenceItemOne==null&&spProMatchIntelligenceItemTwo==null)?
          SPClassNoDataView(height:width(400),):SizedBox(),

          spProMatchStatList.length==0?  SizedBox():Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow:[
                  BoxShadow(
                    offset: Offset(2,5),
                    color: Color(0x0C000000),
                    blurRadius:width(6,),),
                  BoxShadow(
                    offset: Offset(-5,1),
                    color: Color(0x0C000000),
                    blurRadius:width(6,),
                  )
                ],
                borderRadius: BorderRadius.circular(width(7))
            ),
            margin: EdgeInsets.only(bottom: height(8),left: width(10),right: width(10)),
            child: Column(
            children: <Widget>[

              Container(
                height: height(35),
                padding: EdgeInsets.only(left: width(13),right: width(13)),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                     child: Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Container(
                           color: Color(0xFFDE3C31),
                           width: width(10),
                           height: width(10),
                         ),
                         SizedBox(width: 5,),
                         Text(widget.spProGuessInfo.spProTeamOne,
                           style: TextStyle(
                               fontSize: sp(16),
                               fontWeight: FontWeight.bold),
                         maxLines: 1,
                         overflow: TextOverflow.ellipsis,)
                       ],
                     ),
                   ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(widget.spProGuessInfo.spProTeamTwo,
                            style: TextStyle(
                                fontSize: sp(16),
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,),
                          SizedBox(width: 5,),
                          Container(
                            color: Color(0xFF5D8AF7),
                            width: width(10),
                            height: width(10),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),//主客队伍标题
               
               
              Row(
                 children: <Widget>[
                   Expanded(
                     child:Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Column(
                           children: <Widget>[
                             SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_football_jiao"),width: width(15),),
                             Text(spFunFindMatchStat("角球",1),style: TextStyle(fontSize: sp(10)),)
                           ],
                         ),
                         SizedBox(width: width(5),),
                         Column(
                           children: <Widget>[
                             SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_football_hp"),width: width(15),),
                             Text(spFunFindMatchStat("红牌",1),style: TextStyle(fontSize: sp(10)),)
                           ],
                         ),
                         SizedBox(width: width(5),),
                         Column(
                           children: <Widget>[
                             SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_football_h1p"),width: width(15),),
                             Text(spFunFindMatchStat("黄牌",1),style: TextStyle(fontSize: sp(10)),)
                           ],
                         )
                       ],
                     ) ,
                   ),

                   Column(
                     children: <Widget>[
                       Row(
                         children: <Widget>[
                           Text(spFunFindMatchStat("进攻",1),style: TextStyle(fontSize: sp(10),color: Color(0xFF999999)),),
                           Container(
                             height: width(40),
                             width: width(40),
                             child:SfCircularChart(
                               margin: EdgeInsets.zero,
                               title: ChartTitle(text: '' ),
                               legend: Legend(isVisible: false),
                               series: [
                                 DoughnutSeries<SPClassChartDoughnutData, String>(
                                   explode: false,
                                   explodeIndex: 0,

                                   dataSource: [
                                     SPClassChartDoughnutData(double.tryParse(spFunFindMatchStat("进攻",1)),color: Color(0xFFDE3C31)),
                                     SPClassChartDoughnutData(double.tryParse(spFunFindMatchStat("进攻",2)),color: Color(0xFF5D8AF7)),

                                   ],
                                   xValueMapper: (SPClassChartDoughnutData data, _) => "",
                                   yValueMapper: (SPClassChartDoughnutData data, _) => data.percenter,
                                   pointColorMapper:(SPClassChartDoughnutData data, _) => data.color,
                                   startAngle: 90,
                                   endAngle: 90,
                                 ),
                               ],
                             ),
                           ),
                           Text(spFunFindMatchStat("进攻",2),style: TextStyle(fontSize: sp(10),color: Color(0xFF999999)),),

                         ],
                       ),
                       Text("进攻",style: TextStyle(fontSize: sp(12)),)

                     ],
                   ),
                   SizedBox(width: width(26),),
                   Column(
                     children: <Widget>[
                       Row(
                         children: <Widget>[
                           Text(spFunFindMatchStat("危险进攻",1),style: TextStyle(fontSize: sp(10),color: Color(0xFF999999)),),
                           Container(
                             height: width(40),
                             width: width(40),
                             child:SfCircularChart(
                               margin: EdgeInsets.zero,
                               title: ChartTitle(text: '' ),
                               legend: Legend(isVisible: false),
                               series: [
                                 DoughnutSeries<SPClassChartDoughnutData, String>(
                                   explode: false,
                                   explodeIndex: 0,

                                   dataSource: [
                                     SPClassChartDoughnutData(double.tryParse(spFunFindMatchStat("危险进攻",1)),color: Color(0xFFDE3C31)),
                                     SPClassChartDoughnutData(double.tryParse(spFunFindMatchStat("危险进攻",2)),color: Color(0xFF5D8AF7)),

                                   ],
                                   xValueMapper: (SPClassChartDoughnutData data, _) => "",
                                   yValueMapper: (SPClassChartDoughnutData data, _) => data.percenter,
                                   pointColorMapper:(SPClassChartDoughnutData data, _) => data.color,
                                   startAngle: 90,
                                   endAngle: 90,
                                 ),
                               ],
                             ),
                           ),
                           Text(spFunFindMatchStat("危险进攻",2),style: TextStyle(fontSize: sp(10),color: Color(0xFF999999)),),

                         ],
                       ),
                       Text("危险进攻",style: TextStyle(fontSize: sp(12)),)

                     ],
                   ),

                   Expanded(
                     child:Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Column(
                           children: <Widget>[
                             SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_football_jiao"),width: width(15),),
                             Text(spFunFindMatchStat("角球",2),style: TextStyle(fontSize: sp(10)),)
                           ],
                         ),
                         SizedBox(width: width(5),),
                         Column(
                           children: <Widget>[
                             SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_football_hp"),width: width(15),),
                             Text(spFunFindMatchStat("红牌",2),style: TextStyle(fontSize: sp(10)),)
                           ],
                         ),
                         SizedBox(width: width(5),),
                         Column(
                           children: <Widget>[
                             SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_football_h1p"),width: width(15),),
                             Text(spFunFindMatchStat("黄牌",2),style: TextStyle(fontSize: sp(10)),)
                           ],
                         )
                       ],
                     ) ,
                   )
                 ],
               ), //第一层数据
              Container(
                margin: EdgeInsets.symmetric(vertical: width(10)),
                height: 0.5,
                color: Colors.grey[300],
              ),

              Column(
                 children: <Widget>[
                   Row(
                     children: <Widget>[
                       SizedBox(width: width(16),),
                       Text(spFunFindMatchStat("控球率",1),
                         style: TextStyle(
                             fontSize: sp(11),
                             color: Color(0xFF666666)
                         ),

                       ),
                       Expanded(
                         child: Center(
                           child:Text("控球率",
                             style: TextStyle(fontSize: sp(12)),),

                         ),
                       ),
                       Text(spFunFindMatchStat("控球率",2),
                         style: TextStyle(
                             fontSize: sp(11),
                             color: Color(0xFF666666)
                         ),

                       ),
                       SizedBox(width: width(16),),
                     ],
                   ),
                   SizedBox(height: width(3),),
                   Stack(
                     alignment: Alignment.centerLeft,
                     children: <Widget>[
                       Visibility(
                         child: Container(
                           decoration: BoxDecoration(
                               color: Color(0xFFEBEBEB),
                               borderRadius: BorderRadius.circular(300)
                           ),
                           width: width(308),
                           height: height(7),
                           child: Row(
                             children: <Widget>[

                               Expanded(
                                 flex: 1,
                                 child: Container(
                                   decoration: BoxDecoration(
                                       color: Color(0xFFDE3C31),
                                       borderRadius: BorderRadius.horizontal(left:Radius.circular(300) )
                                   ),
                                   height: height(7),
                                 ),
                               ),
                               SizedBox(width: width(3),),
                               Expanded(
                                 flex: 1,
                                 child: Container(
                                   decoration: BoxDecoration(
                                       color: Color(0xFF5D8AF7),
                                       borderRadius: BorderRadius.horizontal(right:Radius.circular(300) )
                                   ),
                                   height: height(7),
                                 ),
                               ),

                             ],
                           ),
                         ),
                         replacement: Container(
                           decoration: BoxDecoration(
                               color: Color(0xFFEBEBEB),
                               borderRadius: BorderRadius.circular(300)
                           ),
                           width: width(308),
                           height: height(7),
                         ),
                         visible:(
                             double.tryParse(spFunFindMatchStat("控球率",1).replaceAll("%", ""))==0
                                 &&double.tryParse(spFunFindMatchStat("控球率",2).replaceAll("%", ""))==0
                         ) ,
                       ),
                       Positioned(
                         left: 0,
                         child: AnimatedSize(
                           duration: Duration(milliseconds: 800),
                           child: Container(
                             decoration: BoxDecoration(
                                 color: Color(0xFFDE3C31),
                                 borderRadius: (double.tryParse(spFunFindMatchStat("控球率",1).replaceAll("%", ""))*0.01)==1 ?
                                 BorderRadius.circular(300):
                                 BorderRadius.horizontal(left:Radius.circular(300) )
                             ),
                             width: width(305)*(double.tryParse(spFunFindMatchStat("控球率",1).replaceAll("%", ""))*0.01),
                             height: height(7),
                           ),
                           vsync: this,
                         ),
                       ),
                      Positioned(
                        right: 0,
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 800),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFF5D8AF7),
                                borderRadius: (double.tryParse(spFunFindMatchStat("控球率",2).replaceAll("%", ""))*0.01)==1 ?
                                BorderRadius.circular(300):
                                BorderRadius.horizontal(right:Radius.circular(300) )
                            ),
                            width: width(305)*(double.tryParse(spFunFindMatchStat("控球率",2).replaceAll("%", ""))*0.01),
                            height: height(7),
                          ),
                          vsync: this,
                        ),
                      )
                     ],
                   ),
                 ],
               ),//控球率

              Column(
                children: <Widget>[
                  SizedBox(height: width(10),),

                  Row(
                    children: <Widget>[
                      SizedBox(width: width(16),),
                      Text(spFunFindMatchStat("半场控球率",1),
                        style: TextStyle(
                            fontSize: sp(11),
                            color: Color(0xFF666666)
                        ),

                      ),
                      Expanded(
                        child: Center(
                          child:Text("半场控球率",
                            style: TextStyle(fontSize: sp(12)),),

                        ),
                      ),
                      Text(spFunFindMatchStat("半场控球率",2),
                        style: TextStyle(
                            fontSize: sp(11),
                            color: Color(0xFF666666)
                        ),

                      ),
                      SizedBox(width: width(16),),
                    ],
                  ),
                  SizedBox(height: width(3),),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[

                      Visibility(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFEBEBEB),
                              borderRadius: BorderRadius.circular(300)
                          ),
                          width: width(308),
                          height: height(7),
                          child: Row(
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFDE3C31),
                                      borderRadius: BorderRadius.horizontal(left:Radius.circular(300) )
                                  ),
                                  height: height(7),
                                ),
                              ),
                              SizedBox(width: width(3),),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF5D8AF7),
                                      borderRadius: BorderRadius.horizontal(right:Radius.circular(300) )
                                  ),
                                  height: height(7),
                                ),
                              ),

                            ],
                          ),
                        ),
                        replacement: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFEBEBEB),
                              borderRadius: BorderRadius.circular(300)
                          ),
                          width: width(308),
                          height: height(7),
                        ),
                        visible:(
                            double.tryParse(spFunFindMatchStat("半场控球率",1).replaceAll("%", ""))==0
                            &&double.tryParse(spFunFindMatchStat("半场控球率",2).replaceAll("%", ""))==0
                        ) ,
                      ),
                      Positioned(
                        left: 0,
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 800),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFDE3C31),
                                borderRadius: (double.tryParse(spFunFindMatchStat("半场控球率",1).replaceAll("%", ""))*0.01)==1 ?
                                BorderRadius.circular(300):
                                BorderRadius.horizontal(left:Radius.circular(300) )
                            ),
                            width: width(305)*(double.tryParse(spFunFindMatchStat("半场控球率",1).replaceAll("%", ""))*0.01),
                            height: height(7),
                          ),
                          vsync: this,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 800),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFF5D8AF7),
                                borderRadius: (double.tryParse(spFunFindMatchStat("半场控球率",2).replaceAll("%", ""))*0.01)==1 ?
                                BorderRadius.circular(300):
                                BorderRadius.horizontal(right:Radius.circular(300) )
                            ),
                            width: width(305)*(double.tryParse(spFunFindMatchStat("半场控球率",2).replaceAll("%", ""))*0.01),
                            height: height(7),
                          ),
                          vsync: this,
                        ),
                      )
                    ],
                  ),
                ],
              ),//半场控球率

              Column(
                children: <Widget>[
                  SizedBox(height: width(10),),

                  Row(
                    children: <Widget>[
                      SizedBox(width: width(16),),
                      Text((int.parse(spFunFindMatchStat("射门",1))-int.parse(spFunFindMatchStat("射门不中",1))).toString(),
                        style: TextStyle(
                            fontSize: sp(11),
                            color: Color(0xFF666666)
                        ),

                      ),
                      Expanded(
                        child: Center(
                          child:Text("射正",
                            style: TextStyle(fontSize: sp(12)),),

                        ),
                      ),
                      Text((int.parse(spFunFindMatchStat("射门",2))-int.parse(spFunFindMatchStat("射门不中",2))).toString(),
                        style: TextStyle(
                            fontSize: sp(11),
                            color: Color(0xFF666666)
                        ),

                      ),
                      SizedBox(width: width(16),),
                    ],
                  ),
                  SizedBox(height: width(3),),

                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Visibility(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFEBEBEB),
                              borderRadius: BorderRadius.circular(300)
                          ),
                          width: width(308),
                          height: height(7),
                          child: Row(
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFDE3C31),
                                      borderRadius: BorderRadius.horizontal(left:Radius.circular(300) )
                                  ),
                                  height: height(7),
                                ),
                              ),
                              SizedBox(width: width(3),),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF5D8AF7),
                                      borderRadius: BorderRadius.horizontal(right:Radius.circular(300) )
                                  ),
                                  height: height(7),
                                ),
                              ),

                            ],
                          ),
                        ),
                        replacement: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFEBEBEB),
                              borderRadius: BorderRadius.circular(300)
                          ),
                          width: width(308),
                          height: height(7),
                        ),
                        visible:(
                            (int.parse(spFunFindMatchStat("射门",1))-int.parse(spFunFindMatchStat("射门不中",1)))==0
                                &&(int.parse(spFunFindMatchStat("射门",2))-int.parse(spFunFindMatchStat("射门不中",2)))==0
                        ) ,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(width: width(16),),
                          Expanded(
                            flex: (int.parse(spFunFindMatchStat("射门",1))-int.parse(spFunFindMatchStat("射门不中",1))),
                            child: Container(
                              margin: EdgeInsets.only(right: width(5)),
                              decoration: BoxDecoration(
                                  color: Color(0xFFDE3C31),
                                  borderRadius: BorderRadius.horizontal(left:Radius.circular(300) )
                              ),
                              height: height(7),
                            ),
                          ),
                          Expanded(
                            flex: (int.parse(spFunFindMatchStat("射门",2))-int.parse(spFunFindMatchStat("射门不中",2))),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF5D8AF7),
                                  borderRadius: BorderRadius.horizontal(right:Radius.circular(300) )
                              ),
                              height: height(7),
                            ),
                          ),
                          SizedBox(width: width(16),),
                        ],
                      )
                    ],
                  ),

                ],
              ),//射正

              Column(
                children: <Widget>[
                  SizedBox(height: width(10),),

                  Row(
                    children: <Widget>[
                      SizedBox(width: width(16),),
                      Text(spFunFindMatchStat("射门",1),
                        style: TextStyle(
                            fontSize: sp(11),
                            color: Color(0xFF666666)
                        ),

                      ),
                      Expanded(
                        child: Center(
                          child:Text("射门",
                            style: TextStyle(fontSize: sp(12)),),

                        ),
                      ),
                      Text(spFunFindMatchStat("射门",2),
                        style: TextStyle(
                            fontSize: sp(11),
                            color: Color(0xFF666666)
                        ),

                      ),
                      SizedBox(width: width(16),),
                    ],
                  ),
                  SizedBox(height: width(3),),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Visibility(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFEBEBEB),
                              borderRadius: BorderRadius.circular(300)
                          ),
                          width: width(308),
                          height: height(7),
                          child: Row(
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFDE3C31),
                                      borderRadius: BorderRadius.horizontal(left:Radius.circular(300) )
                                  ),
                                  height: height(7),
                                ),
                              ),
                              SizedBox(width: width(3),),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF5D8AF7),
                                      borderRadius: BorderRadius.horizontal(right:Radius.circular(300) )
                                  ),
                                  height: height(7),
                                ),
                              ),

                            ],
                          ),
                        ),
                        replacement: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFEBEBEB),
                              borderRadius: BorderRadius.circular(300)
                          ),
                          width: width(308),
                          height: height(7),
                        ),
                        visible:(
                            double.tryParse(spFunFindMatchStat("射门",1))==0
                                &&double.tryParse(spFunFindMatchStat("射门",2))==0
                        ) ,
                      ),
                      Positioned(
                        left: 0,
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 800),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFDE3C31),
                                borderRadius: spFunFindMatchStatCalc("射门",1)==1 ?
                                BorderRadius.circular(300):
                                BorderRadius.horizontal(left:Radius.circular(300) )
                            ),
                            width: width(305)*( spFunFindMatchStatCalc("射门",1)),
                            height: height(7),
                          ),
                          vsync: this,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 800),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFF5D8AF7),
                                borderRadius:  spFunFindMatchStatCalc("射门",1)==2 ?
                                BorderRadius.circular(300):
                                BorderRadius.horizontal(right:Radius.circular(300) )
                            ),
                            width: width(305)*( spFunFindMatchStatCalc("射门",2)),
                            height: height(7),
                          ),
                          vsync: this,
                        ),
                      )
                    ],
                  ),
                ],
              ),//射门
              SizedBox(height: width(10),),
            ],
          ),) ,
          (spProMatchEventList.length==0)? SizedBox(): Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow:[
                  BoxShadow(
                    offset: Offset(2,5),
                    color: Color(0x0C000000),
                    blurRadius:width(6,),),
                  BoxShadow(
                    offset: Offset(-5,1),
                    color: Color(0x0C000000),
                    blurRadius:width(6,),
                  )
                ],
                borderRadius: BorderRadius.circular(width(7))
            ),
            margin: EdgeInsets.only(bottom: height(8),left: width(10),right: width(10),),
            child: Column(
              children: <Widget>[
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 300),
                  child:Column(
                    children: <Widget>[
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: height(20),bottom: height(20)),
                          shrinkWrap: true,
                          itemCount: spProMatchEventList.length,
                          itemBuilder: (c,index){
                            var item =spProMatchEventList[index];
                            return Container(
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: width(70),),
                                      Expanded(
                                        child:Container(
                                          padding: EdgeInsets.all(width(10)),
                                          margin: EdgeInsets.only(top: width(8)),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(width: 0.5,color: Color(0xFFCCCCCC)),
                                            borderRadius: BorderRadius.circular(width(3)),
                                              boxShadow:[BoxShadow(
                                                offset: Offset(0,2),
                                                color: Color(0xFFCCCCCC),
                                              )]

                                          ),
                                          child:  Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(item.content,style: TextStyle(fontSize: sp(12)),),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: width(40),
                                        alignment: Alignment.center,
                                        child: Text(
                                            sprintf("%s - %s ",[item.spProTeamOneScore,item.spProTeamTwoScore]),
                                            style: TextStyle(fontSize: sp(12)),
                                        
                                        ),
                                      )


                                    ],
                                  ),

                                  Positioned(
                                    left: 0,
                                    child: Container(
                                      width: width(70),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath(item.spProEventImage),width: width(15),),
                                          SizedBox(width: 5,),
                                          Text(item.time+"'",style: TextStyle(fontSize: sp(10)),),
                                        ],
                                      ),
                                    ),
                                  )


                                ],
                              ),
                            );
                          }),

                    ],
                  ),
                ),

              ],

            ),
          ),


          (spProMatchLineupPlayerEntity==null&&spProMatchLineupEntity==null)?  SizedBox(): AnimatedSize(
            vsync: this,
            duration: Duration(
                milliseconds: 300
            ),
            child:Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                      offset: Offset(2,5),
                      color: Color(0x0C000000),
                      blurRadius:width(6,),),
                    BoxShadow(
                      offset: Offset(-5,1),
                      color: Color(0x0C000000),
                      blurRadius:width(6,),
                    )
                  ],
                  borderRadius: BorderRadius.circular(width(7))
              ),
              margin: EdgeInsets.only(bottom: height(8),left: width(10),right: width(10),),
              child: Column(
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
                        Text("首发阵容",style:TextStyle(fontWeight: FontWeight.w500,fontSize: sp(15)),),
                        Expanded(
                          child: SizedBox(),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(width(5)),
                            child:  SPClassEncryptImage.asset(
                              spProShowTeam? SPClassImageUtil.spFunGetImagePath("ic_down_arrow"):SPClassImageUtil.spFunGetImagePath("ic_up_arrow"),
                              width: width(13),
                            ),
                          ),
                          onTap: (){
                            setState(() {spProShowTeam=!spProShowTeam;});
                          },
                        )
                      ],
                    ),
                  ),

                  (spProMatchLineupEntity==null)?SizedBox():Stack(
                    alignment: Alignment.center,
                    children:spFunBuildLineUpTeam(),
                  ),

                  (spProMatchLineupPlayerEntity==null||!spProShowTeam)?SizedBox(): Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(width(13)),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Row(
                                children: <Widget>[
                                  ( widget.spProGuessInfo.spProIconUrlOne.isEmpty)? SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                                    width: width(20),
                                  ):Image.network(
                                    widget.spProGuessInfo.spProIconUrlOne,
                                    width: width(20),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(widget.spProGuessInfo.spProTeamOne,style: TextStyle(fontSize: sp(12)),)
                                ],

                              ),),
                              Expanded(child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(widget.spProGuessInfo.spProTeamTwo,style: TextStyle(fontSize: sp(12)),),
                                  SizedBox(width: 5,),
                                  ( widget.spProGuessInfo.spProIconUrlTwo.isEmpty)? SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                                    width: width(20),
                                  ):Image.network(
                                    widget.spProGuessInfo.spProIconUrlTwo,
                                    width: width(20),
                                  ),
                                ],

                              ),),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: width(13),right: width(13)),
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
                              Text("首发球员",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(15)),),
                              Expanded(child: SizedBox(),),
                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: width(18),right: width(18)),
                            shrinkWrap: true,
                            itemCount: math.max(spProStartingOnes.length, spProStartingTwos.length),
                            itemBuilder: (c,index){
                              return  Container(
                                padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[300],width: 0.4))
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child:(index<=(spProStartingOnes.length-1))? Row(
                                      children: <Widget>[
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFFEA5E5E)
                                          ),
                                          child: Text(spProStartingOnes[index].spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                        SizedBox(width: 3,),
                                        Text(spProStartingOnes[index].spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),)
                                      ],
                                    ):SizedBox(),),
                                    Expanded(child:(index<=(spProStartingTwos.length-1))? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(spProStartingTwos[index].spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),),
                                        SizedBox(width: 3,),
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFF5D9CEC)
                                          ),
                                          child: Text(spProStartingTwos[index].spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                      ],
                                    ):SizedBox(),),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(height: height(20),),
                        Container(
                          padding: EdgeInsets.only(left: width(13),right: width(13)),
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
                              Text("替补球员",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(15)),),
                              Expanded(child: SizedBox(),),
                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: width(18),right: width(18)),
                            shrinkWrap: true,
                            itemCount: math.max(spProSubstituteOnes.length, spProSubstituteTwos.length),
                            itemBuilder: (c,index){
                              return  Container(
                                padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[300],width: 0.4))
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child:(index<=(spProSubstituteOnes.length-1))? Row(
                                      children: <Widget>[
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFFEA5E5E)
                                          ),
                                          child: Text(spProSubstituteOnes[index].spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                        SizedBox(width: 3,),
                                        Text(spProSubstituteOnes[index].spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),)
                                      ],
                                    ):SizedBox(),),
                                    Expanded(child:(index<=(spProSubstituteTwos.length-1))? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(spProSubstituteTwos[index].spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),),
                                        SizedBox(width: 3,),
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFF5D9CEC)
                                          ),
                                          child: Text(spProSubstituteTwos[index].spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                      ],
                                    ):SizedBox(),),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),


                ],

              ),
            ) ,
          ),

          (  spProMatchInjuryEntity==null)? SizedBox(): AnimatedSize(
            vsync: this,
            duration: Duration(
                milliseconds: 300
            ),
            child:Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                      offset: Offset(2,5),
                      color: Color(0x0C000000),
                      blurRadius:width(6,),),
                    BoxShadow(
                      offset: Offset(-5,1),
                      color: Color(0x0C000000),
                      blurRadius:width(6,),
                    )
                  ],
                  borderRadius: BorderRadius.circular(width(7))
              ),
              margin: EdgeInsets.only(bottom: height(8),left: width(10),right: width(10),),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: height(35),
                    padding: EdgeInsets.only(left: width(13),right: width(13)),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        Text("伤停信息",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: sp(15)),),
                        Expanded(
                          child: SizedBox(),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(width(5)),
                            child:  SPClassEncryptImage.asset(
                              spProShowJury? SPClassImageUtil.spFunGetImagePath("ic_down_arrow"):SPClassImageUtil.spFunGetImagePath("ic_up_arrow"),
                              width: width(13),
                            ),
                          ),
                          onTap: (){
                            setState(() {spProShowJury=!spProShowJury;});
                          },
                        )
                      ],
                    ),
                  ),
                  (  spProMatchInjuryEntity==null||!spProShowJury)? SizedBox():Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(top: height(8),bottom: height(8),left: width(17)),
                                color: Color(0xFFF9F9F9),
                                child: Text("球员",style: GoogleFonts.notoSansSC(textStyle: TextStyle(fontSize: sp(12),fontWeight: FontWeight.w500)),),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                                color: Color(0xFFF9F9F9),
                                child: Text("伤停原因",style: GoogleFonts.notoSansSC(textStyle: TextStyle(fontSize: sp(12),fontWeight: FontWeight.w500)),),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(width(13)),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Row(
                                children: <Widget>[
                                  ( widget.spProGuessInfo.spProIconUrlOne.isEmpty)? SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                                    width: width(20),
                                  ):Image.network(
                                    widget.spProGuessInfo.spProIconUrlOne,
                                    width: width(20),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(widget.spProGuessInfo.spProTeamOne,style: TextStyle(fontSize: sp(12)),)
                                ],

                              ),),
                            ],
                          ),
                        ),
                        spProMatchInjuryEntity.spProMatchInjury.one==null ? SizedBox():  ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: width(18),right: width(18)),
                            shrinkWrap: true,
                            itemCount: spProMatchInjuryEntity.spProMatchInjury.one.length,
                            itemBuilder: (c,index){
                              var item =spProMatchInjuryEntity.spProMatchInjury.one[index];
                              return  Container(
                                padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[300],width: 0.4))
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFFDE3C31)
                                          ),
                                          child: Text(item.spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                        SizedBox(width: 3,),
                                        Text(item.spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),)
                                      ],
                                    ),),
                                    Expanded(child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(item.reason,maxLines: 1,style:TextStyle(fontSize: sp(12)),),

                                      ],
                                    )),
                                  ],
                                ),
                              );
                            }),

                        spProMatchInjuryEntity.spProMatchInjury.two==null ?  SizedBox():   Container(
                          padding: EdgeInsets.all(width(13)),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Row(
                                children: <Widget>[
                                  ( widget.spProGuessInfo.spProIconUrlTwo.isEmpty)? SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                                    width: width(20),
                                  ):Image.network(
                                    widget.spProGuessInfo.spProIconUrlTwo,
                                    width: width(20),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(widget.spProGuessInfo.spProTeamTwo,style: TextStyle(fontSize: sp(12)),)
                                ],

                              ),),
                            ],
                          ),
                        ),
                        spProMatchInjuryEntity.spProMatchInjury.two==null ? SizedBox():      ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: width(18),right: width(18)),
                            shrinkWrap: true,
                            itemCount: spProMatchInjuryEntity.spProMatchInjury.two.length,
                            itemBuilder: (c,index){
                              var item =spProMatchInjuryEntity.spProMatchInjury.two[index];
                              return  Container(
                                padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[300],width: 0.4))
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFF5D9CEC)
                                          ),
                                          child: Text(item.spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                        SizedBox(width: 3,),
                                        Text(item.spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),)
                                      ],
                                    ),),
                                    Expanded(child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(item.reason,maxLines: 1,style:TextStyle(fontSize: sp(12)),),

                                      ],
                                    )),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),),


                ],

              ),
            ) ,
          ),

          spProMatchIntelligenceItemOne==null? SizedBox():  AnimatedSize(
            vsync: this,
            duration: Duration(
                milliseconds: 300
            ),
            child:Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                      offset: Offset(2,5),
                      color: Color(0x0C000000),
                      blurRadius:width(6,),),
                    BoxShadow(
                      offset: Offset(-5,1),
                      color: Color(0x0C000000),
                      blurRadius:width(6,),
                    )
                  ],
                  borderRadius: BorderRadius.circular(width(7))
              ),
              margin: EdgeInsets.only(left: width(10),right: width(10),top: width(10)),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(width(6)),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.4,color: Color(0xFFDDDDDD)))
                    ),
                    width: ScreenUtil.screenWidth,
                    alignment: Alignment.center,
                    child: Text(widget.spProGuessInfo.spProTeamOne,style: GoogleFonts.notoSansSC(fontSize: sp(16),fontWeight: FontWeight.w500),),
                  ),
                  Container(
                    width: ScreenUtil.screenWidth,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: height(13),bottom:  height(13),left:  width(25),right: width(25)),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.4,color: Color(0xFFDDDDDD)))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("阵容",style: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w500,textStyle: TextStyle(color: Color(0xFFDE3C31))),),
                              SizedBox(height: height(6),),
                              Text(spProMatchIntelligenceItemOne.information,style: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w400,textStyle: TextStyle(color: Color(0xFF333333))),),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: height(13),bottom:  height(13),left:  width(25),right: width(25)),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.4,color: Color(0xFFDDDDDD)))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("状态",style: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w500,textStyle: TextStyle(color: Color(0xFFDE3C31))),),
                              SizedBox(height: height(6),),
                              Text("${spProMatchIntelligenceItemOne.status}",style: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w400,textStyle: TextStyle(color: Color(0xFF333333))),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:(spProMatchIntelligenceItemOne==null)? EdgeInsets.all(width(5)):null,
                    child:(spProMatchIntelligenceItemOne==null)? Text("暂无数据",style: TextStyle(color: Color(0xFF999999)),):SizedBox(),
                  )
                ],

              ),
            ) ,
          ),

          spProMatchIntelligenceItemTwo==null? SizedBox():AnimatedSize(
            vsync: this,
            duration: Duration(
                milliseconds: 300
            ),
            child:Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                      offset: Offset(2,5),
                      color: Color(0x0C000000),
                      blurRadius:width(6,),),
                    BoxShadow(
                      offset: Offset(-5,1),
                      color: Color(0x0C000000),
                      blurRadius:width(6,),
                    )
                  ],
                  borderRadius: BorderRadius.circular(width(7))
              ),
              margin: EdgeInsets.only(left: width(10),right: width(10),top: width(10)),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(width(6)),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.4,color: Color(0xFFDDDDDD)))
                    ),
                    width: ScreenUtil.screenWidth,
                    alignment: Alignment.center,
                    child: Text(widget.spProGuessInfo.spProTeamTwo,style: GoogleFonts.notoSansSC(fontSize: sp(16),fontWeight: FontWeight.w500),),
                  ),
                  Container(
                    width: ScreenUtil.screenWidth,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: height(13),bottom:  height(13),left:  width(25),right: width(25)),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.4,color: Color(0xFFDDDDDD)))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("阵容",style: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w500,textStyle: TextStyle(color: Color(0xFFDE3C31))),),
                              SizedBox(height: height(6),),
                              Text("${spProMatchIntelligenceItemTwo.information}",style: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w400,textStyle: TextStyle(color: Color(0xFF333333))),),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: height(13),bottom:  height(13),left:  width(25),right: width(25)),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.4,color: Color(0xFFDDDDDD)))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("状态",style: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w500,textStyle: TextStyle(color: Color(0xFFDE3C31))),),
                              SizedBox(height: height(6),),
                              Text("${spProMatchIntelligenceItemTwo.status}",style: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w400,textStyle: TextStyle(color: Color(0xFF333333))),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:(spProMatchIntelligenceItemTwo==null)? EdgeInsets.all(width(5)):null,
                    child:(spProMatchIntelligenceItemTwo==null)? Text("暂无数据",style: TextStyle(color: Color(0xFF999999)),):SizedBox(),
                  )
                ],

              ),
            ) ,
          ),
        ],
      ),
    );
  }

  void spFunSortMatchEvent() {
    var eventList= List<SPClassMatchEventMatchEventItem>();

    spProOrgMatchEventList.forEach((item){
      spProEventTitles.forEach((tile){
        if(item.spProEventName.contains(tile)){
          item.spProEventImage=spProEventImages[spProEventTitles.indexOf(tile)];
        }
      });
      eventList.add(item);
    });
    eventList.sort((left,right)=>double.parse(left.spProSeqNum).compareTo(double.parse(right.spProSeqNum)));
    eventList.forEach((item) {
      spFunInitMatchEventText(item);
    });
    eventList.sort((left,right)=>double.parse(right.spProSeqNum).compareTo(double.parse(left.spProSeqNum)));

    var fisrtItem=SPClassMatchEventMatchEventItem()
      ..content="大家好，欢迎来到红胜体育观看本场直播，比赛即将开始"
      ..time="-"
      ..spProEventImage="ic_match_live_whistle";
    eventList.add(fisrtItem);

    if(widget.spProGuessInfo.status=="over"){
      var endItem=SPClassMatchEventMatchEventItem()
        ..content=sprintf(
            "随着裁判一声哨响，本场比赛结束，总比分%s-%s，感谢大家关注红胜体育，下次再会！",
            [
              widget.spProGuessInfo.spProScoreOne,
              widget.spProGuessInfo.spProScoreTwo,
            ]
        )
        ..time="-"
        ..spProEventImage="ic_match_live_whistle"
        ..spProTeamOneScore=widget.spProGuessInfo.spProScoreOne
        ..spProTeamTwoScore=widget.spProGuessInfo.spProScoreTwo;
      eventList.insert(0,endItem);
    }
    setState(() {
      spProMatchEventList=eventList;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void spFunDownCount() {

    if(widget.spProGuessInfo.status=="in_progress"){
      spProTimer=  Timer.periodic(Duration(seconds: 1), (timer){
        if(spProTimer==null){
          timer.cancel();
        }else{
          spFunRefreshTimer();
        }
      });
    }else{

    }


  }

  void spFunRefreshTimer() {

    DateTime nowTime= DateTime.now();

    Duration duration =DateTime.parse(widget.spProGuessInfo.spProStTime).difference(nowTime);

    hour=(duration.inHours);
    minute=(duration.inMinutes-((duration.inHours*60)));
    second=(duration.inSeconds-(duration.inMinutes*60));

    if(hour<=0&&minute<=0&&second<=0){
      spProTimer.cancel();
      this.spProTimer=null;
      spFunGetMatchEvent("");
    }
    if(mounted){
      setState(() {

      });
    }
  }

  void spFunGetMatchEvent(String refSeqNum) async{

    if(spProIsDispose){
      return;
    }
    SPClassApiManager.spFunGetInstance().spFunMatchEvent<SPClassMatchEventEntity>(context: context,spProGuessMatchId:widget.spProGuessInfo.spProGuessMatchId,refSeqNum: refSeqNum,spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (result) async{
          spProIsLoading=false;
          if(result.spProMatchEvent!=null&&result.spProMatchEvent.length>0){
            spProOrgMatchEventList.addAll(result.spProMatchEvent);
          }else{
            if(result.spProGuessMatch.spProIsOver=="1"){

            }
          }

          if(result.spProGuessMatch!=null){
            if(result.spProGuessMatch.spProIsRealtimeOver=="0"){
              await Future.delayed(Duration(seconds: 3),(){
                spFunGetMatchEvent(spProOrgMatchEventList.length==0? "":spProOrgMatchEventList[spProOrgMatchEventList.length-1].spProSeqNum);
              });
              widget.spProGuessInfo.status="in_progress";
            }else{
              widget.spProGuessInfo.status="over";
            }
            widget.spProGuessInfo.spProScoreTwo=result.spProGuessMatch.spProScoreTwo;
            widget.spProGuessInfo.spProScoreOne=result.spProGuessMatch.spProScoreOne;
            widget.spProGuessInfo.spProStatusDesc=result.spProGuessMatch.spProStatusDesc;
            if(widget.callback!=null){
              widget.callback(widget.spProGuessInfo);
            }
          }

          if(spProOrgMatchEventList.length>0|| widget.spProGuessInfo.status=="in_progress"){
            spFunSortMatchEvent();
          }
          setState(() {});
        },
        onError: (result) async{
          spProIsLoading=false;
          setState(() {});
          if(spProOrgMatchEventList.length>0||widget.spProGuessInfo.status=="in_progress"){
            await Future.delayed(Duration(seconds: 1),(){
              spFunGetMatchEvent(spProOrgMatchEventList.length==0? "":spProOrgMatchEventList[spProOrgMatchEventList.length-1].spProSeqNum);
            });
          }
        }
    ));
  }

  String spFunFindMatchStat(String type, int i) {


    var item= spProMatchStatList.firstWhere((item) =>(item.spProStatType==type),orElse:()=>null );
    if(item!=null){
      if(i==1){
        return item.spProTeamOneVal;
      }
      if(i==2){
        return item.spProTeamTwoVal;
      }
    }

    return "0";
  }

  double spFunFindMatchStatCalc(String type, int i) {


    var item= spProMatchStatList.firstWhere((item) =>(item.spProStatType==type),orElse:()=>null );
    if(item!=null){
      if(i==1){
        if(item.spProTeamOneVal=="0"){
          return 0;
        }
        return double.tryParse(item.spProTeamOneVal)/(double.tryParse(item.spProTeamOneVal)+double.tryParse(item.spProTeamTwoVal));
      }
      if(i==2){
        if(item.spProTeamTwoVal=="0"){
          return 0;
        }
        return double.tryParse(item.spProTeamTwoVal)/(double.tryParse(item.spProTeamOneVal)+double.tryParse(item.spProTeamTwoVal));
      }
    }


    return 0;
  }

   spFunInitMatchEventText(SPClassMatchEventMatchEventItem item) {

    if(item!=null&&item.content.isEmpty){
      item.content=item.spProEventName;
      item.spProTeamOneScore = spProGoalScoreOne.toString();
      item.spProTeamTwoScore = spProGoalScoreTwo.toString();
       if(item.spProEventName=="入球"){
         if(item.spProWhichTeam=="1"){
           spProGoalScoreOne++;
           item.spProTeamOneScore=spProGoalScoreOne.toString();
         }
         if(item.spProWhichTeam=="2"){
           spProGoalScoreTwo++;
           item.spProTeamTwoScore=spProGoalScoreTwo.toString();
         }
         item.content= sprintf("%s进球啦，这是本场比赛的第%d个进球",
             [
               (item.spProWhichTeam=="1" ? widget.spProGuessInfo.spProTeamOne:widget.spProGuessInfo.spProTeamTwo),
               ( spProGoalScoreOne+spProGoalScoreTwo),

             ]);
       }

       if(item.spProEventName=="角球"){
         if(item.spProWhichTeam=="1"){
           spProCornerScoreOne++;
         }
         if(item.spProWhichTeam=="2"){
           spProCornerScoreTwo++;
         }
         item.content= sprintf("%s获得了本场的第%s个角球",
             [
               (item.spProWhichTeam=="1" ? widget.spProGuessInfo.spProTeamOne:widget.spProGuessInfo.spProTeamTwo),
               (item.spProWhichTeam=="1" ? spProCornerScoreOne.toString():spProCornerScoreTwo.toString()),

             ]);
       }

       if(item.spProEventName=="点球"){
         if(item.spProWhichTeam=="1"){
           spProPenalScoreOne++;
         }
         if(item.spProWhichTeam=="2"){
           spProPenalScoreTwo++;
         }
         item.content= sprintf("裁判吹罚,%s获得了点球机会，这是本场比赛的第%s个点球",
             [
               (item.spProWhichTeam=="1" ? widget.spProGuessInfo.spProTeamOne:widget.spProGuessInfo.spProTeamTwo),
               (item.spProWhichTeam=="1" ? spProPenalScoreOne.toString():spProPenalScoreTwo.toString()),

             ]);
       }

       if(item.spProEventName=="射失点球"){

         item.content= sprintf("%s点球没劲，可惜了！",
             [
               (item.spProPlayerName.isNotEmpty ? item.spProPlayerName:(item.spProWhichTeam=="1" ? widget.spProGuessInfo.spProTeamOne:widget.spProGuessInfo.spProTeamTwo)),
             ]);
       }

       if(item.spProEventName=="乌龙"){
         if(item.spProWhichTeam=="1"){
           spProMistakeScoreOne++;
         }
         if(item.spProWhichTeam=="2"){
           spProMistakeScoreTwo++;
         }
         item.content= sprintf("哎呀！,%s出现乌龙球，这是本场比赛的第%s个乌龙球",
             [
               (item.spProWhichTeam=="1" ? widget.spProGuessInfo.spProTeamOne:widget.spProGuessInfo.spProTeamTwo),
               (item.spProWhichTeam=="1" ? spProMistakeScoreOne.toString():spProMistakeScoreTwo.toString()),

             ]);
       }

       if(item.spProEventName=="黄牌"){
         var keyOne = item.spProEventName;
         var keyTwo = item.spProEventName;
         if (item.spProWhichTeam == "1") {
           if (!spProEventRecords.containsKey(keyOne)) {
             spProEventRecords[keyOne] = 0;
           }
           spProEventRecords[keyOne] = spProEventRecords[keyOne] + 1;
         }
         if (item.spProWhichTeam == "2") {
           if (!spProEventRecords.containsKey(keyTwo)) {
             spProEventRecords[keyTwo] = 0;
           }
           spProEventRecords[keyTwo] = spProEventRecords[keyTwo] + 1;
         }
         item.content= sprintf("裁判出示了第%s张黄牌，%s",
             [
               (item.spProWhichTeam=="1" ? spProEventRecords[keyOne].toString(): spProEventRecords[keyTwo].toString()),
               ("给了"+(item.spProPlayerName.isEmpty?
               (item.spProWhichTeam == "1"? widget.spProGuessInfo.spProTeamOne:widget.spProGuessInfo.spProTeamTwo):
               (item.spProPlayerName))),

             ]);
       }

       if(item.spProEventName=="红牌"){
        var keyOne = item.spProEventName;
        var keyTwo = item.spProEventName;
        if (item.spProWhichTeam == "1") {
          if (!spProEventRecords.containsKey(keyOne)) {
            spProEventRecords[keyOne] = 0;
          }
          spProEventRecords[keyOne] = spProEventRecords[keyOne] + 1;
        }
        if (item.spProWhichTeam == "2") {
          if (!spProEventRecords.containsKey(keyTwo)) {
            spProEventRecords[keyTwo] = 0;
          }
          spProEventRecords[keyTwo] = spProEventRecords[keyTwo] + 1;
        }


        item.content= sprintf("裁判出示了第%s张红牌，%s",
            [
              (item.spProWhichTeam=="1" ? spProEventRecords[keyOne].toString(): spProEventRecords[keyTwo].toString()),
              ("给了"+(item.spProPlayerName.isEmpty?
              (item.spProWhichTeam == "1"? widget.spProGuessInfo.spProTeamOne:widget.spProGuessInfo.spProTeamTwo):
              (item.spProPlayerName))),
            ]);
      }

      if(item.spProEventName=="两黄变红"){
        var keyOne = "黄牌" ;
        var keyTwo = "黄牌" ;
        if (item.spProWhichTeam == "1") {
          if (!spProEventRecords.containsKey(keyOne)) {
            spProEventRecords[keyOne] = 0;
          }
          spProEventRecords[keyOne] = spProEventRecords[keyOne] + 1;
        }
        if (item.spProWhichTeam == "2") {
          if (!spProEventRecords.containsKey(keyTwo)) {
            spProEventRecords[keyTwo] = 0;
          }
          spProEventRecords[keyTwo] = spProEventRecords[keyTwo] + 1;
        }
        item.content= sprintf("裁判出示了第%s张黄牌，还是给了%s,%s被罚下",
            [
              (item.spProWhichTeam=="1" ? spProEventRecords[keyOne].toString(): spProEventRecords[keyTwo].toString()),
              (item.spProPlayerName),
              (item.spProPlayerName),

            ]);
      }

      if(item.spProEventName=="换人"){
        if (item.spProWhichTeam == "1") {
        }
        if (item.spProWhichTeam == "2") {
        }
        item.content= sprintf("比赛暂停,%s换人(%s)",
            [
              (item.spProWhichTeam=="1" ? widget.spProGuessInfo.spProTeamOne: widget.spProGuessInfo.spProTeamTwo),
              (item.spProPlayerName),
            ]);
      }
    }
  }

  spFunLineUpString(String spProTeamOneLineup) {
    List<String> list=[];
    for(var i=0;i<spProTeamOneLineup.length;i++){
      list.add(spProTeamOneLineup.substring(i,i+1));
    }
    return JsonEncoder().convert(list).replaceAll("[", "").replaceAll("]", "").replaceAll(",", "-").replaceAll("\"", "");

  }

  spFunBuildLineUpTeam() {
    List<Widget> views=[];

    views.add(SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_football_place"),height: width(217),fit: BoxFit.fitHeight,));
    views.add(Positioned(
      left: width(10),
      child:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_footer_one"),width: width(18)),
    ));
    views.add( Positioned(
      right: width(10),
      child:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_footer_two"),width: width(18)),
    ));
    views.add(Positioned(
      left: width(10),
      bottom: width(5),
      child:Text(spFunLineUpString(spProMatchLineupEntity.spProMatchLineup[0].spProTeamOneLineup),style: TextStyle(fontSize: width(12)),),
    ));
    views.add(Positioned(
      right: width(10),
      bottom: width(5),
      child:Text(spFunLineUpString(spProMatchLineupEntity.spProMatchLineup[0].spProTeamTwoLineup),style: TextStyle(fontSize: width(12)),),
    ));

    views.add(Positioned(
      left: width(35),
      child: Container(
          width: width(110),
          height: width(163),
          child: spFunBuildLineUpTeamRow(spProMatchLineupEntity.spProMatchLineup[0].spProTeamOneLineup,"ic_footer_one")),
    ),
    );
    views.add(Positioned(
      right: width(35),
      child: Container(
          width: width(110),
          height: width(163),
          child: spFunBuildLineUpTeamRow(spFunReverseString(spProMatchLineupEntity.spProMatchLineup[0].spProTeamTwoLineup),"ic_footer_two")),
    ),
    );


    return views;
  }

  spFunBuildLineUpTeamRow(spProTeamOneLineup,imageName) {
    List<String> list=[];
    for(var i=0;i<spProTeamOneLineup.length;i++){
      list.add(spProTeamOneLineup.substring(i,i+1));
    }
    return  Row(
      children: list.map((item){
        return Expanded(
            child: Column(
              children: List<int>(int.parse(item)).map((ren){
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath(imageName.toString()),width: width(18)),
                  ),
                );
              }).toList(),
            ));
      }).toList(),
    );
  }

  spFunReverseString(String spProTeamTwoLineup) {
    var result ="";
    for(var i=spProTeamTwoLineup.length-1;i>=0;i--){
      result=result+spProTeamTwoLineup.substring(i,i+1);
    }
    return result;

  }
}



