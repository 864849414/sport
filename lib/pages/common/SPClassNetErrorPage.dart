
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

// ignore: must_be_immutable
class SPClassNetErrorPage extends StatefulWidget
{
  VoidCallback onTap;

  SPClassNetErrorPageState createState()=> SPClassNetErrorPageState();

  SPClassNetErrorPage(this.onTap);
}

class SPClassNetErrorPageState extends State<SPClassNetErrorPage>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child:GestureDetector(
          behavior: HitTestBehavior.opaque,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SPClassEncryptImage.asset(
                SPClassImageUtil.spFunGetImagePath('ic_common_net_error'),
                fit: BoxFit.contain,
                width: 100,
                height: 100,
              ),
              SizedBox(height: 5,),
              Text("网络出问题啦",style: TextStyle(fontSize: 16,color: Color(0xFF666666)),),
              SizedBox(height: 10,),
              OutlineButton(
                color: Theme.of(context).primaryColor,
                disabledBorderColor:Theme.of(context).primaryColor ,
                child: Text("立即刷新",style: TextStyle(fontSize: 15,color:Theme.of(context).primaryColor,decoration: TextDecoration.none),),
              )
            ],
          ),
          onTap: (){
            widget.onTap();
          },
        ),
      ) ,
    );
  }

}
