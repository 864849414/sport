import 'dart:async';

import 'package:dio/dio.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBannerItem.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassSchemeDetailEntity.dart';
import 'package:sport/model/SPClassNoticesNotice.dart';
import 'package:sport/pages/home/FollowPage.dart';
import 'package:sport/pages/news/webViewPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/pages/common/SPClassShareView.dart';
import 'package:sport/pages/competition/detail/SPClassMatchDetailPage.dart';
import 'package:sport/pages/competition/scheme/SPClassExpertApplyPage.dart';
import 'package:sport/pages/competition/scheme/SPClassSchemeDetailPage.dart';
import 'package:sport/pages/dialogs/SPClassHomeFilterMatchDialog.dart';
import 'package:sport/pages/home/SPClassTabHotExpert.dart';
import 'package:sport/pages/news/SPClassWebPageState.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:sport/pages/user/SPClassContactPage.dart';
import 'package:sport/utils/colors.dart';
import 'package:sport/widgets/SPClassNestedScrollViewRefreshBallStyle.dart';
import 'SPClassHomeSchemeList.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/pages/home/AIAnalysisPage.dart';

class SPClassHomePage extends StatefulWidget {
  SPClassHomePageState spProState;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState = SPClassHomePageState();
  }
}

class SPClassHomePageState extends State<SPClassHomePage>
    with
        AutomaticKeepAliveClientMixin<SPClassHomePage>,
        TickerProviderStateMixin<SPClassHomePage> {
  var banners = List<SPClassBannerItem>();
  TabController spProTabSchemeController;
  TabController spProTabMatchController;   //???????????????
  PageController spProPageControlller;
  ScrollController spProMsgScrollController;
  ScrollController spProHomeScrollController;
  List<SPClassNoticesNotice> notices = List(); //????????????
  static String spProHomeMatchType = "??????";
  static String spProHomeMatchTypeKey = "is_zq_expert";
  var spProShowTitle = false;
  var spProShowTopView = false;
  var spProTabMatchTitles = ['??????', '??????', '??????', 'AI??????'];
  var spProTabMatchKeys = ['',"??????", "??????"];
  var spProTabSchemeTitles = ["?????????","??????",  "??????"];
  var spProTabSchemeKeys = ["recent_correct_rate","newest",  "free"];
  var spProTabExpertKeys = ['',"is_zq_expert", "is_lq_expert", "is_es_expert"];
  List<SPClassGuessMatchInfo> spProHotMatch =List();//????????????
  var spProPayWay = "";
  var spProReFreshTime;
  List<SPClassHomeSchemeList> spProSchemeViews = List();
  List<SPClassTabHotExpert> spProTabHotViews = List();
  GlobalKey spProKeyTopTitle = GlobalKey();
  GlobalKey spProKeyBannerItem = GlobalKey();
  double spProTopOffset = 0.0;
  double spProHeightNoticeItem = 0.0;
  int spProTabSchemeIndex = 0;
  int spProTabMatchIndex = 1; //??????????????????
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunGetHotMatch();
    // if (SPClassApplicaion.spProShowMenuList.contains("es")) {
    //   spProTabMatchTitles.add("????????????");
    //   spProTabMatchKeys.add("lol");
    // }
    spProMsgScrollController = ScrollController(initialScrollOffset: width(25));
    spProHomeScrollController = ScrollController();
    spProTabSchemeController = TabController(
        length: spProTabSchemeTitles.length,
        vsync: this,
        initialIndex: (spFunIsLogin() &&
                SPClassApplicaion.spProUserLoginInfo.spProIsFirstLogin)
            ? 2
            : 0);
    spProTabMatchController =
        TabController(length: spProTabMatchTitles.length,initialIndex: 1, vsync: this);
    spProSchemeViews = spProTabSchemeKeys.map((key) {
      return SPClassHomeSchemeList(
        spProFetchType: key,
        spProPayWay: spProPayWay,
        spProShowProfit: key != "recent_correct_rate",
      );
    }).toList();
    spProTabHotViews =
        spProTabExpertKeys.map((key) => SPClassTabHotExpert(key)).toList();
    spProPageControlller = PageController();

    Timer.periodic(Duration(seconds: 2), (timer) {
      if (spProMsgScrollController.positions.isNotEmpty) {
        spProMsgScrollController.animateTo(spProMsgScrollController.offset + 20,
            duration: Duration(seconds: 2), curve: Curves.linear);
      }
    });
    spProTabMatchController.addListener(() {
      if (spProTabMatchIndex == spProTabMatchController.index) {
        return;
      }
      spProTabMatchIndex = spProTabMatchController.index;
      setState(() {});
      if (spProTabMatchTitles[spProTabMatchController.index]=='AI??????'||spProTabMatchTitles[spProTabMatchController.index]=='??????') {
        return;
      }
      spProHomeMatchType = spProTabMatchKeys[spProTabMatchController.index];
      spProHomeMatchTypeKey = spProTabExpertKeys[spProTabMatchController.index];

      SPClassApplicaion.spProEventBus.fire("scheme:refresh" +
          "${spProTabMatchKeys[spProTabMatchController.index]}");

    });
    spProTabSchemeController.addListener(() {
      if (spProTabSchemeIndex == spProTabSchemeController.index) {
        return;
      }
      spProTabSchemeIndex = spProTabSchemeController.index;
      if (spProTabSchemeController.index == 1) {
        SPClassApiManager.spFunGetInstance().spFunLogAppEvent(
          spProEventName: "high_correct_rate",
        );
      } else if (spProTabSchemeController.index == 2) {
        SPClassApiManager.spFunGetInstance().spFunLogAppEvent(
          spProEventName: "high_max_red",
        );
      }
    });
    spFunGetBannerList();
    spFunGetNotices();

    spProHomeScrollController.addListener(() {
      if (spProHomeScrollController.offset >=
          ((kToolbarHeight + ScreenUtil.statusBarHeight) * 0.8)) {
        if (!spProShowTitle) {
          if (mounted) {
            setState(() {
              spProShowTitle = true;
            });
          }
        }
      } else {
        if (spProShowTitle) {
          if (mounted) {
            setState(() {
              spProShowTitle = false;
            });
          }
        }
      }

      if (spProHomeScrollController.offset >= (spProTopOffset)) {
        if (!spProShowTopView) {
          if (mounted) {
            setState(() {
              spProShowTopView = true;
            });
          }
        }
      } else {
        if (spProShowTopView) {
          if (mounted) {
            setState(() {
              spProShowTopView = false;
            });
          }
        }
      }
    });

    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if (event == "loginInfo") {
        // getSeqNum();
        if (spFunIsLogin() &&
            SPClassApplicaion.spProUserLoginInfo.spProIsFirstLogin) {
          spProTabSchemeController.index = 2;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      // floatingActionButton: AnimatedContainer(
      //   duration: Duration(milliseconds: 200),
      //   child: !spProShowTopView||spProTabMatchTitles[spProTabMatchController.index]=='AI??????'||spProTabMatchTitles[spProTabMatchController.index]=='??????'
      //       ? SizedBox()
      //       : GestureDetector(
      //           child: Container(
      //             padding: EdgeInsets.all(width(4)),
      //             decoration: ShapeDecoration(
      //               shape: CircleBorder(
      //                   side: BorderSide(color: Color(0xFF666666), width: 0.4)),
      //             ),
      //             child: Icon(
      //               Icons.vertical_align_top,
      //               color: Color(0xFF666666),
      //               size: width(25),
      //             ),
      //           ),
      //           onTap: () {
      //             spFunScrollTop();
      //           },
      //         ),
      // ),
      body: Container(
        // margin:EdgeInsets.only(top: height(50)),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              color: MyColors.main1,
              height: width(48),
              padding: EdgeInsets.only(
                  // top: height(14),
                  // bottom: height(8),
                  left: width(18),
                  right: width(18)),
              child: Container(
                height: height(26),
                child: TabBar(
                    // indicator: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(width(150))),
                    labelColor: MyColors.main1,
                    labelPadding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    unselectedLabelColor: Colors.white,
                    unselectedLabelStyle: GoogleFonts.notoSansSC(
                      fontSize: sp(17),
                    ),
                    isScrollable: false,
                    // indicatorSize:TabBarIndicatorSize.tab,
                    labelStyle: GoogleFonts.notoSansSC(
                      fontSize: sp(17),
                      fontWeight: FontWeight.w500,
                    ),
                    controller: spProTabMatchController,
                    tabs: spProTabMatchTitles.map((key) {
                      return Container(
                        width: width(65),
                        height: width(27),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:spProTabMatchController.index==spProTabMatchTitles.indexOf(key)?Colors.white: MyColors.main1,
                          borderRadius: BorderRadius.circular(width(150)),
                        ),
                        child: Text(key),
                      );
                      // return Tab(
                      //   text: key,
                      // );
                    }).toList()),
              ),
            ),
            spProTabMatchTitles[spProTabMatchController.index]=='??????'?FollowPage():
            spProTabMatchTitles[spProTabMatchController.index]=='AI??????'?AIAnalysis():
            Expanded(
              child: SPClassNestedScrollViewRefreshBallStyle(
                onRefresh: () {
                  spFunGetBannerList();
                  spFunGetNotices();
                  spFunGetHotMatch();
                  spProTabHotViews[spProTabMatchController.index]
                      .spProState
                      .onRefresh();
                  return spProSchemeViews[spProTabSchemeController.index]
                      .spProState
                      .spFunOnRefresh(spProPayWay,
                          spProTabMatchKeys[spProTabMatchController.index]);
                },
                child: NestedScrollView(
                  controller: spProHomeScrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool boxIsScrolled) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          height: width(86),
                          padding: EdgeInsets.only(left: width(15),right: width(15),),
                          margin: EdgeInsets.only(top: width(12),),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: spProHotMatch.map((e) {
                              return matchSchedule(e);
                            }).toList(),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: IndexedStack(
                          index: spProTabMatchController.index,
                          children: spProTabHotViews,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: Color(0xFFF2F2F2),
                          height: height(8),
                        ),
                      ),
                    ];
                  },
                  pinnedHeaderSliverHeightBuilder: () {
                    return 0;
                  },
                  innerScrollPositionKeyBuilder: () {
                    var index = "homeTab";
                    index += spProTabSchemeController.index.toString();
                    return Key(index);
                  },
                  body: Container(
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         offset: Offset(2, 5),
                    //         color: Color(0x0C000000),
                    //         blurRadius: width(
                    //           6,
                    //         ),
                    //       ),
                    //       BoxShadow(
                    //         offset: Offset(-5, 1),
                    //         color: Color(0x0C000000),
                    //         blurRadius: width(
                    //           6,
                    //         ),
                    //       )
                    //     ],
                    //     borderRadius: BorderRadius.circular(width(7))),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            key: spProKeyTopTitle,
                            padding: EdgeInsets.only(
                                left: width(13), right: width(13)),
                            height: width(42),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.4, color: Colors.grey[300]))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width:
                                      width(70 * spProTabSchemeTitles.length),
                                  child: TabBar(
                                    labelColor: MyColors.main1,
                                    labelPadding: EdgeInsets.zero,
                                    unselectedLabelColor: Color(0xFF666666),
                                    indicatorColor: MyColors.main1,
                                    isScrollable: false,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorPadding: EdgeInsets.symmetric(horizontal: width(24)),
                                    labelStyle: GoogleFonts.notoSansSC(
                                        fontSize: sp(15),
                                        fontWeight: FontWeight.bold),
                                    unselectedLabelStyle:
                                        TextStyle(fontSize: sp(13)),
                                    controller: spProTabSchemeController,
                                    tabs: spProTabSchemeTitles.map((tab) {
                                      return Tab(
                                        text: tab,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Container(
                                  height: width(19),
                                  width: width(0.4),
                                  color: Color(0xFFCCCCCC),
                                  margin: EdgeInsets.only(right: width(10)),
                                ),
                                GestureDetector(
                                  child: SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath(
                                        "shaixuan"),
                                    width: width(23),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        child: SPClassHomeFilterMatchDialog(
                                            (value) {
                                          spProPayWay = value;
                                          spProSchemeViews[
                                                  spProTabSchemeController
                                                      .index]
                                              .spProState
                                              .spFunOnRefresh(
                                                  spProPayWay,
                                                  spProTabMatchKeys[
                                                      spProTabMatchController
                                                          .index]);
                                        },
                                            spProTabMatchKeys[
                                                spProTabMatchController
                                                    .index]));
                                  },
                                )
                              ],
                            ),
                          ),
                          onDoubleTap: () {
                            spFunScrollTop();
                          },
                        ),
                        SizedBox(
                          height:width(3) ,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: spProTabSchemeController,
                            children: spProSchemeViews.map((view) {
                              return NestedScrollViewInnerScrollPositionKeyWidget(
                                  Key("homeTab" +
                                      "${spProSchemeViews.indexOf(view).toString()}"),
                                  view);
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget matchSchedule(SPClassGuessMatchInfo data){
    return Container(
      height: height(86),
      // margin: EdgeInsets.only(left:width(i==0?14:8),),
      width: width(160),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow:[
            BoxShadow(
              offset: Offset(0,0),
              color: Color(0xFFCED4D9),
              blurRadius:width(6,),),
          ],
          borderRadius: BorderRadius.circular(width(8))
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
                    ( data.status=="in_progress" ) ? Text("?????????",style: TextStyle(fontSize: sp(12),color: Color(0xFFFB5146),),):Text(SPClassDateUtils.spFunDateFormatByString(data.spProStTime, "MM-dd HH:mm"),style: TextStyle(fontSize: sp(11),color: Color(0xFF999999),),maxLines: 1,),
                    Text("???${SPClassStringUtils.spFunMaxLength(data.spProLeagueName,length: 3)}???",style: TextStyle(fontSize: sp(11),color: Color(0xFF999999),),maxLines: 1,),
                    SizedBox(width: 25,)
                  ],
                ),

                Expanded(
                  child: data.status=="not_started" ?
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  (data.spProIconUrlOne.isNotEmpty)? Image.network(data.spProIconUrlOne,width: width(17),):
                                  SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                                    width: width(17),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child:  Text(data.spProTeamOne,style: TextStyle(fontSize: sp(13),),maxLines: 1,),
                                  ),
                                  SizedBox(width: width(7),),
                                ],
                              ),
                              SizedBox(height: height(5),),
                              Row(
                                children: <Widget>[
                                  (data.spProIconUrlTwo.isNotEmpty)? Image.network(data.spProIconUrlTwo,width: width(17),):
                                  SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                                    width: width(17),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child:  Text(data.spProTeamTwo,style: TextStyle(fontSize: sp(13),),maxLines: 1,),
                                  ),
                                  SizedBox(width: width(7),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '???',
                        style: TextStyle(
                            fontSize: sp(14),
                            color:
                            MyColors.grey_99),
                      ),
                      SizedBox(width: 12,)
                    ],
                  ):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          (data.spProIconUrlOne.isNotEmpty)? Image.network(data.spProIconUrlOne,width: width(17),):
                          SPClassEncryptImage.asset(
                            SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                            width: width(17),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child:  Text(data.spProTeamOne,style: TextStyle(fontSize: sp(13),),maxLines: 1,),
                          ),
                          Text(data.status=="not_started" ?  "-":data.spProScoreOne,style: TextStyle(fontSize: sp(13),color:data.status=="in_progress" ? Color(0xFFFB5146): Color(0xFF999999))),
                          SizedBox(width: width(7),),
                        ],
                      ),
                      SizedBox(height: height(5),),
                      Row(
                        children: <Widget>[
                          (data.spProIconUrlTwo.isNotEmpty)? Image.network(data.spProIconUrlTwo,width: width(17),):
                          SPClassEncryptImage.asset(
                            SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                            width: width(17),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child:  Text(data.spProTeamTwo,style: TextStyle(fontSize: sp(13),),maxLines: 1,),
                          ),
                          Text(data.status=="not_started" ?  "-":data.spProScoreTwo,style: TextStyle(fontSize: sp(13),color:data.status=="in_progress" ? Color(0xFFFB5146): Color(0xFF999999))),
                          SizedBox(width: width(7),),
                        ],
                      ),
                    ],
                  ),
                )

              ],
            ),
            onTap: (){
              SPClassApiManager.spFunGetInstance().spFunMatchClick(queryParameters: {"match_id": data.spProGuessMatchId});

              SPClassNavigatorUtils.spFunPushRoute(context, SPClassMatchDetailPage(data,spProMatchType:"guess_match_id",));

            },
          ),
          Positioned(
            right: 0,
            top: 0,
            child:Container(
              width: width(39),
              height: width(17),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width(5)),topRight: Radius.circular(width(5))),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF1DBDF2),
                        Color(0xFF1D99F2),
                      ]
                  )
              ),
              child: Text('${data.spProSchemeNum}??????',style: TextStyle(color: Colors.white,fontSize: sp(10)),),
            ),
          )
        ],
      ),
    );
  }

  void spFunGetBannerList() {
    SPClassApiManager.spFunGetInstance().spFunGetBanner<SPClassBannerItem>(
        spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result) {
          setState(() {
            banners = result.spProDataList;
          });
        }),
        queryParameters: {"type": "analysis"});
  }

  void spFunGetNotices() {
    SPClassApiManager.spFunGetInstance().spFunGetNotice<SPClassNoticesNotice>(
        spProCallBack: SPClassHttpCallBack(spProOnSuccess: (notices) {
      if (notices.spProDataList.length > 0) {
        if (mounted) {
          setState(() {
            this.notices = notices.spProDataList;
          });
        }
      }
    }));
  }

  void spFunTabReFresh() {
    if (spProReFreshTime == null ||
        DateTime.now().difference(spProReFreshTime).inSeconds > 30) {
      spFunGetBannerList();
      spFunGetNotices();
      spProTabHotViews[spProTabMatchController.index].spProState.onRefresh();
      spProSchemeViews[spProTabSchemeController.index]
          .spProState
          .spFunOnRefresh(
              spProPayWay, spProTabMatchKeys[spProTabMatchController.index]);
      spProReFreshTime = DateTime.now();
    }
  }

  void spFunScrollTop() {
    RenderBox renderBox = spProKeyTopTitle.currentContext.findRenderObject();

    spProHomeScrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  spFunGoRoutPage(
      String urlPage, String title, String spProMsgId, bool isDemo) {
    if (spProMsgId != null) {
      SPClassApiManager.spFunGetInstance().spFunPushMsgClick(
          pushMsgId: spProMsgId,
          isDemo: isDemo,
          spProAutoLoginStr: spFunIsLogin()
              ? SPClassApplicaion.spProUserLoginInfo.spProAutoLoginStr
              : "");
    }
    if (urlPage == null || urlPage.trim().isEmpty) {
      return;
    }
    if (urlPage.startsWith("hs_sport:")) {
      Uri url = Uri.parse(urlPage.replaceAll("hs_sport", "hssport"));
      if (urlPage.contains("scheme?")) {
        if (spFunIsLogin(context: context)) {
          SPClassApiManager.spFunGetInstance().spFunSchemeDetail(
              queryParameters: {"scheme_id": url.queryParameters["scheme_id"]},
              context: context,
              spProCallBack: SPClassHttpCallBack<SPClassSchemeDetailEntity>(
                  spProOnSuccess: (value) {
                SPClassNavigatorUtils.spFunPushRoute(
                    context, SPClassSchemeDetailPage(value));
              }));
        }
      }
      if (urlPage.contains("expert?")) {
        SPClassApiManager.spFunGetInstance().spFunExpertInfo(
            queryParameters: {"expert_uid": url.queryParameters["expert_uid"]},
            context: context,
            spProCallBack: SPClassHttpCallBack(spProOnSuccess: (info) {
              SPClassNavigatorUtils.spFunPushRoute(
                  context, SPClassExpertDetailPage(info));
            }));
      }
      if (urlPage.contains("guess_match?")) {
        SPClassApiManager.spFunGetInstance()
            .spFunSportMatchData<SPClassGuessMatchInfo>(
                loading: true,
                context: context,
                spProGuessMatchId: url.queryParameters["guess_match_id"],
                dataKeys: "guess_match",
                spProCallBack:
                    SPClassHttpCallBack(spProOnSuccess: (result) async {
                  SPClassNavigatorUtils.spFunPushRoute(
                      context,
                      SPClassMatchDetailPage(
                        result,
                        spProMatchType: "guess_match_id",
                        spProInitIndex: 1,
                      ));
                }));
      }
      if (urlPage.contains("invite")) {
        if (spFunIsLogin(context: context)) {
          SPClassApiManager.spFunGetInstance().spFunShare(
              context: context,
              spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result) {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SPClassShareView(
                        title: result.title,
                        spProDesContent: result.content,
                        spProPageUrl: result.spProPageUrl ??
                            SPClassNetConfig.spFunGetShareUrl(),
                        spProIconUrl: result.spProIconUrl,
                      );
                    });
              }));
        }
      }
      if (urlPage.contains("contact_cs")) {
        SPClassNavigatorUtils.spFunPushRoute(context, SPClassContactPage());
      }

      if (urlPage.contains("apply_expert")) {
        if (spFunIsLogin(context: context)) {
          SPClassNavigatorUtils.spFunPushRoute(
              context, SPClassExpertApplyPage());
        }
      }

      if (urlPage.contains("big_data_report")) {
        if (spFunIsLogin(context: context)) {
          spFunGetBcwUrl("bigDataReport");
        }
      }
      if (urlPage.contains("all_analysis")) {
        if (spFunIsLogin(context: context)) {
          spFunGetBcwUrl("allAnalysis");
        }
      }

      if (urlPage.contains("odds_wave")) {
        if (spFunIsLogin(context: context)) {
          spFunGetBcwUrl("oddsWave");
        }
      }
      if (urlPage.contains("dark_horse_analysis")) {
        if (spFunIsLogin(context: context)) {
          spFunGetBcwUrl("coldJudge");
        }
      }
    } else {
      SPClassNavigatorUtils.spFunPushRoute(
          context, SPClassWebPage(urlPage, title));
    }
  }

  void spFunGetBcwUrl(String value) {
    if (spFunIsLogin(context: context)) {
      var params = SPClassApiManager.spFunGetInstance().spFunGetCommonParams();
      params.putIfAbsent("model_type", () => value);
//      SPClassNavigatorUtils.spFunPushRoute(context, SPClassWebPage( SPClassNetConfig.spFunGetBasicUrl()+"user/bcw/login?"+Transformer.urlEncodeMap(params),""));
      SPClassNavigatorUtils.spFunPushRoute(
          context,
          WebViewPage(
              SPClassNetConfig.spFunGetBasicUrl() +
                  "user/bcw/login?" +
                  Transformer.urlEncodeMap(params),
              ""));
    }
  }

  spFunGetHotMatch() {
    SPClassApiManager.spFunGetInstance().spFunGuessMatchList<SPClassGuessMatchInfo>(queryParams: {"page": 1,"date":"","spProFetchType": "hot"},spProCallBack: SPClassHttpCallBack(
      spProOnSuccess: (list){
        if(mounted){
          setState(() {
            spProHotMatch=list.spProDataList.length>2?list.spProDataList.sublist(0,2):list.spProDataList;
          });
        }
      },
    ));
  }
}
