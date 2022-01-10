import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';

class SPClassAnimationPoint extends StatefulWidget{
  bool spProIsWhite;

  SPClassAnimationPoint({this.spProIsWhite:true});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassAnimationPointState();
  }

}


class SPClassAnimationPointState extends State<SPClassAnimationPoint>{
  var timer;

  var spProShowUrl="ic_white_point";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!widget.spProIsWhite){
      spProShowUrl=getUrl();
    }
    timer=  Timer.periodic(Duration(milliseconds: 500), (timer){
      setState(() {
        spProShowUrl=getUrl();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: width(16),
      width: width(16),
      child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath(spProShowUrl)),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  String getUrl() {
     if(spProShowUrl=="ic_white_point"){
       return "ic_yellow_point";
     }
     return "ic_white_point";

  }

}