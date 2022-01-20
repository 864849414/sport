import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassAnylizeMatchList.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassChartDoughnutData.dart';
import 'package:sport/model/SPClassForecast.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/pages/dialogs/SPClassForcecastRuluDialog.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassListUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/pages/common/SPClassLoadingPage.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/colors.dart';
import 'package:sprintf/sprintf.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SPClassMatchAnylizePage extends StatefulWidget{
  Map<String,dynamic> params;
  SPClassGuessMatchInfo spProGuessMatch;
  SPClassMatchAnylizePage(this.params,this.spProGuessMatch);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMatchAnylizePageState();
  }

}

class SPClassMatchAnylizePageState extends State<SPClassMatchAnylizePage> with AutomaticKeepAliveClientMixin,TickerProviderStateMixin{
  SPClassAnylizeMatchList spProAnylizeMatchList;
  int spProHistoryIndex=0;
  int spProHistoryOneIndex=0;
  int spProHistoryTwoIndex=0;

  var spProPointsKey="总";
  List<SPClassTeamPointsList> spProTeamPointsList=[];//积分排名

  var spProHistoryKey="全部";
  List<SPClassEntityHistory> spProHistoryList= List();//对赛往绩

  var spProHistoryOneKey="全部";
  List<SPClassEntityHistory> spProHistoryOne= List();//近期战绩

  var spProHistoryTwoKey="全部";
  List<SPClassEntityHistory> spProHistoryTwo= List();//近期战绩 客队


  List<SPClassEntityHistory> spProFutureListOne=[];//未来赛事
  List<SPClassEntityHistory> spProFutureListTwo=[];//未来赛事


  var spProIsLoading=true;

  SPClassForecast spProForecastInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SPClassApiManager().spFunMatchAnalyse(queryParameters: widget.params,spProCallBack: SPClassHttpCallBack<SPClassAnylizeMatchList>(
      spProOnSuccess: (list){
        spProAnylizeMatchList=list;
        spProIsLoading=false;
        if(spProAnylizeMatchList!=null){

          spFunInitPointData();
          if(spProAnylizeMatchList.history!=null&&spProAnylizeMatchList.history.length>0){
            spProHistoryList.clear();
            spProHistoryList.addAll(spProAnylizeMatchList.history);
          }
          if(spProAnylizeMatchList.spProTeamOneHistory!=null&&spProAnylizeMatchList.spProTeamOneHistory.length>0){
            spProHistoryOne.addAll(spProAnylizeMatchList.spProTeamOneHistory);
          }
          if(spProAnylizeMatchList.spProTeamTwoHistory!=null&&spProAnylizeMatchList.spProTeamTwoHistory.length>0){
            spProHistoryTwo.addAll(spProAnylizeMatchList.spProTeamTwoHistory);
          }
          spFunInitFutureList();
        }


        setState(() {
        });

      },
      onError: (e){
        spProIsLoading=false;
        setState(() {
        });
      }
    ));

 //   getForecastInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Visibility(
      child: SingleChildScrollView(
        child: Column(
          children: [

            // SizedBox(height:width(10)),

//            预测
            calculate(),

            // 暂无数据
            Visibility(
              child: SPClassNoDataView(height:width(400),),
              visible:(SPClassListUtil.spFunIsEmpty(spProTeamPointsList)
                  && SPClassListUtil.spFunIsEmpty(spProHistoryList)
                  && SPClassListUtil.spFunIsEmpty(spProHistoryOne)
                  && SPClassListUtil.spFunIsEmpty(spProHistoryTwo)
                  && SPClassListUtil.spFunIsEmpty(spProFutureListOne)
                  && SPClassListUtil.spFunIsEmpty(spProFutureListTwo)
                  && SPClassListUtil.spFunIsEmpty(spProFutureListTwo)
                  && (spProForecastInfo==null)
              ),
            ),

//            能力对比
            ability(),
            myDivider(),
//        积分排名
            scoreRanking(),
//            历史战绩
            history(),

            // 近期战绩
            recentAchievements(),

            // 未来赛事
            future()


          ],
        ),
      ),
      visible: !spProIsLoading,
      replacement: SPClassLoadingPage(),

    );
  }
  
//  预测
  Widget calculate(){
    return Visibility(
      child: Stack(
        alignment:Alignment.topCenter,
        children: <Widget>[
          Container(
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
              borderRadius: BorderRadius.circular(width(7)),
            ),
            margin: EdgeInsets.only(left: width(10),right: width(10),top: width(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: width(30),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(spFunGetSupportRate(1),style: TextStyle(fontSize: sp(10)),),
                        SizedBox(height: width(5),),
                        AnimatedSize(
                          vsync: this,
                          duration: Duration(
                              milliseconds: 300
                          ),
                          child: Container(
                            width: width(27),
                            height: spFunGetForecastHeight(1),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [spFunGetUserSupport(1),0.0],
                                    colors: [
                                      Color(0xFFF14B0B),
                                      Color(0xFFF1150B),
                                    ]
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: width(5),),
                        Text("主胜",style: TextStyle(fontSize: sp(12)),),

                        GestureDetector(
                          child: Container(
                            decoration: (spProForecastInfo!=null
                                &&spProForecastInfo.spProSupportWhich!=null
                                &&spProForecastInfo.spProSupportWhich=="1"
                            )?BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x66FF9613).withOpacity(0.1),
                                      offset: Offset(5,1),
                                      blurRadius: width(10)
                                  )
                                ]
                            ):null,
                            padding: EdgeInsets.all(width(8)),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath(
                                  (spProForecastInfo!=null
                                      &&spProForecastInfo.spProSupportWhich!=null
                                      &&spProForecastInfo.spProSupportWhich=="1"
                                  )?
                                  "ic_forecast_gooded":"ic_forecast_good"),
                              width: width(16),
                            ),
                          ),
                          onTap: (){
                            spFunSupportForecast("1");
                          },
                        )
                      ],
                    ),

                    SizedBox(width: width(67),),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(spFunGetSupportRate(0),style: TextStyle(fontSize: sp(10)),),
                        SizedBox(height: width(5),),
                        AnimatedSize(
                          vsync: this,
                          duration: Duration(
                              milliseconds: 300
                          ),
                          child: Container(
                            width: width(27),
                            height: spFunGetForecastHeight(0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [spFunGetUserSupport(0),0.0],
                                    colors: [
                                      Color(0xFFB1B1B1),
                                      Color(0x91030000),

                                    ]
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: width(5),),
                        Text("平局",style: TextStyle(fontSize: sp(12)),),

                        GestureDetector(
                          child: Container(
                            decoration: (spProForecastInfo!=null
                                &&spProForecastInfo.spProSupportWhich!=null
                                &&spProForecastInfo.spProSupportWhich=="0"
                            )?BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x66FF9613).withOpacity(0.1),
                                      offset: Offset(5,1),
                                      blurRadius: width(10)
                                  )
                                ]
                            ):null,
                            padding: EdgeInsets.all(width(8)),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath(
                                  (spProForecastInfo!=null
                                      &&spProForecastInfo.spProSupportWhich!=null
                                      &&spProForecastInfo.spProSupportWhich=="0"
                                  )?
                                  "ic_forecast_gooded":"ic_forecast_good"),
                              width: width(16),
                            ),
                          ),
                          onTap: (){
                            spFunSupportForecast("0");
                          },
                        )
                      ],
                    ),

                    SizedBox(width: width(67),),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(spFunGetSupportRate(2),style: TextStyle(fontSize: sp(10)),),
                        SizedBox(height: width(5),),
                        AnimatedSize(
                          vsync: this,
                          duration: Duration(
                              milliseconds: 300
                          ),
                          child: Container(
                            width: width(27),
                            height: spFunGetForecastHeight(2),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [spFunGetUserSupport(2),0.0],
                                    colors: [
                                      Color(0xFF2CDDFF),
                                      Color(0xFF1489FA),

                                    ]
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: width(5),),
                        Text("客胜",style: TextStyle(fontSize: sp(12)),),

                        GestureDetector(
                          child: Container(
                            decoration: (spProForecastInfo!=null
                                &&spProForecastInfo.spProSupportWhich!=null
                                &&spProForecastInfo.spProSupportWhich=="2"
                            )?BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x66FF9613).withOpacity(0.1),
                                      offset: Offset(5,1),
                                      blurRadius: width(10)
                                  )
                                ]
                            ):null,
                            padding: EdgeInsets.all(width(8)),
                            child: SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath(
                                  (spProForecastInfo!=null
                                      &&spProForecastInfo.spProSupportWhich!=null
                                      &&spProForecastInfo.spProSupportWhich=="2"
                                  )?
                                  "ic_forecast_gooded":"ic_forecast_good"),
                              width: width(16),
                            ),
                          ),
                          onTap: (){
                            spFunSupportForecast("2");
                          },
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: width(10),),

              ],

            ),
          ),
          Positioned(
            top: width(10),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                SPClassEncryptImage.asset(
                  SPClassImageUtil.spFunGetImagePath("bg_title_forecast"),
                  width: width(124),
                ),
                Text("全民预测",style: TextStyle(color: Colors.white,fontSize: sp(16),fontWeight: FontWeight.bold),),
              ],
            ),
          ),

          Positioned(
            top: width(15),
            right: width(25),
            child:  GestureDetector(
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text("?",style: TextStyle(color: Colors.white,fontSize: sp(8)),),
                    width: width(16),
                    height: width(16),
                    decoration: BoxDecoration(
                        color: Color(0xFFB5B5B5),
                        shape: BoxShape.circle
                    ),
                  ),
                ],
              ),
              onTap: (){
                showDialog(context: context, builder: (c)=>SPClassForcecastRuluDialog());
              },
            ),
          )

        ],
      ),
      visible: (spProForecastInfo!=null),
    );
  }

