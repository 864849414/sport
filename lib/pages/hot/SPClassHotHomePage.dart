
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/pages/hot/circleInfo/SPClassCircleHomePage.dart';
import 'package:sport/pages/hot/forecast/SPClassForecastHomePage.dart';
import 'package:sport/pages/news/info/SPClassNewVideoPage.dart';
import 'package:sport/pages/news/SPClassLoginWebPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';

class SPClassHotHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassHotHomePageState();
  }

}
class SPClassHotHomePageState extends State<SPClassHotHomePage>with AutomaticKeepAliveClientMixin<SPClassHotHomePage> ,TickerProviderStateMixin<SPClassHotHomePage>{
  TabController spProTabCicleInfoController;
  var spProTabTitles=["社区"];
  List<Widget> pageviews=[];
  PageController spProPageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageviews.add(SPClassCircleHomePage());

/*
    spProTabTitles.add("预测");
    pageviews.add(ForecastHomePage()) ;*/
    if(SPClassApplicaion.spProShowMenuList.contains("info")){
      /* spProTabTitles.add("资讯");
      pageviews.add(NewsPage()) ;*/
      spProTabTitles.add("视频");
      pageviews.add(SPClassNewVideoPage()) ;
    }



    if(SPClassApplicaion.spProShowMenuList.contains("bcw_data")){
      spProTabTitles.add("AI大数据");
      pageviews.add(SPClassLoginWebPage("bigDataReport"));
      spProTabTitles.add("冷门分析");
      pageviews.add(SPClassLoginWebPage("coldJudge"));
      spProTabTitles.add("全维预测");
      pageviews.add(SPClassLoginWebPage("allAnalysis"));
      spProTabTitles.add("赔率波动");
      pageviews.add(SPClassLoginWebPage("oddsWave"));
    }


    spProTabCicleInfoController=TabController(length:spProTabTitles.length,vsync: this);

    spProPageController=PageController();


    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="login:out"){
        spProTabCicleInfoController.index=0;
        spProPageController.jumpToPage(0);
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  Scaffold(
      body: Container(
        color: Color(0xFFF1F1F1),
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil.screenWidth,
              padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(width: 0.5,color: Colors.grey[300]))
              ),
              alignment: Alignment.center,
              child:TabBar(
                labelColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: width(10)),
                unselectedLabelColor: Color(0xFF999999),
                indicatorColor: Colors.red,
                isScrollable: true,
                indicatorWeight: 2,
                indicatorSize:TabBarIndicatorSize.label,
                onTap: (index){
                  if(!spFunIsLogin()&&!
                      (spProTabTitles[index].contains("社区")
                      ||spProTabTitles[index].contains("视频")
                      ||spProTabTitles[index].contains("预测"))
                  ){
                     spFunIsLogin(context: context);
                     spProTabCicleInfoController.index=spProTabCicleInfoController.previousIndex;
                     return;
                  }
                  spProPageController.jumpToPage(index);
                },
                labelStyle: GoogleFonts.notoSansSC(fontSize: sp(19),fontWeight: FontWeight.bold),
                unselectedLabelStyle:  TextStyle(fontSize: sp(13)),
                controller: spProTabCicleInfoController,
                tabs:spProTabTitles.map((key){
                  return    Tab(text: key,);
                }).toList() ,
              ),
            ),
            Expanded(
              child: PageView(
                controller: spProPageController,
                physics: const NeverScrollableScrollPhysics(),
                children:pageviews,
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













}