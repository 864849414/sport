import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/pages/news/webViewPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/utils/colors.dart';


///AI分析页
class AIAnalysis extends StatefulWidget {
  _AIAnalysisState spProState;
  AIAnalysis({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState=_AIAnalysisState();
  }
}

class _AIAnalysisState extends State<AIAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF2F2F2),
          padding: EdgeInsets.only(top: width(6)),
          child: Column(
            children: <Widget>[
              itemWidget('lengmengfenxi','冷门分析','冷门多角度分析',1333,298,'coldJudge'),
              itemWidget('dashuju','AI大数据','大家好，欢迎收看本场比赛直播,球员们正在热身，比赛即将啊实打实的阿萨德阿萨德',1333,298,'allAnalysis'),
              itemWidget('peilvbodong','赔率波动','冷门多角度分析',1333,298,'oddsWave'),
              itemWidget('quanweiyuce','全维预测','冷门多角度分析',1333,298,'allAnalysis'),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemWidget(String image,String title,String subtitle,int hasBuy,int money,String url){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        if(url==null||url=='')return;
        spFunGetBcwUrl(url);
      },
      child:  Container(
        margin: EdgeInsets.only(bottom: width(6)),
        padding: EdgeInsets.symmetric(horizontal: width(16),vertical: width(15)),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(width(4)),
              child: Container(
                width: width(96),
                height: width(115),
                child: Image.asset(SPClassImageUtil.spFunGetImagePath(image),fit: BoxFit.cover,),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: width(15)),
                height: width(115),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(title,style: TextStyle(fontSize: sp(17),fontWeight: FontWeight.bold),),
                        // Text('$hasBuy人已购',style: TextStyle(fontSize: sp(12),color:MyColors.grey_99),),
                      ],
                    ),
                    // SizedBox(height: height(6),),
                    Text(subtitle,style: TextStyle(fontSize: sp(13),color:MyColors.grey_33),maxLines: 2,overflow: TextOverflow.ellipsis,),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(fontSize: sp(16),color: Color(0xFFF74825)),
                              text: '$money',
                              children: [
                                TextSpan(
                                  text: "元/月",
                                  style: TextStyle(fontSize: sp(12),color: Color(0xFFF74825)),
                                )
                              ]
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width(8),vertical: width(4)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: MyColors.main1,width: 0.5),
                          ),
                          child: Text('立即购买',style: TextStyle(color: MyColors.main1,fontSize: sp(12)),),
                        )
                      ],
                    )

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void spFunGetBcwUrl(String value){
    if(spFunIsLogin(context: context)){
      var params=SPClassApiManager.spFunGetInstance().spFunGetCommonParams();
      params.putIfAbsent("model_type", ()=>value);
      SPClassNavigatorUtils.spFunPushRoute(context, WebViewPage( SPClassNetConfig.spFunGetBasicUrl()+"user/bcw/login?"+Transformer.urlEncodeMap(params),""));
    }
  }

}

@override
// TODO: implement wantKeepAlive
bool get wantKeepAlive => true;
