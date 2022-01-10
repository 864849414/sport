import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassListEntity.dart';
import 'package:sport/model/SPClassSchemeGuessMatch2.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/dialogs/SPClassBottomPickAndSearchList.dart';

class SPClassPickSchemeDataDialog extends StatefulWidget {
  SPClassSchemeGuessMatch2 spProGuessMatch;
  ValueChanged<SPClassSchemeGuessMatch2>  changed;

  SPClassPickSchemeDataDialog(this.changed,{this.spProGuessMatch});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassPickSchemeDataDialogState();
  }
}

class SPClassPickSchemeDataDialogState extends State<SPClassPickSchemeDataDialog> {
  var spProMatchTime = "";
  var LeagueName = "";
   SPClassSchemeGuessMatch2 spProGuessMatch ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProMatchTime = SPClassDateUtils.dateFormatByDate(DateTime.now(), "yyyy-MM-dd");
    if(widget.spProGuessMatch!=null){
      spProGuessMatch=widget.spProGuessMatch;
      LeagueName=widget.spProGuessMatch.spProLeagueName;
      spProMatchTime=SPClassDateUtils.spFunDateFormatByString(spProGuessMatch.spProStTime, "yyyy-MM-dd");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: GestureDetector(
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: width(300),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(width(7))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width(10)),
                        width: width(300),
                        child: Text(
                          "选择赛事球队",
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: sp(16)),
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.vertical(
                                top:
                                    Radius.circular(width(7)))),
                      ),
                      Container(
                        width: width(300),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.4, color: Colors.grey[300]))),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: width(20),
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: width(24),
                                ),
                                Text(
                                  "比赛时间",
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: sp(14)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: width(8),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                  width: width(227),
                                  height: width(37),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Color(0xFFA8A8A8)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            width(3))),
                                  ),
                                  child: Text(
                                    spProMatchTime,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: sp(12)),
                                  )),
                              onTap: () {
                                DatePicker.showDatePicker(context,
                                    initialDateTime: DateTime.now(),
                                    locale: DateTimePickerLocale.zh_cn,
                                    onConfirm: (date, index) {
                                      setState(() {
                                        spProMatchTime = SPClassDateUtils.dateFormatByDate(
                                            date, "yyyy-MM-dd");
                                        LeagueName="";
                                        spProGuessMatch=null;
                                      });
                                    });
                              },
                            ),

                            SizedBox(
                              height: width(18),
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: width(24),
                                ),
                                Text(
                                  "联赛名",
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: sp(14)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: width(8),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                  width: width(227),
                                  height: width(37),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Color(0xFFA8A8A8)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            width(3))),
                                  ),
                                  child: Text(
                                    LeagueName,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: sp(12)),
                                  )),
                              onTap: () {
                                SPClassApiManager.spFunGetInstance().spFunSchemeLeagueOfDate<SPClassListEntity<String>>(context: context,queryParameters: {
                                  "match_type":SPClassMatchDataUtils.spFunExpertTypeToMatchType(SPClassApplicaion.spProUserLoginInfo.spProExpertMatchType),"date":spProMatchTime
                                },spProCallBack: SPClassHttpCallBack(
                                    spProOnSuccess: (value){
                                      showCupertinoModalPopup(context: context, builder:
                                          (c)=>SPClassBottomPickAndSearchList(spProDialogTitle: "联赛",list: value.spProDataList,changed: (index){
                                        setState(() {
                                          LeagueName=value.spProDataList[index];
                                          spProGuessMatch=null;
                                        });
                                      },));
                                    }
                                ));
                              },
                            ),

                            SizedBox(
                              height: width(18),
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: width(24),
                                ),
                                Text(
                                  "比赛队伍",
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: sp(14)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: width(8),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                  width: width(227),
                                  height: width(37),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Color(0xFFA8A8A8)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            width(3))),
                                  ),
                                  child: Text(
                                    spProGuessMatch!=null ? (spProGuessMatch.spProTeamOne+ " vs "+spProGuessMatch.spProTeamTwo):"",
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: sp(12)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              onTap: () {
                                if(LeagueName.isEmpty){
                                  SPClassToastUtils.spFunShowToast(msg: "请选择联赛");
                                  return ;
                                }
                                SPClassApiManager.spFunGetInstance().spFunSchemeGuessMatchList<SPClassSchemeGuessMatch2>(context: context,queryParameters: {
                                  "match_type":SPClassMatchDataUtils.spFunExpertTypeToMatchType(SPClassApplicaion.spProUserLoginInfo.spProExpertMatchType),"date":spProMatchTime,
                                  "league_name":LeagueName

                                },spProCallBack: SPClassHttpCallBack(
                                    spProOnSuccess: (value){
                                      showCupertinoModalPopup(context: context, builder:
                                          (c)=>SPClassBottomPickAndSearchList(spProDialogTitle: "队伍",list: value.spProDataList.map((e) =>
                                          (SPClassDateUtils.spFunDateFormatByString(e.spProStTime, "HH:ss") + " "+e.spProTeamOne+" vs "+e.spProTeamTwo)).toList(),
                                            changed: (index){
                                            setState(() {
                                             spProGuessMatch=value.spProDataList[index];
                                            });
                                      },));
                                    }
                                ));
                              },
                            ),

                            SizedBox(
                              height: width(20),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: height(45),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: GestureDetector(
                                behavior:HitTestBehavior.opaque,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: height(45),
                                  child: Text(
                                    "取消",
                                    style: TextStyle(
                                        fontSize: sp(17),
                                        color: Color(0xFF333333)),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: GestureDetector(
                                behavior:HitTestBehavior.opaque,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:(LeagueName.isNotEmpty&&spProGuessMatch!=null)?   Color(0xFFDE3C31):Color(0xFFFFAFAA),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(
                                              width(7)))),
                                  height: height(45),
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                        fontSize: sp(17),
                                        color: Colors.white),
                                  ),
                                ),
                                onTap: ()  {
                                  if((LeagueName.isNotEmpty&&spProGuessMatch!=null)){
                                     spProGuessMatch.spProLeagueName=LeagueName;
                                     widget.changed(spProGuessMatch);
                                     Navigator.of(context).pop();
                                  }else{
                                    SPClassToastUtils.spFunShowToast(msg: "请完善相关信息");
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {},
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      onWillPop: () async {
        return true;
      },
    );
  }
}
