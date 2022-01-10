import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/pages/common/SPClassDialogUtils.dart';
import 'package:sport/pages/game/SPCLassGameList.dart';
import 'package:sport/pages/game/SPClassGameCarousel.dart';
import 'package:sport/pages/game/SPClassGameGift.dart';
import 'package:sport/pages/game/SPClassGameHeader.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/widgets/SPClassNestedScrollViewRefreshBallStyle.dart';
import '../../SPClassEncryptImage.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
class SPClassGamePage extends StatefulWidget {
  const SPClassGamePage({Key key}) : super(key: key);

  @override
  _SPClassGamePageState createState() => _SPClassGamePageState();
}

class _SPClassGamePageState extends State<SPClassGamePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder:(BuildContext context,bool innerBoxIsScrolled){
            return <Widget>[
              SliverToBoxAdapter(
                child: SPClassGameHeader(),
              ),
              SliverToBoxAdapter(
                child: SPClassGameCarousel(),
              ),
              SliverToBoxAdapter(
                child: SPClassGameGift(),
              ),
            ];
      },
        pinnedHeaderSliverHeightBuilder: () {
          return statusBarHeight;
        },
        body:Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(style: BorderStyle.none),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset:Offset.fromDirection(3,-2)
                )
              ]
          ),
          //里面有一个 EasyRefresh.custom上拉加载的ListView
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(style: BorderStyle.none),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset:Offset.fromDirection(3,-2)
                      )
                    ]
                ),
                //里面有一个 EasyRefresh.custom上拉加载的ListView
                child: Padding(
                  padding:  EdgeInsets.only(left: width(10),bottom: width(5),top: width(5)),
                  child: Text('每日推荐',
                    style: TextStyle(fontSize: ScreenUtil().setSp(17),fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: width(30)),
                  child: SPClassGameList())
            ],
          ),
        )

//        Container(
//          padding: EdgeInsets.only(bottom: width(10)),
//          margin: EdgeInsets.only(top: width(10)),
//          alignment: Alignment.topLeft,
//          decoration: BoxDecoration(
//              color: Colors.white,
//              border: Border.all(style: BorderStyle.none),
//              borderRadius: BorderRadius.all(Radius.circular(10)),
//              boxShadow: [
//                BoxShadow(
//                    color: Colors.black12,
//                    blurRadius: 3,
//                    offset:Offset.fromDirection(3,-2)
//                )
//              ]
//          ),
//          //里面有一个 EasyRefresh.custom上拉加载的ListView
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Padding(
//                padding:  EdgeInsets.only(left: width(10),bottom: width(5),top: width(5)),
//                child: Text('每日推荐',
//                  style: TextStyle(fontSize: ScreenUtil().setSp(17),fontWeight: FontWeight.bold),
//                ),
//              ),
//            ],
//          ),
//        )


      ),
    );

//      SingleChildScrollView(
//      controller: _controller,
//      child: Column(
//        children: <Widget>[
//          SPClassGameHeader(),
//          SPClassGameCarousel(),
//          SPClassGameList(),
//        ],
//      ),
//    );
  }
}
