import 'dart:async';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassSchemeGuessMatch2.dart';
import 'package:sport/model/SPClassSchemePlayWay.dart';

import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/competition/detail/SPClassMatchDetailPage.dart';
import 'package:sport/pages/dialogs/SPClassBottomLeaguePage.dart';
import 'package:sport/pages/user/publicScheme/SPClassAddSchemeSuccessPage.dart';
import 'package:sport/pages/user/publicScheme/SPClassPickSchemeDataDialog.dart';
import 'package:sport/widgets/SPClassMarqueeWidget.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassPublicSchemePage extends StatefulWidget{
  SPClassSchemeGuessMatch2 spProGuessMatch;

  SPClassPublicSchemePage({this.spProGuessMatch});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassPublicSchemePageState();
  }

}

class SPClassPublicSchemePageState extends State<SPClassPublicSchemePage>{
  var LeagueName = "";
  SPClassSchemeGuessMatch2 spProGuessMatch ;
  ScrollController scrollController;
  Timer timer;
  List<SPClassSchemePlayWay> spProPlayWays=[];
  var  spProPlayWayIndex=0;
  var  spProPlayWayColNum=2;
  var  spProSupportWhich=-1;
  var  spProSupportWhich2=-1;
  var spProCanReturn=true;
  var spProPriceList=[-1,0,18,28,38,58];
  int spProPriceIndex=0;
  var title="";
  var detail="";

  var spProCanCommit=false;


  var spProHadKey=false;

  SPClassMarqueeWidget spProMarqueeWidget;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController=ScrollController();


