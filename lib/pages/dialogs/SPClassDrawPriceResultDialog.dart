import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/model/SPClassCoupon.dart';
import 'package:sport/model/SPClassPrizeDrawInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassDrawPriceResultDialog extends StatefulWidget{
  SPClassPrizeDrawInfo spProPrizeDrawInfo;
  VoidCallback callback;

  SPClassDrawPriceResultDialog({this.spProPrizeDrawInfo,this.callback});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassDrawPriceResultDialogState();
  }

}

class SPClassDrawPriceResultDialogState extends State<SPClassDrawPriceResultDialog>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child:Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
               Stack(
                 alignment: Alignment.center,
                 children: <Widget>[
                   SPClassEncryptImage.asset(
                       SPClassImageUtil.spFunGetImagePath("bg_draw_price_result",format: ".png"),
                       width: width(268),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: width(80)),
                        Container(
                          padding: EdgeInsets.all(width(8)),
                          width: width(62),
                          height: width(62),
                          child: SPClassImageUtil.spFunNetWordImage(
                              url: widget.spProPrizeDrawInfo.spProIconUrl,
                              fit: BoxFit.contain),
                        ),
                        Text(
                            widget.spProPrizeDrawInfo.spProProductName,
                            style: TextStyle(fontSize: sp(15),color: Color(0xFF333333))),
                        SizedBox(height: width(5)),
                        Text(widget.spProPrizeDrawInfo.spProProductName.contains("钻石")?
                        "钻石已放入你的账户":
                        "快去添加客服微信领取奖励吧",
                            style: TextStyle(fontSize: sp(10),color: Color(0xFF999999))),
                        SizedBox(height: width(10)),

                        GestureDetector(
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              SPClassEncryptImage.asset(
                                SPClassImageUtil.spFunGetImagePath("ic_btn_reciver_price_draw"),
                                width: width(117),
                              ),
                              Text("再抽一次",style: TextStyle(color: Color(0xFFF57900),fontSize: sp(14)),)
                            ],
                          ),
                          onTap: (){
                            if(widget.callback!=null){
                              widget.callback();
                            }
                            Navigator.of(context).pop();
                          },
                        )

  //
                      ],
                    )

               ],),
               GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top: width(15)),
                width: width(23),
                height: width(23),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                    border:Border.all(color: Colors.white,width: 1)
                ),
                child: Icon(Icons.close,color: Colors.white,size: width(15),),
              ),
              onTap: (){
                Navigator.of(context).pop();

              },
            )
          ],
        ),
      ),
      onWillPop:() async{
        return true;
      },
    );
  }

}