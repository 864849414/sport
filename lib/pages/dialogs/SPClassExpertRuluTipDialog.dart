
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';


class SPClassExpertRuluTipDialog extends StatefulWidget{

  SPClassExpertRuluTipDialog();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassExpertRuluTipDialogState();
  }

}

class SPClassExpertRuluTipDialogState extends State<SPClassExpertRuluTipDialog>{
  var spProMsgList=[
    "近期胜率：近2场、3场、5场、7场、10场胜率",
    "近10场回报率：近10场红单的赔率*100%相加之和除以红单+黑单数;让球和总进球的赔率分别+1;",
    "SP  均  值：近10场推荐的SP均值",
    "最近连红：最近战绩连红数",
    "最高连红：全周期历史最高连红数"
  ];
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

                      ListView.builder(
                          padding: EdgeInsets.only(left: width(20),right: width(20)),
                          shrinkWrap: true,
                          itemCount: spProMsgList.length,
                          itemBuilder: (c,index){
                            var item =spProMsgList[index];
                       return Container(
                         margin: EdgeInsets.only(top: height(5)),
                         child: Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Container(
                               margin: EdgeInsets.only(top: width(8)),
                               height: width(5),
                               width: width(5),
                               decoration:ShapeDecoration(
                                 color: Colors.grey,
                                 shape: CircleBorder()
                               ),
                             ),
                             SizedBox(width: width(8),),
                             Expanded(
                               child: Text(item, style: TextStyle(color: Color(0xFF333333),fontSize: sp(12)),),
                             )
                           ],
                         ),
                       );
                      }),
                      SizedBox(height: width(20),),
                      Container(height: 0.4,color: Colors.grey[300],),
                      FlatButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: width(47),
                          alignment: Alignment.center,
                          child: Text("知道了",style: TextStyle(color: Color(0xFFDE3C31),fontSize: sp(14)),),
                        ),
                        onPressed: (){
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