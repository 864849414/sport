
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/contants/SPClassSharedPreferencesKeys.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';


class SPClassAddSchemeRuleTipDialog extends StatefulWidget{
  VoidCallback callback;
  SPClassAddSchemeRuleTipDialog({this.callback});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassAddSchemeRuleTipDialogState();
  }

}

class SPClassAddSchemeRuleTipDialogState extends State<SPClassAddSchemeRuleTipDialog>{
  var spProMsgList=[
    "1、专家方案收益将根据用户发布方案的价格，按一定的比例获得收益",
    "2、方案收益将按每周一进行一次结算统计",
    "3、所有推荐的方案，亚指不得低于0.7；竞彩单选指数不得低于1.4，竞彩双选每个选项赔率需在2.20及以上，且两个选项相加赔率需在5.30及以上",
    "4、发布的内容不能出现黄赌毒、不得留下任何误导用户的联系方式（包括但不限于微信、微博、QQ等），如有违反，立即封号处理",
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
                      
                      Text("规则",style: TextStyle(fontWeight: FontWeight.bold,fontSize: sp(16)),),
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
                          SharedPreferences.getInstance().then((sp) => sp.setBool(SPClassSharedPreferencesKeys.KEY_DIAOLG_ADD_SCHEME_RULE, true));
                          Navigator.of(context).pop();
                          widget.callback();
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

        },
      ),
      onWillPop:() async{
        return true;
      },
    );
  }

}