import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/pages/user/SPClassContactPage.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassDialogOpenRedPakege extends StatefulWidget{
  String price;

  SPClassDialogOpenRedPakege(this.price);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassDialogOpenRedPakegeState();
  }

}

class SPClassDialogOpenRedPakegeState extends State<SPClassDialogOpenRedPakege> with TickerProviderStateMixin{
  bool spProShowOpen=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[


            spProShowOpen ? Stack(
              children: <Widget>[
                GestureDetector(
                  child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_open_red_moeny"),width: width(290),),
                  onTap: (){
                    setState(() {
                      spProShowOpen=!spProShowOpen;
                    });
                  },
                ),
                Positioned(
                  top:  width(30),
                  left: 0,
                  right: 0,
                  child: Text("恭喜你！成功抽中现金红包！"+
                          "\n"+
                           "请添加客服领取！",textAlign: TextAlign.center,style: TextStyle(color: Color(0xFFF9EBAD),fontSize: sp(18)),),
                )
              ],
            ):Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("bg_red_moeny"),width: width(350),),
                Positioned(
                  top: width(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: widget.price,
                          style: TextStyle(fontSize: sp(50), color: Color(0xFFE3494B),fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(text: "  元", style: TextStyle(fontSize: sp(25), color: Color(0xFFE3494B),fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),

                ),
                Positioned(
                  top: width(223),
                  child: Column(
                    children: <Widget>[
                      SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_red_wenzi"),width: width(208),),
                      SizedBox(height: width(50),),
                      GestureDetector(
                        child:  Container(
                          width: width(160),
                          height: width(45),
                          decoration:BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(300)
                          ),
                          alignment: Alignment.center,
                          child: Text("联系客服",style: TextStyle(fontWeight: FontWeight.bold,fontSize: sp(16),color: Colors.white),),
                        ),
                        onTap: (){
                          Navigator.of(context).pop();
                          SPClassNavigatorUtils.spFunPushRoute(context, SPClassContactPage());
                        },
                      )
                    ],
                  ),

                ),
              ],
            )



          ],
        ),
      ),
    );
  }


}