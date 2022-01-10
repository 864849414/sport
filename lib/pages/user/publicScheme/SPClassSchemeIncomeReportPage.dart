import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassExpertIncome.dart';
import 'package:sport/model/SPClassIncomeReport.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/dialogs/SPClassWithdrawIncomeTipDialog.dart';
import 'package:sport/pages/user/publicScheme/SPClassExpertIncomeDetailPage.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassSchemeIncomeReportPage extends StatefulWidget{

  SPClassSchemeIncomeReportPage();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassSchemeIncomeReportPageState();
  }

}

class SPClassSchemeIncomeReportPageState extends State<SPClassSchemeIncomeReportPage> {
  EasyRefreshController spProRefreshController;
  int page;
  SPClassIncomeReport spProIncomeReport;

  List<SPClassExpertIncome> incomes=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunOnRefresh();
    spProRefreshController=EasyRefreshController();
    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="refresh:myscheme"){
        spFunOnRefresh();
      }
    });



  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
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
                    height: height(35),
                    padding: EdgeInsets.only(left: width(13),right: width(13)),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 4,),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("我的收益",style: GoogleFonts.notoSansSC(fontSize: sp(15)),),
                            ],
                          ),
                        ),

                        spFunShowMore()?  GestureDetector(
                         child: Row(
                           children: <Widget>[
                             Text("订单明细",style: TextStyle(fontSize: sp(11),color:Color(0xFF888888) ),),
                             SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                               width: width(11),
                             ),
                           ],
                         ),
                         onTap: (){
                           SPClassNavigatorUtils.spFunPushRoute(context, SPClassExpertIncomeDetailPage(incomes));

                         },
                       ):SizedBox()

                      ],
                    ),
                  ),
                  SizedBox(height: width(12),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          padding: EdgeInsets.only(left: width(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                               Text("累计收益",style: TextStyle(fontSize: sp(11)),),
                               Row(
                                 children: <Widget>[
                                   Text("￥",style: TextStyle(fontSize: sp(16),color: Color(0xFFDE3C31)),),
                                    Text(spProIncomeReport==null? "0.00":spProIncomeReport.spProPaidIncome,style: TextStyle(fontSize: sp(24),color: Color(0xFFDE3C31),fontWeight: FontWeight.bold),),

                                 ],
                               )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child:Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("待提现金额",style: TextStyle(fontSize: sp(11)),),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text("￥",style: TextStyle(fontSize: sp(16),color: Color(0xFFDE3C31)),),
                                        Text(spProIncomeReport==null? "0.00":spProIncomeReport.spProUnpaidIncome,style: TextStyle(fontSize: sp(24),color: Color(0xFFDE3C31),fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(width(2)),
                                          gradient: LinearGradient(
                                              colors: [Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                          ),
                                          boxShadow:[
                                            BoxShadow(
                                              offset: Offset(3,3),
                                              color: Color(0x66F1CB81),
                                              blurRadius:width(5,),),
                                            BoxShadow(
                                              offset: Offset(-2,1),
                                              color: Color(0x66F1CB81),
                                              blurRadius:width(5,),),
                                          ],
                                        ),
                                        width: width(58),
                                        height: width(27),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text("提现",style: TextStyle(fontSize: sp(11),color: Colors.white),),

                                          ],
                                        ),
                                      ),
                                      onTap: (){

                                         if( (spProIncomeReport==null||double.parse(spProIncomeReport.spProUnpaidIncome)<=0)){
                                           SPClassToastUtils.spFunShowToast(msg: "暂无可提现金额");
                                           return;
                                         }
                                         SPClassApiManager.spFunGetInstance().spFunWithdrawIncome(context: context,spProCallBack: SPClassHttpCallBack(
                                             spProOnSuccess: (result){
                                               showDialog(context: context,child: SPClassWithdrawIncomeTipDialog());
                                               spFunOnRefresh();
                                             }
                                         ));
                                      }
                                  ),
                                  SizedBox(width: width(13),),

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width(12),),


                ],

              ),
            ),
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
                         Expanded(
                           child: Center(
                             child: Text("结算周期",style: TextStyle(fontSize: sp(12)),),
                           ),
                         ),

                        Expanded(
                          child: Center(
                            child: Text("购买金额",style: TextStyle(fontSize: sp(12)),),
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: Text("分成比例",style: TextStyle(fontSize: sp(12)),),
                          ),
                        ),


                        Container(
                          width: width(40),
                          child: Center(
                            child: Text("发布数",style: TextStyle(fontSize: sp(12)),),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text("周收益",style: TextStyle(fontSize: sp(12)),),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text("结算状态",style: TextStyle(fontSize: sp(12)),),
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
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.only(left: width(13),right: width(13),top: 5,bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Text(item.spProStDate+"\n"+item.spProEdDate,style: TextStyle(fontSize: sp(10)),),
                                  ),
                                ),

                                Expanded(
                                  child: Center(
                                    child: Text("￥ "+item.spProSchemeAllDiamond,style: TextStyle(fontSize: sp(10)),),
                                  ),
                                ),

                                Expanded(
                                  child: Center(
                                    child: Text((double.parse(item.proportion)*100).toStringAsFixed(2)+"%",style: TextStyle(fontSize: sp(10)),),
                                  ),
                                ),


                                Container(
                                  width: width(40),
                                  child: Center(
                                    child: Text(item.spProSchemeNum,style: TextStyle(fontSize: sp(10)),),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text("￥"+SPClassStringUtils.spFunSqlitZero(item.income),style: TextStyle(fontSize: sp(10),color:  Color(0xFFDE3C31)),),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(spFunGetStatusText(item.status),style: TextStyle(fontSize: sp(10),
                                        color:getStatusColor(item.status)),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: (){
                            if(spFunShowMore()){
                              SPClassNavigatorUtils.spFunPushRoute(context, SPClassExpertIncomeDetailPage(incomes,spProDayIndex: index,));
                            }

                          },
                        );
                      }),
                  SizedBox(height: width(12),),


                ],

              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void>  spFunOnRefresh() async {
    page=1;
    SPClassApiManager.spFunGetInstance().spFunIncomeReport(queryParameters: {},spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (result){
          spProRefreshController.finishRefresh(noMore: false,success: true);
          spProRefreshController.resetLoadState();
         setState(() {
           spProIncomeReport=result;
         });
        },
        onError: (value){
          spProRefreshController.finishRefresh(success: false);
        }
    ));
    return  SPClassApiManager.spFunGetInstance().spFunIncomeList<SPClassExpertIncome>(queryParameters: {"page":page.toString()},spProCallBack: SPClassHttpCallBack(
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
    await  SPClassApiManager.spFunGetInstance().spFunIncomeList<SPClassExpertIncome>(queryParameters: {"page":(page+1).toString(),},spProCallBack: SPClassHttpCallBack(
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

    if(status=="0"){
       return "未提现";
     }
    if(status=="1"){
      return "待结算";
    }
    if(status=="2"){
      return "已结算";
    }
    return status;
  }
  Color getStatusColor(String status) {

    if(status=="0"){
      return Colors.green;
    }
    if(status=="1"){
      return Colors.green;
    }
    return Colors.black;
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  spFunShowMore() {
    if(SPClassApplicaion.spProUserLoginInfo.spProExpertType=="outer_expert"&&incomes.length>0){

      return true ;
    }
    return false;
  }



}