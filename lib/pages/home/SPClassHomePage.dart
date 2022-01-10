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
import 'package:sport/pages/news/webViewPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
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
  TabController spProTabMatchController;
  PageController spProPageControlller;
  ScrollController spProMsgScrollController;
  ScrollController spProHomeScrollController;
  List<SPClassNoticesNotice> notices = List(); //公告列表
  static String spProHomeMatchType = "足球";
  static String spProHomeMatchTypeKey = "is_zq_expert";
  var spProShowTitle = false;
  var spProShowTopView = false;
  var spProTabMatchTitles = ['关注', '足球', '篮球', 'AI分析'];
  var spProTabMatchKeys = ["足球", "篮球"];
  var spProTabSchemeTitles = ["最新", "高胜率", "免费"];
  var spProTabSchemeKeys = ["newest", "recent_correct_rate", "free"];
  var spProTabExpertKeys = ["is_zq_expert", "is_lq_expert", "is_es_expert"];
  var spProPayWay = "";
  var spProReFreshTime;
  List<SPClassHomeSchemeList> spProSchemeViews = List();
  List<SPClassTabHotExpert> spProTabHotViews = List();
  GlobalKey spProKeyTopTitle = GlobalKey();
  GlobalKey spProKeyBannerItem = GlobalKey();
  double spProTopOffset = 0.0;
  double spProHeightNoticeItem = 0.0;
  int spProTabSchemeIndex = 0;
  int spProTabMatchIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (SPClassApplicaion.spProShowMenuList.contains("es")) {
      spProTabMatchTitles.add("电竞专家");
      spProTabMatchKeys.add("lol");
    }
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
        TabController(length: spProTabMatchTitles.length, vsync: this);
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
      if (spProTabMatchTitles[spProTabMatchController.index]=='AI分析') {
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
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: !spProShowTopView||spProTabMatchTitles[spProTabMatchController.index]=='AI分析'
            ? SizedBox()
            : GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(width(4)),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                        side: BorderSide(color: Color(0xFF666666), width: 0.4)),
                  ),
                  child: Icon(
                    Icons.vertical_align_top,
                    color: Color(0xFF666666),
                    size: width(25),
                  ),
                ),
                onTap: () {
                  spFunScrollTop();
                },
              ),
      ),
      body: Container(
        // margin:EdgeInsets.only(top: height(50)),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              color: MyColors.main1,
              // padding:EdgeInsets.symmetric(vertical: height(11),horizontal: width(20)),
              padding: EdgeInsets.only(
                  top: height(14),
                  bottom: height(8),
                  left: width(20),
                  right: width(20)),
              child: Container(
                height: height(26),
                child: TabBar(
                    indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width(150))),
                    labelColor: MyColors.main1,
                    labelPadding: EdgeInsets.zero,
                    unselectedLabelColor: Colors.white,
                    indicatorColor: MyColors.main1,
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
                      return Tab(
                        text: key,
                      );
                    }).toList()),
              ),
            ),
            spProTabMatchTitles[spProTabMatchController.index]=='AI分析'?AIAnalysis():
            Expanded(
              child: SPClassNestedScrollViewRefreshBallStyle(
                onRefresh: () {
                  spFunGetBannerList();
                  spFunGetNotices();
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
                        child: IndexedStack(
                          index: spProTabMatchController.index,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: width(16),
                                  right: width(16),
                                  top: height(12)),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: <Widget>[

                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width(12),
                                              vertical: width(10)),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(0.0, 0), //阴影xy轴偏移量
                                                    blurRadius: 6, //阴影模糊程度
                                                    spreadRadius: 1.0 //阴影扩散程度
                                                )
                                              ],),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text.rich(
                                                TextSpan(children: [
                                                  TextSpan(
                                                    text: '16:00 ',
                                                    style: TextStyle(
                                                        color: MyColors.grey_99,
                                                        fontSize: sp(12)),
                                                  ),
                                                  TextSpan(
                                                    text: '「意甲」 ',
                                                    style: TextStyle(
                                                        color: MyColors.grey_99,
                                                        fontSize: sp(12)),
                                                  ),
                                                ]),
                                              ),
                                              SizedBox(
                                                height: height(8),
                                              ),
                                              Container(
                                                height: height(44),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              width: width(20),
                                                              height: width(20),
                                                              color:
                                                              Colors.blue,
                                                            ),
                                                            SizedBox(
                                                              width: width(4),
                                                            ),
                                                            Text(
                                                              '西部联赛',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  sp(14)),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              width: width(20),
                                                              height: width(20),
                                                              color:
                                                              Colors.blue,
                                                            ),
                                                            SizedBox(
                                                              width: width(4),
                                                            ),
                                                            Text(
                                                              '西部联赛',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  sp(14)),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      '未',
                                                      style: TextStyle(
                                                          fontSize: sp(14),
                                                          color:
                                                          MyColors.grey_99),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            child: Text(
                                              '19观点',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: sp(10)),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                    Radius.circular(6),
                                                    topRight:
                                                    Radius.circular(6)),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF24AEF2),
                                                      Color(0xFF2285E6)
                                                    ])),
                                            padding: EdgeInsets.all(width(4)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width(8),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width(12),
                                              vertical: width(10)),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(0.0, 0), //阴影xy轴偏移量
                                                    blurRadius: 6, //阴影模糊程度
                                                    spreadRadius: 1.0 //阴影扩散程度
                                                )
                                              ],),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text.rich(
                                                TextSpan(children: [
                                                  TextSpan(
                                                    text: '进行中... ',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFF74825),
                                                        fontSize: sp(12)),
                                                  ),
                                                  TextSpan(
                                                    text: '「意甲」 ',
                                                    style: TextStyle(
                                                        color: MyColors.grey_99,
                                                        fontSize: sp(12)),
                                                  ),
                                                ]),
                                              ),
                                              SizedBox(
                                                height: height(8),
                                              ),
                                              Container(
                                                height: height(44),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              width: width(20),
                                                              height: width(20),
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            SizedBox(
                                                              width: width(4),
                                                            ),
                                                            Text(
                                                              '西部联赛',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      sp(14)),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              width: width(20),
                                                              height: width(20),
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            SizedBox(
                                                              width: width(4),
                                                            ),
                                                            Text(
                                                              '西部联赛',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      sp(14)),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          '1',
                                                          style: TextStyle(
                                                              fontSize: sp(18),
                                                              color: Color(
                                                                  0xFFF74825),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '0',
                                                          style: TextStyle(
                                                              fontSize: sp(18),
                                                              color: MyColors
                                                                  .grey_99,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            child: Text(
                                              '19观点',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: sp(10)),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                    Radius.circular(6),
                                                    topRight:
                                                    Radius.circular(6)),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF24AEF2),
                                                      Color(0xFF2285E6)
                                                    ])),
                                            padding: EdgeInsets.all(width(4)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                                        blurRadius: 15.0, //阴影模糊程度
                                        spreadRadius: 1.0 //阴影扩散程度
                                    )
                                  ]),
                            ),
                            Container(
                              height: 20,
                              color: Colors.green,
                            ),
                          ].toList(),
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
                            height: width(35),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.4, color: Colors.grey[300]))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width:
                                      width(47.0 * spProTabSchemeTitles.length),
                                  child: TabBar(
                                    labelColor: MyColors.main1,
                                    labelPadding: EdgeInsets.zero,
                                    unselectedLabelColor: Color(0xFF666666),
                                    indicatorColor: MyColors.main1,
                                    isScrollable: false,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelStyle: GoogleFonts.notoSansSC(
                                        fontSize: sp(13),
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
                                GestureDetector(
                                  child: SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath(
                                        "ic_filter"),
                                    color: Color(0xFF666666),
                                    width: width(17),
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
}
