import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/pages/competition/SPClassMatchListSettingPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';

import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/pages/hot/circleInfo/SPClassNewCircleInfoPage.dart';

import 'package:sport/SPClassEncryptImage.dart';

class SPClassMatchBasketballView extends StatefulWidget{
  SPClassGuessMatchInfo spProMatchItem;
  bool spProShowLeagueName;
  SPClassMatchBasketballView(this.spProMatchItem,{this.spProShowLeagueName:true});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  SPClassMatchBasketballViewState();
  }
  
}


class SPClassMatchBasketballViewState extends State<SPClassMatchBasketballView>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      margin: EdgeInsets.only(top: width(3),right: width(3),left: width(3)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width(3)),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: width(3),bottom: width(3)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                           widget.spProShowLeagueName? Container(
                              margin: EdgeInsets.only(left: width(7)),

                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: SPClassMatchDataUtils.spFunLeagueNameColor(widget.spProMatchItem.spProLeagueName),
                                  borderRadius: BorderRadius.circular(width(3))
                              ),
                              constraints: BoxConstraints(
                                  minWidth: width(50)
                              ),
                              child:Text(SPClassStringUtils.spFunMaxLength(widget.spProMatchItem.spProLeagueName,length: 4),style: TextStyle(fontSize: sp(10.5),color:Colors.white),) ,
                            ):SizedBox(),
                            SizedBox(width: 7,),
                            Text(SPClassDateUtils.spFunDateFormatByString(widget.spProMatchItem.spProStTime, "MM/dd HH:mm"),style: TextStyle(fontSize: sp(10),color: Color(0xFF999999)),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(


                  alignment: Alignment.center,
                  child: Stack(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: width(6),right: width(6)),
                      child: Text(widget.spProMatchItem.spProStatusDesc, style: TextStyle(color:DateTime.parse(widget.spProMatchItem.spProStTime).difference(DateTime.now()).inSeconds>0? Color(0xFF999999):Color(0xFFF15558), fontSize: sp(13)),),
                    ),
                    SPClassStringUtils.spFunIsNum(widget.spProMatchItem.spProStatusDesc.substring(widget.spProMatchItem.spProStatusDesc.length-1))?  Positioned(
                      right: 0,
                      top: 3,
                      child: SPClassEncryptImage.asset(
                        SPClassImageUtil.spFunGetImagePath("gf_minute",format: ".gif"),
                        color: Color(0xFFF15558),
                      ),
                    ):SizedBox()
                  ],),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:SizedBox(),
                      ),
                      (widget.spProMatchItem.spProSchemeNum==null||int.tryParse(widget.spProMatchItem.spProSchemeNum)==0)? SizedBox(width: width(33),):
                      Row(
                        children: <Widget>[
                          Text(widget.spProMatchItem.spProSchemeNum+"观点",style: TextStyle(color: Color(0xFF24AAF0),fontSize: width(10)),),
                          SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                              height: width(7),
                              color: Color(0xFF24AAF0)
                          ),
                          SizedBox(width: width(5),),
                        ],
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: width(7),),
            padding: EdgeInsets.only(left: width(11),right: width(11)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(widget.spProMatchItem.spProTeamOne,style: GoogleFonts.notoSansSC(fontSize: sp(13),fontWeight: FontWeight.w500,),maxLines: 1,overflow: TextOverflow.ellipsis,),
                Text("[主]",style: GoogleFonts.notoSansSC(fontSize: sp(11),textStyle: TextStyle(color: Color(0xFF999999))),maxLines: 1,overflow: TextOverflow.ellipsis,),

                Expanded(
                  child:SPClassMatchDataUtils.spFunShowScore(widget.spProMatchItem.status)?  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: height(1.5)),
                        margin: EdgeInsets.only(right: width(15)),
                        child:Text((((widget.spProMatchItem.spProYaPan!=null) ?  double.tryParse(widget.spProMatchItem.spProYaPan.spProAddScore)>=0 ? "+":"":"")+((widget.spProMatchItem.spProYaPan!=null) ?  SPClassStringUtils.spFunSqlitZero(widget.spProMatchItem.spProYaPan.spProAddScore):"")),style: GoogleFonts.notoSansSC(fontSize: sp(11),textStyle: TextStyle(color: Color(0xFF333333))),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ),
                      (widget.spProMatchItem.spProSectionScore==null||widget.spProMatchItem.spProSectionScore.length==0) ? SizedBox():Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:widget.spProMatchItem.spProSectionScore.map((item){
                        return  Container(
                          width: width(21),
                          alignment: Alignment.center,
                          child: Text(item.spProScoreOne,style: GoogleFonts.roboto(fontSize: sp(11),textStyle: TextStyle(color: Color(0xFF999999))),),
                        );
                      }).toList(),
                    ),
                      Container(
                        margin: EdgeInsets.only(left: width(25)),
                        width: width(25),
                        alignment: Alignment.center,
                        child: Text(widget.spProMatchItem.spProScoreOne,style: GoogleFonts.roboto(fontSize: sp(11),textStyle: TextStyle(color: Color(0xFFDE3C31)),fontWeight: FontWeight.w500),),
                      )

                    ],
                  ):SizedBox(),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: width(11),right: width(11)),
            child: Row(
              children: <Widget>[
                Text(widget.spProMatchItem.spProTeamTwo,style: GoogleFonts.notoSansSC(fontSize: sp(13),fontWeight: FontWeight.w500,),maxLines: 1,overflow: TextOverflow.ellipsis,),
                Text(" [客]",style: GoogleFonts.notoSansSC(fontSize: sp(11),textStyle: TextStyle(color: Color(0xFF999999))),maxLines: 1,overflow: TextOverflow.ellipsis,),

                Expanded(
                  child:SPClassMatchDataUtils.spFunShowScore(widget.spProMatchItem.status)?  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child:(widget.spProMatchItem.spProSectionScore==null||widget.spProMatchItem.spProSectionScore.length==0) ? SizedBox():Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:widget.spProMatchItem.spProSectionScore.map((item){
                            return  Container(
                              width: width(21),
                              alignment: Alignment.center,
                              child: Text(item.spProScoreTwo,style: GoogleFonts.roboto(fontSize: sp(11),textStyle: TextStyle(color: Color(0xFF999999))),),
                            );
                          }).toList(),
                        ) ,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width(25)),
                        width: width(25),
                        alignment: Alignment.center,
                        child: Text(widget.spProMatchItem.spProScoreTwo,style: GoogleFonts.roboto(fontSize: sp(11),textStyle: TextStyle(color: Color(0xFFDE3C31)),fontWeight: FontWeight.w500),),
                      )

                    ],
                  ):SizedBox(),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: width(4)),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.only(left: width(12),right: width(7)),
                    alignment: Alignment.center,
                    child:  SPClassEncryptImage.asset(
                      SPClassImageUtil.spFunGetImagePath('ic_btn_score_colloect'),
                      width: width(16),
                      color: widget.spProMatchItem.collected=="1" ? null:Colors.grey[300],
                    ),
                  ),
                  onTap: (){
                    if(spFunIsLogin(context: context)){
                      if(!(widget.spProMatchItem.collected=="1")){
                        SPClassApiManager.spFunGetInstance().spFunCollectMatch(matchId: widget.spProMatchItem.spProGuessMatchId,context: context,
                            spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                spProOnSuccess: (result){
                                  if(mounted){
                                    setState(() {
                                      widget.spProMatchItem.collected="1";
                                    });
                                  }
                                }
                            )
                        );
                      }else{
                        SPClassApiManager.spFunGetInstance().spFunDelUserMatch(matchId: widget.spProMatchItem.spProGuessMatchId,context: context,
                            spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                spProOnSuccess: (result){
                                  if(mounted){
                                    setState(() {
                                      widget.spProMatchItem.collected="0";
                                    });
                                  }
                                }
                            )
                        );
                      }

                    }
                  },
                ),
                Container(
                  width: width(15),
                  child: SPClassEncryptImage.asset(
                    ((widget.spProMatchItem.spProVideoUrl!=null&&widget.spProMatchItem.spProVideoUrl.isNotEmpty)&&SPClassMatchDataUtils.spFunShowLive(widget.spProMatchItem.status)) ?SPClassImageUtil.spFunGetImagePath("ic_match_live"):"",
                    width: width(15),
                  ),
                ),
                !SPClassMatchListSettingPageState.SHOW_PANKOU ?SizedBox():  Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("分差:"+SPClassStringUtils.spFunSqlitZero((double.tryParse(widget.spProMatchItem.spProScoreOne)-double.tryParse(widget.spProMatchItem.spProScoreTwo)).toString()),style: TextStyle(color: Color(0xFF666666),fontSize: width(9)),),
                      SizedBox(width: width(8),),
                      Text("总分:"+SPClassStringUtils.spFunSqlitZero((double.tryParse(widget.spProMatchItem.spProScoreOne)+double.tryParse(widget.spProMatchItem.spProScoreTwo)).toString()),style: TextStyle(color: Color(0xFF666666),fontSize: width(9)),),
                      SizedBox(width: width(8),),
                      Text("盘路:"+((widget.spProMatchItem.spProDaXiao!=null) ? SPClassStringUtils.spFunSqlitZero(widget.spProMatchItem.spProDaXiao.spProMidScore):""),style: TextStyle(color: Color(0xFF666666),fontSize: width(9)),),
                      SizedBox(width: width(15),),

                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: height(8),)

        ],
      ),
    );
  }


}