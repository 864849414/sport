import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';

import 'SPClassMatchLiveStatisPage.dart';
import 'SPClassMatchLiveTeamPage.dart';

class SPClassMatchLivePage extends  StatefulWidget{
  SPClassGuessMatchInfo spProGuessInfo;
  ValueChanged<SPClassGuessMatchInfo> callback;
  SPClassMatchLivePage(this.spProGuessInfo,{this.callback});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMatchLivePageState();
  }

}

class SPClassMatchLivePageState extends State<SPClassMatchLivePage> with TickerProviderStateMixin<SPClassMatchLivePage> ,AutomaticKeepAliveClientMixin{
  var index=0;
  PageController spProPageController;
  List<Widget> views ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    views=[SPClassMatchLiveTeamPage(widget.spProGuessInfo)];
    spProPageController=PageController();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Container(
      color: Color(0xFFF1F1F1),
      width: ScreenUtil.screenWidth,
      child: Column(
        children: <Widget>[
          SizedBox(height: height(12),),
/*
          Application.isShowIosUI()? : Container(
            margin: EdgeInsets.only(top: height(12),bottom: height(8)),
            width: width(213),
            height: width(33),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft:Radius.circular(width(5)),topLeft: Radius.circular(width(5))),
                          border: Border.all(color: Color(0xFFDE3C31),width: 0.4),
                          color: index==0? Color(0xFFDE3C31):Colors.white
                      ),
                      alignment: Alignment.center,
                      child: Text("直播",style: TextStyle(fontSize: sp(14),color: index==0? Colors.white :Color(0xFFDE3C31)),),
                    ),
                    onPressed: (){
                      setState(() {
                        index=0;
                      });
                      spProPageController.jumpToPage(0 );
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight:Radius.circular(width(5)),topRight: Radius.circular(width(5))),
                          border: Border.all(color: Color(0xFFDE3C31),width: 0.4),
                          color: index==1? Color(0xFFDE3C31):Colors.white
                      ),
                      alignment: Alignment.center,
                      child: Text("阵容",style: TextStyle(fontSize: sp(14),color: index==1? Colors.white :Color(0xFFDE3C31)),),
                    ),
                    onPressed: (){
                      setState(() {
                        index=1;
                      });
                      spProPageController.jumpToPage(1);
                    },
                  ),
                ),
              ],
            ),
          ),
*/
          Expanded(
            child:PageView(
              controller: spProPageController,
              physics: NeverScrollableScrollPhysics(),
              children:views,
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



}

