import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/model/SPClassExpertIncome.dart';
import 'package:sport/model/SPClassExpertIncomeDetail.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/dialogs/SPClassBottomLeaguePage.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassExpertIncomeDetailPage extends StatefulWidget{
  List<SPClassExpertIncome> spProDayList=[];
  int spProDayIndex;
  SPClassExpertIncomeDetailPage(this.spProDayList,{this.spProDayIndex:0});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassExpertIncomeDetailPageState();
  }

}

class SPClassExpertIncomeDetailPageState extends State<SPClassExpertIncomeDetailPage>{
  var index=0;
  EasyRefreshController spProRefreshController;
  int page;

  List<SPClassExpertIncomeDetail> incomes=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunOnRefresh();
    index=widget.spProDayIndex;
    spProRefreshController=EasyRefreshController();



  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title:"订单明细",
      ),
      body: Container(
        color: Color(0xFFF1F1F1),
        child: EasyRefresh.custom(
          controller:spProRefreshController ,
          header: SPClassBallHeader(
              textColor: Color(0xFF666666)
          ),
          footer: SPClassBallFooter(
              textColor: Color(0xFF666666)
          ),
          onRefresh: spFunOnRefresh,
          onLoad: spFunOnMore,
          slivers: <Widget>[

             SliverToBoxAdapter(
               child:GestureDetector(
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: width(19),vertical: width(13)),
                   width: ScreenUtil.screenWidth,
                   color: Colors.white,
                   child: Row(
                     children: <Widget>[
                       Text(
                         SPClassDateUtils.spFunDateFormatByString(widget.spProDayList[index].spProStDate, "yyyy/MM/dd")+" - "+
                             SPClassDateUtils.spFunDateFormatByString(widget.spProDayList[index].spProEdDate, "yyyy/MM/dd"),
                         style: TextStyle(color: Color(0xFF666666),fontSize: sp(12)),),
                       Icon(Icons.expand_more,color: Color(0xFF666666),size: width(16),),
                       Expanded(child: SizedBox(),),
                       Text("￥"+SPClassStringUtils.spFunSqlitZero(widget.spProDayList[index].income),style: TextStyle(color: Colors.red,fontSize: sp(12)),),

                     ],
                   ),
                 ),
                 onTap: (){
                   showModalBottomSheet(
                     context: context,
                     builder: (BuildContext c) {
                       return SPClassBottomLeaguePage(widget.spProDayList.map((e){
                        return SPClassDateUtils.spFunDateFormatByString(e.spProStDate, "yyyy/MM/dd")+" - "+
                            SPClassDateUtils.spFunDateFormatByString(e.spProEdDate, "yyyy/MM/dd");
                       }).toList(),"请选择日期",(listIndex){

                         setState(() {
                           index=listIndex;
                         });
                         spProRefreshController.callRefresh();
                       },initialIndex: index,);
                     },
                   );;
                 },
               ),
             ),

            SliverToBoxAdapter(
              child: SizedBox(height: width(10),),
            ),




            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
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
                    borderRadius: BorderRadius.circular(width(7))
                ),
                margin: EdgeInsets.only(bottom: height(8),left: width(10),right: width(10)),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: width(37),
                      padding: EdgeInsets.only(left: width(13),right: width(13)),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: width(30),
                            child: Center(
                              child: Text("时间",style: TextStyle(fontSize: sp(10)),),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text("场次",style: TextStyle(fontSize: sp(10)),),
                            ),
                          ),
                          Container(
                            width: width(30),
                            child: Center(
                              child: Text("赛果",style: TextStyle(fontSize: sp(10)),),
                            ),
                          ),


                          Container(
                            width: width(45),
                            child: Center(
                              child: Text("价格",style: TextStyle(fontSize: sp(10)),),
                            ),
                          ),
                          Container(
                            width: width(35),
                            child: Center(
                              child: Text("不中退",style: TextStyle(fontSize: sp(10)),),
                            ),
                          ),
                          Container(
                            width: width(40),
                            child: Center(
                              child: Text("收益",style: TextStyle(fontSize: sp(10)),),
                            ),
                          ),
                          Container(
                            width: width(45),
                            child: Center(
                              child: Text("场次状态",style: TextStyle(fontSize: sp(10)),),
                            ),
                          ),

                        ],
                      ),
                    ),

                    incomes.length==0?SPClassNoDataView(height: width(200),):SizedBox(),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: incomes.length,
                        itemBuilder: (c,index){
                          var item=incomes[index];
                          return   Container(
                            padding: EdgeInsets.symmetric(horizontal: width(13),vertical: width(5)),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: width(30),
                                  child: Center(
                                    child: Text(
                                      SPClassDateUtils.spFunDateFormatByString(item.spProStTime, "MM-dd")
                                      ,style: TextStyle(fontSize: sp(10)),),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                          item.spProLeagueName.toLowerCase()+"\n"+
                                          (SPClassStringUtils.spFunMaxLength(item.spProTeamOne,length: 3)+"vs"+SPClassStringUtils.spFunMaxLength(item.spProTeamTwo,length: 3))
                                      ,style: TextStyle(fontSize: sp(10)),textAlign: TextAlign.center,),
                                  ),
                                ),
                                Container(
                                  width: width(30),
                                  child: Center(
                                    child:(item.spProVerifyStatus =="-1")?
                                    SPClassEncryptImage.asset(
                                      SPClassImageUtil.spFunGetImagePath("ic_scheme_exption",),
                                      width: width(19),):
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical:width(3)),
                                      width: width(19),
                                      decoration: BoxDecoration(
                                        color:item.spProIsWin=="-1"?   null:(item.spProIsWin=="1" ?Color(0xFFDE3C31):(item.spProIsWin=="2" ?Colors.green:Colors.grey)),
                                        borderRadius: BorderRadius.circular(width(5))
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(spFunGetWinText(item.spProIsWin),style: TextStyle(color:item.spProIsWin=="-1"?   Colors.black:Colors.white,fontSize: sp(10),
                                          fontWeight: item.spProIsWin=="-1"? FontWeight.bold:null),),
                                    ),
                                  ),
                                ),



                                Container(
                                  width: width(45),
                                  child: Center(
                                    child: Text(SPClassStringUtils.spFunSqlitZero(item.spProDiamond)+" 钻石",style: TextStyle(fontSize: sp(10)),),
                                  ),
                                ),

                                Container(
                                  width: width(35),
                                  child: Center(
                                    child: Text((item.spProCanReturn=="1"? "是":"否"),style: TextStyle(fontSize: sp(10)),),
                                  ),
                                ),

                                Container(
                                  width: width(40),
                                  child: Center(
                                    child: Text((double.tryParse(item.spProExpertIncome)>0? "+":"")+SPClassStringUtils.spFunSqlitZero(item.spProExpertIncome),style: TextStyle(fontSize: sp(10),color: Colors.red),),
                                  ),
                                ),

                                Container(
                                  width: width(45),
                                  child: Center(
                                    child: Text(spFunGetStatusText(item.status),style: TextStyle(fontSize: sp(10),color: spFunGetStatusColor(item.status)),),
                                  ),
                                ),

                              ],
                            ),
                          );
                        }),
                    SizedBox(height: width(12),),


                  ],

                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future<void>  spFunOnRefresh() async {
    page=1;

    return  SPClassApiManager.spFunGetInstance().spFunSchemeOrderList<SPClassExpertIncomeDetail>(queryParameters: {"page":page.toString(),"income_st_date":widget.spProDayList[index].spProStDate},spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (result){
          spProRefreshController.finishRefresh(noMore: false,success: true);
          spProRefreshController.resetLoadState();
          setState(() {
            incomes=result.spProDataList;
          });
        },
        onError: (value){
          spProRefreshController.finishRefresh(success: false);
        }
    ));
  }
  Future<void>  spFunOnMore() async {
    await  SPClassApiManager.spFunGetInstance().spFunSchemeOrderList<SPClassExpertIncomeDetail>(queryParameters: {"page":(page+1).toString(),"income_st_date":widget.spProDayList[index].spProStDate},spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (list){
          if(list.spProDataList.length==0){
            spProRefreshController.finishLoad(noMore: true);
          }else{
            page++;
            spProRefreshController.finishLoad(noMore: false);

          }

          if(mounted){
            setState(() {
              incomes.addAll(list.spProDataList);
            });
          }
        },
        onError: (value){
          spProRefreshController.finishLoad(success: false);

        }
    ));

  }

  String spFunGetStatusText(String status) {

    if(status=="not_started"){
      return "未开始";
    }
    if(status=="in_progress"){
      return "进行中";
    }
    if(status=="abnormal"){
      return "异常";
    }
    if(status=="over"){
      return "已结束";
    }
    return status;
  }

  Color spFunGetStatusColor(String status) {

    if(status=="not_started"){
      return  Colors.grey;
    }
    if(status=="in_progress"){
      return Colors.green;
    }
    if(status=="abnormal"){
      return Colors.red;
    }
    if(status=="over"){
      return Colors.black;
    }
    return Colors.black;
  }

  String spFunGetWinText(String spProIsWin) {
   // _win：1为结果未知，0表示输 1表示赢 2表示平局
    if(spProIsWin=="-1"){
      return "--";
    }
    if(spProIsWin=="0"){
      return "黑";
    }
    if(spProIsWin=="1"){
      return "红";
    }
    if(spProIsWin=="2"){
      return "走";
    }
    return "";

  }


}