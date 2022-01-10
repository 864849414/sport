import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassForecast.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassListEntity.dart';
import 'package:sport/model/SPClassPkRanking.dart';
import 'package:sport/pages/competition/detail/SPClassMatchDetailPage.dart';
import 'package:sport/pages/hot/forecast/SPClassForcecastItemView.dart';
import 'package:sport/pages/hot/forecast/SPClassRankingPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassForecastHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassForecastHomePageState();
  }

}

class SPClassForecastHomePageState extends State<SPClassForecastHomePage>{
  var page=0;
  EasyRefreshController spProController;
  List<SPClassForecast> spProDataList=[];
  List<SPClassPkRanking> rankings=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProController=EasyRefreshController();
    spFunGetList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: Container(
        child: EasyRefresh.custom(
            onLoad: spFunGetMoreList,
            onRefresh: spFunGetList,
            controller:spProController ,
            header: SPClassBallHeader(
                textColor: Color(0xFF666666)
            ),
            footer: SPClassBallFooter(
              textColor: Color(0xFF666666)
           ),
           slivers:
           [
             SliverToBoxAdapter(
               child: Visibility(
                 child: Stack(
                   alignment:Alignment.topCenter,
                   children: <Widget>[
                     GestureDetector(
                       child: Container(
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
                         margin: EdgeInsets.only(left: width(5),right: width(5),top: width(15)),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                             SizedBox(height: width(30),),
                             Container(
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.all(Radius.circular( width(5))),
                                   border: Border.all(width: 0.4,color: Colors.grey[300])
                               ),
                               margin: EdgeInsets.only(
                                   left: width(10),
                                   right: width(10),
                                   top: width(10)),
                               child: Column(
                                 children: <Widget>[
                                   Container(
                                     decoration: BoxDecoration(
                                         color: Color(0xFFDDDDDD),
                                         borderRadius: BorderRadius.vertical(top:Radius.circular( width(5)))
                                     ),
                                     alignment: Alignment.center,
                                     child: Row(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: <Widget>[
                                         Container(
                                           width: width(44),
                                           height: width(28),
                                           alignment: Alignment.center,
                                           child: Text("排行",style: TextStyle(
                                               color: Color(0xFF656565),
                                               fontSize: sp(11)
                                           ),),
                                         ),
                                         SizedBox(width: width(10),),
                                         Expanded(
                                           child: Container(
                                             height: width(28),
                                             alignment: Alignment.centerLeft,
                                             child: Text("用户",style: TextStyle(
                                                 color: Color(0xFF656565),
                                                 fontSize: sp(11)
                                             ),),
                                           ),
                                         ),
                                         Container(
                                           width: width(44),
                                           height: width(28),
                                           alignment: Alignment.center,
                                           child: Text("积分",style: TextStyle(
                                               color: Color(0xFF656565),
                                               fontSize: sp(11)
                                           ),),
                                         ),
                                         SizedBox(width: 15,),

                                         Container(
                                           width: width(44),
                                           height: width(28),
                                           alignment: Alignment.center,
                                           child: Text("奖励",style: TextStyle(
                                               color: Color(0xFF656565),
                                               fontSize: sp(11)
                                           ),),
                                         ),
                                         SizedBox(width: 15,),
                                       ],
                                     ),
                                   ),
                                   Container(
                                     height:width(159) ,
                                     child: ListView.builder(
                                         padding: EdgeInsets.zero,
                                         physics: const NeverScrollableScrollPhysics(),
                                         itemCount: rankings.length,
                                         itemBuilder: (c,index){
                                           var item =rankings[index];
                                           return  Container(
                                             decoration: BoxDecoration(
                                                 border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                                             ),
                                             alignment: Alignment.center,
                                             height: width(53),
                                             child: Row(
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               children: <Widget>[
                                                 Container(
                                                   width: width(44),
                                                   height: width(28),
                                                   alignment: Alignment.center,
                                                   child: (index<3&&index>=0) ?
                                                   spFunBuildMedal(index+1):Text((index+1).toString(),style: TextStyle(fontSize: sp(13),color: Color(0xFF999999)),),
                                                 ),
                                                 SizedBox(width: width(10),),
                                                 Expanded(
                                                   child: Row(
                                                     children: <Widget>[
                                                       ClipRRect(
                                                         borderRadius: BorderRadius.circular(300),
                                                         child: SPClassImageUtil.spFunNetWordImage(
                                                             url: item.spProAvatarUrl,
                                                             width: width(32),
                                                             height: width(32)),
                                                       ),
                                                       SizedBox(width: width(5),),
                                                       Flexible(
                                                         child: Text(item.spProNickName,
                                                           style: TextStyle(fontSize: sp(12)),
                                                           maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                       )
                                                     ],
                                                   ),
                                                 ),
                                                 Container(
                                                   width: width(44),
                                                   height: width(28),
                                                   alignment: Alignment.center,
                                                   child: Text(item.points,style: TextStyle(
                                                       color: Color(0xFFE3494B),
                                                       fontSize: sp(12)
                                                   ),),
                                                 ),
                                                 SizedBox(width: 15,),
                                                 Container(
                                                   width: width(44),
                                                   height: width(28),
                                                   alignment: Alignment.center,
                                                   child: Text(item.spProRewardMoney+"元",style: TextStyle(
                                                       color: Color(0xFFE3494B),
                                                       fontSize: sp(12)
                                                   ),),
                                                 ),
                                                 SizedBox(width: 15,),
                                               ],
                                             ),
                                           );
                                         }),
                                   )
                                 ],
                               ),
                             ),
                             Padding(
                               padding: EdgeInsets.symmetric(vertical: width(5)),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   Text("查看完整榜单",style: TextStyle(fontSize: sp(11),color: Color(0xFFFFAD00)),),
                                   Icon(Icons.chevron_right,color: Color(0xFFFFAD00),size: width(20),)

                                 ],
                               ),
                             ),
                             SizedBox(height: width(5),),

                           ],

                         ),
                       ),
                       onTap: (){
                         SPClassNavigatorUtils.spFunPushRoute(context, SPClassRankingPage());
                       },
                     ),
                     Positioned(
                       top: width(7),
                       child: SPClassEncryptImage.asset(
                         SPClassImageUtil.spFunGetImagePath("bg_ranking_title"),
                         width: width(147),
                       ),
                     )
                   ],
                 ),
                 visible: rankings.length>0,
               ),
             ),

             SliverList(
               delegate: SliverChildBuilderDelegate((c,i){
                 return  GestureDetector(
                   child: SPClassForcecastItemView(spProDataList[i]),
                   onTap: (){
                     Api.spFunSportMatchData<SPClassGuessMatchInfo>(loading: true,context: context,spProGuessMatchId:spProDataList[i].spProGuessMatchId,dataKeys: "guess_match",spProCallBack: SPClassHttpCallBack(
                         spProOnSuccess: (result) async {
                           SPClassNavigatorUtils.spFunPushRoute(context, SPClassMatchDetailPage(result,spProMatchType:"guess_match_id",spProInitIndex: 1,));
                         }
                     ) );
                   },
                 );
               },
                 childCount: spProDataList.length,
               ),
             )
           ]),
           )
           );
         }

    Future<void>  spFunGetList() async{

       spFunGetRankingList();
        page=1;
        return  Api.spFunForecastList<SPClassForecast>(queryParameters: {"page":"1","fetch_type":"all"},
        spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
          spProDataList=result.spProDataList;
        if(mounted){setState(() {});}
        },
        onError: (e){
         spProController.finishRefresh(success: false);
        }
        )
    );
  }

  Future<void>  spFunGetMoreList() {
    return  Api.spFunForecastList<SPClassForecast>(queryParameters: {"page":page+1,"fetch_type":"all"},
        spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
          if(result.spProDataList.length>0){
            page++;
            spProController.finishLoad(success: true);
          }else{
            spProController.finishLoad(noMore: true);
          }
          spProDataList.addAll(result.spProDataList);
          if(mounted){setState(() {});}
        },
          onError: (e){
              spProController.finishLoad(success: false);
            }
        )
    );


  }

  spFunBuildMedal(int ranking) {
    return SPClassEncryptImage.asset(
      SPClassImageUtil.spFunGetImagePath(ranking==1? "ic_leaderbord_one":(ranking==2? "ic_leaderbord_two":"ic_leaderbord_three")),
      width: width(25),
    );

  }

  void spFunGetRankingList() {

    Api.spFunDoPkRankings<SPClassBaseModelEntity>(spProCallBack:SPClassHttpCallBack(
       spProOnSuccess: (result){
        var listResult= SPClassListEntity<SPClassPkRanking>(key: "pk_rankings",object: new SPClassPkRanking());
        listResult.fromJson(result.data);
        rankings=listResult.spProDataList;
        setState(() {});
       }
    ));

  }
}