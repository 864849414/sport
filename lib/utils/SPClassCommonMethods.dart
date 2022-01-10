import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';

num width(num width){
  return ScreenUtil().setWidth(width);
}
num height(num width){
  return ScreenUtil().setHeight(width);
}
num sp(num sp){
  return ScreenUtil().setSp(sp);
}

// ignore: non_constant_identifier_names
SPClassApiManager get Api=>SPClassApiManager.spFunGetInstance();

String get AppId => (Platform.isAndroid ? SPClassApplicaion.spProAndroidAppId:SPClassApplicaion.spProIOSAppId);

String get ChannelId => (Platform.isAndroid ? SPClassApplicaion.spProChannelId:"10");