import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/AnimationImagePage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/pages/user/coupon/SPClassCouponPage.dart';
import 'package:sport/pages/user/scheme/follow/SPClassMyFollowSchemePage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/pages/common/SPClassShareView.dart';
import 'package:sport/pages/competition/scheme/SPClassExpertApplyPage.dart';
import 'package:sport/pages/dialogs/SPClassDialogTurntable.dart';
import 'package:sport/pages/user/about/SPClassAboutUsPage.dart';
import 'package:sport/pages/user/info/SPClassUserInfoPage.dart';
import 'package:sport/pages/user/publicScheme/SPClassMyAddSchemePage.dart';
import 'package:sport/pages/user/scheme/bug/SPClassMyBuySchemePage.dart';
import 'package:sport/pages/user/setting/SPClassSettingPage.dart';
import 'package:sport/pages/user/systemMsg/SPClassSystemMsgPageState.dart';
import 'SPClassContactPage.dart';
import 'SPClassDiamondHistoryPage.dart';
import 'SPClassFeedbackPage.dart';
import 'SPClassMyFollowExpertPage.dart';
import 'SPClassNewUserWalFarePage.dart';
import 'SPClassRechargeDiamondPage.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassUserPage extends StatefulWidget {
  @override
  SPClassUserPageState createState() => SPClassUserPageState();
}

