import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/utils/SPClassImageUtil.dart';

import 'package:sport/SPClassEncryptImage.dart';

class SPClassLoadingPage extends StatefulWidget{


  SPClassLoadingPageState createState()=>SPClassLoadingPageState();
}

class SPClassLoadingPageState extends State<SPClassLoadingPage> with SingleTickerProviderStateMixin
{
  AnimationController spProController;
  Timer spProTimer;
  int spProCurrentTime=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProController= AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    spProController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        //重置起点
        spProController.reset();
        //开启
        await Future.delayed(Duration(milliseconds: 100));
        spProController.forward();
      }
    });
    spProController.forward();
    spProTimer=Timer.periodic(Duration(seconds: 1), (value){
      spProCurrentTime++;
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    spProController.stop();
    spProTimer.cancel();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
      ),
      child: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RotationTransition(
                turns: spProController,
                alignment: Alignment.center,
                child:SPClassEncryptImage.asset(
                  SPClassImageUtil.spFunGetImagePath('ic_common_loading'),
                  fit: BoxFit.contain,
                  width: 60,
                  height: 60,
                ) ,
              )
              ,
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("正在加载",style: TextStyle(fontSize: 14,color: Color(0xFF666666)),),
                  Text((spProCurrentTime%3==0 ?".  ":(spProCurrentTime%3==1? ".. ":"...")),style: TextStyle(fontSize: 14,color: Color(0xFF666666)),),

                ],
              )
            ],
          ),
      ) ,
    );
  }


}