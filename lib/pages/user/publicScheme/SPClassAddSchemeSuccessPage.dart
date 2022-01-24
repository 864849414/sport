import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/colors.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassAddSchemeSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: SPClassToolBar(
        context,
        title: "方案已经提交",
      ),
      body:Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Column(
          children: <Widget>[
                SizedBox(height:width(112),width: ScreenUtil.screenWidth,),
                SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_success_scheme"),width:width(54) ,),
                 SizedBox(height:width(29),width: ScreenUtil.screenWidth,),

                Text("您的方案提交成功，我们将在24小时内进行审核"+
                    " \n"+
                    "并通知您审核结果，敬请留意",style: TextStyle(fontSize: sp(14),color: Color(0xFF333333)),textAlign: TextAlign.center,),
                SizedBox(height:width(90),width: ScreenUtil.screenWidth,),

                 GestureDetector(
                   child:  Container(
                  height: width(46),
                  alignment: Alignment.center,
                   child:Container(
                  alignment: Alignment.center,
                  height: width(46),
                  width: width(250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    color: Colors.white
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Text("我知道了",style: TextStyle(fontSize: sp(15),color: MyColors.main1),)
                    ],
                  ),
                ) ,
              ),
              onTap: () async {
                  Navigator.of(context).pop();
              },
            )

          ],
        ),
      ) ,

    );
  }

}