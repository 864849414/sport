import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/model/SPClassLeagueFilter.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/competition/filter/SPClassFilterHomePage.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassFilterleagueMatchPage extends StatefulWidget{

  String spProIsLottery;
  bool spProIsHot;
  CallBack callback;
  String spProChooseLeagueName;
  Map<String,dynamic> param;

  SPClassFilterleagueMatchPage(this.spProIsLottery,this.spProChooseLeagueName,{this.param,this.callback,this.spProIsHot});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassFilterleagueMatchPageState();
  }

}

class SPClassFilterleagueMatchPageState extends State<SPClassFilterleagueMatchPage>{
  List<List<SPClassLeagueName>> spProListValue=List();
  List<String> spProLeagueName=List();
  List<String> spProListKeys=List();
  List<String> spProHistoryList;
  EasyRefreshController controller;

  bool spProSelectAll=false;
  bool spProSelectAllNot=false;
  int spProMatchCount=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=EasyRefreshController();
    if(widget.spProChooseLeagueName!=null&&widget.spProChooseLeagueName.isNotEmpty){
       spProHistoryList=widget.spProChooseLeagueName.split(";");
    }else{
      if(!widget.spProIsHot){
        spProSelectAll=true;
      }
    }
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      body: Container(
        color: Color(0xFFF1F1F1),
        child: EasyRefresh.custom(
          controller: controller,
          onRefresh: spFunOnRefresh,
          firstRefresh: true,
          header: SPClassBallHeader(
              textColor: Color(0xFF666666)
          ),
          emptyWidget: spProListValue.length==0? SPClassNoDataView():null,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  var key=spProListValue[index];
                  return Container(
                    padding: EdgeInsets.only(left: width(15),right: width(15) ),
                    child:Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: height(15),bottom: height(5)),
                          alignment: Alignment.centerLeft,
                          child: Text(key[0].spProPinyinInitial,style: TextStyle(fontSize: sp(13),color: Color(0xFF333333)),),
                        ),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          crossAxisSpacing: width(11),
                          mainAxisSpacing: height(9),
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: width(103)/width(27),
                          children:key.map((item){
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(width: 0.4,color:item.check?  Color(0xFFDE3C31): Color(0xFFCCCCCC) ),
                                    borderRadius: BorderRadius.circular(width(3))
                                ),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: width(9),),
                                    SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_check_box"), width: width(13),color:item.check?  Color(0xFFDE3C31): Color(0xFFCCCCCC)),
                                    SizedBox(width: width(3),),
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Text("${(item.spProLeagueName.length>4&&SPClassStringUtils.spFunIsNum(item.spProLeagueName.substring(0,4))) ? item.spProLeagueName.substring(4).trim():item.spProLeagueName}" ,style: TextStyle(fontSize: sp(11),color:item.check?  Color(0xFFDE3C31): Color(0xFF333333)),maxLines: 1,overflow: TextOverflow.ellipsis,)
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width(3),),
                                    Text(item.spProMatchCnt.isEmpty? "":"${item.spProMatchCnt}"+
                                        "场",style: TextStyle(fontSize: sp(11),color:Color(0xFFCCCCCC))),
                                    SizedBox(width: width(4),),

                                  ],
                                ),
                              ),
                              onTap: (){
                                spProSelectAll=false;
                                spProSelectAllNot=false;
                                item.check=!item.check;
                                spFunCalcCheckCount();
                              },
                            );
                          }).toList(),

                        )
                      ],
                    ),
                  );
                },
                childCount: spProListValue.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: height(50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(width: width(14),),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: <Widget>[
                        SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_check_box"), width: width(13),color:spProSelectAll?  Color(0xFFDE3C31): Color(0xFFCCCCCC)),
                        SizedBox(width: width(3),),
                        Text("全选",style: TextStyle(fontSize: sp(13),color:spProSelectAll?  Color(0xFFDE3C31): Color(0xFF333333)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                    onTap: (){
                      if(!spProSelectAll){
                        setState(() {
                          spProSelectAllNot=false;
                          spProSelectAll=true;
                        });
                        spFunCalcCheckCount(isBtn: true);
                      }

                    },
                  ),
                  SizedBox(width: width(13),),
                  Container(
                    width: 1,
                    height: height(9),
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: width(13),),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: <Widget>[
                        SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_check_box"), width: width(13),color:spProSelectAllNot?  Color(0xFFDE3C31): Color(0xFFCCCCCC)),
                        SizedBox(width: width(3),),
                        Text("反选",style: TextStyle(fontSize: sp(13),color:spProSelectAllNot?  Color(0xFFDE3C31): Color(0xFF333333)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                    onTap: (){
                      if(!spProSelectAllNot){
                        setState(() {
                          spProSelectAllNot=true;
                          spProSelectAll=false;
                        });
                        spFunCalcCheckCount(isBtn: true);
                      }

                    },
                  ),
                  SizedBox(width: width(13),),

                  Text("已选择中${spProMatchCount.toString()}场赛事",style: TextStyle(fontSize: sp(12),color:Color(0xFFB1B1B1)),maxLines: 1,overflow: TextOverflow.ellipsis,),

                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,

              child: Container(
                alignment: Alignment.center,
                width: width(100),
                height: height(50),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xFFF2150C),
                          Color(0xFFF24B0C)
                        ]
                    )
                ),
                child: Text("确定",style: TextStyle(color: Colors.white,fontSize: sp(16)),),
              ),
              onTap: (){
                if(spProMatchCount==0){
                  SPClassToastUtils.spFunShowToast(msg:"请选择赛事");
                  return;
                }
                var result= JsonEncoder().convert(spProLeagueName).replaceAll("[", "").replaceAll("]", "").replaceAll(",", ";").replaceAll("\"", "");
                if(spProSelectAll){
                  result="";
                }
                widget.callback(result,widget.spProIsLottery);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }


  Future<void>  spFunOnRefresh() async{
    widget.param.remove("league_name") ;
    widget.param.remove("is_first_level") ;
    widget.param.remove("is_lottery") ;
    if(widget.spProIsLottery.isNotEmpty){
      widget.param["is_lottery"]=widget.spProIsLottery;
    }
    await SPClassApiManager.spFunGetInstance().spFunLeagueListByStatus<SPClassLeagueFilter>(params: widget.param,spProCallBack:SPClassHttpCallBack(
        spProOnSuccess: (result){
          controller.finishLoad(success: true);
          controller.resetRefreshState();
          if(result.spProLeagueList!=null&&result.spProLeagueList.length>0){
            spProListKeys.clear();
            spProListValue.clear();
            spProListValue.clear();
            result.spProLeagueList.forEach((item){

              if(item.spProIsHot!=null&&item.spProIsHot=="1"){
                item.spProPinyinInitial="热";
                if(widget.spProIsHot){
                  item.check=true;
                }
              }
              if(item.spProPinyinInitial.isEmpty){
                item.spProPinyinInitial="#";
              }

              if(spProListKeys.indexOf( item.spProPinyinInitial)==-1){
                spProListKeys.add(item.spProPinyinInitial);
                spProListValue.add(List());
              }
              if(result.spProHotLeagueList!=null&&result.spProHotLeagueList.length>0){
                if(!result.spProHotLeagueList.contains(item.spProLeagueName)){
                  spProListValue[spProListKeys.indexOf(item.spProPinyinInitial)].add(item);
                }
              }else{
                spProListValue[spProListKeys.indexOf(item.spProPinyinInitial)].add(item);
              }
            });
            spProListValue.removeWhere((deleteItem)=>deleteItem.length==0);
            spProListValue.sort((left,right){
//              if(left[0].spProPinyinInitial=="热"||right[0].spProPinyinInitial=="热"){
//                return 1;
//              }
              if(left[0].spProPinyinInitial=="热"){
                return -1;
              }
              if(right[0].spProPinyinInitial=="热"){
                return 1;
              }
              return left[0].spProPinyinInitial.codeUnitAt(0).compareTo(right[0].spProPinyinInitial.codeUnitAt(0));
            });



            if(spProHistoryList!=null){
              spProListValue.forEach((listItem){
                listItem.forEach((itemItem){
                  if(spProHistoryList.indexOf(itemItem.spProLeagueName)>-1){
                    itemItem.check=true;
                  }else{
                    itemItem.check=false;
                  }
                });
              });
            }

            widget.spProIsHot=false;
            setState(() {}
            );
            spFunCalcCheckCount();
          }
        },
        onError: (value){
          controller.finishLoad(success: false);
        }
    ) );




  }

  void spFunCalcCheckCount({bool isBtn:false}) {

      spProListValue.forEach((list){
        list.forEach((item){
          if(spProSelectAll){
           item.check=true;
          }
          if(spProSelectAllNot){
            item.check=!item.check;
          }
        });
      });

    spProMatchCount=0;
    spProLeagueName.clear();
    spProListValue.forEach((list){
      list.forEach((item){
        if(item.check){
          spProLeagueName.add(item.spProLeagueName);
          if(item.spProMatchCnt.isNotEmpty){
            spProMatchCount+=int.parse(item.spProMatchCnt);
          }else{
            spProMatchCount++;
          }
        }
      });
    });
    setState(() {});
  }
}