class SPClassUserPageState extends State<SPClassUserPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var spProMyTitles = ["已购方案", "关注专家","关注方案", "新人福利"];
  var spProMyTitleImages = ["bug","follow_expert", "follow",  "new"];
  var spProOtherTitles = [
    "邀请好友",
    '专家入驻',
    /*"抽奖",*/
    "系统消息",
    "联系客服",
    "关于我们",
    "意见反馈",
    "设置"
  ];
  var spProOtherImages = [
    "invite",
    "expert_apply",
/*"turntable",*/
    "sys",
    "contact",
    "about",
    "feelback",
    "setting"
  ];
  var spProUserSubscription;
  int spProSeqNum = 0;
  AnimationController spProScaleAnimation;
  bool spProIsSignIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SPClassApplicaion.spFunGetUserInfo(isFire: false);
    spProUserSubscription =
        SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if (event == "userInfo") {
        // getSeqNum();
        if (SPClassApplicaion.spProUserLoginInfo.spProExpertVerifyStatus == "1") {
          spProMyTitles.remove("专家入驻");
          spProMyTitles.remove("我的发布");
          spProMyTitleImages.remove("expert_apply");
          spProMyTitles.add("我的发布");
          spProMyTitleImages.add("expert_apply");
        } else {
          spProMyTitles.remove("我的发布");
          spProMyTitles.remove("专家入驻");
          spProMyTitleImages.remove("expert_apply");
          // spProMyTitles.add("专家入驻");
          // spProMyTitleImages.add("expert_apply");
        }
        if (mounted) {
          setState(() {});
        }
      }
    });

    if (!SPClassApplicaion.spProShowMenuList.contains("home")) {
      spProMyTitles.remove("已购方案");
      spProMyTitles.remove("关注方案");
      spProMyTitleImages.remove("bug");
      spProMyTitleImages.remove("follow");
      //spProOtherTitles.remove("邀请好友");
      spProOtherTitles.remove("新人福利");
      //spProOtherImages.remove("invite");
      spProOtherImages.remove("new");
    }

    if (!SPClassApplicaion.spProShowMenuList.contains("expert")) {
      spProMyTitles.remove("关注专家");
      spProMyTitles.remove("专家入驻");
      spProMyTitleImages.remove("follow_expert");
      spProMyTitleImages.remove("expert_apply");
    }

    if (SPClassApplicaion.spProUserLoginInfo.spProExpertVerifyStatus == "1") {
      spProMyTitles.remove("专家入驻");
      spProMyTitleImages.remove("expert_apply");
      spProMyTitles.add("我的发布");
      spProMyTitleImages.add("expert_apply");
    }

    if (Platform.isIOS) {
      spProMyTitles.remove("已购方案");
      spProMyTitleImages.remove("bug");
      spProOtherTitles.remove("好友");
      spProOtherTitles.remove("新人福利");
      spProOtherImages.remove("invite");
      spProOtherImages.remove("new");
      spProOtherTitles.remove("抽奖");
      spProOtherImages.remove("turntable");
    }

    spProScaleAnimation = AnimationController(
        duration: const Duration(milliseconds: 350),
        reverseDuration: const Duration(milliseconds: 350),
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.3);
    spProScaleAnimation.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SPClassEncryptImage.asset(
                SPClassImageUtil.spFunGetImagePath("zhuanjiabg"),
                width: MediaQuery.of(context).size.width,
                height: height(180),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text("个人中心",
                          style:
                              TextStyle(fontSize: sp(19), color: Colors.white)),
                      centerTitle: true,
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: width(15),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white, width: width(2)),
                                borderRadius:
                                    BorderRadius.circular(width(27.5))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(width(25.5)),
                              child:
                                  (!SPClassApplicaion.spFunIsExistUserInfo() ||
                                          SPClassApplicaion.spProUserInfo
                                              .spProAvatarUrl.isEmpty)
                                      ? SPClassEncryptImage.asset(
                                          SPClassImageUtil.spFunGetImagePath(
                                              "ic_default_avater"),
                                          width: width(46),
                                          height: width(46),
                                        )
                                      : Image.network(
                                          SPClassApplicaion
                                              .spProUserInfo.spProAvatarUrl,
                                          fit: BoxFit.cover,
                                          width: width(46),
                                          height: width(46),
                                        ),
                            ),
                          ),
                          SizedBox(
                            width: width(8),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: SPClassApplicaion.spFunIsExistUserInfo()
                                  ? <Widget>[
                                      Text(
                                        SPClassApplicaion
                                            .spProUserInfo.spProNickName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: sp(17)),
                                      ),
                                      Text(
                                        "UID:" +
                                            "${SPClassApplicaion.spProUserLoginInfo.spProUserId.toString()}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: sp(13)),
                                      ),
                                    ]
                                  : <Widget>[
                                      Text(
                                        "登录 / 注册",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "登录后可以获得更多奖励哦",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14),
                                      ),
                                    ],
                            ),
                          ),
                          Visibility(
                            visible: (SPClassApplicaion.spProShowMenuList
                                .contains("pay") ||
                                double.tryParse(SPClassApplicaion
                                    .spProUserInfo.spProDiamond) >
                                    0),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: (){
                                if (spFunIsLogin(context: context)) {
                                  SPClassNavigatorUtils.spFunPushRoute(
                                      context,
                                      SPClassRechargeDiamondPage());
                                }
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text('立即充值', style: GoogleFonts.notoSansSC(textStyle: TextStyle(color:Color(0xFFEB3E1C),fontWeight: FontWeight.w500),fontSize: sp(13))),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: width(15),vertical: width(4)),
                                  ),
                                  Text('${SPClassApplicaion
                                      .spFunIsExistUserInfo()
                                      ? SPClassStringUtils
                                      .spFunSqlitZero(
                                      SPClassApplicaion
                                          .spProUserInfo
                                          .spProDiamond)
                                      : "-"}:钻石',style: TextStyle(fontSize: sp(15),color: Colors.white),)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width(15),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (spFunIsLogin(context: context)) {
                          SPClassNavigatorUtils.spFunPushRoute(
                              context, SPClassUserInfoPage());
                        }
                      },
                    ),
                    SizedBox(
                      height: width(20),
                    ),
                    spProMyTitles.length > 0
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(2, 5),
                                    color: Color(0x0D000000),
                                    blurRadius: width(
                                      6,
                                    ),
                                  ),
                                  BoxShadow(
                                    offset: Offset(-5, 1),
                                    color: Color(0x0D000000),
                                    blurRadius: width(
                                      6,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(width(7))),
                            margin: EdgeInsets.only(
                                bottom: width(8),
                                left: width(10),
                                right: width(10),
                                top: width(10)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: width(15), right: width(13),top: width(19)),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "常用功能",
                                        style: GoogleFonts.notoSansSC(
                                            fontWeight: FontWeight.bold,
                                            fontSize: sp(15)),
                                      ),
                                    ],
                                  ),
                                ),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  padding: EdgeInsets.zero,
                                  childAspectRatio: width(85) / width(97),
                                  children: spProMyTitles.map((item) {
                                    var index = spProMyTitles.indexOf(item);
                                    return GestureDetector(
                                      child: spProMyTitleImages.length>index?Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SPClassEncryptImage.asset(
                                              SPClassImageUtil.spFunGetImagePath(
                                                  "ic_user_" +
                                                      "${spProMyTitleImages[index]}"),
                                              width: width(36)),
                                          Text(
                                            item,
                                            style: TextStyle(
                                                color: Color(0xFF333333),
                                                fontSize: sp(13)),
                                          )
                                        ],
                                      ):SizedBox(),
                                      onTap: () => spFunOnTap(item),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    Container(
                      margin: EdgeInsets.only(top: width(10)),
                      child: Column(
                        children: spProOtherTitles.map((item) {
                          var index = spProOtherTitles.indexOf(item);
                          return GestureDetector(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                spProOtherImages.length>index?
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          SPClassEncryptImage.asset(
                                              SPClassImageUtil.spFunGetImagePath(
                                                  "ic_user_" +
                                                      "${spProOtherImages[index]}"),
                                              width: width(23)),
                                          SizedBox(
                                            width: width(4),
                                          ),
                                          Stack(
                                            overflow: Overflow.visible,
                                            children: <Widget>[
                                              Text(
                                                item,
                                                style: TextStyle(
                                                    color: Color(0xFF333333),
                                                    fontSize: sp(13)),
                                              ),
                                              item == "系统消息"
                                                  ? Positioned(
                                                right:-width(12),
                                                top:0,
                                                child: (spFunIsLogin() &&
                                                    double.tryParse(SPClassApplicaion
                                                        .spProUserLoginInfo
                                                        .spProUnreadMsgNum) >
                                                        0)
                                                    ? Container(
                                                  width: width(12),
                                                  height: width(12),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle),
                                                  child: Text('${int.tryParse(SPClassApplicaion
                                                      .spProUserLoginInfo
                                                      .spProUnreadMsgNum)}',style: TextStyle(color: Colors.white,fontSize: sp(8)),),
                                                )
                                                    : SizedBox(),
                                              )
                                                  : SizedBox()
                                            ],
                                          ),
                                          Expanded(
                                            child: SizedBox(),
                                          ),
                                          SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                                            width: width(11),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: width(15),vertical: width(12)),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2),width: 0.4),),
                                      ),
                                    )
                                // Column(
                                //   crossAxisAlignment:
                                //   CrossAxisAlignment.center,
                                //   mainAxisAlignment:
                                //   MainAxisAlignment.center,
                                //   children: <Widget>[
                                //     SPClassEncryptImage.asset(
                                //         SPClassImageUtil.spFunGetImagePath(
                                //             "ic_user_" +
                                //                 "${spProOtherImages[index]}"),
                                //         width: width(47)),
                                //     Text(
                                //       item,
                                //       style: TextStyle(
                                //           color: Color(0xFF333333),
                                //           fontSize: sp(12)),
                                //     )
                                //   ],
                                // )

                                    :SizedBox(),
                               
                                // item == "系统消息"
                                //     ? Positioned(
                                //   top: width(20),
                                //   right: width(20),
                                //   child: (spFunIsLogin() &&
                                //       double.tryParse(SPClassApplicaion
                                //           .spProUserLoginInfo
                                //           .spProUnreadMsgNum) >
                                //           0)
                                //       ? Container(
                                //     height: width(8),
                                //     width: width(8),
                                //     decoration: BoxDecoration(
                                //         color: Colors.red,
                                //         shape: BoxShape.circle),
                                //   )
                                //       : SizedBox(),
                                // )
                                //     : SizedBox()
                              ],
                            ),
                            onTap: () => spFunOnTap(item),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void spFunOnTap(String value) {
    if (!spFunIsLogin(context: context)) {
      return;
    }

    if (value == "已购方案") {
      // SPClassNavigatorUtils.spFunPushRoute(context, AnimationImagePage());
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassMyBuySchemePage());
    }

    if (value == "关注方案") {
      SPClassNavigatorUtils.spFunPushRoute(
          context, SPClassMyFollowSchemePage());
    }

    if (value == "关注专家") {
      SPClassNavigatorUtils.spFunPushRoute(
          context, SPClassMyFollowExpertPage());
    }

    if (value == "专家入驻") {
      if (SPClassApplicaion.spProUserLoginInfo.spProExpertVerifyStatus == "0") {
        SPClassToastUtils.spFunShowToast(msg: "您的申请正在审核中，请留意系统消息");
        return;
      }
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassExpertApplyPage());
    }

    if (value == "邀请好友") {
      if (spFunIsLogin(context: context)) {
        SPClassApiManager.spFunGetInstance().spFunShare(
            context: context,
            spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result) {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SPClassShareView(
                      title: result.title,
                      spProDesContent: result.content,
                      spProPageUrl: result.spProPageUrl ??
                          SPClassNetConfig.spFunGetShareUrl(),
                      spProIconUrl: result.spProIconUrl,
                    );
                  });
            }));
      }
    }

    if (value == "新人福利") {
      SPClassNavigatorUtils.spFunPushRoute(
          context, SPClassNewUserWalFarePage());
    }

    if (value == "抽奖") {
      showCupertinoModalPopup(
          context: context, builder: (c) => SPClassDialogTurntable(() {}));
      //  NavigatorUtils.pushRoute(context, PrizeDrawPage());
    }

    if (value == "系统消息") {
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassSystemMsgPage());
    }

    if (value == "优惠券") {
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassCouponPage());
    }

    if (value == "联系客服") {
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassContactPage());
    }

    if (value == "关于我们") {
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassAboutUsPage());
    }

    if (value == "意见反馈") {
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassFeedbackPage());
    }
    if (value == "设置") {
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassSettingPage());
    }
    if (value == "我的发布") {
      SPClassNavigatorUtils.spFunPushRoute(context, SPClassMyAddSchemePage());
    }
  }
}