//  能力对比
  Widget ability(){
    return Visibility(
      child: AnimatedSize(
        vsync: this,
        duration: Duration(
            milliseconds: 300
        ),
        child:Container(
              color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Stack(
              //   alignment: Alignment.center,
              //   children: <Widget>[
              //     SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_match_statc_title"),width: width(319),),
              //     Text("能力对比",style: TextStyle(fontSize: sp(16),fontWeight: FontWeight.bold),)
              //   ],
              // ),
              ///近期战绩
              (spFunGetMatchAllPointsScore(1,"全部")+spFunGetMatchAllPointsScore(2,"全部")==0) ?SizedBox():Container(
                padding: EdgeInsets.symmetric(horizontal: width(15),vertical: width(20)),
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(sprintf("%d胜%d平%d负",
                          [
                            spFunGetMatchCount(spFunGetHistoryOneList("全部").take(spFunGetMinListLength("全部")).toList(), 1),
                            spFunGetMatchCount(spFunGetHistoryOneList("全部").take(spFunGetMinListLength("全部")).toList(), 0),
                            spFunGetMatchCount(spFunGetHistoryOneList("全部").take(spFunGetMinListLength("全部")).toList(), 2),
                          ]
                      ),
                        style: TextStyle(fontSize: sp(15),color: Color(0xFF333333),fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text("近期战绩",
                        style: TextStyle(fontSize: sp(12)),textAlign: TextAlign.center,),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(sprintf("%d胜%d平%d负",
                          [
                            spFunGetMatchCount(spFunGetHistoryTwoList("全部").take(spFunGetMinListLength("全部")).toList(), 1,winTeam: 2),
                            spFunGetMatchCount(spFunGetHistoryTwoList("全部").take(spFunGetMinListLength("全部")).toList(), 0,winTeam: 2),
                            spFunGetMatchCount(spFunGetHistoryTwoList("全部").take(spFunGetMinListLength("全部")).toList(), 2,winTeam: 2),
                          ]
                      ),
                        style: TextStyle(fontSize: sp(15),color: Color(0xFF333333),fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              (spFunGetHistoryOneList("同主客").take(spFunGetMinListLength("同主客")).toList().length==0)?SizedBox():Container(
                padding: EdgeInsets.symmetric(horizontal: width(15),vertical: width(20)),
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(sprintf("%d胜%d平%d负",
                          [
                            spFunGetMatchCount(spFunGetHistoryOneList("同主客").take(spFunGetMinListLength("同主客")).toList(), 1),
                            spFunGetMatchCount(spFunGetHistoryOneList("同主客").take(spFunGetMinListLength("同主客")).toList(), 0),
                            spFunGetMatchCount(spFunGetHistoryOneList("同主客").take(spFunGetMinListLength("同主客")).toList(), 2),
                          ]
                      ),
                        style: TextStyle(fontSize: sp(15),color: Color(0xFF333333),fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text("近期战绩",
                        style: TextStyle(fontSize: sp(12)),textAlign: TextAlign.center,),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(sprintf("%d胜%d平%d负",
                          [
                            spFunGetMatchCount(spFunGetHistoryTwoList("同主客").take(spFunGetMinListLength("同主客")).toList(), 1,winTeam: 2),
                            spFunGetMatchCount(spFunGetHistoryTwoList("同主客").take(spFunGetMinListLength("同主客")).toList(), 0,winTeam: 2),
                            spFunGetMatchCount(spFunGetHistoryTwoList("同主客").take(spFunGetMinListLength("同主客")).toList(), 2,winTeam: 2),
                          ]
                      ),
                        style: TextStyle(fontSize: sp(15),color: Color(0xFF333333),fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ///能力指数
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          width: width(62),
                          child: Text((
                              spFunGetMatchAllPointsScore(1,"全部")
                                  +spFunGetMatchAllPointsScore(1,"同主客")
                                  +spFunAvgWinOrLose25Score(true,1)
                                  +spFunAvgWinOrLose25Score(false,1)
                          ).toStringAsFixed(0),
                            style: TextStyle(fontSize: sp(12),color: Color(0xFF333333)),
                          ),
                        ),
                        SizedBox(width: width(8),),
                        Expanded(
                          child:  Row(
                            children: <Widget>[
                              Expanded(
                                flex:(spFunGetMatchAllPointsScore(1,"全部")+
                                    spFunGetMatchAllPointsScore(1,"同主客")+
                                    spFunAvgWinOrLose25Score(true,1)+
                                    spFunAvgWinOrLose25Score(false,1)).toInt(),

                                child: Container(
                                  margin: EdgeInsets.only(right: 2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: MyColors.main1,
                                      borderRadius: BorderRadius.horizontal(left:Radius.circular(300) )
                                  ),
                                  height: width(7),
                                ),
                              ),
                              Expanded(
                                flex:(spFunGetMatchAllPointsScore(2,"全部")+
                                    spFunGetMatchAllPointsScore(2,"同主客")+
                                    spFunAvgWinOrLose25Score(true,2)+
                                    spFunAvgWinOrLose25Score(false,2)).toInt() ,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFF5F40),
                                      borderRadius: BorderRadius.horizontal(right:Radius.circular(300) )
                                  ),
                                  alignment: Alignment.center,
                                  height: width(7),
                                ),
                              ),
                            ],
                          ),
                        ) ,
                        SizedBox(width: width(8),),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: width(62),
                          child: Text((
                              spFunGetMatchAllPointsScore(2,"全部")
                                  +spFunGetMatchAllPointsScore(2,"同主客")
                                  +spFunAvgWinOrLose25Score(true,2)
                                  +spFunAvgWinOrLose25Score(false,2)
                          ).toStringAsFixed(0),
                            style: TextStyle(fontSize: sp(12),color: Color(0xFF333333)),
                          ),
                        ),
                      ],
                    ),
                    Text("能力指数",
                      style: TextStyle(fontSize: sp(12)),),
                    SizedBox(height: width(8),),
                  ],
                ),
              ),
              ///场均进球
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          width: width(62),
                          child: Text(sprintf("%s",
                              [
                                SPClassStringUtils.spFunSqlitZero(spFunAvgWinOrLoseScoreOne(true).toStringAsFixed(2))
                              ]
                          ),
                            style: TextStyle(fontSize: sp(12),color: Color(0xFF333333)),
                          ),
                        ),
                        SizedBox(width: width(8),),
                        Expanded(
                          child:  Row(
                            children: <Widget>[
                              Expanded(
                                flex:(spFunAvgWinOrLoseScoreOne(true)*100).toInt() ,

                                child: Container(
                                  margin: EdgeInsets.only(right: 2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: MyColors.main1,
                                      borderRadius: BorderRadius.horizontal(left:Radius.circular(300) )
                                  ),
                                  height: width(7),
                                ),
                              ),
                              Expanded(
                                flex:(spFunAvgWinOrLoseScoreTwo(true)*100).toInt() ,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFF5F40),
                                      borderRadius: BorderRadius.horizontal(right:Radius.circular(300) )
                                  ),
                                  alignment: Alignment.center,
                                  height: width(7),
                                ),
                              ),
                            ],
                          ),
                        ) ,
                        SizedBox(width: width(8),),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: width(62),
                          child: Text(sprintf("%s",
                              [

                                SPClassStringUtils.spFunSqlitZero( spFunAvgWinOrLoseScoreTwo(true).toStringAsFixed(2))

                              ]
                          ),
                            style: TextStyle(fontSize: sp(12),color: Color(0xFF333333)),
                          ),
                        ),
                      ],
                    ),
                    Text("场均进球",
                      style: TextStyle(fontSize: sp(12)),),
                    SizedBox(height: width(8),),
                  ],
                ),
              ),
              ///场均失球
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          width: width(62),
                          child: Text(sprintf("%s",
                              [
                                SPClassStringUtils.spFunSqlitZero(spFunAvgWinOrLoseScoreOne(false).toStringAsFixed(2))
                              ]
                          ),
                            style: TextStyle(fontSize: sp(12),color: Color(0xFF333333)),
                          ),
                        ),
                        SizedBox(width: width(8),),
                        Expanded(
                          child:  Row(
                            children: <Widget>[
                              Expanded(
                                flex:(spFunAvgWinOrLoseScoreTwo(false)*100).toInt() ,
                                child: Container(
                                  margin: EdgeInsets.only(right: 2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: MyColors.main1,
                                      borderRadius: BorderRadius.horizontal(left:Radius.circular(300) )
                                  ),
                                  height: width(7),
                                ),
                              ),
                              Expanded(
                                flex:(spFunAvgWinOrLoseScoreOne(false)*100).toInt() ,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFF5F40),
                                      borderRadius: BorderRadius.horizontal(right:Radius.circular(300) )
                                  ),
                                  alignment: Alignment.center,
                                  height: width(7),
                                ),
                              ),
                            ],
                          ),
                        ) ,
                        SizedBox(width: width(8),),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: width(62),
                          child: Text(sprintf("%s",
                              [
                                SPClassStringUtils.spFunSqlitZero(spFunAvgWinOrLoseScoreTwo(false).toStringAsFixed(2))
                              ]
                          ),
                            style: TextStyle(fontSize: sp(12),color: Color(0xFF333333)),
                          ),
                        ),
                      ],
                    ),
                    Text("场均失球",
                      style: TextStyle(fontSize: sp(12)),),
                    SizedBox(height: width(8),),
                  ],
                ),
              ),
            ],

          ),
        ) ,
      ),
      visible:(SPClassListUtil.spFunIsNotEmpty(spProHistoryList)
          || SPClassListUtil.spFunIsNotEmpty(spProHistoryOne)
          || SPClassListUtil.spFunIsNotEmpty(spProHistoryTwo)
      ),
    );
  }

