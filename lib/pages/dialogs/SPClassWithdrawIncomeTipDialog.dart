import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';


class SPClassWithdrawIncomeTipDialog extends StatefulWidget{

  SPClassWithdrawIncomeTipDialog();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassWithdrawIncomeTipDialogState();
  }

}

class SPClassWithdrawIncomeTipDialogState extends State<SPClassWithdrawIncomeTipDialog>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child:GestureDetector(
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: width(288),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(width(5))
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: width(20),),
                      SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_success_scheme"),width:width(54) ,),
                      SizedBox(height:width(29),width: ScreenUtil.screenWidth,),

                      Text("提现申请已提交",style: TextStyle(fontSize: sp(16),color: Color(0xFF333333)),textAlign: TextAlign.center,),
                      SizedBox(height: width(10),),
                      Text("最快24小时内可到账，如遇节假日顺延",style: TextStyle(fontSize: sp(11),color: Color(0xFF999999)),textAlign: TextAlign.center,),
                      SizedBox(height: width(20),),
                      Container(height: 0.4,color: Colors.grey[300],),
                      GestureDetector(
                        child: Container(
                          height: width(47),
                          alignment: Alignment.center,
                          child: Text("知道了",style: TextStyle(color: Color(0xFFDE3C31),fontSize: sp(14)),),
                        ),
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
                onTap: (){

                },
              )
            ],
          ),
        ),
        onTap: (){
           Navigator.of(context).pop();
        },
      ),
      onWillPop:() async{
        return true;
      },
    );
  }

}