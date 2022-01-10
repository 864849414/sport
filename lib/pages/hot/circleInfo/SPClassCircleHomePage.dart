import 'dart:async';
import 'dart:math';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassNoticesNotice.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';

import 'package:sport/pages/competition/detail/SPClassMatchDetailPage.dart';
import 'package:sport/pages/hot/circleInfo/SPClassHotCircleList.dart';
import 'package:sport/pages/hot/circleInfo/SPClassNewCircleInfoPage.dart';
import 'package:sport/widgets/SPClassNestedScrollViewRefreshBallStyle.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassCircleHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassCircleHomePageState();
  }

}
class SPClassCircleHomePageState extends State<SPClassCircleHomePage>with AutomaticKeepAliveClientMixin<SPClassCircleHomePage> ,TickerProviderStateMixin<SPClassCircleHomePage>{
  ScrollController spProMsgScrollController;
  ScrollController spProHomeScrollController;
  List<SPClassGuessMatchInfo> spProHotMatch =List();//热门赛事
  List<SPClassNoticesNotice> notices = List();//公告列表
  TabController spProTabCicleInfoController;
  List<SPClassHotCircleList> spProHotViews=List();
  var spProRefreshTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProMsgScrollController=ScrollController(initialScrollOffset: width(25));
    spProHomeScrollController=ScrollController();
    spProHotViews=[SPClassHotCircleList("all"),SPClassHotCircleList("my_following")];
    spProTabCicleInfoController=TabController(length:spProHotViews.length,vsync: this);
    Timer.periodic(Duration(seconds: 2), (timer){
      if(spProMsgScrollController.positions.isNotEmpty){
        spProMsgScrollController.animateTo(spProMsgScrollController.offset+20, duration: Duration(seconds: 2), curve: Curves.linear);
      }
    })    ;

