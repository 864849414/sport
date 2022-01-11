import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/pages/news/webViewPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/pages/news/SPClassWebPageState.dart';
import 'package:sport/utils/colors.dart';
import 'SPClassHomeRangkingList.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassTabHotExpert extends StatefulWidget {
 String spProMatchType ;
 SPClassTabHotExpertState spProState;

 SPClassTabHotExpert(this.spProMatchType);
 @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState=SPClassTabHotExpertState();
  }

}


class SPClassTabHotExpertState extends State<SPClassTabHotExpert> with TickerProviderStateMixin{
  // var spProTabExpertTitles=["胜率","连红"];
  var spProTabExpertTitles=['推荐','胜率','连红','回报'];
  List<SPClassHomeRangkingList> spProExpertViews=List();
  TabController spProTabExpertController;
  var spProTabExpertKey=["hot","recent_correct_rate",'max_red_num','recent_profit'];

  get spProBodyParameters => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    spProTabExpertController=TabController(length: spProTabExpertTitles.length,vsync: this);
    spProExpertViews=spProTabExpertKey.map((key){ return SPClassHomeRangkingList(key,widget.spProMatchType); }).toList();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: width(18),/*left: width(10),right: width(10),*/bottom:  width(12)),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: width(16),right: width(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height:width(25),
                  width: width(240),
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child:TabBar(
                    indicator: BoxDecoration(
                        color: MyColors.main1,
                        borderRadius: BorderRadius.circular(width(18)),
                    ),
                    labelColor: Colors.white,
                    labelPadding: EdgeInsets.zero,
                    unselectedLabelColor: Color(0xFF666666),
                    isScrollable: false,
                    indicatorSize:TabBarIndicatorSize.tab,
                    labelStyle: GoogleFonts.notoSansSC(fontSize: sp(13),fontWeight: FontWeight.bold),
                    unselectedLabelStyle:  TextStyle(fontSize: sp(13)),
                    controller: spProTabExpertController,
                    tabs:spProTabExpertTitles.map((key){
                      return    Tab(text: key,);
                    }).toList() ,
                  ),
                ),
                Expanded(child: SizedBox(),),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("youjiantou",),
                      width: height(24),
                      height: height(24),
                    ),
                  ),
                  onTap: (){
                    SPClassApplicaion.spProEventBus.fire("tab:expert");
                  },
                )
              ],
            ),
          ),
          Container(
            height: width(100),
            child: TabBarView(
              controller: spProTabExpertController,
              children: spProExpertViews,
            ),
          ),

        //大数据H5
        !SPClassApplicaion.spProShowMenuList.contains("bcw_data")? SizedBox():Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
            ),
            padding: EdgeInsets.only(left: height(5),right: height(5),bottom: height(4),top:height(4)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: width(40),
                    decoration: BoxDecoration(
                      color: Color(0xFFFEFBED),
                      borderRadius: BorderRadius.circular(width(5))
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("AI大数据",style: TextStyle(fontSize: sp(12),fontWeight: FontWeight.bold),),
                              Text("AI全维度深度分析",style: TextStyle(fontSize: sp(9),color: Color(0xFF999999)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                          onTap: (){
                            spFunGetBcwUrl("bigDataReport");
                          },
                        ),
                        Positioned(right: 2,top: 2,child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_home_fire",format: ".gif"),height: width(9),),)
                      ],
                    ),
                  ),
                ),
                SizedBox(width: width(3),),

                Expanded(
                  child: Container(
                    height: width(40),
                    decoration: BoxDecoration(
                        color: Color(0xFFEFF9FE),
                        borderRadius: BorderRadius.circular(width(5))
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("冷门分析",style: TextStyle(fontSize: sp(12),fontWeight: FontWeight.bold),),
                              Text("多角度分析爆冷",style: TextStyle(fontSize: sp(9),color: Color(0xFF999999)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                          onTap: (){
                            spFunGetBcwUrl("coldJudge");
                          },
                        ),
                        Positioned(right: 2,top: 2,child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_home_new",format: ".gif"),height: width(9),),)
                      ],
                    ),
                  ),
                ),
                SizedBox(width: width(3),),
                Expanded(
                  child: Container(
                    height: width(40),
                    decoration: BoxDecoration(
                        color: Color(0xFFF7F3FE),
                        borderRadius: BorderRadius.circular(width(5))
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("全维预测",style: TextStyle(fontSize: sp(12),fontWeight: FontWeight.bold),),
                          Text("AI预测主流玩法",style: TextStyle(fontSize: sp(9),color: Color(0xFF999999)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      onTap: ()=>{
                        spFunGetBcwUrl("allAnalysis")
                      },
                    ),
                  ),
                ),
                SizedBox(width: width(3),),
                Expanded(
                  child: Container(
                    height: width(40),
                    decoration: BoxDecoration(
                        color: Color(0xFFEBFCED),
                        borderRadius: BorderRadius.circular(width(5))
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("赔率波动",style: TextStyle(fontSize: sp(12),fontWeight: FontWeight.bold),),
                          Text("匹配赔率波动走势",style: TextStyle(fontSize: sp(9),color: Color(0xFF999999)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      onTap: ()=>{
                        spFunGetBcwUrl("oddsWave")
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],

      ),
    );
  }

 onRefresh(){
   spProExpertViews[spProTabExpertController.index].spProState.onFunOnRefresh();
 }

 void spFunGetBcwUrl(String value){
    if(spFunIsLogin(context: context)){
      var params=SPClassApiManager.spFunGetInstance().spFunGetCommonParams();
      params.putIfAbsent("model_type", ()=>value);
//      SPClassNavigatorUtils.spFunPushRoute(context, SPClassWebPage( SPClassNetConfig.spFunGetBasicUrl()+"user/bcw/login?"+Transformer.urlEncodeMap(params),""));
      SPClassNavigatorUtils.spFunPushRoute(context, WebViewPage( SPClassNetConfig.spFunGetBasicUrl()+"user/bcw/login?"+Transformer.urlEncodeMap(params),""));
    }
 }



}