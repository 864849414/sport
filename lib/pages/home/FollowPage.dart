import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/pages/user/SPClassMyFollowExpertPage.dart';
import 'package:sport/pages/user/scheme/follow/SPClassFollowSchemeListPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/colors.dart';

class FollowPage extends StatefulWidget {
  _FollowPageState spProState;
  FollowPage({Key key}) : super(key: key);

  // @override
  // _FollowPageState createState() => _FollowPageState();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState = _FollowPageState();
  }
}

@override
// TODO: implement wantKeepAlive
bool get wantKeepAlive => true;

class _FollowPageState extends State<FollowPage> with  TickerProviderStateMixin<FollowPage>{
  TabController _controller;
  List topTitle = ['关注专家','关注方案'];

  @override
  void initState() {
    _controller = TabController(
        length: topTitle.length,
        vsync: this,
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: width(width(6)),
            color: Color(0xFFF2F2F2),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.4, color: Colors.grey[300]))),
            child: TabBar(
              labelColor: MyColors.main1,
              labelPadding: EdgeInsets.zero,
              unselectedLabelColor: Color(0xFF666666),
              indicatorColor: MyColors.main1,
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.symmetric(horizontal: width(100)),
              labelStyle: GoogleFonts.notoSansSC(
                  fontSize: sp(15),
                  fontWeight: FontWeight.bold),
              unselectedLabelStyle:
              TextStyle(fontSize: sp(15)),
              controller: _controller,
              tabs: topTitle.map((tab) {
                return Tab(
                  text: tab,
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                SPClassMyFollowExpertPage(),
                SPClassFollowSchemeListPage('0'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
