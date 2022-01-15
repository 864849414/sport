import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/utils/colors.dart';
import 'package:sport/widgets/SPClassToolBar.dart';

import 'SPClassMyFollowExpertPage.dart';

class FollowExpertPage extends StatefulWidget {
  const FollowExpertPage({Key key}) : super(key: key);

  @override
  _FollowExpertPageState createState() => _FollowExpertPageState();
}

class _FollowExpertPageState extends State<FollowExpertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title:"我的关注",
        spProBgColor: MyColors.main1,
        iconColor: 0xFFFFFFFF,
      ),
      body: SPClassMyFollowExpertPage(),
    );
  }
}
