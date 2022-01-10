import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';

import 'package:sport/model/SPClassMatchInjuryEntity.dart';
import 'package:sport/model/SPClassMatchLineupEntity.dart';
import 'package:sport/model/SPClassMatchLineupPlayerEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'dart:math' as math;
import 'package:sport/utils/SPClassImageUtil.dart';

class SPClassMatchLiveTeamPage extends  StatefulWidget{
  SPClassGuessMatchInfo spProGuessInfo;
  SPClassMatchLiveTeamPage(this.spProGuessInfo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMatchLiveTeamPageState();
  }

}

class SPClassMatchLiveTeamPageState extends State<SPClassMatchLiveTeamPage> with TickerProviderStateMixin<SPClassMatchLiveTeamPage> ,AutomaticKeepAliveClientMixin{
  SPClassMatchLineupEntity spProMatchLineupEntity;
  SPClassMatchLineupPlayerEntity spProMatchLineupPlayerEntity;
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> spProStartingOnes;//首发主队
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> spProStartingTwos;//首发客队
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> spProSubstituteOnes;//替补客队
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> spProSubstituteTwos;//替补客队
  SPClassMatchInjuryEntity spProMatchInjuryEntity;
  var spProShowTeam=true;
  var spProShowJury=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SPClassApiManager.spFunGetInstance().spFunSportMatchData<SPClassMatchLineupEntity>(context: context,spProGuessMatchId:widget.spProGuessInfo.spProGuessMatchId,dataKeys: "match_lineup",spProCallBack: SPClassHttpCallBack(
      spProOnSuccess: (result) async {
        if(result.spProMatchLineup!=null&&result.spProMatchLineup.length>0){
          setState(() {
            spProMatchLineupEntity=result;
          });
        }

      }
    ) );

    SPClassApiManager.spFunGetInstance().spFunSportMatchData<SPClassMatchLineupPlayerEntity>(context: context,spProGuessMatchId:widget.spProGuessInfo.spProGuessMatchId,dataKeys: "match_lineup_player;match_injury;match_lineup;match_intelligence",spProCallBack: SPClassHttpCallBack(
      spProOnSuccess: (result) async {
        if(result.spProMatchLineupPlayer!=null&&result.spProMatchLineupPlayer.one!=null){
          spProStartingOnes=[];
          spProSubstituteOnes=[];
          spProStartingTwos=[];
          spProSubstituteTwos=[];
          result.spProMatchLineupPlayer.one.forEach((item){
             if(item.spProIsRegular=="1"){
               spProStartingOnes.add(item);
             }else{
               spProSubstituteOnes.add(item);
             }
          });
         if(result.spProMatchLineupPlayer.two!=null){
           result.spProMatchLineupPlayer.two.forEach((item){
             if(item.spProIsRegular=="1"){
               spProStartingTwos.add(item);
             }else{
               spProSubstituteTwos.add(item);
             }
           });
         }

          setState(() {
            spProMatchLineupPlayerEntity=result;
          });
        }
      }
    ) );


    SPClassApiManager.spFunGetInstance().spFunSportMatchData<SPClassMatchInjuryEntity>(context: context,spProGuessMatchId:widget.spProGuessInfo.spProGuessMatchId,dataKeys: "match_injury",spProCallBack: SPClassHttpCallBack(
      spProOnSuccess: (result)  {
        if(result.spProMatchInjury!=null){
          setState(() {
            spProMatchInjuryEntity=result;
          });
        }
      }
    ) );


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(),
          AnimatedSize(
            vsync: this,
            duration: Duration(
                milliseconds: 300
            ),
            child:Container(
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
                  borderRadius: BorderRadius.circular(width(7))
              ),
              margin: EdgeInsets.only(bottom: height(8),left: width(10),right: width(10),),
              child: Column(
                children: <Widget>[
                  Container(
                    height: height(35),
                    padding: EdgeInsets.only(left: width(13),right: width(13)),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: height(4),
                          height: height(14),
                          decoration: BoxDecoration(
                              color: Color(0xFFDE3C31),
                              borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        SizedBox(width: 4,),
                        Text("双方阵容",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: sp(15)),),
                        Expanded(
                          child: SizedBox(),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(width(5)),
                            child:  SPClassEncryptImage.asset(
                              spProShowTeam? SPClassImageUtil.spFunGetImagePath("ic_down_arrow"):SPClassImageUtil.spFunGetImagePath("ic_up_arrow"),
                              width: width(13),
                            ),
                          ),
                          onTap: (){
                            setState(() {spProShowTeam=!spProShowTeam;});
                          },
                        )
                      ],
                    ),
                  ),

