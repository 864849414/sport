import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/SPClassEncodeUtil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassSchemeDetailEntity.dart';
import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/pages/competition/scheme/SPClassSchemeDetailPage.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/utils/colors.dart';

class SPClassSchemeItemView extends StatelessWidget {
  SPClassSchemeListSchemeList item;
  bool spProShowRate;
  bool spProShowProFit;
  bool spProCanClick;
  bool spProShowLine;
  SPClassSchemeItemView(this.item,
      {this.spProShowRate: true,
      this.spProShowProFit: true,
      this.spProCanClick: true,
      this.spProShowLine: true});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
            left: width(13),
            right: width(13),
            top: height(15),
            bottom: height(12)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: 0.5,
                    color: spProShowLine ? Color(0xFFF2F2F2) : Colors.white))),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(width(20)),
                        child: (item?.expert?.spProAvatarUrl == null ||
                                item.expert.spProAvatarUrl.isEmpty)
                            ? SPClassEncryptImage.asset(
                                SPClassImageUtil.spFunGetImagePath(
                                    "ic_default_avater"),
                                width: width(40),
                                height: width(40),
                              )
                            : Image.network(
                                item.expert.spProAvatarUrl,
                                width: width(40),
                                height: width(40),
                                fit: BoxFit.cover,
                              ),
                      ),
                      onTap: () {
                        if (spProCanClick) {
                          SPClassApiManager.spFunGetInstance().spFunExpertInfo(
                              queryParameters: {"expert_uid": item.spProUserId},
                              context: context,
                              spProCallBack:
                                  SPClassHttpCallBack(spProOnSuccess: (info) {
                                SPClassNavigatorUtils.spFunPushRoute(
                                    context, SPClassExpertDetailPage(info));
                              }));
                        }
                      },
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: (item.expert.spProNewSchemeNum != "null" &&
                              int.parse(item.expert.spProNewSchemeNum) > 0)
                          ? Container(
                              alignment: Alignment.center,
                              width: width(13),
                              height: width(13),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(width(6)),
                                color: Color(0xFFE3494B),
                              ),
                              child: Text(
                                item.expert.spProNewSchemeNum,
                                style: TextStyle(
                                    fontSize: sp(8), color: Colors.white),
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
                SizedBox(
                  width: width(5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "${item.expert.spProNickName}",
                              style: GoogleFonts.notoSansSC(
                                textStyle: TextStyle(
                                  color: Color(0xFF333333),
                                ),
                                fontSize: sp(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4,),
                            Text(
                              "7分钟前",
                              style: GoogleFonts.notoSansSC(
                                textStyle: TextStyle(
                                  color: MyColors.grey_99,
                                ),
                                fontSize: sp(10),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: width(6)),
                          child: Row(
                            children: <Widget>[
                              Visibility(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: width(8),
                                      right: width(8),
                                      top: width(0.8)),
                                  alignment: Alignment.center,
                                  height: width(16),
                                  // constraints:
                                  //     BoxConstraints(minWidth: width(52)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: LinearGradient(colors: [
                                        Color(0xFFFF6A4C),
                                        Color(0xFFFF8D66),
                                      ])),
                                  child: Text(
                                    "近" +
                                        "${item.expert.spProLast10Result.length.toString()}" +
                                        "中" +
                                        "${item.expert.spProLast10CorrectNum}",
                                    style: TextStyle(
                                        fontSize: sp(9),
                                        color: Color(0xFFF7F7F7),
                                        letterSpacing: 1),
                                  ),
                                ),
                                visible: (item.expert.spProSchemeNum != null &&
                                    (double.tryParse(item
                                                .expert.spProLast10CorrectNum) /
                                            double.tryParse(item
                                                .expert.spProLast10Result.length
                                                .toString())) >=
                                        0.6),
                              ),
                              SizedBox(
                                width: width(4),
                              ),
                              Visibility(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: width(8),
                                      right: width(8),
                                      top: width(0.8)),
                                  alignment: Alignment.center,
                                  height: width(16),
                                  // constraints:
                                  //     BoxConstraints(minWidth: width(52)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: LinearGradient(colors: [
                                        Color(0xFFFFB44D),
                                        Color(0xFFFFA64D),
                                      ])),
                                  child: Text(
                                    "${item.expert.spProCurrentRedNum}连红",
                                    style: TextStyle(
                                        fontSize: sp(9),
                                        color: Color(0xFFF7F7F7),
                                        letterSpacing: 1),
                                  ),
                                ),
                                visible:
                                    int.tryParse(item.expert.spProCurrentRedNum) >
                                        2,
                              ),
                              SizedBox(
                                width: width(8),
                              ),
                              Visibility(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: width(6),
                                      right: width(6),
                                      top: width(0.8)),
                                  alignment: Alignment.center,
                                  height: width(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFF1B8DE0), width: 0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "不中退",
                                    style: TextStyle(
                                        fontSize: sp(9),
                                        color: Color(0xFF1B8DE0),
                                        letterSpacing: 1),
                                  ),
                                ),
                                visible: item.spProCanReturn&&item.spProDiamond!="0"&&item.spProIsOver=="0",
                              ),
                              // int.tryParse( item.expert.spProCurrentRedNum)>2?  Stack(
                              //   children: <Widget>[
                              //     SPClassEncryptImage.asset(item.expert.spProCurrentRedNum.length>1  ? SPClassImageUtil.spFunGetImagePath("ic_recent_red2"):SPClassImageUtil.spFunGetImagePath("ic_recent_red"),
                              //       height:width(16) ,
                              //       fit: BoxFit.fitHeight,
                              //     ),
                              //     Positioned(
                              //       left: width(item.expert.spProCurrentRedNum.length>1  ? 5:7),
                              //       bottom: 0,
                              //       top: 0,
                              //       child: Container(
                              //         alignment: Alignment.center,
                              //         child: Text("${item.expert.spProCurrentRedNum}",style: GoogleFonts.roboto(textStyle: TextStyle(color:Color(0xFFDE3C31) ,fontSize: sp(14.8),fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
                              //       ),
                              //     ),
                              //     Positioned(
                              //       right: width(7),
                              //       bottom: 0,
                              //       top: 0,
                              //       child: Container(
                              //         padding: EdgeInsets.only(top: width(0.8)),
                              //         alignment: Alignment.center,
                              //         child: Text("连红",style: TextStyle(color:Colors.white ,fontSize: sp(9),fontStyle: FontStyle.italic)),
                              //       ),
                              //     )
                              //   ],
                              // ):SizedBox()
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                spProShowProFit
                    ? Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child:
                            double.tryParse(item.expert.spProRecentProfit) <= 0
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text: spProShowRate
                                              ? "${(double.tryParse(item.expert.spProRecentProfitSum) * 100).toStringAsFixed(0)}%"
                                              : "",
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              textStyle: TextStyle(
                                                  fontSize: sp(24),
                                                  color: Color(0xFFF74825))),
                                        ),
                                      ),
                                      Text(
                                        spProShowRate ? "近10场回报率" : "",
                                        style: TextStyle(
                                            fontSize: sp(10),
                                            color: MyColors.grey_99),
                                      )
                                    ],
                                  ),
                      )
                    : Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: SPClassMatchDataUtils.spFunCalcBestCorrectRate(
                                    item.expert.spProLast10Result) <
                                0.7
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: spProShowRate
                                          ? "${(SPClassMatchDataUtils.spFunCalcBestCorrectRate(item.expert.spProLast10Result) * 100).toStringAsFixed(0)}"
                                          : "",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          textStyle: TextStyle(
                                              fontSize: sp(27),
                                              color: Color(0xFF1B8DE0))),
                                      children: [
                                        TextSpan(
                                            text: '%',
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                    fontSize: sp(10),
                                                    color: Color(0xFF1B8DE0),),),
                                        )
                                      ]
                                    ),
                                  ),
                                  Text(
                                    spProShowRate ? "近期胜率" : "",
                                    style: TextStyle(
                                        fontSize: sp(10),
                                        color: Color(0xFF666666)),
                                  )
                                ],
                              ),
                      )
              ],
            ),

            // Container(
            //   margin: EdgeInsets.only(top: width(8)),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Container(
            //         alignment: Alignment.center,
            //         padding: EdgeInsets.only(left: width(6), right: width(6),),
            //         margin: EdgeInsets.only(right: width(4), top: width(6)),
            //         decoration: BoxDecoration(
            //             border: Border.all(
            //                 color: SPClassMatchDataUtils.getFontColors(
            //                     item.spProGuessType,
            //                     item.spProMatchType,
            //                     item.spProPlayingWay),
            //                 width: 0.5),
            //             color: SPClassMatchDataUtils.getColors(
            //                 item.spProGuessType,
            //                 item.spProMatchType,
            //                 item.spProPlayingWay),
            //             borderRadius: BorderRadius.circular(width(4))),
            //         child: Text(
            //           "${SPClassMatchDataUtils.spFunPayWayName(item.spProGuessType, item.spProMatchType, item.spProPlayingWay)}",
            //           style: TextStyle(
            //             color: SPClassMatchDataUtils.getFontColors(
            //                 item.spProGuessType,
            //                 item.spProMatchType,
            //                 item.spProPlayingWay),
            //             fontSize: sp(10),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Text(
            //           '${item.title}',
            //           style: GoogleFonts.notoSansSC(
            //               textStyle: TextStyle(
            //                 color: Color(0xFF333333),
            //               ),
            //               fontSize: sp(17)),
            //           maxLines: 2,
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: width(6)),
              alignment: Alignment.centerLeft,
              child:Stack(
                children: <Widget>[
                  Container(
                    child: RichText(
                      maxLines: 2,overflow: TextOverflow.ellipsis,
                      text:  TextSpan(
                          text: item.title,
                          style: GoogleFonts.notoSansSC(textStyle: TextStyle(color:Color(0xFF333333),),fontSize: sp(17),)
                      ),
                    ),
                    padding: EdgeInsets.only(left: width(18+SPClassMatchDataUtils.spFunPayWayName(item.spProGuessType, item.spProMatchType, item.spProPlayingWay).length*9)),
                  ),
                  Positioned(top: width(6),left: 0,child:
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: width(6),right: width(6)),
                    decoration: BoxDecoration(
                        border: Border.all(color: SPClassMatchDataUtils.getFontColors(item.spProGuessType, item.spProMatchType, item.spProPlayingWay),width: 0.5),
                        color: SPClassMatchDataUtils.getColors(item.spProGuessType, item.spProMatchType, item.spProPlayingWay),
                        borderRadius: BorderRadius.circular(width(4))
                    ),
                    child: Text("${SPClassMatchDataUtils.spFunPayWayName(item.spProGuessType, item.spProMatchType, item.spProPlayingWay)}",style: TextStyle(color:SPClassMatchDataUtils.getFontColors(item.spProGuessType, item.spProMatchType, item.spProPlayingWay),fontSize: sp(9),),),
                  ),)
                ],
              ),
            ),
            SizedBox(
              height: width(6),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: width(8),top: width(4),bottom: width(4)),
              decoration: BoxDecoration(
                color: Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(width(4))
              ),
              child: Row(
                children: <Widget>[
                  // item.spProMatchType.toLowerCase()=="lol" ? Container(
                  //   padding: EdgeInsets.symmetric(horizontal: width(5)),
                  //   child: Row(
                  //     children: <Widget>[
                  //       SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_lol_match"),width: width(13),),
                  //       SizedBox(width: width(5),),
                  //       Text(item.spProLeagueName,style: TextStyle(fontSize: sp(11)),),
                  //     ],
                  //   ),
                  // ):Container(
                  //   margin: EdgeInsets.only(left: width(8)),
                  //   constraints:BoxConstraints(
                  //       minWidth: width(67)
                  //   ) ,
                  //   child: Column(
                  //     children: <Widget>[
                  //
                  //     ],
                  //   ),
                  // ),
                  Row(
                    children: <Widget>[
                      Text(
                        SPClassDateUtils.spFunDateFormatByString(
                            item.spProStTime, "MM-dd    HH:mm"),
                        style: TextStyle(
                            fontSize: sp(11), color: MyColors.grey_99),
                      ),
                      SizedBox(
                        width: width(8),
                      ),
                      Text(
                        item.spProLeagueName,
                        style: TextStyle(
                            fontSize: sp(11), color: MyColors.grey_99),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: width(4), right: width(8)),
                    width: 0.5,
                    height: height(9),
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          SPClassStringUtils.spFunMaxLength(item.spProTeamOne,
                              length: 5),
                          style: TextStyle(
                              fontSize: sp(11), color: MyColors.grey_66),
                          maxLines: 1,
                        ),
                        Text(
                          " VS ",
                          style: TextStyle(
                              fontSize: sp(13), color: Color(0xFF999999)),
                          maxLines: 1,
                        ),
                        // item.spProIsOver!="1"? Text(" VS ",style: TextStyle(fontSize: sp(13),color: Color(0xFF999999)),maxLines: 1,):
                        // Text(item.spProScoreOne.trim()+
                        //     " - "+
                        //     item.spProScoreTwo.trim(),style: TextStyle(fontSize: sp(11),
                        //     color: Color(0xFFE3494B)),),
                        Text(
                          SPClassStringUtils.spFunMaxLength(item.spProTeamTwo,
                              length: 5),
                          style: TextStyle(
                              fontSize: sp(11), color: MyColors.grey_66),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: width(8)),
                    child: (item.spProIsOver == "1" ||
                            item.spProDiamond == "0" ||
                            item.spProIsBought == "1")
                        ? Text(
                            '免费',
                            style: TextStyle(
                                color: Color(0xFF4D97FF), fontSize: sp(14)),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SPClassEncryptImage.asset(
                                SPClassImageUtil.spFunGetImagePath("zhuanshi"),
                                width: width(17),
                              ),
                              Text(
                                '${item.spProDiamond}',
                                style: TextStyle(
                                    color: MyColors.main1, fontSize: sp(13)),
                              ),
                            ],
                          ),
                  )
                  //  Container(
                  //   margin: EdgeInsets.only(right: width(8)),
                  //   decoration: BoxDecoration(
                  //       color: item.spProIsOver=="1" ? Color(0xFFF6F6F6):Color(0xFFDE3C31),
                  //       border: Border.all(color: item.spProIsOver=="1" ?Color(0xFF888888):Color(0xFFDE3C31),width: 1.5),
                  //       borderRadius: BorderRadius.circular(width(5))
                  //   ),
                  //   width: width(40),
                  //   height: width(30),
                  //   alignment: Alignment.center,
                  //   child: (item.spProIsOver=="1"||item.spProDiamond=="0"||item.spProIsBought=="1") ?
                  //   Text((item.spProDiamond=="0"&&item.spProIsOver=="0") ?
                  //   "查看详情":"查看详情",style: TextStyle(color:item.spProIsOver=="1" ?Colors.grey:Colors.white,fontSize: sp(8)),),):
                  //    item.spProCanReturn?  Column(
                  //     children: <Widget>[
                  //       Container(
                  //         color:Color(0xFFDE3C31) ,
                  //         height: width(13),
                  //         alignment: Alignment.center,
                  //         child: Text(int.tryParse(item.spProDiamond)==0? "查看详情":"${item.spProDiamond}"+
                  //             "钻石",style: TextStyle(color: Colors.white,fontSize: sp(9)),),
                  //       ),
                  //       Expanded(
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.vertical(bottom: Radius.circular(width(3)))
                  //           ),
                  //           alignment: Alignment.center,
                  //           child: Text("不中包退",style: TextStyle(color:Color(0xFFDE3C31),fontSize: sp(7)),),
                  //         ),
                  //       )
                  //     ],
                  //   )
                  //   :Text("${item.spProDiamond}"+
                  //        "钻石",style: TextStyle(color: Colors.white,fontSize: sp(9)),),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (spFunIsLogin(context: context)) {
          SPClassApiManager.spFunGetInstance().spFunSchemeDetail(
              queryParameters: {"scheme_id": item.spProSchemeId},
              context: context,
              spProCallBack: SPClassHttpCallBack<SPClassSchemeDetailEntity>(
                  spProOnSuccess: (value) {
                SPClassNavigatorUtils.spFunPushRoute(
                    context, SPClassSchemeDetailPage(value));
              }));
        }
      },
    );
  }
}
