import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';

class SPClassToolBar extends AppBar{
  SPClassToolBar(
      BuildContext context,
      {String title,
       Color spProBgColor:Colors.white,
       int iconColor:0xFF333333,
        List<Widget> actions,
        bool showLead:true
      }
      ):super(
          leading:!showLead? null: FlatButton(
            child: Icon(Icons.arrow_back_ios,size: width(20),color: Color(iconColor),),
            onPressed: (){Navigator.of(context).pop();},),
          elevation:1,
          centerTitle:true,
          backgroundColor:spProBgColor,
          brightness:Brightness.light,
          title:title!=null ?Text(title,style:TextStyle(color: Color(iconColor),fontSize: sp(18)),):null,actions:actions,

  );
}