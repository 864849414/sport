import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/colors.dart';

import '../SPClassEncryptImage.dart';

class SPClassToolBar extends AppBar{
  SPClassToolBar(
      BuildContext context,
      {String title,
       Color spProBgColor:MyColors.main1,
       int iconColor:0xFFFFFFFF,
        List<Widget> actions,
        bool showLead:true
      }
      ):super(
          leading:!showLead? null: FlatButton(
            child: SPClassEncryptImage.asset(
              SPClassImageUtil.spFunGetImagePath("arrow_right"),
              width: width(23),
              color: Color(iconColor),
            ),
            onPressed: (){Navigator.of(context).pop();},),
          elevation:1,
          centerTitle:true,
          backgroundColor:spProBgColor,
          brightness:Brightness.light,
          title:title!=null ?Text(title,style:TextStyle(color: Color(iconColor),fontSize: sp(18)),):null,actions:actions,

  );
}