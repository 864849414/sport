
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';


class SPClassPriceDrawRuluDialog extends StatefulWidget{

  SPClassPriceDrawRuluDialog();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassPriceDrawRuluDialogState();
  }

}

class SPClassPriceDrawRuluDialogState extends State<SPClassPriceDrawRuluDialog>{
  var spProMsgList=[
    "用户每次抽奖扣除1张抽奖券，每天限参与游戏10次；",
    "每周会有一定数量的手机、京东卡和话费卡送出，先到先得中奖用户请留意查看中奖记录领取奖品！手机、京东卡、话费等奖励将在3个工作日内发放奖励。；",
    "用户如果违反诚实信用原则或出现违规行为（如作弊、恶意套取等），一经发现我公司有权终止该客户参加本次活动并取消其获奖资格；",

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
              Container(
                width: width(288),
                padding: EdgeInsets.only(left: width(20),right: width(20)),

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width(5))
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: width(20),),
                    SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_title_rule_price_draw"),width: width(150),),
                    SizedBox(height: width(10),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("活动时间：",style: TextStyle(fontSize: sp(14),fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: width(10),),
                    Text("本活动为长期活动，具体在线时间以页面呈现为准"),
                    SizedBox(height: width(20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("抽奖细则：",style: TextStyle(fontSize: sp(14),fontWeight: FontWeight.bold),),
                      ],
                    ),
                    ListView.builder(
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
                                  margin: EdgeInsets.only(top: width(2)),
                                  height: width(15),
                                  width: width(15),
                                  decoration:ShapeDecoration(
                                      color: Color(0xFFDE3C31),
                                      shape: CircleBorder()
                                  ),
                                  child: Text((index+1).toString(),style: TextStyle(color: Colors.white,fontSize: sp(9)),),
                                  alignment: Alignment.center,
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

                  ],
                ),
              ),

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
              ),
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