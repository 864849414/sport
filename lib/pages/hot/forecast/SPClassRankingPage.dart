import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassListEntity.dart';
import 'package:sport/model/SPClassPkRanking.dart';
import 'package:sport/pages/dialogs/SPClassRankingRuluDialog.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassRankingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassRankingPageState();
  }

}

class  SPClassRankingPageState extends State<SPClassRankingPage>{
  List<SPClassPkRanking> rankings=[];

  SPClassPkRanking spProMyRanking;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunGetRankingList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(context,
       title: "赛季排行榜",
       actions: <Widget>[
         GestureDetector(
           child: Row(
             children: <Widget>[
               Container(
                 alignment: Alignment.center,
                 child: Text("?",style: TextStyle(color: Colors.white),),
                 width: width(16),
                 height: width(16),
                 decoration: BoxDecoration(
                   color: Color(0xFFB5B5B5),
                   shape: BoxShape.circle
                 ),
               ),
               SizedBox(width: width(5),),
               Text("活动规则",
                 style: TextStyle(
                     color: Color(0xFF343434,),fontSize: sp(13))
                 ,)
             ],
           ),
           onTap: (){
              showDialog(context: context, builder: (c)=>SPClassRankingRuluDialog());
           },
         ),
         SizedBox(width: width(13),),

       ],
      ),
      body: Container(
        child: EasyRefresh.custom(
            header: SPClassBallHeader(
                textColor: Color(0xFF666666)
            ),
            footer: SPClassBallFooter(
                textColor: Color(0xFF666666)
            ),
            onRefresh: spFunGetRankingList,
            slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: <Widget>[
                  SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_ranking"),width: width(360),fit: BoxFit.fitWidth,),
                  Positioned(
                    top: width(44),
                    left: width(26),
                    child: Text("排行榜",style: TextStyle(
                        color: Colors.white,
                        fontSize: sp(30),
                        fontWeight: FontWeight.bold
                    ),),
                  )
                ],
              ),
            ),

            SliverToBoxAdapter(
                child:Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
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
                            child:Text(spProMyRanking!=null ? spProMyRanking.ranking:"",
                              style: TextStyle(fontSize: sp(13),color: Color(0xFF999999)),),
                          ),
                          SizedBox(width: width(10),),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(300),
                                  child: SPClassImageUtil.spFunNetWordImage(
                                      url: spProMyRanking!=null ?spProMyRanking.spProAvatarUrl:"",
                                      width: width(32),
                                      height: width(32)),
                                ),
                                SizedBox(width: width(5),),
                                Flexible(
                                  child: Text(spProMyRanking!=null ?spProMyRanking.spProNickName:"-",
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
                            child: Text(spProMyRanking!=null ?spProMyRanking.points:"-",style: TextStyle(
                                color: Color(0xFFE3494B),
                                fontSize: sp(12)
                            ),),
                          ),
                          SizedBox(width: 15,),
                          Container(
                            width: width(44),
                            height: width(28),
                            alignment: Alignment.center,
                            child: Text(spProMyRanking!=null ?(spProMyRanking.spProRewardMoney+"元"):"-",style: TextStyle(
                                color: Color(0xFFE3494B),
                                fontSize: sp(12)
                            ),),
                          ),
                          SizedBox(width: 15,),
                        ],
                      ),
                    ),
                    Container(
                      height: width(10),
                      color: Color(0xFFDDDDDD),
                    ),
                  ],
                ),
              ),

           SliverToBoxAdapter(
                child:Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular( width(5))),
                      border: Border.all(width: 0.4,color: Colors.grey[300])
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
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
                      ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rankings.length,
                          itemBuilder: (c,index){
                            var item =rankings[index];
                            return  Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
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
                          })
                    ],
                  ),
                )
              ),
        ]),
      ),
    );
  }


  Future<void> spFunGetRankingList() {

  return  Api.spFunDoPkRankings<SPClassBaseModelEntity>(spProCallBack:SPClassHttpCallBack(
        spProOnSuccess: (result){
          if(result.data["my_ranking"]!=null){
            spProMyRanking= SPClassPkRanking(json: result.data["my_ranking"]);
          }
          var listResult= SPClassListEntity<SPClassPkRanking>(key: "pk_rankings",object: new SPClassPkRanking());
          listResult.fromJson(result.data);
          rankings=listResult.spProDataList;
          setState(() {});
        }
    ));

  }

  spFunBuildMedal(int ranking) {
    return SPClassEncryptImage.asset(
      SPClassImageUtil.spFunGetImagePath(ranking==1? "ic_leaderbord_one":(ranking==2? "ic_leaderbord_two":"ic_leaderbord_three")),
      width: width(25),
    );

  }
}