//  积分排名
  Widget scoreRanking(){
    return Visibility(
      child: AnimatedSize(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_match_statc_title"),width: width(319),),
                  Text("积分排名",style: TextStyle(fontSize: sp(16),fontWeight: FontWeight.bold),)
                ],
              ),
              Container(
                width: ScreenUtil.screenWidth,
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(top: height(8),right:  height(11)),
                  width: width(140),
                  height: width(27),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(width(5)),topLeft: Radius.circular(width(5))),
                                border: Border.all(color: spProPointsKey=="总"? Color(0xFFDE3C31):Color(0xFFC4C4C4),width: 0.4),
                                color: spProPointsKey=="总"? Color(0xFFDE3C31):Colors.white
                            ),
                            alignment: Alignment.center,
                            child: Text("总",style: TextStyle(fontSize: sp(14),color: spProPointsKey=="总"? Colors.white :Color(0xFF666666)),),
                          ),
                          onPressed: (){
                            setState(() {
                              spProPointsKey="总";
                            });

                          },
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color:spProPointsKey=="主"? Color(0xFFDE3C31):Color(0xFFC4C4C4),
                                        width: 0.4
                                    ),
                                    bottom: BorderSide(
                                        color:spProPointsKey=="主"? Color(0xFFDE3C31):Color(0xFFC4C4C4),
                                        width: 0.4
                                    )
                                ),
                                color: spProPointsKey=="主"? Color(0xFFDE3C31):Colors.white
                            ),
                            alignment: Alignment.center,
                            child: Text("主",style: TextStyle(fontSize: sp(14),color: spProPointsKey=="主"? Colors.white :Color(0xFF666666)),),
                          ),
                          onPressed: (){
                            setState(() {
                              spProPointsKey="主";
                            });

                          },
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight:Radius.circular(width(5)),
                                    topRight: Radius.circular(width(5))),
                                border: Border.all(color: spProPointsKey=="客"? Color(0xFFDE3C31):Color(0xFFC4C4C4),width: 0.4),
                                color: spProPointsKey=="客"? Color(0xFFDE3C31):Colors.white
                            ),
                            alignment: Alignment.center,
                            child: Text("客",style: TextStyle(fontSize: sp(14),color:spProPointsKey=="客"? Colors.white :Color(0xFF666666)),),
                          ),
                          onPressed: (){
                            setState(() {
                              spProPointsKey="客";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: height(8),horizontal:  height(11)),
                width: width(330),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFDDDDDD),width: 0.4)
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              child: Text("球队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),
                          ) ,

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: width(40),
                              child: Text("排名",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),
                          ) ,

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: width(40),
                              child: Text("积分",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),
                          ) ,

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: width(40),
                              child: Text("场次",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),
                          ) ,

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              width: width(40),
                              child: Text("胜率",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),
                          ) ,
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: width(40),
                              child: Text("胜/平/负",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),
                          ) ,
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: width(40),
                              child: Text("进/失",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),
                          ) ,

                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: spFunGetTeamPoints(spProPointsKey).map((item){
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
                                    child: Text(item.spProTeamName,style: TextStyle(fontSize: sp(11),fontWeight: FontWeight.w500),),
                                  ),
                                ) ,

                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    child: Text(item.ranking,style: TextStyle(fontSize: sp(11),fontWeight: FontWeight.w500),),
                                  ),
                                ) ,

                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    child: Text(item.points,style: TextStyle(fontSize: sp(11),fontWeight: FontWeight.w500),),
                                  ),
                                ) ,

                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    child: Text(item.spProMatchNum,style: TextStyle(fontSize: sp(11),fontWeight: FontWeight.w500),),
                                  ),
                                ) ,

                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: width(40),
                                    child: Text(sprintf("%s%",[(double.parse(item.spProWinRate)*100).toStringAsFixed(0)]),style: TextStyle(fontSize: sp(11),fontWeight: FontWeight.w500),),
                                  ),
                                ) ,
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    child: Text(sprintf("%s/%s/%s",[item.spProWinNum,item.spProDrawNum,item.spProLoseNum]),style: TextStyle(fontSize: sp(11),fontWeight: FontWeight.w500),),
                                  ),
                                ) ,
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    child: Text(sprintf("%s/%s",[item.score,item.spProLoseScore]),style: TextStyle(fontSize: sp(11),fontWeight: FontWeight.w500),),
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
              )
            ],

          ),
        ) ,
      ),
      visible:SPClassListUtil.spFunIsNotEmpty(spProTeamPointsList) ,
    );
  }

