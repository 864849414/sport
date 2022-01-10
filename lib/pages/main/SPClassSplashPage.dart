


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/SPClassEncryptImage.dart';


class SPClassSplashPage extends StatefulWidget{
  VoidCallback callback;

  SPClassSplashPage(this.callback);
  SPClassSplashPageState createState()=>SPClassSplashPageState();
}

class SPClassSplashPageState extends State<SPClassSplashPage>
{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil.init(context, width: 360, height: 640);
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
           Expanded(
             child:  Container(
                 alignment: Alignment.center,
                 child:SPClassApplicaion.spFunIsShowIosUI() ?
                 SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_splash_pg"),
                   fit: BoxFit.cover,
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height,
                 ):CachedNetworkImage(
                   fit: BoxFit.cover,
                   width: MediaQuery.of(context).size.width,
                   imageUrl: "${SPClassNetConfig.spFunGetImageUrl()}img/startup.png?time=${DateTime.now().millisecondsSinceEpoch.toString()}",
                   imageBuilder: (context, imageProvider) => Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(
                         image: imageProvider,
                         fit: BoxFit.cover,
                       ),
                     ),
                   ),
                   errorWidget: (context, url, error) =>
                       SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_splash"),
                         fit: BoxFit.cover,
                         width: MediaQuery.of(context).size.width,
                       ),
                 )
             ),
           ),
           Container(
            height: width(80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_app_logo"),
                      width: width(40),
                    ),
                    SizedBox(width: width(3),),
                    Text("${SPClassApplicaion.spProAppName}",style: GoogleFonts.notoSansSC(fontSize: sp(18),fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(height: height(5),),
                Text("Copyright © 2018-2020 "+
                    "${SPClassApplicaion.spProAppName} "+
                        "All Rights Reserved",style: GoogleFonts.notoSansSC(fontSize: sp(9),textStyle: TextStyle(color: Color(0xFF999999))),)

              ],
            ),
          )
        ],
      ),
    );
  }


}
