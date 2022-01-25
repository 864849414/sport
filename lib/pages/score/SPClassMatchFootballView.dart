import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassSchemeGuessMatch2.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/pages/competition/SPClassMatchListSettingPage.dart';
import 'package:sport/pages/competition/detail/SPClassMatchDetailPage.dart';
import 'package:sport/pages/user/publicScheme/SPClassPublicSchemePage.dart';
import 'package:sport/utils/colors.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassMatchFootballView extends StatefulWidget {
  SPClassGuessMatchInfo spProMatchItem;
  bool spProShwoGroupName;
  bool spProShowLeagueName;
  SPClassMatchFootballView(this.spProMatchItem,
      {this.spProShwoGroupName: false, this.spProShowLeagueName: true});
  SPClassMatchFootballViewState state;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return state = SPClassMatchFootballViewState();
  }
}

class SPClassMatchFootballViewState extends State<SPClassMatchFootballView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: width(3),top: width(3)),
      padding: EdgeInsets.symmetric(vertical: width(4)),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // stops: [0.5,1],
            colors: [
              Colors.white,
              Color(0xFFF7F7F7)
            ]
          ),
          boxShadow: [
          BoxShadow(
            offset: Offset(0,1),
            color: Color(0xFFD9D9D9),
            blurRadius:width(3,),),
        ]
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: width(3), bottom: width(3)),
            child: Row(
              children: <Widget>[
                widget.spProShowLeagueName
                    ? Container(
                  width:width(70),
                  child: Text(
                    widget.spProShwoGroupName
                        ? widget.spProMatchItem.spProGroupName
                        : widget
                        .spProMatchItem.spProLeagueName,
                    style: TextStyle(
                      fontSize: sp(10),
                      color: SPClassMatchDataUtils
                          .spFunLeagueNameColor(
                          widget.spProShwoGroupName
                              ? widget.spProMatchItem
                              .spProGroupName
                              : widget.spProMatchItem
                              .spProLeagueName),
                    ),
                    maxLines: 1,overflow: TextOverflow.ellipsis,
                  ),
                  padding: EdgeInsets.only(left: width(15)),
                )
                    : SizedBox(width:width(70),),
                // 左
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        SPClassDateUtils.spFunDateFormatByString(
                            widget.spProMatchItem.spProStTime,
                            "MM/dd HH:mm"),
                        style: TextStyle(
                            fontSize: sp(12), color: Color(0xFF999999)),
                      ),
                    ],
                  ),
                ),
                // 中
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding:
                        EdgeInsets.only(left: width(6), right: width(6)),
                        child: Text(
                          SPClassStringUtils.spFunMatchStatusString(
                              widget.spProMatchItem.spProIsOver == "1",
                              widget.spProMatchItem.spProStatusDesc,
                              widget.spProMatchItem.spProStTime,
                              status: widget.spProMatchItem.status),
                          style: TextStyle(
                              color: DateTime.parse(
                                  widget.spProMatchItem.spProStTime)
                                  .difference(DateTime.now())
                                  .inSeconds >
                                  0
                                  ? Color(0xFF999999)
                                  : Color(0xFFF15558),
                              fontSize: sp(12)),
                        ),
                      ),
                      SPClassStringUtils.spFunIsNum(
                          widget.spProMatchItem.spProStatusDesc)
                          ? Positioned(
                        right: 0,
                        top: 3,
                        child: SPClassEncryptImage.asset(
                          SPClassImageUtil.spFunGetImagePath("gf_minute",
                              format: ".gif"),
                          color: Color(0xFFF15558),
                        ),
                      )
                          : SizedBox()
                    ],
                  ),
                ),
                // 右
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            widget.spProMatchItem.corner.isNotEmpty
                                ? SPClassEncryptImage.asset(
                              SPClassImageUtil.spFunGetImagePath(
                                  "ic_coner_score"),
                              width: width(12),
                            )
                                : SizedBox(),
                            Text(
                              "${widget.spProMatchItem.corner}",
                              style: TextStyle(
                                  color: Color(0xFF999999), fontSize: sp(12)),
                            ),
                            SizedBox(width: width(5),),
                            widget.spProMatchItem.spProHalfScore.isNotEmpty
                                ? Text(
                              "半 " + widget.spProMatchItem.spProHalfScore,
                              style: TextStyle(
                                  fontSize: sp(12), color: Color(0xFF999999)),
                            )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 观点
                (widget.spProMatchItem.spProSchemeNum == null ||
                    int.tryParse(
                        widget.spProMatchItem.spProSchemeNum) ==
                        0)
                    ? SizedBox(
                  width: width(70),
                )
                    : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: width(70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          widget.spProMatchItem.spProSchemeNum +
                              "观点",
                          style: TextStyle(
                              color: Color(0xFF24AAF0),
                              fontSize: width(10)),
                        ),
                        SPClassEncryptImage.asset(
                            SPClassImageUtil.spFunGetImagePath(
                                "ic_btn_right"),
                            height: width(7),
                            color: Color(0xFF24AAF0)),
                        SizedBox(
                          width: width(15),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    SPClassApiManager.spFunGetInstance()
                        .spFunMatchClick(queryParameters: {
                      "match_id":
                      widget.spProMatchItem.spProGuessMatchId
                    });
                    SPClassNavigatorUtils.spFunPushRoute(
                        context,
                        SPClassMatchDetailPage(
                          widget.spProMatchItem,
                          spProMatchType: "guess_match_id",
                          spProInitIndex: 3,
                        ));
                  },
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only( bottom: width(4)),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    width: width(45),
                    alignment: Alignment.center,
                    child: SPClassEncryptImage.asset(
                      SPClassImageUtil.spFunGetImagePath(
                          'ic_btn_score_colloect'),
                      width: width(16),
                      color: widget.spProMatchItem.collected == "1"
                          ? MyColors.main1
                          : Colors.grey[300],
                    ),
                  ),
                  onTap: () {
                    if (spFunIsLogin(context: context)) {
                      if (!(widget.spProMatchItem.collected == "1")) {
                        SPClassApiManager.spFunGetInstance().spFunCollectMatch(
                            matchId: widget.spProMatchItem.spProGuessMatchId,
                            context: context,
                            spProCallBack:
                                SPClassHttpCallBack<SPClassBaseModelEntity>(
                                    spProOnSuccess: (result) {
                              SPClassApplicaion.spProEventBus
                                  .fire("updateFollow");
                              if (mounted) {
                                setState(() {
                                  widget.spProMatchItem.collected = "1";
                                });
                              }
                            }));
                      } else {
                        SPClassApiManager.spFunGetInstance().spFunDelUserMatch(
                            matchId: widget.spProMatchItem.spProGuessMatchId,
                            context: context,
                            spProCallBack:
                                SPClassHttpCallBack<SPClassBaseModelEntity>(
                                    spProOnSuccess: (result) {
                              SPClassApplicaion.spProEventBus
                                  .fire("updateFollow");
                              if (mounted) {
                                setState(() {
                                  widget.spProMatchItem.collected = "0";
                                });
                              }
                            }));
                      }
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                (widget.spProMatchItem.spProRedCard
                                            .isNotEmpty &&
                                        int.tryParse(widget
                                                .spProMatchItem.spProRedCard
                                                .split("-")[0]) >
                                            0 &&
                                        SPClassMatchListSettingPageState
                                            .spProShowRedCard)
                                    ? Container(
                                        padding: EdgeInsets.all(width(1)),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFDA5548),
                                            borderRadius: BorderRadius.circular(
                                                width(2))),
                                        child: Text(
                                          widget.spProMatchItem.spProRedCard
                                              .split("-")[0],
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                              fontSize: sp(11)),
                                        ),
                                      )
                                    : SizedBox(),
                                (widget.spProMatchItem.spProYellowCard
                                            .isNotEmpty &&
                                        int.tryParse(widget
                                                .spProMatchItem.spProYellowCard
                                                .split("-")[0]) >
                                            0 &&
                                        SPClassMatchListSettingPageState
                                            .spProShowRedCard)
                                    ? Container(
                                        padding: EdgeInsets.all(width(1)),
                                        margin:
                                            EdgeInsets.only(left: 3, right: 3),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFEDB445),
                                            borderRadius: BorderRadius.circular(
                                                width(2))),
                                        child: Text(
                                          widget.spProMatchItem.spProYellowCard
                                              .split("-")[0],
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                              fontSize: sp(11)),
                                        ),
                                      )
                                    : SizedBox(),
                                Visibility(
                                  child: Text(
                                    sprintf("[%s] ", [
                                      widget.spProMatchItem.spProRankingOne
                                    ]),
                                    style: TextStyle(
                                        fontSize: sp(10),
                                        color: Color(0xFF888888)),
                                  ),
                                  visible:
                                      (widget.spProMatchItem.spProRankingOne !=
                                              null &&
                                          widget.spProMatchItem.spProRankingOne
                                              .isNotEmpty),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.spProMatchItem.spProTeamOne,
                                    style: GoogleFonts.notoSansSC(
                                      fontSize: sp(13),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: width(7)),
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                !SPClassMatchDataUtils.spFunShowScore(
                                        widget.spProMatchItem.status)
                                    ? Text(
                                        "VS",
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                          color: Color(0xFF999999),
                                          fontWeight: FontWeight.bold,
                                          fontSize: sp(17),
                                        )),
                                      )
                                    : Text(
                                        widget.spProMatchItem.spProScoreOne +
                                            " - " +
                                            widget.spProMatchItem.spProScoreTwo,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                          color: Color(0xFFDE3C31),
                                          fontWeight: FontWeight.w500,
                                          fontSize: sp(17),
                                        )),
                                      ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    widget.spProMatchItem.spProTeamTwo,
                                    style: GoogleFonts.notoSansSC(
                                      fontSize: sp(13),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Visibility(
                                  child: Text(
                                    sprintf("[%s] ", [
                                      widget.spProMatchItem.spProRankingTwo
                                    ]),
                                    style: TextStyle(
                                        fontSize: sp(10),
                                        color: Color(0xFF888888)),
                                  ),
                                  visible:
                                      (widget.spProMatchItem.spProRankingTwo !=
                                              null &&
                                          widget.spProMatchItem.spProRankingTwo
                                              .isNotEmpty),
                                ),
                                (widget.spProMatchItem.spProRedCard
                                            .isNotEmpty &&
                                        int.tryParse(widget
                                                .spProMatchItem.spProRedCard
                                                .split("-")[1]) >
                                            0 &&
                                        SPClassMatchListSettingPageState
                                            .spProShowRedCard)
                                    ? Container(
                                        padding: EdgeInsets.all(width(1)),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFDA5548),
                                            borderRadius: BorderRadius.circular(
                                                width(2))),
                                        child: Text(
                                          widget.spProMatchItem.spProRedCard
                                              .split("-")[1],
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                              fontSize: sp(11)),
                                        ),
                                      )
                                    : SizedBox(),
                                (widget.spProMatchItem.spProYellowCard
                                            .isNotEmpty &&
                                        int.tryParse(widget
                                                .spProMatchItem.spProYellowCard
                                                .split("-")[1]) >
                                            0 &&
                                        SPClassMatchListSettingPageState
                                            .spProShowRedCard)
                                    ? Container(
                                        padding: EdgeInsets.all(width(1)),
                                        margin:
                                            EdgeInsets.only(left: 3, right: 3),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFEDB445),
                                            borderRadius: BorderRadius.circular(
                                                width(2))),
                                        child: Text(
                                          widget.spProMatchItem.spProYellowCard
                                              .split("-")[1],
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                              fontSize: sp(11)),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),

                        ],
                      ),
                      Visibility(
                        child: Container(
                          margin: EdgeInsets.only(top: height(3)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: widget.spProMatchItem.spProYaPan !=
                                          null
                                      ? Text(
                                          SPClassStringUtils.spFunSqlitZero(
                                                  widget
                                                      .spProMatchItem
                                                      .spProYaPan
                                                      .spProWinOddsOne) +
                                              " / " +
                                              widget.spProMatchItem.spProYaPan
                                                  .spProAddScoreDesc +
                                              " /" +
                                              SPClassStringUtils.spFunSqlitZero(
                                                  widget
                                                      .spProMatchItem
                                                      .spProYaPan
                                                      .spProWinOddsTwo),
                                          style: GoogleFonts.roboto(
                                              fontSize: sp(11),
                                              textStyle: TextStyle(
                                                  color: Color(0xFF999999))),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              ((widget.spProMatchItem.spProVideoUrl != null &&
                                          widget.spProMatchItem.spProVideoUrl
                                              .isNotEmpty) &&
                                      SPClassMatchDataUtils.spFunShowLive(
                                          widget.spProMatchItem.status) &&
                                      widget
                                          .spProMatchItem.spProOtScore.isEmpty)
                                  ? Container(
                                      width: width(15),
                                      child: SPClassEncryptImage.asset(
                                        SPClassImageUtil.spFunGetImagePath(
                                            "ic_match_live"),
                                        width: width(15),
                                      ),
                                    )
                                  : SizedBox(),
                              Visibility(
                                child: Text(
                                  widget.spProMatchItem.spProOtScore,
                                  style: TextStyle(
                                      fontSize: sp(11),
                                      color: Color(0xFF999999)),
                                ),
                                visible: widget
                                    .spProMatchItem.spProOtScore.isNotEmpty,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: widget.spProMatchItem.spProDaXiao !=
                                          null
                                      ? Text(
                                          SPClassStringUtils.spFunSqlitZero(
                                                  widget
                                                      .spProMatchItem
                                                      .spProDaXiao
                                                      .spProWinOddsOne) +
                                              " /" +
                                              SPClassStringUtils.spFunSqlitZero(
                                                  widget.spProMatchItem
                                                      .spProMidScore) +
                                              "球 /" +
                                              SPClassStringUtils.spFunSqlitZero(
                                                  widget
                                                      .spProMatchItem
                                                      .spProDaXiao
                                                      .spProWinOddsTwo),
                                          style: GoogleFonts.roboto(
                                              fontSize: sp(11),
                                              textStyle: TextStyle(
                                                  color: Color(0xFF999999))),
                                        )
                                      : SizedBox(),
                                ),
                              )
                            ],
                          ),
                        ),
                        visible: SPClassMatchListSettingPageState.SHOW_PANKOU,
                      )
                    ],
                  ),
                ),
                Container(
                  width: width(45),
                  alignment: Alignment.centerLeft,
                  child: SPClassMatchDataUtils.spFunCanAddScheme(
                      widget.spProMatchItem.spProCanAddScheme,
                      widget.spProMatchItem.spProMatchType,
                      widget.spProMatchItem.status)
                      ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: width(10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 0.5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFEBEA),
                                  border: Border.all(
                                      color: Color(0xFFDE3C31),
                                      width: 0.4),
                                  borderRadius:
                                  BorderRadius.circular(300)),
                              child: Row(
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    SPClassImageUtil.spFunGetImagePath(
                                        "ic_add_scheme"),
                                    width: width(8),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    "点评",
                                    style: TextStyle(
                                        fontSize: sp(9),
                                        color: Color(0xFFDE3C31)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: width(10),
                        ),
                      ],
                    ),
                    onTap: () {
                      var spProGuessMatch =
                      SPClassSchemeGuessMatch2.newObject(
                          widget.spProMatchItem.spProGuessMatchId,
                          widget.spProMatchItem.spProLeagueName,
                          widget.spProMatchItem.spProTeamOne,
                          widget.spProMatchItem.spProTeamTwo,
                          widget.spProMatchItem.spProStTime);
                      SPClassNavigatorUtils.spFunPushRoute(
                          context,
                          SPClassPublicSchemePage(
                            spProGuessMatch: spProGuessMatch,
                          ));
                    },
                  )
                      : SizedBox(),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }

  void spFunOnfresh(List<SPClassGuessMatchInfo> matchs) {
    var item = matchs.firstWhere(
        (item) =>
            (item.spProGuessMatchId == widget.spProMatchItem.spProGuessMatchId),
        orElse: () => null);
    if (item != null) {
      widget.spProMatchItem = item;
      setState(() {});
    }
  }
}