    WidgetsBinding.instance.addPostFrameCallback((frame) {
     // pickerMatch();
      if(widget.spProGuessMatch!=null){
        spProGuessMatch=widget.spProGuessMatch;
        spFunInitMarquee();

        spFunGetPlayList();

      }
      timer= Timer.periodic(Duration(seconds: 4), (timer){


      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title: "发布方案",
      ),
      backgroundColor: Color(0xFFF1F1F1),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                padding:EdgeInsets.symmetric(horizontal: width(16)),
                decoration: BoxDecoration(
                    color:Colors.white,
                ),
                child:Row(
                  children: <Widget>[
                    Text("比赛选择：",style: TextStyle(color: Color(0xFF333333),fontSize: sp(14),fontWeight: FontWeight.w600),),
                    SizedBox(height: width(10),),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child:  Container(
                          padding: EdgeInsets.symmetric(vertical: width(4),horizontal: width(3)),
                          margin: EdgeInsets.only(left: width(3)),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.4,color: Colors.grey[300]),
                              borderRadius: BorderRadius.circular(width(3))
                          ),
                          child: Text(spProGuessMatch ==null ?"比赛选择":"重新选择",style: TextStyle(color: Color(0xFFDE3C31),fontSize: sp(12)),),
                        ),
                      ),
                      onTap: (){
                        spFunPickerMatch();
                      },
                    ),
                  ],
                ),
              ),
               Container(
                 color: Colors.white,
                 child: GestureDetector(
                   behavior: HitTestBehavior.opaque,
                   child: Container(
                     color: Color(0xFFF6F6F6),
                     margin: EdgeInsets.all(width(10)),
                     height: width(64),
                     child: Row(
                       children: <Widget>[
                         SizedBox(width: width(8),),
                         Expanded(
                           child: spProGuessMatch==null? Container(
                             padding: EdgeInsets.only(left: width(15)),
                             child: Text("请点击上方按钮选择比赛",style: TextStyle(fontSize: sp(16),color: Color(0xFFB5B5B5)),),
                           ):GestureDetector(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment:CrossAxisAlignment.center,
                               children: <Widget>[
                                 spProMarqueeWidget!=null ? Container(
                                   height: width(30),
                                   child:spProMarqueeWidget,
                                 ):SizedBox(),
                                 Row(
                                   children: <Widget>[
                                     Text(spProGuessMatch.spProLeagueName,style: TextStyle(fontSize: sp(11),color: Color(0xFF666666)),),
                                     SizedBox(width: width(5),),
                                     Text(SPClassDateUtils.spFunDateFormatByString(spProGuessMatch.spProStTime, "MM月dd日 HH:mm"),style: TextStyle(fontSize: sp(11),color: Color(0xFF666666)),),
                                   ],
                                 ),
                               ],
                             ),

                           ),
                         ),

                         SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                           width: width(13),
                         ),
                         SizedBox(width: width(8),),
                       ],
                     ),
                   ),
                   onTap: (){
                     if(spProGuessMatch==null){
                       return;
                     }
                     SPClassApiManager.spFunGetInstance().spFunSportMatchData<SPClassGuessMatchInfo>(loading: true,context: context,spProGuessMatchId:spProGuessMatch.spProGuessMatchId,dataKeys: "guess_match",spProCallBack: SPClassHttpCallBack(
                         spProOnSuccess: (result) async {
                           SPClassNavigatorUtils.spFunPushRoute(context, SPClassMatchDetailPage(result,spProMatchType:"guess_match_id",spProInitIndex: 1,));
                         }
                     ) );
                   },

                 ),
               ),
               SizedBox(height: width(8),),
               Container(
                 padding:EdgeInsets.symmetric(horizontal: width(16)),
                 color: Colors.white,
                 child: Column(
                   children: <Widget>[
                    SizedBox(height:width(19) ,),
                    Row(
                      children: <Widget>[
                        Text("推荐玩法：",style: TextStyle(color: Color(0xFF333333),fontSize: sp(14),fontWeight: FontWeight.w600),)
                      ],
                    ),
                    SizedBox(height: width(10),),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width(3)),
                        border: Border.all(width: 0.4,color: Colors.grey[300])
                      ),
                      child: GridView.count(crossAxisCount: spProPlayWayColNum,
                        shrinkWrap: true,
                        childAspectRatio:( width(328)/spProPlayWayColNum)/width(37),
                        children: spProPlayWays.map((way){
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: spProPlayWayIndex==spProPlayWays.indexOf(way) ? Color(0xFFDE3C31):null,
                                      borderRadius: spProPlayWayIndex==spProPlayWays.indexOf(way) ?
                                      BorderRadius.horizontal(
                                          left:((spProPlayWays.indexOf(way)+1)%spProPlayWayColNum==1? Radius.circular(width(3)):Radius.circular(0)),
                                          right:((spProPlayWays.indexOf(way)+1)%spProPlayWayColNum==0? Radius.circular(width(3)):Radius.circular(0))
                                      ):null,
                                      border:((spProPlayWays.indexOf(way)+1)%spProPlayWayColNum==0||spProPlayWayIndex==spProPlayWays.indexOf(way) )?  null:Border(right: BorderSide(width: 0.4,color:Colors.grey[300] )),


                                    ),
                                    alignment: Alignment.center,
                                    child: Text(way.spProPlayingWay +
                                        ((SPClassMatchDataUtils.spFunExpertTypeToMatchType(SPClassApplicaion.spProUserLoginInfo.spProExpertMatchType)=="lol"&&(way.spProPlayingWay=="总击杀"||way.spProPlayingWay=="总时长"))? (" (第"+way.spProBattleIndex.trim()+"局)"):""),
                                      style: TextStyle(color: spProPlayWayIndex==spProPlayWays.indexOf(way) ? Colors.white:Colors.black),),
                                  ),
                                ),
                                Container(height: 0.4,width: ScreenUtil.screenWidth,color: Colors.grey[300],),
                              ],
                            ),
                            onTap: (){
                              setState(() {
                                spProPlayWayIndex=spProPlayWays.indexOf(way);
                                spProSupportWhich=-1;
                                spProSupportWhich2=-1;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                   ],
                 ),
               ),
              Container(
                padding:EdgeInsets.symmetric(horizontal: width(16)),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(height:width(19) ,),
                    Row(
                      children: <Widget>[
                        Text("推荐选项：",style: TextStyle(color: Color(0xFF333333),fontSize: sp(14),fontWeight: FontWeight.w600),)
                      ],
                    ),
                    SizedBox(height: width(10),),

                    spProPlayWays.length>0?  Row(
                      children: <Widget>[
                         Expanded(
                          child: Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal:width(6)),
                                child:(spProPlayWays[spProPlayWayIndex].spProPlayingWay.contains("让球")&&(spProPlayWays[spProPlayWayIndex].spProGuessType =="竞彩"))?  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(double.parse(spProPlayWays[spProPlayWayIndex].spProAddScore) ==0
                                        ? "0": double.parse(spProPlayWays[spProPlayWayIndex].spProAddScore) >0
                                        ? "+${SPClassStringUtils.spFunSqlitZero(spProPlayWays[spProPlayWayIndex].spProAddScore)}": "${SPClassStringUtils.spFunSqlitZero(spProPlayWays[spProPlayWayIndex].spProAddScore)}",style: TextStyle(fontSize: sp(13),color: Color(0xFF333333),),)
                                  ],
                                ):SizedBox(),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(width(3)),
                                      border: Border.all(width: 0.4,color: Colors.grey[300])
                                  ),
                                  child: Row(
                                    children: <Widget>[

                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            decoration:(spProSupportWhich==1||spProSupportWhich2==1) ?BoxDecoration(
                                              color:Color(0xFFDE3C31),
                                              borderRadius: BorderRadius.horizontal(left:Radius.circular(width(3))),
                                              )
                                            :null,
                                            height: width(37),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(SPClassMatchDataUtils.spFunSchemeOptionLeftTitle(spProPlayWays[spProPlayWayIndex],
                                                    SPClassMatchDataUtils.spFunExpertTypeToMatchType(SPClassApplicaion.spProUserLoginInfo.spProExpertMatchType),guessMatch2: spProGuessMatch),
                                                     style: TextStyle(color:(spProSupportWhich==1||spProSupportWhich2==1) ?Colors.white:null )
                                                ),
                                                Text("  ("+spProPlayWays[spProPlayWayIndex].spProWinOddsOne+")",style: TextStyle(color:(spProSupportWhich==1||spProSupportWhich2==1) ?Colors.white:null ),),
                                              ],
                                            ),
                                          ),
                                          onTap: (){
                                            if(!SPClassMatchDataUtils.spFunCanPick(spProPlayWays[spProPlayWayIndex], 1)){
                                              SPClassToastUtils.spFunShowToast(msg: "推介指数偏低，暂不支持");
                                              return;
                                            }
                                            if(spProPlayWays[spProPlayWayIndex].spProGuessType=="竞彩"){
                                              if(spProSupportWhich==1){
                                                spProSupportWhich=spProSupportWhich2;
                                                spProSupportWhich2=-1;
                                              }else if(spProSupportWhich2==1){
                                                spProSupportWhich2=-1;
                                              }else{
                                                if(spProSupportWhich==-1){
                                                  spProSupportWhich=1;
                                                }else{
                                                  if(SPClassMatchDataUtils.spFunIsTwoPicker(spProPlayWays[spProPlayWayIndex], spProSupportWhich, 1)){
                                                    spProSupportWhich2=1;
                                                  }
                                                }
                                              }
                                            }else{
                                              spProSupportWhich=1;
                                            }
                                             setState(() {});
                                          },
                                        ),
                                      ),

                                      Expanded(
                                        child: GestureDetector(
                                          child: Container(
                                            height: width(37),
                                             decoration:BoxDecoration(
                                                 color:(spProSupportWhich==0||spProSupportWhich2==0) ?Color(0xFFDE3C31):null,
                                                border: Border(
                                                  left: BorderSide(width: 0.4,color: Colors.grey[300]),
                                                  right: BorderSide(width: 0.4,color: Colors.grey[300]),
                                                )
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(SPClassMatchDataUtils.spFunSchemeOptionMiddleTitle(spProPlayWays[spProPlayWayIndex],
                                                    SPClassMatchDataUtils.spFunExpertTypeToMatchType(SPClassApplicaion.spProUserLoginInfo.spProExpertMatchType),guessMatch2: spProGuessMatch),
                                                    style: TextStyle(color:(spProSupportWhich==0||spProSupportWhich2==0) ?Colors.white:null )
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: (){


                                            if(spProPlayWays[spProPlayWayIndex].spProPlayingWay.contains("胜平负")){
                                              if(!SPClassMatchDataUtils.spFunCanPick(spProPlayWays[spProPlayWayIndex], 0)){
                                                SPClassToastUtils.spFunShowToast(msg: "推介指数偏低，暂不支持");
                                                return;
                                              }
                                              if(spProPlayWays[spProPlayWayIndex].spProGuessType=="竞彩"){
                                                if(spProSupportWhich==0){
                                                  spProSupportWhich=spProSupportWhich2;
                                                  spProSupportWhich2=-1;
                                                }else if(spProSupportWhich2==0){
                                                  spProSupportWhich2=-1;
                                                }else{
                                                  if(spProSupportWhich==-1){
                                                    spProSupportWhich=0;
                                                  }else{
                                                    if(SPClassMatchDataUtils.spFunIsTwoPicker(spProPlayWays[spProPlayWayIndex], spProSupportWhich, 0)){
                                                      spProSupportWhich2=0;
                                                    }
                                                  }
                                                }
                                              }else{
                                                spProSupportWhich=0;
                                              }

                                              setState(() {});
                                            }

                                          },
                                        )
                                      ),

                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            decoration:(spProSupportWhich==2 ||spProSupportWhich2==2 ) ?BoxDecoration(
                                              color:Color(0xFFDE3C31),
                                              borderRadius: BorderRadius.horizontal(right:Radius.circular(width(3))),
                                            )
                                                :null,
                                            height: width(37),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(SPClassMatchDataUtils.spFunSchemeOptionRightTitle(spProPlayWays[spProPlayWayIndex],
                                                    SPClassMatchDataUtils.spFunExpertTypeToMatchType(SPClassApplicaion.spProUserLoginInfo.spProExpertMatchType),guessMatch2: spProGuessMatch),
                                                    style: TextStyle(color:(spProSupportWhich==2 ||spProSupportWhich2==2 ) ?Colors.white:null )
                                                ),
                                                Text("  ("+spProPlayWays[spProPlayWayIndex].spProWinOddsTwo+")",style: TextStyle(color:(spProSupportWhich==2 ||spProSupportWhich2==2 ) ?Colors.white:null ),),
                                              ],
                                            ),
                                          ),
                                          onTap: (){
                                             if(!SPClassMatchDataUtils.spFunCanPick(spProPlayWays[spProPlayWayIndex], 2)){
                                               SPClassToastUtils.spFunShowToast(msg: "推介指数偏低，暂不支持");
                                               return;
                                             }

                                            if(spProPlayWays[spProPlayWayIndex].spProGuessType=="竞彩"){
                                              if(spProSupportWhich==2){
                                                spProSupportWhich=spProSupportWhich2;
                                                spProSupportWhich2=-1;
                                              }else if(spProSupportWhich2==2){
                                                spProSupportWhich2=-1;
                                              }else{
                                                if(spProSupportWhich==-1){
                                                  spProSupportWhich=2;
                                                }else{
                                                  if(SPClassMatchDataUtils.spFunIsTwoPicker(spProPlayWays[spProPlayWayIndex], spProSupportWhich, 2)){
                                                    spProSupportWhich2=2;
                                                  }
                                                }
                                              }
                                            }else{
                                              spProSupportWhich=2;
                                            }

                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )

                      ],
                    ):SizedBox(),
                    SizedBox(height: width(10),),

                  ],
                ),
              ),

              SizedBox(height: height(8),),
              Container(
                padding: EdgeInsets.only(left: width(14)),
                decoration: BoxDecoration(
                    color:Colors.white,
                    border: Border.all(width: 0.4,color: Colors.grey[300])
                ),
                child: TextField(
                  maxLength: 50,
                  autofocus: false,
                  buildCounter:(
                      BuildContext context, {
                        @required int currentLength,
                        @required int maxLength,
                        @required bool isFocused,
                      }) {
                    //自定义的显示格式
                    return SizedBox();
                  },
                  maxLines: 1,
                  style: TextStyle(fontSize: sp(14),),
                  decoration: InputDecoration(
                      hintText: "请输入50字以内的原创标题",
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                    title=value;
                    spFunCheckCommit();
                  },
                ),
              ),




              Container(
                constraints: BoxConstraints(
                  maxHeight: double.maxFinite,
                  minHeight: width(200),
                ),
                decoration: BoxDecoration(
                    color:Colors.white,
                    border: Border.all(width: 0.4,color: Colors.grey[300])
                ),
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 8.0, bottom: 4.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  style: TextStyle(fontSize: sp(14),),
                  decoration: InputDecoration(
                    hintMaxLines: 6,
                    hintText: "文章内容不少于100字，涉嫌抄袭，广告，擅留微信、QQ等联系方式将给予不通过文章处理；",
                    border: InputBorder.none,
                  ),

                  maxLines: null,
                  onChanged: (value){
                    detail=value;
                    spFunCheckCommit();
                  },
                ),
              ),

              Container(
                padding:EdgeInsets.symmetric(horizontal: width(16)),
                decoration: BoxDecoration(
                    color:Colors.white,
                    border: Border.all(width: 0.4,color: Colors.grey[300])
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height:width(10) ,),
                    Row(
                      children: <Widget>[
                        Text("不中包退",style: TextStyle(color: Color(0xFF333333),fontSize: sp(14),fontWeight: FontWeight.w600),),
                        Expanded(child: SizedBox(),),
                        GestureDetector(
                          child: Container(
                            width: width(50),
                            height: width(27),
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(300),
                              color:spProCanReturn ? Theme.of(context).primaryColor:Color(0xFFEAE8EB),
                            ),
                            child: Row(
                              mainAxisAlignment:spProCanReturn ? MainAxisAlignment.start:MainAxisAlignment.end ,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 2,right: 2),
                                  width: width(23),
                                  height: width(23),
                                  decoration: ShapeDecoration(
                                      shadows: [
                                        BoxShadow(
                                            offset: Offset(1,1),
                                            color: Colors.black.withOpacity(0.2)
                                        ),
                                      ],
                                      shape: CircleBorder(),
                                      color: Colors.white
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: (){

                          },
                        ),

                      ],
                    ),

                    SizedBox(height: width(10),),


                  ],
                ),
              ),


              Container(
                padding:EdgeInsets.symmetric(horizontal: width(16)),
                decoration: BoxDecoration(
                    color:Colors.white,
                    border: Border.all(width: 0.4,color: Colors.grey[300])
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height:width(10) ,),
                    Row(
                      children: <Widget>[
                        Text("价格方案",style: TextStyle(color: Color(0xFF333333),fontSize: sp(14),fontWeight: FontWeight.w600),),
                        Expanded(child: SizedBox(),),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 3,horizontal: 6),

                            child: Row(
                              children: <Widget>[
                                Text(spProPriceList[spProPriceIndex]==0 ? "免费":spProPriceList[spProPriceIndex]==-1 ? "请选择":(spProPriceList[spProPriceIndex].toString()+"钻石"),style: TextStyle(color: Color(0xFF333333),fontSize: sp(13)),),
                                SizedBox(width: width(5),),
                                SPClassEncryptImage.asset(
                                  SPClassImageUtil.spFunGetImagePath("ic_up_arrow",),
                                  width: width(13),

                                )
                              ],
                            ) ,
                          ),
                          onTap: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext c) {
                                return SPClassBottomLeaguePage(spProPriceList.map((price) {
                                  if(price==0){return "免费";}
                                  if(price==-1){return "请选择";}
                                  return (price.toString()+"钻石");
                                }).toList(),"请选择",(index){
                                  setState(() {
                                    spProPriceIndex=index;
                                  });
                                  FocusScope.of(context).requestFocus(FocusNode());
                                },initialIndex:spProPriceIndex,);
                              },
                            );
                          },
                        )

                      ],
                    ),

                    SizedBox(height: width(10),),


                  ],
                ),
              ),
              SizedBox(height: height(50),),

            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow:[BoxShadow(
              offset: Offset(1,1),
              color: Color(0x1a000000),
              blurRadius:width(6,),
            )]
        ),
        height: height(53),
        child:GestureDetector(
          child:  Container(
            color: Colors.white,
            height: height(53),
            alignment: Alignment.center,
            child:Container(
              alignment: Alignment.center,
              height: height(40),
              width: width(320),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width(3)),
                gradient: LinearGradient(
                    colors: [Color(0xFFF2150C),Color(0xFFF24B0C)]
                ),
                boxShadow:[
                  BoxShadow(
                    offset: Offset(3,3),
                    color: Color(0x4DF23B0C),
                    blurRadius:width(5,),),

                ],

              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Text("提交",style: TextStyle(fontSize: sp(15),color: Colors.white),)
                ],
              ),
            ) ,
          ),
          onTap: () async {
            if(spFunCheckCommit(showToast: true)){
              SPClassApiManager.spFunGetInstance().spFunAddScheme(context: context,
                  queryParameters: {
                    "scheme_title":title,
                    "guess_match_id":spProGuessMatch.spProGuessMatchId,
                    "can_return":spProCanReturn? 1:0,
                    "support_which":SPClassMatchDataUtils.spFunGetSupportWitch(spProPlayWays[spProPlayWayIndex], spProSupportWhich),
                    "support_which2":SPClassMatchDataUtils.spFunGetSupportWitch(spProPlayWays[spProPlayWayIndex], spProSupportWhich2),
                    "diamond":spProPriceList[spProPriceIndex],
                    "win_odds_one":spProPlayWays[spProPlayWayIndex].spProWinOddsOne,
                    "draw_odds":spProPlayWays[spProPlayWayIndex].spProDrawOdds,
                    "win_odds_two":spProPlayWays[spProPlayWayIndex].spProWinOddsTwo,
                    "add_score":spProPlayWays[spProPlayWayIndex].spProAddScore,
                    "mid_score":spProPlayWays[spProPlayWayIndex].spProMidScore,
                    "battle_index":spProPlayWays[spProPlayWayIndex].spProBattleIndex,
                    "guess_type":spProPlayWays[spProPlayWayIndex].spProGuessType,
                    "playing_way":spProPlayWays[spProPlayWayIndex].spProPlayingWay,
                  },
                  bodyPrams:{
                    "scheme_detail":detail.replaceAll("\n", "<br/>")
                  },
                  spProCallBack:  SPClassHttpCallBack(
                      spProOnSuccess: (value){
                        Navigator.of(context).pop();
                        SPClassApplicaion.spProEventBus.fire("refresh:myscheme");
                        SPClassNavigatorUtils.spFunPushRoute(context, SPClassAddSchemeSuccessPage());
                      }
                  )
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  void spFunPickerMatch() {
    showDialog(context: context,builder:(c)=>SPClassPickSchemeDataDialog((value){
      spProMarqueeWidget=null;
      spProGuessMatch=value;
      setState(() {

      });
     spFunInitMarquee();



     spFunGetPlayList();
    },spProGuessMatch:spProGuessMatch,));
  }

  bool spFunCheckCommit({bool showToast:false}) {
    var result=true;
      if(spProGuessMatch==null){
        if(showToast){
          SPClassToastUtils.spFunShowToast(msg: "请选择比赛");
        }
        result= false;
      }else if(spProSupportWhich==-1){
        if(showToast){
          SPClassToastUtils.spFunShowToast(msg: "请选择推荐结果");
        }
        result= false;
      } else if(spProSupportWhich==-1){
        if(showToast){
          SPClassToastUtils.spFunShowToast(msg: "请选择推荐结果");
        }
        result=false;
      }else if(title.isEmpty){
        if(showToast){
          SPClassToastUtils.spFunShowToast(msg: "请填写标题");
        }
        result= false;
      } else if(detail.isEmpty){
        if(showToast){
          SPClassToastUtils.spFunShowToast(msg: "请填写内容");
        }
        result= false;
      } else if(detail.length<100){
        if(showToast){
          SPClassToastUtils.spFunShowToast(msg: "文章内容不少于100字");
        }
        result= false;
      }else if(spProPriceList[spProPriceIndex]==-1){
        if(showToast){
          SPClassToastUtils.spFunShowToast(msg: "请选择价格");
        }
        result= false;
      }
      setState(() {
        spProCanCommit=result;
      });
     return result;
  }

  void spFunGetPlayList() {

    SPClassApiManager.spFunGetInstance().spFunPlayingWayOdds<SPClassBaseModelEntity>(context:
    context,queryParameters: {"guess_match_id":spProGuessMatch.spProGuessMatchId},
        spProCallBack: SPClassHttpCallBack(
            spProOnSuccess: (value){
              setState(() {
                var spProOddsList=new SPClassListEntity<SPClassSchemePlayWay>(key: "playing_way_list",object: new SPClassSchemePlayWay());
                spProOddsList.fromJson(value.data);
                var spProPriceList=new SPClassListEntity<String>(key: "price_list");
                spProPriceList.fromJson(value.data);
                spProPriceList.spProDataList.insert(0, "-1");
                spProPlayWays=  spProOddsList.spProDataList;
                spProPriceIndex=0;
                this.spProPriceList= spProPriceList.spProDataList.map((e) => int.tryParse(e)).toList();
                spProPlayWayColNum=spProPlayWays.length==3? 3:2;
              });
              FocusScope.of(context).requestFocus(FocusNode());

            }
        ));
  }

  void spFunInitMarquee() {
    setState(() {
      spProMarqueeWidget= SPClassMarqueeWidget(
        child: Row(
          children: <Widget>[
            Text(spProGuessMatch.spProTeamOne,style: TextStyle(fontSize: sp(16),color: Color(0xFF333333)),),
            Text(" VS ",style: TextStyle(fontSize: sp(16),color: Color(0xFFB5B5B5)),),
            Text(spProGuessMatch.spProTeamTwo+"",style: TextStyle(fontSize: sp(16),color: Color(0xFF333333)),),
            SizedBox(width: width(50),),
          ],
        ),
      );
    });
  }



}