   spFunTabReFresh();




  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  Scaffold(
      floatingActionButton:GestureDetector(
        child:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_new_ciricle_info"),
        width: width(70),
        ),
        onTap: (){
          if(spFunIsLogin(context: context)){
            SPClassNavigatorUtils.spFunPushRoute(context, SPClassNewCircleInfoPage(""));
          }
        },
      ),
      body: Container(
        color: Color(0xFFF1F1F1),
        child: SPClassNestedScrollViewRefreshBallStyle(
          onRefresh: ()  {
            spFunGetHotMatch();
            spFunGetNotices();
            return  spProHotViews[spProTabCicleInfoController.index].spProState.onRefresh();

          },
          child:NestedScrollView(
            controller: spProHomeScrollController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: height(5),),

                        Container(

                          height: height(90),
                          child:  ListView.builder(
                              physics: PageScrollPhysics(),
                              itemCount:spProHotMatch.length ,
                              scrollDirection:Axis.horizontal,
                              itemBuilder: (c, i) =>

                                  Container(
                                    margin: EdgeInsets.only(left:width(15),top: height(8),bottom: height(8)),
                                    width: width(160),
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
                                    ),
                                    padding: EdgeInsets.only(left: width(7) ),
                                    child: Stack(
                                      children: <Widget>[
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(height: height(4),),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text( (spProHotMatch[i].spProMatchType.toLowerCase() == "lol"?  "[电竞] ":("["+
                                                        spProHotMatch[i].spProMatchType.substring(0,1)+
                                                        "] ")+spProHotMatch[i].spProLeagueName),
                                                      style: TextStyle(fontSize: sp(11),
                                                      color:( spProHotMatch[i].spProIsOver=="1" || DateTime.parse(spProHotMatch[i].spProStTime).difference(DateTime.now()).inSeconds>0)? Color(0xFF999999):Color(0xFFFB5146),),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,),
                                                  ),
                                                  ( spProHotMatch[i].status=="in_progress" ) ? Text("进行中",style: TextStyle(fontSize: sp(12),color: Color(0xFFFB5146),),):Text(SPClassDateUtils.spFunDateFormatByString(spProHotMatch[i].spProStTime, "MM-dd HH:mm"),style: TextStyle(fontSize: sp(11),color: Color(0xFF999999),),maxLines: 1,),
                                                  SizedBox(width: width(30),)

                                                ],
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        (spProHotMatch[i].spProIconUrlOne.isNotEmpty)? Image.network(spProHotMatch[i].spProIconUrlOne,width: width(17),):
                                                        SPClassEncryptImage.asset(
                                                          SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                                                          width: width(17),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                          child:  Text( spProHotMatch[i].spProTeamOne,style: TextStyle(fontSize: sp(13),),maxLines: 1,),
                                                        ),
                                                        Text(spProHotMatch[i].status=="not_started" ?  "-":spProHotMatch[i].spProScoreOne,style: TextStyle(fontSize: sp(13),color:spProHotMatch[i].status=="in_progress" ? Color(0xFFFB5146): Color(0xFF999999))),
                                                        SizedBox(width: width(7),),
                                                      ],
                                                    ),
                                                    SizedBox(height: height(5),),
                                                    Row(
                                                      children: <Widget>[
                                                        (spProHotMatch[i].spProIconUrlTwo.isNotEmpty)? Image.network(spProHotMatch[i].spProIconUrlTwo,width: width(17),):
                                                        SPClassEncryptImage.asset(
                                                          SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                                                          width: width(17),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                          child:  Text(spProHotMatch[i].spProTeamTwo,style: TextStyle(fontSize: sp(13),),maxLines: 1,),
                                                        ),
                                                        Text(spProHotMatch[i].status=="not_started" ?  "-":spProHotMatch[i].spProScoreTwo,style: TextStyle(fontSize: sp(13),color:spProHotMatch[i].status=="in_progress" ? Color(0xFFFB5146): Color(0xFF999999))),
                                                        SizedBox(width: width(7),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )

                                            ],
                                          ),
                                          onTap: (){
                                            SPClassApiManager.spFunGetInstance().spFunMatchClick(queryParameters: {"match_id": spProHotMatch[i].spProGuessMatchId});

                                            SPClassNavigatorUtils.spFunPushRoute(context, SPClassMatchDetailPage(spProHotMatch[i],spProMatchType:"guess_match_id",));

                                          },
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child:Container(
                                            padding: EdgeInsets.only(left: 3,right: 3),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width(5)))
                                            ),
                                            child: Text((double.tryParse(spProHotMatch[i].spProSchemeNum)==0 ||!SPClassApplicaion.spProShowMenuList.contains("match_scheme"))? "精选":
                                            ("${spProHotMatch[i].spProSchemeNum}"+
                                                "推荐"),style: TextStyle(color: Colors.white,fontSize: sp(9)),),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                          ),
                        ),

                      ],
                    ),
                  ),
                )
              ];
            },
            pinnedHeaderSliverHeightBuilder: () {
              return   0;
            },
            innerScrollPositionKeyBuilder: () {
              var index = "homeTab";

              index += spProTabCicleInfoController.index.toString();

              return Key(index);
            },
            body:Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: width(13),right: width(13)),
                    height:width(40),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: width(92),
                          child:TabBar(
                            labelColor: Colors.black,
                            labelPadding: EdgeInsets.zero,
                            unselectedLabelColor: Color(0xFF999999),
                            indicatorColor: Colors.black,
                            isScrollable: false,
                            indicatorWeight: 1,
                            indicatorSize:TabBarIndicatorSize.label,
                            labelStyle: GoogleFonts.notoSansSC(fontSize: sp(19),fontWeight: FontWeight.bold),
                            unselectedLabelStyle:  TextStyle(fontSize: sp(13)),
                            controller: spProTabCicleInfoController,
                            tabs:["推荐","关注"].map((key){
                              return    Tab(text: key,);
                            }).toList() ,
                          ),
                        ),


                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: spProTabCicleInfoController,
                      children: spProHotViews.map((view){
                        return NestedScrollViewInnerScrollPositionKeyWidget(
                            Key("homeTab"+
                                spProHotViews.indexOf(view).toString()),
                            view

                        );
                      }).toList(),
                    ),
                  )
                ],
              ) ,
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  void spFunGetNotices() {
/*    ApiManager.getInstance().getNotice<NoticesNotice>(spProCallBack: HttpCallBack(
        spProOnSuccess: (notices){
          if(notices.spProDataList.length>0){
            if(mounted){
              setState(() {
                this.notices=notices.spProDataList;
              });
            }
          }
        }
    ));*/
  }

  spFunGetHotMatch() {
    SPClassApiManager.spFunGetInstance().spFunGuessMatchList<SPClassGuessMatchInfo>(queryParams: {"page": 1,"date":"","spProFetchType": "hot"},spProCallBack: SPClassHttpCallBack(
      spProOnSuccess: (list){
        if(mounted){
          setState(() {
            spProHotMatch=list.spProDataList;
          });
        }
      },
    ));
  }

  void spFunTabReFresh()  {
    if (spProRefreshTime == null ||
        DateTime.now().difference(spProRefreshTime).inSeconds > 30) {
      spFunGetHotMatch();
      spFunGetNotices();
      spProRefreshTime=DateTime.now();

    }
  }






  String spFunGetNewsDefaulf() {

    var list =[SPClassImageUtil.spFunGetImagePath('ic_news_randow_oen'),SPClassImageUtil.spFunGetImagePath('ic_news_randow_two'),SPClassImageUtil.spFunGetImagePath('ic_news_randow_three')
      ,SPClassImageUtil.spFunGetImagePath('ic_news_randow_four'),SPClassImageUtil.spFunGetImagePath('ic_news_randow_five')];


    return list[Random().nextInt(list.length)];


  }
}