//  历史战绩
  Widget history(){
    return Visibility(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: width(15),right: width(15),top: width(24),bottom: width(10)),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("对赛往绩",style: TextStyle(fontSize: sp(17),fontWeight: FontWeight.bold),)),
                  Container(
                    width: width(93),
                    height: width(27),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(width(12)),topLeft: Radius.circular(width(12))),
                                  // border: Border.all(color: spProHistoryKey=="全部"? MyColors.main1:Color(0xFFF2F2F2),width: 0.4),
                                  color: spProHistoryKey=="全部"? MyColors.main1:Color(0xFFF2F2F2)
                              ),
                              alignment: Alignment.center,
                              child: Text("全部",style: TextStyle(fontSize: sp(14),color: spProHistoryKey=="全部"? Colors.white :Color(0xFF999999)),),
                            ),
                            onPressed: (){
                              setState(() {
                                spProHistoryKey="全部";
                              });

                            },
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight:Radius.circular(width(12)),
                                      topRight: Radius.circular(width(12))),
                                  // border: Border.all(color: spProHistoryKey=="主场"? Color(0xFFDE3C31):Color(0xFFC4C4C4),width: 0.4),
                                  color: spProHistoryKey=="主场"? MyColors.main1:Color(0xFFF2F2F2)

                            ),
                              alignment: Alignment.center,
                              child: Text("主场",style: TextStyle(fontSize: sp(14),color:spProHistoryKey=="主场"? Colors.white :Color(0xFF999999)),),
                            ),
                            onPressed: (){
                              setState(() {
                                spProHistoryKey="主场";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: width(13),),
                Expanded(
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: <Widget>[
                      Text('${widget.spProGuessMatch.spProTeamOne}VS${widget.spProGuessMatch.spProTeamTwo}',style: TextStyle(fontSize: sp(13)),),
                      Text(sprintf("  (%d场)",[
                        spFunGetHistoryList(spProHistoryKey).length
                      ]
                      ),
                        style: TextStyle(fontSize: sp(12)),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height:width(10) ,),
            Container(
              margin: EdgeInsets.symmetric(horizontal:  height(11)),
              child:  Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('${widget.spProGuessMatch.spProTeamOne}:',
                        style: TextStyle(
                          fontSize: sp(15),
                          color: Color(0xFF333333),
                        ),),
                      Text(sprintf("  %d胜%d平%d负",[
                        spFunGetMatchCount(spFunGetHistoryList(spProHistoryKey),1),
                        spFunGetMatchCount(spFunGetHistoryList(spProHistoryKey),0),
                        spFunGetMatchCount(spFunGetHistoryList(spProHistoryKey),2),
                      ],
                      ),
                        style: TextStyle(fontSize: sp(12)),),
                    ],
                  ),
                  SizedBox(height:3),
                  Row(
                    children: <Widget>[
                      spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),1)==0? SizedBox(): Container(
                        margin: EdgeInsets.only(right: width(4)),
                        decoration: BoxDecoration(
                          color: MyColors.main1,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(width(4)))
                        ),
                        alignment: Alignment.center,
                        width: width(318)*spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),1),
                        height: width(10),
                      ),

                      spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),0)==0? SizedBox(): Container(
                        margin: EdgeInsets.only(right: width(4)),
                        alignment: Alignment.center,
                        width: width(318)*spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),0),
                        height: width(10),
                        color: Color(0xFF5FB349),
                      ),

                      spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),2)==0? SizedBox(): Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          width: width(318)*spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),2),
                          height: width(10),
                          decoration: BoxDecoration(
                              color: Color(0xFFFF5F40),
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(width(4)))
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: <Widget>[
                      spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),1)==0? SizedBox(): Container(
                        margin: EdgeInsets.only(right: width(4)),
                        alignment: Alignment.center,
                        width: width(318)*spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),1),
                        child: Text(
                          sprintf("%d胜",[spFunGetMatchCount(spFunGetHistoryList(spProHistoryKey),1),]),
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: sp(12),
                          ),
                        ),
                      ),

                      spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),0)==0? SizedBox(): Container(
                        margin: EdgeInsets.only(right: width(4)),
                        alignment: Alignment.center,
                        width: width(318)*spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),0),
                        child: Text(
                          sprintf("%d平",[spFunGetMatchCount(spFunGetHistoryList(spProHistoryKey),0),]),
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: sp(12),
                          ),
                        ),
                      ),

                      spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),2)==0? SizedBox(): Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          width: width(318)*spFunGetMatchRate(spFunGetHistoryList(spProHistoryKey),2),
                          child: Text(
                            sprintf("%d负",[spFunGetMatchCount(spFunGetHistoryList(spProHistoryKey),2),]),
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: sp(12),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
            // 盘口
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal:  height(11),
                  vertical:height(8) ),
              child:  Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('${widget.spProGuessMatch.spProTeamOne}:',
                        style: TextStyle(
                          fontSize: sp(15),
                          color: Color(0xFF333333),
                        ),),
                      Text(sprintf("  盘路 %d赢%d走%d输 %s%s",[
                        spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),1),
                        spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),0),
                        spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),2),
                        (spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),3)==0? "":(" "+(spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),3).toString()+"大"))),
                        (spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),4)==0? "":(" "+(spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),4).toString()+"小"))),

                      ]),
                        style: TextStyle(fontSize: sp(12)),),
                    ],
                  ),
                  SizedBox(height:3),
                  Row(
                    children: <Widget>[
                      spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),1)==0? SizedBox(): Container(
                        margin: EdgeInsets.only(right: width(4)),
                        decoration: BoxDecoration(
                            color: MyColors.main1,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(width(4)))
                        ),
                        alignment: Alignment.center,
                        width: width(318)*spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),1),
                        height: width(10),
                      ),

                      spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),0)==0? SizedBox(): Container(
                        margin: EdgeInsets.only(right: width(4)),
                        alignment: Alignment.center,
                        width: width(318)*spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),0),
                        height: width(10),
                        color: Color(0xFF5FB349),
                      ),

                      spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),2)==0? SizedBox(): Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          width: width(318)*spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),2),
                          height: width(10),
                          decoration: BoxDecoration(
                              color: Color(0xFFFF5F40),
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(width(4)))
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: <Widget>[
                      spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),1)==0? SizedBox(): Container(
                        margin: EdgeInsets.only(right: width(4)),
                        alignment: Alignment.center,
                        width: width(318)*spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),1),
                        child:
                        Text(sprintf("%d赢",[
                          spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),1),
                        ]),
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: sp(12),
                          ),
                        ),
                      ),

                      spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),0)==0? SizedBox(): Container(
                        margin: EdgeInsets.only(right: width(4)),
                        alignment: Alignment.center,
                        width: width(318)*spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),0),
                        child: Text(sprintf("%d走",[
                          spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),0),
                        ]),
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: sp(12),
                          ),
                        ),
                      ),

                      spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),2)==0? SizedBox(): Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          width: width(318)*spFunGetMatchPanKouRate(spFunGetHistoryList(spProHistoryKey,isPanKou: true),2),
                          child: Text(sprintf("%d输",[
                            spFunGetMatchPanKouCount(spFunGetHistoryList(spProHistoryKey,isPanKou: true),2),
                          ]),
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: sp(12),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),


                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: height(8),horizontal:  height(11)),
              width: width(330),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDDDDDD),width: 0.4)
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            child: Text("赛事日期",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                          ),
                        ) ,

                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: width(40),
                            child: Text("主队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                          ),
                        ) ,

                        Container(
                          alignment: Alignment.center,
                          height: width(40),
                          width: width(30),
                          child: Text("比分",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                        ),


                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: width(40),
                            child: Text("客队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                          ),
                        ) ,


                        Container(
                          alignment: Alignment.center,
                          height: width(40),
                          child: Text("赛果",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                        ),


                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: width(40),
                            child: Text("盘路",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                          ),
                        ) ,


                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: spFunGetHistoryList(spProHistoryKey).map((item){
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
                                  child: Text(sprintf("%s%s%s",
                                      [item.spProLeagueName,"\n",SPClassDateUtils.spFunDateFormatByString(item.spProMatchDate, "yyyy.M.dd")]
                                  ),style: TextStyle(
                                    fontSize: sp(11),
                                    color: Color(0xFF666666),
                                  ),textAlign: TextAlign.center,),
                                ),
                              ) ,

                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: width(40),
                                  child: Text(item.spProTeamOne,style: TextStyle(
                                    fontSize: sp(11),
                                    color: spFunGetTeamTextColor(item,1),
                                  ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ) ,

                              Container(
                                alignment: Alignment.center,
                                height: width(40),
                                width: width(30),
                                child: Text(item.spProScoreOne+" : "+item.spProScoreTwo,style: TextStyle(
                                  fontSize: sp(11),
                                  color: spFunGetResultColor(item),
                                ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: width(40),
                                  child: Text(item.spProTeamTwo,style: TextStyle(
                                    fontSize: sp(11),
                                    color: spFunGetTeamTextColor(item,2,),
                                  ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ) ,

                              Container(
                                alignment: Alignment.center,
                                height: width(40),
                                width: width(30),
                                child: Text(spFunGetHistoryResultText(item),style: TextStyle(
                                  fontSize: sp(11),
                                  color: spFunGetResultColor(item),
                                ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: width(40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Center(
                                          child: Text(item.spProWinOrLose.isEmpty?"--":sprintf("%s%s%s",
                                              [
                                                (item.spProAddScore.isEmpty ? "--":SPClassStringUtils.spFunSqlitZero(item.spProAddScore)),
                                                "\n",
                                                item.spProWinOrLose,
                                              ]
                                          ),style: TextStyle(
                                            fontSize: sp(11),
                                            color: spFunGetColorByText(item.spProWinOrLose),
                                          ),textAlign: TextAlign.center,),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(item.spProBigOrSmall.isEmpty?"--":sprintf("%s%s%s",
                                              [
                                                ((item.spProMidScore.isEmpty||double.tryParse(item.spProMidScore)==0) ? "--":SPClassStringUtils.spFunSqlitZero(item.spProMidScore)),
                                                "\n",
                                                item.spProBigOrSmall,
                                              ]
                                          ),style: TextStyle(
                                            fontSize: sp(11),
                                            color: spFunGetColorByText(item.spProBigOrSmall),
                                          ),textAlign: TextAlign.center,),
                                        ),
                                      ),

                                    ],
                                  ),
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
            )
          ],

        ),
      ),
      visible:SPClassListUtil.spFunIsNotEmpty(spProHistoryList),
    );
  }

//  近期战绩
  Widget recentAchievements(){
    return Visibility(
      child:  Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_match_statc_title"),width: width(319),),
                Text("近期战绩",style: TextStyle(fontSize: sp(16),fontWeight: FontWeight.bold),)
              ],
            ),

            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: width(11),),
                          ( widget.spProGuessMatch.spProIconUrlOne.isEmpty)? SPClassEncryptImage.asset(
                            SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                            width: width(21),
                            height: width(21),
                          ):Image.network(
                            widget.spProGuessMatch.spProIconUrlOne,
                            height: width(21),
                          ),
                          SizedBox(width: 5,),
                          Text(widget.spProGuessMatch.spProTeamOne,style: TextStyle(fontSize: sp(12)),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height(8),right:  height(11)),
                      width: width(93),
                      height: width(27),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(width(5)),topLeft: Radius.circular(width(5))),
                                    border: Border.all(color: spProHistoryOneKey=="全部"? Color(0xFFDE3C31):Color(0xFFC4C4C4),width: 0.4),
                                    color: spProHistoryOneKey=="全部"? Color(0xFFDE3C31):Colors.white
                                ),
                                alignment: Alignment.center,
                                child: Text("全部",style: TextStyle(fontSize: sp(14),color: spProHistoryOneKey=="全部"? Colors.white :Color(0xFF666666)),),
                              ),
                              onPressed: (){
                                setState(() {
                                  spProHistoryOneKey="全部";
                                });

                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight:Radius.circular(width(5)),
                                        topRight: Radius.circular(width(5))),
                                    border: Border.all(color: spProHistoryOneKey=="主场"? Color(0xFFDE3C31):Color(0xFFC4C4C4),width: 0.4),
                                    color: spProHistoryOneKey=="主场"? Color(0xFFDE3C31):Colors.white
                                ),
                                alignment: Alignment.center,
                                child: Text("主场",style: TextStyle(fontSize: sp(14),color:spProHistoryOneKey=="主场"? Colors.white :Color(0xFF666666)),),
                              ),
                              onPressed: (){
                                setState(() {
                                  spProHistoryOneKey="主场";
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: width(16),),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child:  Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: width(64),
                                  width: width(64),
                                  child:SfCircularChart(
                                    margin: EdgeInsets.zero,
                                    title: ChartTitle(text: '' ),
                                    legend: Legend(isVisible: false),
                                    series: [
                                      DoughnutSeries<SPClassChartDoughnutData, String>(
                                        explode: false,
                                        explodeIndex: 0,
                                        radius: width(30).toString(),
                                        innerRadius: width(22).toString(),
                                        dataSource: [
                                          SPClassChartDoughnutData(spFunGetMatchCount(spFunGetHistoryOneList(spProHistoryOneKey), 1)*1.0,color: Color(0xFFDE3C31)),
                                          SPClassChartDoughnutData(spFunGetMatchCount(spFunGetHistoryOneList(spProHistoryOneKey), 2)*1.0,color: Color(0xFF5FB349)),
                                          SPClassChartDoughnutData(spFunGetMatchCount(spFunGetHistoryOneList(spProHistoryOneKey), 0)*1.0,color: Color(0xFF333333)),

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
                                Text(sprintf("%d胜%d平%s%d负",[
                                  spFunGetMatchCount(spFunGetHistoryOneList(spProHistoryOneKey), 1),
                                  spFunGetMatchCount(spFunGetHistoryOneList(spProHistoryOneKey), 0),
                                  "\n",
                                  spFunGetMatchCount(spFunGetHistoryOneList(spProHistoryOneKey), 2),
                                ]
                                ),style: TextStyle(fontSize: sp(10),),
                                  textAlign: TextAlign.center,

                                )
                              ],
                            ),
                            Text(sprintf("近%d场",[spFunGetHistoryOneList(spProHistoryOneKey).length]),style: TextStyle(fontSize: sp(12),))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child:  Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: width(64),
                                  width: width(64),
                                  child:SfCircularChart(
                                    margin: EdgeInsets.zero,
                                    title: ChartTitle(text: '' ),
                                    legend: Legend(isVisible: false),
                                    series: [
                                      DoughnutSeries<SPClassChartDoughnutData, String>(
                                        explode: false,
                                        explodeIndex: 0,
                                        radius: width(30).toString(),
                                        innerRadius: width(22).toString(),
                                        dataSource: [
                                          SPClassChartDoughnutData(spFunGetMatchRate(spFunGetHistoryOneList(spProHistoryOneKey), 1),color: Color(0xFFDE3C31)),
                                          SPClassChartDoughnutData(1-spFunGetMatchRate(spFunGetHistoryOneList(spProHistoryOneKey), 1),color: Color(0xFEBEBEB)),

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
                                Text(sprintf("%s%",[(spFunGetMatchRate(spFunGetHistoryOneList(spProHistoryOneKey), 1)*100).toStringAsFixed(0)]),style: TextStyle(fontSize: sp(10),))
                              ],
                            ),
                            Text("胜率",style: TextStyle(fontSize: sp(12),))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child:  Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: width(64),
                                  width: width(64),
                                  child:SfCircularChart(
                                    margin: EdgeInsets.zero,
                                    title: ChartTitle(text: '' ),
                                    legend: Legend(isVisible: false),
                                    series: [
                                      DoughnutSeries<SPClassChartDoughnutData, String>(
                                        explode: false,
                                        explodeIndex: 0,
                                        radius: width(30).toString(),
                                        innerRadius: width(22).toString(),
                                        dataSource: [
                                          SPClassChartDoughnutData(spFunGetMatchPanKouRate(spFunGetHistoryOneList(spProHistoryOneKey), 1),color: Color(0xFFDE3C31)),
                                          SPClassChartDoughnutData(1-spFunGetMatchPanKouRate(spFunGetHistoryOneList(spProHistoryOneKey), 1),color: Color(0xFEBEBEB)),

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
                                Text(sprintf("%s%",[(spFunGetMatchPanKouRate(spFunGetHistoryOneList(spProHistoryOneKey), 1)*100).toStringAsFixed(0)]),style: TextStyle(fontSize: sp(10),))
                              ],
                            ),
                            Text("赢盘率",style: TextStyle(fontSize: sp(12),))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width(16),),

                Container(
                  margin: EdgeInsets.symmetric(vertical: height(8),horizontal:  height(11)),
                  width: width(330),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFDDDDDD),width: 0.4)
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                child: Text("赛事日期",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                              ),
                            ) ,

                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: width(40),
                                child: Text("主队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                              ),
                            ) ,

                            Container(
                              alignment: Alignment.center,
                              height: width(40),
                              width: width(30),
                              child: Text("比分",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),


                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: width(40),
                                child: Text("客队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                              ),
                            ) ,


                            Container(
                              alignment: Alignment.center,
                              height: width(40),
                              child: Text("赛果",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),


                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                width: width(40),
                                child: Text("盘路",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                              ),
                            ) ,


                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: spFunGetHistoryOneList(spProHistoryOneKey).map((item){
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
                                      child: Text(sprintf("%s%s%s",
                                          [item.spProLeagueName,"\n",SPClassDateUtils.spFunDateFormatByString(item.spProMatchDate, "yyyy.M.dd")]
                                      ),style: TextStyle(
                                        fontSize: sp(11),
                                        color: Color(0xFF666666),
                                      ),textAlign: TextAlign.center,),
                                    ),
                                  ) ,

                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: width(40),
                                      child: Text(item.spProTeamOne,style: TextStyle(
                                        fontSize: sp(11),
                                        color: spFunGetTeamTextColor(item,1),
                                      ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ) ,

                                  Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    width: width(30),
                                    child: Text(item.spProScoreOne+" : "+item.spProScoreTwo,style: TextStyle(
                                      fontSize: sp(11),
                                      color: spFunGetResultColor(item),
                                    ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: width(40),
                                      child: Text(item.spProTeamTwo,style: TextStyle(
                                        fontSize: sp(11),
                                        color: spFunGetTeamTextColor(item,2),
                                      ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ) ,

                                  Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    width: width(30),
                                    child: Text(spFunGetHistoryResultText(item),style: TextStyle(
                                      fontSize: sp(11),
                                      color: spFunGetResultColor(item),
                                    ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: width(40),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(item.spProWinOrLose.isEmpty?"--":sprintf("%s%s%s",
                                                  [
                                                    (item.spProAddScore.isEmpty ? "--":SPClassStringUtils.spFunSqlitZero(item.spProAddScore)),
                                                    "\n",
                                                    item.spProWinOrLose,
                                                  ]
                                              ),style: TextStyle(
                                                fontSize: sp(11),
                                                color: spFunGetColorByText(item.spProWinOrLose),
                                              ),textAlign: TextAlign.center,),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(item.spProBigOrSmall.isEmpty?"--":sprintf("%s%s%s",
                                                  [
                                                    ((item.spProMidScore.isEmpty||double.tryParse(item.spProMidScore)==0) ? "--":SPClassStringUtils.spFunSqlitZero(item.spProMidScore)),
                                                    "\n",
                                                    item.spProBigOrSmall,
                                                  ]
                                              ),style: TextStyle(
                                                fontSize: sp(11),
                                                color: spFunGetColorByText(item.spProBigOrSmall),
                                              ),textAlign: TextAlign.center,),
                                            ),
                                          ),

                                        ],
                                      ),
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
                )
              ],
            ),
            SizedBox(height: width(16),),

            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: width(11),),
                          ( widget.spProGuessMatch.spProIconUrlTwo.isEmpty)? SPClassEncryptImage.asset(
                            SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                            width: width(21),
                            height: width(21),
                          ):Image.network(
                            widget.spProGuessMatch.spProIconUrlTwo,
                            height: width(21),
                          ),
                          SizedBox(width: 5,),
                          Text(widget.spProGuessMatch.spProTeamTwo,style: TextStyle(fontSize: sp(12)),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height(8),right:  height(11)),
                      width: width(93),
                      height: width(27),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(width(5)),topLeft: Radius.circular(width(5))),
                                    border: Border.all(color: spProHistoryTwoKey=="全部"? Color(0xFFDE3C31):Color(0xFFC4C4C4),width: 0.4),
                                    color: spProHistoryTwoKey=="全部"? Color(0xFFDE3C31):Colors.white
                                ),
                                alignment: Alignment.center,
                                child: Text("全部",style: TextStyle(fontSize: sp(14),color: spProHistoryTwoKey=="全部"? Colors.white :Color(0xFF666666)),),
                              ),
                              onPressed: (){
                                setState(() {
                                  spProHistoryTwoKey="全部";
                                });

                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight:Radius.circular(width(5)),
                                        topRight: Radius.circular(width(5))),
                                    border: Border.all(color: spProHistoryTwoKey=="客场"? Color(0xFFDE3C31):Color(0xFFC4C4C4),width: 0.4),
                                    color: spProHistoryTwoKey=="客场"? Color(0xFFDE3C31):Colors.white
                                ),
                                alignment: Alignment.center,
                                child: Text("客场",style: TextStyle(fontSize: sp(14),color:spProHistoryTwoKey=="客场"? Colors.white :Color(0xFF666666)),),
                              ),
                              onPressed: (){
                                setState(() {
                                  spProHistoryTwoKey="客场";
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: width(16),),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child:  Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: width(64),
                                  width: width(64),
                                  child:SfCircularChart(
                                    margin: EdgeInsets.zero,
                                    title: ChartTitle(text: '' ),
                                    legend: Legend(isVisible: false),
                                    series: [
                                      DoughnutSeries<SPClassChartDoughnutData, String>(
                                        explode: false,
                                        explodeIndex: 0,
                                        radius: width(30).toString(),
                                        innerRadius: width(22).toString(),
                                        dataSource: [
                                          SPClassChartDoughnutData(spFunGetMatchCount(spFunGetHistoryTwoList(spProHistoryTwoKey,), 1,winTeam:2)*1.0,color: Color(0xFFDE3C31)),
                                          SPClassChartDoughnutData(spFunGetMatchCount(spFunGetHistoryTwoList(spProHistoryTwoKey), 2,winTeam:2)*1.0,color: Color(0xFF5FB349)),
                                          SPClassChartDoughnutData(spFunGetMatchCount(spFunGetHistoryTwoList(spProHistoryTwoKey), 0,winTeam: 2)*1.0,color: Color(0xFF333333)),

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
                                Text(sprintf("%d胜%d平%s%d负",[
                                  spFunGetMatchCount(spFunGetHistoryTwoList(spProHistoryTwoKey), 1,winTeam: 2),
                                  spFunGetMatchCount(spFunGetHistoryTwoList(spProHistoryTwoKey), 0,winTeam: 2),
                                  "\n",
                                  spFunGetMatchCount(spFunGetHistoryTwoList(spProHistoryTwoKey), 2,winTeam: 2),
                                ]
                                ),style: TextStyle(fontSize: sp(10),),
                                  textAlign: TextAlign.center,

                                )
                              ],
                            ),
                            Text(sprintf("近%d场",[spFunGetHistoryTwoList(spProHistoryTwoKey).length]),style: TextStyle(fontSize: sp(12),))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child:  Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: width(64),
                                  width: width(64),
                                  child:SfCircularChart(
                                    margin: EdgeInsets.zero,
                                    title: ChartTitle(text: '' ),
                                    legend: Legend(isVisible: false),
                                    series: [
                                      DoughnutSeries<SPClassChartDoughnutData, String>(
                                        explode: false,
                                        explodeIndex: 0,
                                        radius: width(30).toString(),
                                        innerRadius: width(22).toString(),
                                        dataSource: [
                                          SPClassChartDoughnutData(spFunGetMatchRate(spFunGetHistoryTwoList(spProHistoryTwoKey), 1,winTeam: 2),color: Color(0xFFDE3C31)),
                                          SPClassChartDoughnutData(1-spFunGetMatchRate(spFunGetHistoryTwoList(spProHistoryTwoKey), 1,winTeam: 2),color: Color(0xFEBEBEB)),

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
                                Text(sprintf("%s%",[(spFunGetMatchRate(spFunGetHistoryTwoList(spProHistoryTwoKey), 1,winTeam: 2)*100).toStringAsFixed(0)]),style: TextStyle(fontSize: sp(10),))
                              ],
                            ),
                            Text("胜率",style: TextStyle(fontSize: sp(12),))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child:  Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: width(64),
                                  width: width(64),
                                  child:SfCircularChart(
                                    margin: EdgeInsets.zero,
                                    title: ChartTitle(text: '' ),
                                    legend: Legend(isVisible: false),
                                    series: [
                                      DoughnutSeries<SPClassChartDoughnutData, String>(
                                        explode: false,
                                        explodeIndex: 0,
                                        radius: width(30).toString(),
                                        innerRadius: width(22).toString(),
                                        dataSource: [
                                          SPClassChartDoughnutData(spFunGetMatchPanKouRate(spFunGetHistoryTwoList(spProHistoryTwoKey), 1),color: Color(0xFFDE3C31)),
                                          SPClassChartDoughnutData(1-spFunGetMatchPanKouRate(spFunGetHistoryTwoList(spProHistoryTwoKey), 1),color: Color(0xFEBEBEB)),

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
                                Text(sprintf("%s%",[(spFunGetMatchPanKouRate(spFunGetHistoryTwoList(spProHistoryTwoKey), 1)*100).toStringAsFixed(0)]),style: TextStyle(fontSize: sp(10),))
                              ],
                            ),
                            Text("赢盘率",style: TextStyle(fontSize: sp(12),))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width(16),),

                Container(
                  margin: EdgeInsets.symmetric(vertical: height(8),horizontal:  height(11)),
                  width: width(330),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFDDDDDD),width: 0.4)
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                child: Text("赛事日期",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                              ),
                            ) ,

                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: width(40),
                                child: Text("主队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                              ),
                            ) ,

                            Container(
                              alignment: Alignment.center,
                              height: width(40),
                              width: width(30),
                              child: Text("比分",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),


                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: width(40),
                                child: Text("客队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                              ),
                            ) ,


                            Container(
                              alignment: Alignment.center,
                              height: width(40),
                              child: Text("赛果",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                            ),


                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                width: width(40),
                                child: Text("盘路",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                              ),
                            ) ,


                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: spFunGetHistoryTwoList(spProHistoryTwoKey).map((item){
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
                                      child: Text(sprintf("%s%s%s",
                                          [item.spProLeagueName,"\n",SPClassDateUtils.spFunDateFormatByString(item.spProMatchDate, "yyyy.M.dd")]
                                      ),style: TextStyle(
                                        fontSize: sp(11),
                                        color: Color(0xFF666666),
                                      ),textAlign: TextAlign.center,),
                                    ),
                                  ) ,

                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: width(40),
                                      child: Text(item.spProTeamOne,style: TextStyle(
                                        fontSize: sp(11),
                                        color: spFunGetTeamTextColor(item,1,isOne:false),
                                      ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ) ,

                                  Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    width: width(30),
                                    child: Text(item.spProScoreOne+" : "+item.spProScoreTwo,style: TextStyle(
                                      fontSize: sp(11),
                                      color: spFunGetResultColor(item,winTeam:2),
                                    ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: width(40),
                                      child: Text(item.spProTeamTwo,style: TextStyle(
                                        fontSize: sp(11),
                                        color: spFunGetTeamTextColor(item,2,isOne:false),
                                      ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ) ,

                                  Container(
                                    alignment: Alignment.center,
                                    height: width(40),
                                    width: width(30),
                                    child: Text(spFunGetHistoryResultText(item,winTeam: 2),style: TextStyle(
                                      fontSize: sp(11),
                                      color: spFunGetResultColor(item,winTeam: 2),
                                    ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: width(40),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(item.spProWinOrLose.isEmpty?"--":sprintf("%s%s%s",
                                                  [
                                                    (item.spProAddScore.isEmpty ? "--":SPClassStringUtils.spFunSqlitZero(item.spProAddScore)),
                                                    "\n",
                                                    item.spProWinOrLose,
                                                  ]
                                              ),style: TextStyle(
                                                fontSize: sp(11),
                                                color: spFunGetColorByText(item.spProWinOrLose),
                                              ),textAlign: TextAlign.center,),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(item.spProBigOrSmall.isEmpty?"--":sprintf("%s%s%s",
                                                  [
                                                    ((item.spProMidScore.isEmpty||double.tryParse(item.spProMidScore)==0) ? "--":SPClassStringUtils.spFunSqlitZero(item.spProMidScore)),
                                                    "\n",
                                                    item.spProBigOrSmall,
                                                  ]
                                              ),style: TextStyle(
                                                fontSize: sp(11),
                                                color: spFunGetColorByText(item.spProBigOrSmall),
                                              ),textAlign: TextAlign.center,),
                                            ),
                                          ),

                                        ],
                                      ),
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
                )
              ],
            ),


          ],

        ),
      ),
      visible:!(spProHistoryOne.length==0&&spProHistoryTwo.length==0) ,
    );
  }

//  未来赛事
  Widget future(){
    return Visibility(
      child:  Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_match_statc_title"),width: width(319),),
                Text("未来赛事",style: TextStyle(fontSize: sp(16),fontWeight: FontWeight.bold),)
              ],
            ),

            AnimatedSize(
              vsync: this,
              duration: Duration(
                  milliseconds: 300
              ),
              child:Column(
                children: <Widget>[

                  Visibility(
                    child:Column(
                      children: <Widget>[
                        SizedBox(height: height(8),),
                        Row(
                          children: <Widget>[
                            SizedBox(width: width(10),),
                            ( widget.spProGuessMatch.spProIconUrlOne.isEmpty)? SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                              width: width(20),
                            ):Image.network(
                              widget.spProGuessMatch.spProIconUrlOne,
                              width: width(20),
                            ),
                            SizedBox(width: 5,),
                            Text(widget.spProGuessMatch.spProTeamOne,style: TextStyle(fontSize: sp(12)),)
                          ],

                        ),
                        Container(
                          margin: EdgeInsets.only(top: height(8),bottom: height(8)),
                          width: width(330),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFDDDDDD),width: 0.4)
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                        child: Text("赛事日期",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                      ),
                                    ) ,

                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: width(40),
                                        child: Text("主队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                      ),
                                    ) ,

                                    Container(
                                      alignment: Alignment.center,
                                      height: width(40),
                                      width: width(30),
                                      child: Text("",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                    ),


                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: width(40),
                                        child: Text("客队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                      ),
                                    ) ,

                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: width(40),
                                        child: Text("间隔",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                      ),
                                    ) ,


                                  ],
                                ),
                              ),

                              Container(
                                child: Column(
                                  children: spProFutureListOne.map((item){
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
                                              child: Text(sprintf("%s%s%s",
                                                  [item.spProLeagueName,"\n",SPClassDateUtils.spFunDateFormatByString(item.spProStTime, "yyyy.M.dd")]
                                              ),style: TextStyle(
                                                fontSize: sp(11),
                                                color: Color(0xFF666666),
                                              ),textAlign: TextAlign.center,),
                                            ),
                                          ) ,

                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: width(40),
                                              child: Text(item.spProTeamOne,style: TextStyle(
                                                fontSize: sp(11),
                                                color: spFunGetTeamTextColor(item, 1),
                                              ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ) ,

                                          Container(
                                            alignment: Alignment.center,
                                            height: width(40),
                                            width: width(30),
                                            child: Text("vs",style: TextStyle(
                                              fontSize: sp(14),
                                              color: Color(0xFF888888),
                                            ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: width(40),
                                              child: Text(item.spProTeamTwo,style: TextStyle(
                                                fontSize: sp(11),
                                                color: spFunGetTeamTextColor(item, 2),
                                              ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ) ,


                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: width(40),
                                              child: Text("${(DateTime.parse(item.spProStTime).difference(DateTime.now()).inDays+1).toString()}"+
                                                  "天",style: TextStyle(
                                                fontSize: sp(11),
                                              ),textAlign: TextAlign.center,),
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
                        )
                      ],
                    ),
                    visible: SPClassListUtil.spFunIsNotEmpty(spProFutureListOne),
                  ),

                  Visibility(
                    child:Column(
                      children: <Widget>[
                        SizedBox(height: height(8),),
                        Row(
                          children: <Widget>[
                            SizedBox(width: width(10),),
                            ( widget.spProGuessMatch.spProIconUrlTwo.isEmpty)? SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                              width: width(20),
                            ):Image.network(
                              widget.spProGuessMatch.spProIconUrlTwo,
                              width: width(20),
                            ),
                            SizedBox(width: 5,),
                            Text(widget.spProGuessMatch.spProTeamTwo,style: TextStyle(fontSize: sp(12)),)
                          ],

                        ),
                        Container(
                          margin: EdgeInsets.only(top: height(8),bottom: height(8)),
                          width: width(330),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFDDDDDD),width: 0.4)
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                        child: Text("赛事日期",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                      ),
                                    ) ,

                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: width(40),
                                        child: Text("主队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                      ),
                                    ) ,

                                    Container(
                                      alignment: Alignment.center,
                                      height: width(40),
                                      width: width(30),
                                      child: Text("",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                    ),


                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: width(40),
                                        child: Text("客队",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                      ),
                                    ) ,

                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: width(40),
                                        child: Text("间隔",style: TextStyle(fontSize: sp(11),color: Color(0xFF888888)),),
                                      ),
                                    ) ,


                                  ],
                                ),
                              ),

                              Container(
                                child: Column(
                                  children: spProFutureListTwo.map((item){
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
                                              child: Text(sprintf("%s%s%s",
                                                  [item.spProLeagueName,"\n",SPClassDateUtils.spFunDateFormatByString(item.spProStTime, "yyyy.M.dd")]
                                              ),style: TextStyle(
                                                fontSize: sp(11),
                                                color: Color(0xFF666666),
                                              ),textAlign: TextAlign.center,),
                                            ),
                                          ) ,

                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: width(40),
                                              child: Text(item.spProTeamOne,style: TextStyle(
                                                fontSize: sp(11),
                                                color: spFunGetTeamTextColor(item,1,isOne:false),
                                              ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ) ,

                                          Container(
                                            alignment: Alignment.center,
                                            height: width(40),
                                            width: width(30),
                                            child: Text("vs",style: TextStyle(
                                              fontSize: sp(14),
                                              color: Color(0xFF888888),
                                            ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: width(40),
                                              child: Text(item.spProTeamTwo,style: TextStyle(
                                                fontSize: sp(11),
                                                color: spFunGetTeamTextColor(item,2,isOne:false),
                                              ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ) ,


                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: width(40),
                                              child: Text("${(DateTime.parse(item.spProStTime).difference(DateTime.now()).inDays+1).toString()}"+
                                                  "天",style: TextStyle(
                                                fontSize: sp(11),
                                              ),textAlign: TextAlign.center,),
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
                        )
                      ],
                    ),
                    visible: SPClassListUtil.spFunIsNotEmpty(spProFutureListTwo),
                  ),

                ],
              ) ,
            ),


          ],

        ),
      ),
      visible:(SPClassListUtil.spFunIsNotEmpty(spProFutureListOne)||SPClassListUtil.spFunIsNotEmpty(spProFutureListTwo)),
    );
  }

  Widget myDivider(){
    return Container(
      height: width(6),
      color: Color(0xFFF2F2F2),
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;




  spFunGetColorByText(String item) {

    if(item=="赢"||item=="大"){
      return Color(0xFFE3494B);
    }else if(item=="走"){
      return Color(0xFF1C9FB3);
    }else if(item=="小"||item=="输"){
      return Color(0xFF439642);
    }else{
      return Color(0xFF888888);
    }
  }

  spFunGetResultColor(SPClassEntityHistory itemHistory,{int winTeam:1}){

    if(spFunIsHistoryWin(itemHistory,value: winTeam)){
      return Color(0xFFE3494B);
    }else if( spFunIsHistoryDraw(itemHistory)){
      return Color(0xFF888888);
    }else if( spFunIsHistoryLose(itemHistory,value: winTeam)){
      return Color(0xFF439642);
    }else{
      return Color(0xFF333333);
    }

  }

  bool spFunIsHistoryWin(SPClassEntityHistory itemHistory,{int value:1}) {
    int realValue=value;



    if(itemHistory==null||itemHistory.spProScoreOne.isEmpty||itemHistory.spProScoreTwo.isEmpty){
      return false;
    }

    if(realValue==1){
       if(widget.spProGuessMatch.spProTeamOneId!=null){
          if(widget.spProGuessMatch.spProTeamOneId==itemHistory.spProTeamOneId){
            if(double.parse(itemHistory.spProScoreOne)>double.parse(itemHistory.spProScoreTwo)){
              return true;
            }
          }
          if(widget.spProGuessMatch.spProTeamOneId==itemHistory.spProTeamTwoId){
            if(double.parse(itemHistory.spProScoreTwo)>double.parse(itemHistory.spProScoreOne)){
              return true;
            }
          }

       }


    }

    if(realValue==2){
      if(widget.spProGuessMatch.spProTeamTwoId!=null){
        if(widget.spProGuessMatch.spProTeamTwoId==itemHistory.spProTeamOneId){
          if(double.parse(itemHistory.spProScoreOne)>double.parse(itemHistory.spProScoreTwo)){
            return true;
          }
        }
        if(widget.spProGuessMatch.spProTeamTwoId==itemHistory.spProTeamTwoId){
          if(double.parse(itemHistory.spProScoreTwo)>double.parse(itemHistory.spProScoreOne)){
            return true;
          }
        }
      }
    }

    return false;
  }

  spFunIsHistoryLose(SPClassEntityHistory itemHistory,{int value:1}) {
    int realValue=value;


    if(itemHistory==null||itemHistory.spProScoreOne.isEmpty||itemHistory.spProScoreTwo.isEmpty){
      return false;
    }

    if(realValue==1){
      if(widget.spProGuessMatch.spProTeamOneId!=null){
        if(widget.spProGuessMatch.spProTeamOneId==itemHistory.spProTeamOneId){
          if(double.parse(itemHistory.spProScoreOne)<double.parse(itemHistory.spProScoreTwo)){
            return true;
          }
        }
        if(widget.spProGuessMatch.spProTeamOneId==itemHistory.spProTeamTwoId){
          if(double.parse(itemHistory.spProScoreTwo)<double.parse(itemHistory.spProScoreOne)){
            return true;
          }
        }

      }


    }

    if(realValue==2){
      if(widget.spProGuessMatch.spProTeamTwoId!=null){
        if(widget.spProGuessMatch.spProTeamTwoId==itemHistory.spProTeamOneId){
          if(double.parse(itemHistory.spProScoreOne)<double.parse(itemHistory.spProScoreTwo)){
            return true;
          }
        }
        if(widget.spProGuessMatch.spProTeamTwoId==itemHistory.spProTeamTwoId){
          if(double.parse(itemHistory.spProScoreTwo)<double.parse(itemHistory.spProScoreOne)){
            return true;
          }
        }
      }
    }

    return false;
  }

  spFunIsHistoryDraw(SPClassEntityHistory itemHistory) {

    if(itemHistory==null||itemHistory.spProScoreOne.isEmpty||itemHistory.spProScoreTwo.isEmpty){
      return false;
    }

    if(itemHistory.spProScoreTwo==itemHistory.spProScoreOne){
       return true;
    }

    return false;

  }

  spFunGetHistoryResultText(SPClassEntityHistory itemHistory,{int winTeam:1}) {

    if(itemHistory==null||itemHistory.spProScoreOne.isEmpty||itemHistory.spProScoreTwo.isEmpty){
      return "";
    }

    if(itemHistory.spProScoreTwo==itemHistory.spProScoreOne){
      return "平";
    }

    if(spFunIsHistoryWin(itemHistory,value:winTeam )){
      return "胜";
    }else if(spFunIsHistoryLose(itemHistory,value:winTeam )){
      return "负";
    }
    return "";
  }


  List<SPClassEntityHistory>  spFunGetFilterList(List<SPClassEntityHistory> history, int spProHistoryIndex,{String value}) {
    String realValue=widget.spProGuessMatch.spProTeamOne;

    if(value!=null){
      realValue=value;
    }
    if(spProHistoryIndex==0){
      return history;
    }else{
      var list=List<SPClassEntityHistory>();
      for(var item in history){
        if(realValue==item.spProTeamOne){
          list.add(item);
        }
      }
      return list;
    }
  }

  List<SPClassEntityHistory> spFunGetFilterListNum(List<SPClassEntityHistory> history, int num) {

    if(num==-1){
      return history;
    }else{
      return history.take(num).toList();
    }

  }

  void spFunInitPointData() {
    if(spProAnylizeMatchList.spProTeamPointsList!=null&&spProAnylizeMatchList.spProTeamPointsList.length>0){
      spProTeamPointsList=spProAnylizeMatchList.spProTeamPointsList;
    }

  }




  void spFunInitFutureList() {
    if(spProAnylizeMatchList!=null&&(spProAnylizeMatchList.spProTeamOneFuture!=null&&spProAnylizeMatchList.spProTeamOneFuture.length>0)) {
        spProFutureListOne=spProAnylizeMatchList.spProTeamOneFuture;
    }
    if(spProAnylizeMatchList!=null&&(spProAnylizeMatchList.spProTeamTwoFuture!=null&&spProAnylizeMatchList.spProTeamTwoFuture.length>0)) {
        spProFutureListTwo=spProAnylizeMatchList.spProTeamTwoFuture;
    }
    if(mounted){
      setState(() {});
    }
  }

  List<SPClassTeamPointsList> spFunGetTeamPoints(String spProPointsKey) {
    List<SPClassTeamPointsList> list=[];
        spProTeamPointsList.forEach((item) {
          if(item.type.contains(spProPointsKey)){
            list.add(item);
          }
        });

    return list;
  }

  List<SPClassEntityHistory> spFunGetHistoryList(String spProHistoryKey,{bool isPanKou:false}) {

    List<SPClassEntityHistory> list=[];
    spProHistoryList.forEach((item) {
      if(isPanKou){

        if(spProHistoryKey=="主场"){
          if(item.spProTeamOne==widget.spProGuessMatch.spProTeamOne){
            if((item.spProWinOrLose.isNotEmpty))
            {
              list.add(item);
            }
          }
        }else{
          if((item.spProWinOrLose.isNotEmpty))
          {
            list.add(item);
          }
        }
      }else{
        if(spProHistoryKey=="主场"){
          if(item.spProTeamOne==widget.spProGuessMatch.spProTeamOne){
            list.add(item);
          }
        }else{
          list.add(item);
        }
      }

    });



    return list;
  }

  List<SPClassEntityHistory> spFunGetHistoryOneList(String spProHistoryKey) {

    List<SPClassEntityHistory> list=[];
    spProHistoryOne.forEach((item) {
      if(spProHistoryKey=="主场"){
        if(item.spProTeamOne==widget.spProGuessMatch.spProTeamOne){
            list.add(item);
          }
        }else if (spProHistoryKey=="同主客"){
        if(item.spProTeamOne==widget.spProGuessMatch.spProTeamOne&&item.spProTeamTwo==widget.spProGuessMatch.spProTeamTwo){
            list.add(item);
          }
        }else{
          list.add(item);
        }

    });



    return list;
  }

  List<SPClassEntityHistory> spFunGetHistoryTwoList(String spProHistoryKey) {

    List<SPClassEntityHistory> list=[];
    spProHistoryTwo.forEach((item) {
      if(spProHistoryKey=="主场"){
        if(item.spProTeamOne==widget.spProGuessMatch.spProTeamTwo){
          list.add(item);
        }
      }else if (spProHistoryKey=="同主客"){
        if(item.spProTeamOne==widget.spProGuessMatch.spProTeamOne&&item.spProTeamTwo==widget.spProGuessMatch.spProTeamTwo){
          list.add(item);
        }
      }else if (spProHistoryKey=="客场"){
        if(item.spProTeamTwo==widget.spProGuessMatch.spProTeamTwo){
          list.add(item);
        }
      }else{
        list.add(item);
      }

    });



    return list;
  }

  //value 1 =win ; 2=lose;
  double spFunGetMatchPanKouRate(List<SPClassEntityHistory> valueList,value) {
    var valueCount=0.0;
    valueList.forEach((item) {
      if(value==1&&item.spProWinOrLose=="赢"){
        valueCount+=1;
      }
      if(value==2&&item.spProWinOrLose=="输"){
        valueCount+=1;
      }
      if(value==0&&item.spProWinOrLose=="走"){
        valueCount+=1;
      }

    });
    if(valueCount==0){
      return 0;
    }

    return valueCount/valueList.length;
  }

   //value 1 =win ; 2=lose; 0=draw;
  double spFunGetMatchRate(List<SPClassEntityHistory> valueList,value,{int winTeam:1}) {
      var valueCount=0.0;
      valueList.forEach((item) {
        if(value==1&&spFunIsHistoryWin(item,value: winTeam)){
          valueCount+=1;
        }
        if(value==2&&spFunIsHistoryLose(item,value: winTeam)){
          valueCount+=1;
        }
        if(value==0&&spFunIsHistoryDraw(item)){
          valueCount+=1;
        }

      });
      if(valueCount==0){
        return 0;
      }

      return valueCount/valueList.length;
  }

  //value 1 =win ; 2=lose; 0=draw;

  int spFunGetMatchCount(List<SPClassEntityHistory> valueList,value,{int winTeam:1}) {
    var valueCount=0;
    valueList.forEach((item) {
      if(value==1&&spFunIsHistoryWin(item,value: winTeam)){
        valueCount+=1;
      }
      if(value==2&&spFunIsHistoryLose(item,value: winTeam)){
        valueCount+=1;
      }
      if(value==0&&spFunIsHistoryDraw(item)){
        valueCount+=1;
      }

    });


    return valueCount;
  }


  //value 1 =win ; 2=lose; 0=draw;

  int spFunGetMatchPanKouCount(List<SPClassEntityHistory> valueList,value,{int winTeam:1}) {
    var valueCount=0;
    valueList.forEach((item) {
      if(value==1&&item.spProWinOrLose=="赢"){
        valueCount+=1;
      }
      if(value==2&&item.spProWinOrLose=="输"){
        valueCount+=1;
      }
      if(value==0&&item.spProWinOrLose=="走"){
        valueCount+=1;
      }
      if(value==3&&item.spProBigOrSmall=="大"){
        valueCount+=1;
      }
      if(value==4&&item.spProBigOrSmall=="小"){
        valueCount+=1;
      }
    });


    return valueCount;
  }

  double spFunGetMatchAllPointsScore(int team,key) {
    var result=0.0;
    var one=0;
    var two=0;

      one= (spFunGetMatchCount(spFunGetHistoryOneList(key).take(spFunGetMinListLength(key)).toList(), 1)*3)+(spFunGetMatchCount(spFunGetHistoryOneList(key).take(spFunGetMinListLength(key)).toList(), 0)*1);
      two= (spFunGetMatchCount(spFunGetHistoryTwoList(key).take(spFunGetMinListLength(key)).toList(), 1,winTeam: 2)*3)+
          (spFunGetMatchCount(spFunGetHistoryTwoList(key).take(spFunGetMinListLength(key)).toList(), 0,winTeam: 2)*1);



    if(team==1&&one==0){
      return 0;
    }
    if(team==2&&two==0){
      return 0;
    }

    if(team==1){
      result=  one/(one+two)*25;
    }
    if(team==2){
      result= two/(one+two)*25;
    }

    return result;
  }

  double spFunAvgWinOrLoseScoreOne(bool spProIsWin){
    var result=0.0;
    var winCount=0;
    var loseCount=0;


    spFunGetHistoryOneList("全部").take(spFunGetMinListLength("全部")).toList().forEach((item) {

      if(item.spProTeamOne==widget.spProGuessMatch.spProTeamOne){
         winCount+=int.parse(item.spProScoreOne);
      }
      if(item.spProTeamTwo==widget.spProGuessMatch.spProTeamOne){
         winCount+=int.parse(item.spProScoreTwo);
      }

      if(item.spProTeamOne!=widget.spProGuessMatch.spProTeamOne){
        loseCount+=int.parse(item.spProScoreOne);
      }
      if(item.spProTeamTwo!=widget.spProGuessMatch.spProTeamOne){
        loseCount+=int.parse(item.spProScoreTwo);
      }

    });
     if(spProIsWin&&winCount==0){
        return 0;
     }
     if(!spProIsWin&&loseCount==0){
       return 0;
     }

     if(spProIsWin){
       result=  winCount/spFunGetHistoryOneList("全部").take(spFunGetMinListLength("全部")).toList().length;
     }
     if(!spProIsWin){
       result= loseCount/spFunGetHistoryOneList("全部").take(spFunGetMinListLength("全部")).toList().length;
     }


     return result;
  }
  double spFunAvgWinOrLoseScoreTwo(bool spProIsWin){
    var result=0.0;
    var winCount=0;
    var loseCount=0;


    spFunGetHistoryTwoList("全部").take(spFunGetMinListLength("全部")).toList().forEach((item) {
      if(item.spProTeamOne==widget.spProGuessMatch.spProTeamTwo){
        winCount+=int.parse(item.spProScoreOne);
      }
      if(item.spProTeamTwo==widget.spProGuessMatch.spProTeamTwo){
        winCount+=int.parse(item.spProScoreTwo);
      }

      if(item.spProTeamOne!=widget.spProGuessMatch.spProTeamTwo){
        loseCount+=int.parse(item.spProScoreOne);
      }
      if(item.spProTeamTwo!=widget.spProGuessMatch.spProTeamTwo){
        loseCount+=int.parse(item.spProScoreTwo);
      }
    });


    if(spProIsWin&&winCount==0){
      return 0;
    }
    if(!spProIsWin&&loseCount==0){
      return 0;
    }

    if(spProIsWin){
       result=  winCount/spFunGetHistoryTwoList("全部").take(spFunGetMinListLength("全部")).toList().length ;
    }
    if(!spProIsWin){
       result= loseCount/spFunGetHistoryTwoList("全部").take(spFunGetMinListLength("全部")).toList().length ;
    }


    return result;
  }

  double spFunAvgWinOrLose25Score(bool spProIsWin,int team ){
     var result =0.0;
     var value=0.0;

    if(team==1){
      value=(spFunAvgWinOrLoseScoreOne(spProIsWin));
    }else{
      value=(spFunAvgWinOrLoseScoreTwo(spProIsWin));
    }

    if(value==0){
      return 0;
    }

     result= (value/(spFunAvgWinOrLoseScoreOne(spProIsWin)+ spFunAvgWinOrLoseScoreTwo(spProIsWin))*25);


   return result;
  }

  int spFunGetMinListLength(String key){

    return min(spFunGetHistoryOneList(key).take(10).toList().length, spFunGetHistoryTwoList(key).take(10).toList().length);
  }

  Color spFunGetTeamTextColor(SPClassEntityHistory team, int i,{bool isOne:true}) {

      if(isOne){
        if(i==1&&(team.spProTeamOne==widget.spProGuessMatch.spProTeamOne||widget.spProGuessMatch.spProTeamOneId==team.spProTeamOneId)){
          return Color(0xFF333333);
        }

        if(i==2&&(team.spProTeamTwo==widget.spProGuessMatch.spProTeamOne||widget.spProGuessMatch.spProTeamOneId==team.spProTeamTwoId)){
          return Color(0xFF333333);
        }
      }
      if(!isOne){
        if(i==1&&(team.spProTeamOne==widget.spProGuessMatch.spProTeamTwo||widget.spProGuessMatch.spProTeamTwoId==team.spProTeamOneId)){
          return Color(0xFF333333);
        }

        if(i==2&&(team.spProTeamTwo==widget.spProGuessMatch.spProTeamTwo||widget.spProGuessMatch.spProTeamTwoId==team.spProTeamTwoId)){
          return Color(0xFF333333);
        }
      }

     return Color(0xFF888888);

  }

  double spFunGetForecastHeight( int i) {
    
    if(spProForecastInfo!=null){
      if(i==1){
        return double.tryParse(spProForecastInfo.spProWinPOne)*width(50);
      }
      if(i==0){
        return double.tryParse(spProForecastInfo.spProDrawP)*width(50);
      }
      if(i==2){
        return double.tryParse(spProForecastInfo.spProWinPTwo)*width(50);
      }
    }
    return 0.0;
  }

 double  spFunGetUserSupport(int i) {

   if(spProForecastInfo!=null){
     var supportOne=double.tryParse(spProForecastInfo.spProSupportOneNum);
     var supportTwo=double.tryParse(spProForecastInfo.spProSupportTwoNum);
     var supportDraw=double.tryParse(spProForecastInfo.spProSupportDrawNum);
     double allNum=(supportOne+supportTwo+supportDraw);
     if(allNum==0){
       return 0;
     }
      if(i==1){
        return (supportOne/allNum)*0.5;
      }
     if(i==0){
       return (supportDraw/allNum)*0.5;
     }
     if(i==0){
       return (supportTwo/allNum)*0.5;
     }
   }
   return 0.0;
  }

  String spFunGetSupportRate(int i) {

    if(spProForecastInfo!=null){

      if(i==1){
        return (double.tryParse(spProForecastInfo.spProWinPOne)*100).toStringAsFixed(0)+"%";
      }
      if(i==0){
        return (double.tryParse(spProForecastInfo.spProDrawP)*100).toStringAsFixed(0)+"%";
      }
      if(i==2){
        return (double.tryParse(spProForecastInfo.spProWinPTwo)*100).toStringAsFixed(0)+"%";
      }
    }
    return "";
  }

  void spFunGetForecastInfo() {
    Api.spFunMatchForecast<SPClassForecast>(
        queryParameters: {"guess_match_id":widget.spProGuessMatch.spProGuessMatchId},
        spProCallBack: SPClassHttpCallBack(
            spProOnSuccess: (result){
              if(result.spProWinPTwo!=null){
                spProForecastInfo=result;
                setState(() {});
              }

            }
        )
    );
  }

  void spFunSupportForecast(String witch) {
    if(spFunIsLogin(context: context)){
      Api.spFunForecastAdd<SPClassBaseModelEntity>(
          queryParameters:{
            "guess_match_id":widget.spProGuessMatch.spProGuessMatchId,
            "support_which":witch,
          },
          spProCallBack: SPClassHttpCallBack(
              spProOnSuccess: (result){
                spFunGetForecastInfo();
              }
          ));
    }
  }
}