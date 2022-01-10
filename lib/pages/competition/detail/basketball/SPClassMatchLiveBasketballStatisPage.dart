import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/model/SPClassPlayerStatListEntity.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassImageUtil.dart';

class SPClassMatchLiveBasketballStatisPage extends  StatefulWidget{
  SPClassGuessMatchInfo spProGuessInfo;

  SPClassMatchLiveBasketballStatisPage(this.spProGuessInfo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMatchLiveBasketballStatisPageState();
  }

}

class SPClassMatchLiveBasketballStatisPageState extends State<SPClassMatchLiveBasketballStatisPage> with TickerProviderStateMixin<SPClassMatchLiveBasketballStatisPage> ,AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(),



        ],
      ),
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}