                  (spProMatchLineupEntity==null||!spProShowTeam)?SizedBox():Stack(
                    alignment: Alignment.center,
                    children:spFunBuildLineUpTeam(),
                  ),

                  (spProMatchLineupPlayerEntity==null||!spProShowTeam)?SizedBox(): Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(width(13)),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Row(
                                children: <Widget>[
                                  ( widget.spProGuessInfo.spProIconUrlOne.isEmpty)? SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                                    width: width(20),
                                  ):Image.network(
                                    widget.spProGuessInfo.spProIconUrlOne,
                                    width: width(20),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(widget.spProGuessInfo.spProTeamOne,style: TextStyle(fontSize: sp(12)),)
                                ],

                              ),),
                              Expanded(child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(widget.spProGuessInfo.spProTeamTwo,style: TextStyle(fontSize: sp(12)),),
                                  SizedBox(width: 5,),
                                  ( widget.spProGuessInfo.spProIconUrlTwo.isEmpty)? SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                                    width: width(20),
                                  ):Image.network(
                                    widget.spProGuessInfo.spProIconUrlTwo,
                                    width: width(20),
                                  ),
                                ],

                              ),),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: width(13),right: width(13)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: height(4),
                                height: height(14),
                                decoration: BoxDecoration(
                                    color: Color(0xFFDE3C31),
                                    borderRadius: BorderRadius.circular(100)
                                ),
                              ),
                              SizedBox(width: 4,),
                              Text("首发球员",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(15)),),
                              Expanded(child: SizedBox(),),
                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: width(18),right: width(18)),
                            shrinkWrap: true,
                            itemCount: math.max(spProStartingOnes.length, spProStartingTwos.length),
                            itemBuilder: (c,index){
                              return  Container(
                                padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[300],width: 0.4))
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child:(index<=(spProStartingOnes.length-1))? Row(
                                      children: <Widget>[
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFF5D9CEC)
                                          ),
                                          child: Text(spProStartingOnes[index].spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                        SizedBox(width: 3,),
                                        Text(spProStartingOnes[index].spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),)
                                      ],
                                    ):SizedBox(),),
                                    Expanded(child:(index<=(spProStartingTwos.length-1))? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(spProStartingTwos[index].spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),),
                                        SizedBox(width: 3,),
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFFEA5E5E)
                                          ),
                                          child: Text(spProStartingTwos[index].spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                      ],
                                    ):SizedBox(),),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(height: height(20),),
                        Container(
                          padding: EdgeInsets.only(left: width(13),right: width(13)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: height(4),
                                height: height(14),
                                decoration: BoxDecoration(
                                    color: Color(0xFFDE3C31),
                                    borderRadius: BorderRadius.circular(100)
                                ),
                              ),
                              SizedBox(width: 4,),
                              Text("替补球员",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(15)),),
                              Expanded(child: SizedBox(),),
                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: width(18),right: width(18)),
                            shrinkWrap: true,
                            itemCount: math.max(spProSubstituteOnes.length, spProSubstituteTwos.length),
                            itemBuilder: (c,index){
                              return  Container(
                                padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[300],width: 0.4))
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child:(index<=(spProSubstituteOnes.length-1))? Row(
                                      children: <Widget>[
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFF5D9CEC)
                                          ),
                                          child: Text(spProSubstituteOnes[index].spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                        SizedBox(width: 3,),
                                        Text(spProSubstituteOnes[index].spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),)
                                      ],
                                    ):SizedBox(),),
                                    Expanded(child:(index<=(spProSubstituteTwos.length-1))? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(spProSubstituteTwos[index].spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),),
                                        SizedBox(width: 3,),
                                        Container(
                                          width: width(21),
                                          padding: EdgeInsets.all(width(2)),
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Color(0xFFEA5E5E)
                                          ),
                                          child: Text(spProSubstituteTwos[index].spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                        ),
                                      ],
                                    ):SizedBox(),),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),

                    (spProMatchLineupPlayerEntity!=null&&spProMatchLineupEntity!=null)?  SizedBox(): Container(
                    padding:EdgeInsets.all(width(5)),
                    child:Text("暂无数据",style: TextStyle(color: Color(0xFF999999)),),
                  )
                ],

              ),
            ) ,
          ),

          AnimatedSize(
            vsync: this,
            duration: Duration(
                milliseconds: 300
            ),
            child:Container(
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
                  borderRadius: BorderRadius.circular(width(7))
              ),
              margin: EdgeInsets.only(bottom: height(8),left: width(10),right: width(10),),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: height(35),
                    padding: EdgeInsets.only(left: width(13),right: width(13)),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: height(4),
                          height: height(14),
                          decoration: BoxDecoration(
                              color: Color(0xFFDE3C31),
                              borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        SizedBox(width: 4,),
                        Text("伤停信息",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: sp(15)),),
                        Expanded(
                          child: SizedBox(),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(width(5)),
                            child:  SPClassEncryptImage.asset(
                              spProShowJury? SPClassImageUtil.spFunGetImagePath("ic_down_arrow"):SPClassImageUtil.spFunGetImagePath("ic_up_arrow"),
                              width: width(13),
                            ),
                          ),
                          onTap: (){
                            setState(() {spProShowJury=!spProShowJury;});
                          },
                        )
                      ],
                    ),
                  ),
                  (  spProMatchInjuryEntity==null||!spProShowJury)? SizedBox():Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(top: height(8),bottom: height(8),left: width(17)),
                              color: Color(0xFFF9F9F9),
                              child: Text("球员",style: GoogleFonts.notoSansSC(textStyle: TextStyle(fontSize: sp(12),fontWeight: FontWeight.w500)),),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                              color: Color(0xFFF9F9F9),
                              child: Text("伤停原因",style: GoogleFonts.notoSansSC(textStyle: TextStyle(fontSize: sp(12),fontWeight: FontWeight.w500)),),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(width(13)),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Row(
                              children: <Widget>[
                                ( widget.spProGuessInfo.spProIconUrlOne.isEmpty)? SPClassEncryptImage.asset(
                                  SPClassImageUtil.spFunGetImagePath("ic_team_one"),
                                  width: width(20),
                                ):Image.network(
                                  widget.spProGuessInfo.spProIconUrlOne,
                                  width: width(20),
                                ),
                                SizedBox(width: 5,),
                                Text(widget.spProGuessInfo.spProTeamOne,style: TextStyle(fontSize: sp(12)),)
                              ],

                            ),),
                          ],
                        ),
                      ),
                      spProMatchInjuryEntity.spProMatchInjury.one==null ? SizedBox():  ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(left: width(18),right: width(18)),
                          shrinkWrap: true,
                          itemCount: spProMatchInjuryEntity.spProMatchInjury.one.length,
                          itemBuilder: (c,index){
                            var item =spProMatchInjuryEntity.spProMatchInjury.one[index];
                            return  Container(
                              padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[300],width: 0.4))
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: width(21),
                                        padding: EdgeInsets.all(width(2)),
                                        alignment: Alignment.center,
                                        decoration: ShapeDecoration(
                                            shape: CircleBorder(),
                                            color: Color(0xFFDE3C31)
                                        ),
                                        child: Text(item.spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                      ),
                                      SizedBox(width: 3,),
                                      Text(item.spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),)
                                    ],
                                  ),),
                                  Expanded(child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(item.reason,maxLines: 1,style:TextStyle(fontSize: sp(12)),),

                                    ],
                                  )),
                                ],
                              ),
                            );
                          }),

                      spProMatchInjuryEntity.spProMatchInjury.two==null ?  SizedBox():   Container(
                        padding: EdgeInsets.all(width(13)),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Row(
                              children: <Widget>[
                                ( widget.spProGuessInfo.spProIconUrlTwo.isEmpty)? SPClassEncryptImage.asset(
                                  SPClassImageUtil.spFunGetImagePath("ic_team_two"),
                                  width: width(20),
                                ):Image.network(
                                  widget.spProGuessInfo.spProIconUrlTwo,
                                  width: width(20),
                                ),
                                SizedBox(width: 5,),
                                Text(widget.spProGuessInfo.spProTeamTwo,style: TextStyle(fontSize: sp(12)),)
                              ],

                            ),),
                          ],
                        ),
                      ),
                      spProMatchInjuryEntity.spProMatchInjury.two==null ? SizedBox():      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(left: width(18),right: width(18)),
                          shrinkWrap: true,
                          itemCount: spProMatchInjuryEntity.spProMatchInjury.two.length,
                          itemBuilder: (c,index){
                            var item =spProMatchInjuryEntity.spProMatchInjury.two[index];
                            return  Container(
                              padding: EdgeInsets.only(top: height(8),bottom: height(8)),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[300],width: 0.4))
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: width(21),
                                        padding: EdgeInsets.all(width(2)),
                                        alignment: Alignment.center,
                                        decoration: ShapeDecoration(
                                            shape: CircleBorder(),
                                            color: Color(0xFF5D9CEC)
                                        ),
                                        child: Text(item.spProShirtNumber,style: GoogleFonts.roboto(fontSize: sp(12),textStyle: TextStyle(color: Colors.white)),),
                                      ),
                                      SizedBox(width: 3,),
                                      Text(item.spProPlayerName,maxLines: 1,style:TextStyle(fontSize: sp(12)),)
                                    ],
                                  ),),
                                  Expanded(child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(item.reason,maxLines: 1,style:TextStyle(fontSize: sp(12)),),

                                    ],
                                  )),
                                ],
                              ),
                            );
                          })
                    ],
                  ),),


                ],

              ),
            ) ,
          ),
        ],
      ),
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  spFunLineUpString(String spProTeamOneLineup) {
    List<String> list=[];
    for(var i=0;i<spProTeamOneLineup.length;i++){
       list.add(spProTeamOneLineup.substring(i,i+1));
    }
   return JsonEncoder().convert(list).replaceAll("[", "").replaceAll("]", "").replaceAll(",", "-").replaceAll("\"", "");

  }

  spFunBuildLineUpTeam() {
    List<Widget> views=[];

     views.add(SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_football_place"),height: width(217),fit: BoxFit.fitHeight,));
     views.add(Positioned(
       left: width(10),
       child:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_footer_one"),width: width(18)),
     ));
     views.add( Positioned(
      right: width(10),
      child:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_footer_two"),width: width(18)),
     ));
     views.add(Positioned(
       left: width(10),
       bottom: width(5),
       child:Text("${spFunLineUpString(spProMatchLineupEntity.spProMatchLineup[0].spProTeamOneLineup)}",style: TextStyle(fontSize: width(12)),),
     ));
     views.add(Positioned(
       right: width(10),
       bottom: width(5),
       child:Text("${spFunLineUpString(spProMatchLineupEntity.spProMatchLineup[0].spProTeamTwoLineup)}",style: TextStyle(fontSize: width(12)),),
     ));

     views.add(Positioned(
       left: width(35),
       child: Container(
         width: width(110),
         height: width(163),
         child: spFunBuildLineUpTeamRow(spProMatchLineupEntity.spProMatchLineup[0].spProTeamOneLineup,"ic_footer_one")),
       ),
     );
    views.add(Positioned(
      right: width(35),
      child: Container(
        width: width(110),
        height: width(163),
        child: spFunBuildLineUpTeamRow(spFunReverseString(spProMatchLineupEntity.spProMatchLineup[0].spProTeamTwoLineup),"ic_footer_two")),
      ),
    );


    return views;
  }

  spFunBuildLineUpTeamRow(spProTeamOneLineup,imageName) {
    List<String> list=[];
    for(var i=0;i<spProTeamOneLineup.length;i++){
      list.add(spProTeamOneLineup.substring(i,i+1));
    }
   return  Row(
      children: list.map((item){
        return Expanded(
            child: Column(
            children: List<int>(int.parse(item)).map((ren){
              return Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("${imageName.toString()}"),width: width(18)),
                ),
              );
            }).toList(),
        ));
      }).toList(),
    );
  }

  spFunReverseString(String spProTeamTwoLineup) {
    var result ="";
    for(var i=spProTeamTwoLineup.length-1;i>=0;i--){
      result=result+spProTeamTwoLineup.substring(i,i+1);
    }
    return result;

  }

}

