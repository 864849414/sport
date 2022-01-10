import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport/model/SPClassForecast.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:math' as math;
import 'package:sport/SPClassEncryptImage.dart';

class SPClassForcecastItemView extends StatelessWidget{
  SPClassForecast forecast;
  SPClassForcecastItemView(this.forecast);

  var spProOneWidth=0.0;
  var spProDrawWidth=0.0;
  var spProTwoWidth=0.0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: width(5),right: width(5),top: width(7)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width(5)),
        boxShadow:[
          BoxShadow(
            offset: Offset(2,5),
            color: Color(0x0D000000),
            blurRadius:width(6,),),
          BoxShadow(
            offset: Offset(-5,1),
            color: Color(0x0D000000),
            blurRadius:width(6,),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: width(12),right: width(12),top: width(13)),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: SPClassImageUtil.spFunNetWordImage(
                      url: forecast.user.spProAvatarUrl,
                      width: width(40),
                      height: width(40)),
                ),
                SizedBox(width: width(10),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(forecast.user.spProNickName,
                      style: TextStyle(fontSize: sp(15),fontWeight: FontWeight.bold),
                    ),
                    Text(SPClassDateUtils.spFunDateFormatByString(forecast.spProAddTime, "MM-dd HH:ss"),
                      style: TextStyle(fontSize: sp(11),color: Color(0xFF999999)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: width(12),right: width(12),top: width(7)),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.4,color: Colors.grey[300]),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: width(10),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(sprintf("[%s]",[forecast.spProGuessMatch.spProLeagueName]),
                          style: TextStyle(color: Color(0xFFDD3B31),
                              fontSize: sp(12)),
                        ),
                        SizedBox(width: width(5),),
                        Flexible(
                          child:  Text(forecast.spProGuessMatch.spProTeamOne,
                            style: TextStyle(
                                fontSize: sp(11)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(" vs ",
                          style: TextStyle(
                              color: Color(0xFF878787),
                              fontSize: sp(11)),
                        ),
                        Flexible(
                          child:  Text(forecast.spProGuessMatch.spProTeamTwo,
                            style: TextStyle(
                                fontSize: sp(11)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: width(10),),
                        Text(SPClassDateUtils.spFunDateFormatByString(forecast.spProGuessMatch.spProStTime, "MM-dd HH:ss"),
                          style: TextStyle(
                              color: Color(0xFF878787),
                              fontSize: sp(11)),
                        ),
                      ],
                    ),
                    SizedBox(height: width(12),),
                    Row(
                      children: <Widget>[
                        SizedBox(width: width(15),),
                        Container(
                          height: width(20),
                          width: spFunGetWidth(1),
                          constraints: BoxConstraints(
                            minWidth:  width(30),
                          ),
                          decoration: BoxDecoration(
                              boxShadow:[
                                BoxShadow(
                                  offset: Offset(2,5),
                                  color: Color(0x4CF13B0B),
                                  blurRadius:width(8,),),

                              ],
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(width(300))),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFF1150B),
                                    Color(0xFFF14B0B),
                                  ]
                              )
                          ),
                          alignment: Alignment.center,
                          child: Text(spFunGetRate(forecast.spProWinPOne),style: TextStyle(color: Colors.white,fontSize: sp(11)),),
                        ),
                        SizedBox(width: width(2),),
                        Container(
                          height: width(20),
                          width: spFunGetWidth(0),
                          constraints: BoxConstraints(
                            minWidth:  width(30),
                          ),
                          decoration: BoxDecoration(
                            boxShadow:[
                              BoxShadow(
                                offset: Offset(2,5),
                                color: Color(0x4CB9B9B9),
                                blurRadius:width(8,),),

                            ],
                            color: Color(0xFFB1B1B1),

                          ),
                          alignment: Alignment.center,
                          child: Text(spFunGetRate(forecast.spProDrawP),style: TextStyle(color: Colors.white,fontSize: sp(11)),),
                        ),
                        SizedBox(width: width(2),),
                        Container(
                          height: width(20),
                          width: spFunGetWidth(2),
                          constraints: BoxConstraints(
                            minWidth:  width(30),
                          ),
                          decoration: BoxDecoration(
                              boxShadow:[
                                BoxShadow(
                                  offset: Offset(2,5),
                                  color: Color(0x4C09D38F),
                                  blurRadius:width(8,),),

                              ],
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(width(300))),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF09D39B),
                                    Color(0xFF09D36B),
                                  ]
                              )
                          ),
                          alignment: Alignment.center,
                          child: Text(spFunGetRate(forecast.spProWinPTwo),style: TextStyle(color: Colors.white,fontSize: sp(11)),),
                        ),
                        SizedBox(width: width(15),),
                      ],
                    ),
                    SizedBox(height: width(15),),
                    Container(height: 0.4,color: Colors.grey[300],),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: width(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("他已预测：",style: TextStyle(fontSize: sp(12),
                          ),),
                          Text(spFunGetSupportText(),style: TextStyle(fontSize: sp(12),color: Color(0xFFF1150B),
                          ),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: width(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("赛事详情",style: TextStyle(fontSize: sp(11),color: Color(0xFFFFAD00)),),
                          Icon(Icons.chevron_right,color: Color(0xFFFFAD00),size: width(20),)

                        ],
                      ),
                    )

                  ],
                ),
              ),
              Positioned(
                top: 0,
                right:  width(13) ,
                child: SPClassEncryptImage.asset(
                  (forecast.spProIsWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_result_red"):
                  (forecast.spProIsWin=="0")? SPClassImageUtil.spFunGetImagePath("ic_result_hei"):
                  (forecast.spProIsWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_result_zou"):"",
                  width: width(30),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: width(12),top: width(10)),
            padding: EdgeInsets.symmetric(horizontal: width(5)),
            decoration: BoxDecoration(
              color: Color(0xFFEAEAEA),
              borderRadius: BorderRadius.circular(width(300))
            ),
            child: Text("#预测",style: TextStyle(color: Color(0xFF565656),fontSize: sp(11),),),
          ),
          SizedBox(height: width(10),),
        ],
      ),
    );
  }

  String spFunGetRate(String value) {
    return (double.tryParse(value)*100).toStringAsFixed(0)+"%";
  }
  
  double spFunGetWidth(int value){
    List<Map> nums=[
      {
        "value":forecast.spProWinPOne,
        "key":"one",
      },
      {
        "value":forecast.spProDrawP,
        "key":"draw",
      },
      {
        "value":forecast.spProWinPTwo,
        "key":"two",
      }
    ];
    nums.sort((left,right)=>double.parse(left["value"]).compareTo(double.parse(right["value"])));
    nums.forEach((itemMap) {
       if(nums.indexOf(itemMap)==nums.length-1){
         if(itemMap["key"]=="one"){
           if(spProOneWidth==0){
              spProOneWidth=width(286)-spProDrawWidth-spProTwoWidth;

           }
         }

         if(itemMap["key"]=="two"){
           if(spProTwoWidth==0){
              spProTwoWidth=width(286)-spProDrawWidth-spProOneWidth;

           }
         }

         if(itemMap["key"]=="draw"){
           if(spProDrawWidth==0){
              spProDrawWidth=width(286)-spProTwoWidth-spProOneWidth;
           }
         }
       }else{
         if(itemMap["key"]=="one"){
           if(spProOneWidth==0){
             var remainWidth=width(286);
             var rate=double.tryParse(itemMap["value"]);
             var calcWidth=remainWidth*rate;
             if(calcWidth>=width(30)){
               spProOneWidth=calcWidth;
             }else{
               spProOneWidth=width(30);
             }
           }
         }

         if(itemMap["key"]=="two"){
           if(spProTwoWidth==0){
             var remainWidth=width(286);
             var rate=double.tryParse(itemMap["value"]);
             var calcWidth=remainWidth*rate;
             if(calcWidth>=width(30)){
               spProTwoWidth=calcWidth;
             }else{
               spProTwoWidth=width(30);
             }
           }
         }

         if(itemMap["key"]=="draw"){
           if(spProDrawWidth==0){
             var remainWidth=width(286);
             var rate=double.tryParse(itemMap["value"]);
             var calcWidth=remainWidth*rate;
             if(calcWidth>=width(30)){
               spProDrawWidth=calcWidth;
             }else{
               spProDrawWidth=width(30);
             }
           }
         }
       }
    });




    if(value==1){
      return spProOneWidth;
    }

    if(value==0){
      return spProDrawWidth;
    }

    if(value==2){
      return spProTwoWidth;
    }

    return 0.0;
  }

  String spFunGetSupportText() {

    if(forecast.spProSupportWhich=="1"){
      return "主胜";
    }
    if(forecast.spProSupportWhich=="0"){
      return "平局";
    }
    if(forecast.spProSupportWhich=="2"){
      return "主客";
    }
    return "";

  }


}