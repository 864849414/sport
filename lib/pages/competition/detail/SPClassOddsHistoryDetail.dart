import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/model/SPClassOddsHistoryListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';

class SPClassOddsHistoryDetail extends StatefulWidget{
  List<String> spProCompanys=List();
  int spProCompanyIndex=0;
  String spProOddsType;
  String spProGuessId;

  SPClassOddsHistoryDetail(this.spProCompanys,this.spProCompanyIndex,this.spProOddsType,this.spProGuessId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassOddsHistoryDetailState();
  }

}

class SPClassOddsHistoryDetailState extends State<SPClassOddsHistoryDetail>{
  List<SPClassOddsHistoryListOddsHistoryList> spProOddsHistoryList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // spFunGetOddHistory();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("赔率变化"),
      ),
      body: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              width: width(75),
              height:MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: widget.spProCompanys.length,
                  itemBuilder:(c,index){
                    var company=widget.spProCompanys[index];
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: height(10),bottom: height(10)),
                    color: widget.spProCompanyIndex==index ?Colors.white:Color(0xFFF1F1F1),
                    child: Row(
                      children: <Widget>[
                        widget.spProCompanyIndex==index ? Container(
                          width: 3,
                          color: Color(0xFFE3494B),
                          height: height(13),
                        ):SizedBox(),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(company,style: TextStyle(fontSize: sp(12)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    if(mounted&&widget.spProCompanyIndex!=index){
                      setState(() {
                        widget.spProCompanyIndex=index;
                      });
                      spFunGetOddHistory();
                    }
                  },
                );
              }),
            ),
            SizedBox(width: 7,),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.radio_button_unchecked,color: Color(0xFFE3494B),size: height(15),),
                          Text(" 赔率详情",style: TextStyle(fontSize: sp(13),color: Color(0xFF333333)),)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300],width: 0.4)
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Color(0xFFF0F0F0),
                              height: height(40),
                              child: Text("指数",style: TextStyle(color: Color(0xFF333333),fontSize: sp(12)),),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              color: Color(0xFFF0F0F0),
                              height: height(40),
                              child: Text(widget.spProOddsType.contains("欧")? "指数":widget.spProOddsType.contains("亚")? "让球":"中间",style: TextStyle(color: Color(0xFF333333),fontSize: sp(12)),),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Color(0xFFF0F0F0),
                              height: height(40),
                              child: Text("指数",style: TextStyle(color: Color(0xFF333333),fontSize: sp(12)),),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              color: Color(0xFFF0F0F0),
                              height: height(40),
                              child: Text("更新时间",style: TextStyle(color: Color(0xFF333333),fontSize: sp(12)),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (spProOddsHistoryList==null||spProOddsHistoryList.length==0)?SPClassNoDataView(
                      height: width(400),
                    ):
                     Expanded(
                       child: ListView.builder(
                           itemCount: spProOddsHistoryList.length,
                           itemBuilder: (c,index){
                             var HistroyItem=spProOddsHistoryList[index];
                           return    Container(
                             decoration: BoxDecoration(
                                 border: Border.all(color: Colors.grey[300],width: 0.4)
                             ),
                             child: Row(
                               children: <Widget>[
                                 Expanded(
                                   child: Container(
                                     alignment: Alignment.center,
                                     decoration: BoxDecoration(
                                         color: Colors.white,
                                         border: Border(right: BorderSide(width: 0.4,color: Colors.grey[300]))
                                     ),
                                     height: height(40),
                                     child: Text(HistroyItem.spProWinOddsOne,style: TextStyle(color: Color(0xFF333333),fontSize: sp(12)),),
                                   ),
                                 ),
                                 Expanded(
                                   flex: 2,
                                   child: Container(
                                     decoration: BoxDecoration(
                                         color: Colors.white,
                                         border: Border(right: BorderSide(width: 0.4,color: Colors.grey[300]))
                                     ),
                                     alignment: Alignment.center,
                                     height: height(40),
                                     child: Text(widget.spProOddsType.contains("欧")? HistroyItem.spProDrawOdds:widget.spProOddsType.contains("亚")? HistroyItem.spProAddScoreDesc:HistroyItem.spProMidScoreDesc,style: TextStyle(color: Color(0xFF333333),fontSize: sp(12)),),
                                   ),
                                 ),
                                 Expanded(
                                   child: Container(
                                     alignment: Alignment.center,
                                     decoration: BoxDecoration(
                                         color: Colors.white,
                                         border: Border(right: BorderSide(width: 0.4,color: Colors.grey[300]))
                                     ),
                                     height: height(40),
                                     child: Text(HistroyItem.spProWinOddsTwo,style: TextStyle(color: Color(0xFF333333),fontSize: sp(12)),),
                                   ),
                                 ),
                                 Expanded(
                                   flex: 2,
                                   child: Container(
                                     alignment: Alignment.center,
                                     color: Colors.white,
                                     height: height(40),
                                     child: Text(SPClassDateUtils.spFunDateFormatByString(HistroyItem.spProChangeTime, "MM-dd HH:mm"),style: TextStyle(color: Color(0xFF333333),fontSize: sp(11)),),
                                   ),
                                 ),
                               ],
                             ),
                           );
                       }),
                     )


                  ],
                ),
                height:MediaQuery.of(context).size.height,

              ),
            ),
            SizedBox(width: 7,),
          ],
        ),
      ),
    );
  }

  void spFunGetOddHistory() {

    SPClassApiManager.spFunGetInstance().spFunOddsHistoryList(spProOddsType: widget.spProOddsType,company:widget.spProCompanys[widget.spProCompanyIndex],spProGuessMatchId:widget.spProGuessId,context: context,
        spProCallBack: SPClassHttpCallBack<SPClassOddsHistoryListEntity>(
          spProOnSuccess: (list){
            if(mounted){
              setState(() {
                spProOddsHistoryList=list.spProOddsHistoryList;
              });
            }
          }
        )
    );

  }

}