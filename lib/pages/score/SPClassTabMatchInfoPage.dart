import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';

import 'SPClassMatchDateList.dart';


class SPClassTabMatchInfoPage extends StatefulWidget {
  String spProMatchType;
  SPClassTabMatchInfoPageState spProState;
  SPClassTabMatchInfoPage(this.spProMatchType);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState=SPClassTabMatchInfoPageState();
  }

}

class SPClassTabMatchInfoPageState extends  State<SPClassTabMatchInfoPage> with TickerProviderStateMixin{
  TabController spProTabController;
  List<SPClassMatchDateList> views=List();
  var spProTabTitle =["全部","即时","赛果","赛程","关注"];
  var spProReFreshTime;
  static int spProReTime=30;
   int follow = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFollowlist();
    var match_key=(widget.spProMatchType=="足球"? "zq":widget.spProMatchType=="篮球"? "lq":"dj");
    views.add(SPClassMatchDateList(status: "all",spProMatchType:widget.spProMatchType));
    views.add(SPClassMatchDateList(status: "in_progress",spProMatchType:widget.spProMatchType));
    views.add(SPClassMatchDateList(status: "over",spProMatchType:widget.spProMatchType,));
    views.add(SPClassMatchDateList(status: "not_started",spProMatchType:widget.spProMatchType));
    views.add(SPClassMatchDateList(status: "my_collected",spProMatchType:widget.spProMatchType));
    spProTabController=TabController(length: spProTabTitle.length,vsync: this,);
    spProTabController.addListener((){
      if(views[spProTabController.index].status=="my_collected"){
          SPClassApplicaion.spProEventBus.fire("score:hidden");
      }else{
        SPClassApplicaion.spProEventBus.fire("score:show");
      }
      (views[spProTabController.index]).spProState.spFunOnRefreshPassive();
      switch(spProTabController.index){
         case 0:
           SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "${match_key}_match_list",);
           break;
        case 2:
          SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "${match_key}_ended_match",);
          break;
        case 3:
          SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "${match_key}_not_started_match",);
          break;
      }
    });
    SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "${match_key}_match_list",);

    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event.startsWith("match:")){
         if(event.contains("全部")){
           spProTabTitle[0]="全部";
         }
         if(event.contains("热门")){
           spProTabTitle[0]="热门";
         }
         setState(() {});
      }
    });

    Timer.periodic(Duration(seconds: spProReTime), (time){
      spFunRefreshData();
    });

    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="score:refresh"){
        // getSeqNum();
        (views[spProTabController.index]).spProState.spFunOnRefreshPassive();

      }
      if(event == 'updateFollow'){
        spFollowlist();
      }
    });
  }
  Future<void> spFollowlist() async{
    await SPClassApiManager.spFunGetInstance().spFunGuessMatchList<SPClassGuessMatchInfo>(
        queryParams: {
          'fetch_type':'my_collected'
        },spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (list){
          follow = list.spProDataList.length;
          setState(() {});
        },
        onError: (result){
        }
    ));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
              ),
              child: TabBar(
                  labelColor: Color(0xFFE3494B),
                  unselectedLabelColor: Color(0xFF666666),
                  isScrollable: false,
                  indicatorColor: Color(0xFFE3494B),
                  labelStyle: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.bold),
                  unselectedLabelStyle: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w400),
                  controller: spProTabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs:spProTabTitle.map((spProTabTitle){
                    return Container(
                      alignment: Alignment.center,
                      height: height(35),
                      child:Text(spProTabTitle,style: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: sp(15)),),
                    );
                  }).toList()
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: spProTabController,
                children: views,
              ),
            )
          ],
        ),
        follow>0?Positioned(
          right:width(5),
//          top: width(2),
          child:Opacity(
            opacity: 0.8,
            child: Container(
              alignment: Alignment.center,
              width: width(22),
              height: height(22),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle, //可以设置角度，BoxShape.circle直接圆形
                ),
              child: Padding(
                padding:  EdgeInsets.only(bottom: width(0)),
                child: Center(child: Text(follow < 100?'$follow':'99+',style: TextStyle(color: Colors.black,fontSize: width(10)))),
              ),
            ),
          ),
        ):Container()
      ],
    );
  }

  void spFunRefreshData(){
    if (spProReFreshTime == null ||
        DateTime.now().difference(spProReFreshTime).inSeconds > spProReTime) {
      (views[spProTabController.index]).spProState.spFunOnRefreshPassive();
      spProReFreshTime=DateTime.now();
    }
  }
  void spFunRefreshTab(){

    if (spProReFreshTime == null ||
        DateTime.now().difference(spProReFreshTime).inSeconds > spProReTime) {
      (views[spProTabController.index]).spProState.spProListScrollController.jumpTo(0, );
      (views[spProTabController.index]).spProState.spFunOnReFresh();
      spProReFreshTime=DateTime.now();
    }
  }
  void spFunReFreshByFilter(String leagueVale,String spProIsLottery){
      (views[spProTabController.index]).spProState.onReFreshByFilter(leagueVale, spProIsLottery);

  }

  String get spFunGetCurrentDate =>  (views[spProTabController.index]).spProState.dates[(views[spProTabController.index]).spProState.spProDateIndex];
  String get spFunGetLeagueName =>  (views[spProTabController.index]).spProState.spFunLeagueName;
  Map<String,dynamic> get spFunGetParams =>  (views[spProTabController.index]).spProState.spFunGetMatchListParams(1);
  bool get spFunIsMatchHot =>  (views[spProTabController.index]).spProState.spFunIsMatchHot;




}