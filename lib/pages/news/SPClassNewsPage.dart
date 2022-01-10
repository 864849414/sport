import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/contants/SPClassSharedPreferencesKeys.dart';
import 'package:sport/pages/news/info/SPClassInfoTabView.dart';


class SPClassNewsPage extends StatefulWidget {
  SPClassNewsPageState createState() => SPClassNewsPageState();
}

class SPClassNewsPageState extends State<SPClassNewsPage>  with AutomaticKeepAliveClientMixin{
  int spProIndex = 0;
  SPClassInfoTabView spProInfoTabView;
  SPClassInfoTabView spProVideoTabView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  buildWidgets();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);

    return Scaffold(
        body: SPClassInfoTabView("info",0));
  }

  spFunBuildWidgets() {
    if (spProInfoTabView == null) {
      spProInfoTabView = SPClassInfoTabView("info",0);
    }
    if (spProVideoTabView == null) {
      spProVideoTabView = SPClassInfoTabView("video",1);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
