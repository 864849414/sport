
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';


class SPClassRankingRuluDialog extends StatefulWidget{

  SPClassRankingRuluDialog();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassRankingRuluDialogState();
  }

}

class SPClassRankingRuluDialogState extends State<SPClassRankingRuluDialog>{
  var spProMsgList=[
    "全平台用户可免费参与；",
    "活动时间以自然周为单位；",
    "活动期间用户通过登录+5积分、玩转盘+5积分每日上限为10次，玩全民预测若猜中+5积分，连胜+10积分，若猜错，则无积分，走盘也无积分，每日上限为5次；",
    "每周榜单只奖励前20名用户，用户需要累计达到100积分才获得上榜资格，上榜的用户将瓜分每周388元现金大奖，其中榜单1-3名用户200元，4-10名用户瓜分100元，10-20名瓜分88元，榜单将会在下周周一公布上周排名，并发放奖金，获奖的的用户在24小时内添加客服微信：领取红包；",
    "禁止利用竞猜活动进行赌博活动等违法违规行为；若在活动前后发现违法违规行为，不仅限于冒用欺诈、赌博、传播色情、冒用他人身份等用户，红胜体育有权取消活动参与资格及领奖资格。",

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