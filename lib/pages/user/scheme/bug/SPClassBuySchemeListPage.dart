import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/home/SPClassSchemeItemView.dart';
import 'package:sport/utils/colors.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';

class SPClassBuySchemeListPage extends StatefulWidget{
   String spProIsOver;

   SPClassBuySchemeListPage(this.spProIsOver);
   @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassBuySchemeListPageState();
  }

}

class SPClassBuySchemeListPageState extends State<SPClassBuySchemeListPage>{
  List<SPClassSchemeListSchemeList> spProSchemeList=List();//全部
  EasyRefreshController spProRefreshController;
  int spProItemIndex=0;
  int page;
  var spProItemBeginValues=[""];
  var spProNowDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProRefreshController=EasyRefreshController();
    spProNowDate=SPClassDateUtils.dateFormatByDate(DateTime.now(), "yyyy-MM-dd");
    spProItemBeginValues.clear();
    spProItemBeginValues.add(SPClassDateUtils.dateFormatByDate(DateTime.now(), "yyyy-MM-dd"));
    spProItemBeginValues.add(SPClassDateUtils.dateFormatByDate(DateTime.now().subtract(new Duration(days: 1)), "yyyy-MM-dd"));
    spProItemBeginValues.add(SPClassDateUtils.dateFormatByDate(DateTime.now().subtract(new Duration(days: 6)), "yyyy-MM-dd"));


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
       widget.spProIsOver!="1"? SizedBox(): Container(
          color: Color(0xFFF1F1F1),
          height: height(40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: spProItemIndex==0? MyColors.main1:null,
                        borderRadius: BorderRadius.circular(100)
                      ),
                      height: height(27),
                      width: width(58),
                      alignment: Alignment.center,
                      child: Text("今天",style: TextStyle(color:spProItemIndex==0? Colors.white:Color(0xFF333333),fontSize: sp(13)),),
                    ),
                    onTap: (){
                      setState(() {spProItemIndex=0;});
                      spProRefreshController.callRefresh(duration: Duration(milliseconds: 500));
                    },
                  ),
                ),
              ),
              Container(width: 1,height: height(12),color: Colors.grey[300],),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: spProItemIndex==1? MyColors.main1:null,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      height: height(27),
                      width: width(58),
                      alignment: Alignment.center,
                      child: Text("昨天",style: TextStyle(color:spProItemIndex==1? Colors.white:Color(0xFF333333),fontSize: sp(13)),),
                    ),
                    onTap: (){
                      setState(() {spProItemIndex=1;});
                      spProRefreshController.callRefresh(duration: Duration(milliseconds: 500));
                    },
                  ),
                ),
              ),
              Container(width: 1,height: height(12),color: Colors.grey[300],),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: spProItemIndex==2? MyColors.main1:null,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      height: height(27),
                      width: width(58),
                      alignment: Alignment.center,
                      child: Text("近七天",style: TextStyle(color:spProItemIndex==2? Colors.white:Color(0xFF333333),fontSize: sp(13)),),
                    ),
                    onTap: (){
                      setState(() {spProItemIndex=2;});
                      spProRefreshController.callRefresh(duration: Duration(milliseconds: 500));
                    },
                  ),
                ),
              ),
              Container(width: 1,height: height(12),color: Colors.grey[300],),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: spProItemIndex==3? MyColors.main1:null,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      height: height(27),
                      width: width(58),
                      alignment: Alignment.center,
                      child: Text("全部",style: TextStyle(color:spProItemIndex==3? Colors.white:Color(0xFF333333),fontSize: sp(13)),),
                    ),
                    onTap: (){
                      setState(() {spProItemIndex=3;});
                      spProRefreshController.callRefresh(duration: Duration(milliseconds: 500));
                    },
                  ),
                ),
              ),
              Container(width: 1,height: height(12),color: Colors.grey[300],),

            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Color(0xFFF1F1F1),
            child: EasyRefresh.custom(
              firstRefresh: true,
              controller:spProRefreshController ,
              header: SPClassBallHeader(
                  textColor: Color(0xFF666666)
              ),
              footer: SPClassBallFooter(
                  textColor: Color(0xFF666666)
              ),
              emptyWidget:spProSchemeList.length==0?  SPClassNoDataView():null,
              onRefresh: spFunOnRefresh,
              onLoad: spFunOnMore,
              slivers: <Widget>[

                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(left: width(10),right: width(10),bottom: width(10)),
                    padding: EdgeInsets.only(top: width(5),bottom: width(5)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width(7))
                    ),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: spProSchemeList.length,
                        itemBuilder: (c,index){
                          var schemeItem=spProSchemeList[index];
                          return Stack(
                            children: <Widget>[
                              SPClassSchemeItemView(schemeItem,spProShowRate: false,),
                              Positioned(
                                top: 10,
                                right:  width(13) ,
                                child: SPClassEncryptImage.asset(
                                  (schemeItem.spProIsWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_result_red"):
                                  (schemeItem.spProIsWin=="0")? SPClassImageUtil.spFunGetImagePath("ic_result_hei"):
                                  (schemeItem.spProIsWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_result_zou"):"",
                                  width: width(40),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),

              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void>  spFunOnRefresh() async {
    page=1;
    var queryParameters;
    if(widget.spProIsOver=="1"&&spProItemIndex<3){
      queryParameters={"fetch_type":"my_bought","is_over":widget.spProIsOver,"page":page.toString(),"ed_date": spProNowDate, "st_date":spProItemBeginValues[spProItemIndex]};
    }else{
      queryParameters={"fetch_type":"my_bought","is_over":widget.spProIsOver,"page":page.toString(),};
    }
    return  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: queryParameters,spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){
          spProRefreshController.finishRefresh(noMore: false,success: true);
          spProRefreshController.resetLoadState();
          if(mounted){
            setState(() {
              spProSchemeList=list.spProSchemeList;
            });
          }
        },
        onError: (value){
          spProRefreshController.finishRefresh(success: false);
        }
    ));
  }

  Future<void>  spFunOnMore() async {
    var  queryParameters;
    if(widget.spProIsOver=="1"&&spProItemIndex<3){
      queryParameters={"fetch_type":"my_bought","is_over":widget.spProIsOver,"page":(page+1).toString(),"ed_date": spProNowDate, "st_date":spProItemBeginValues[spProItemIndex]};
    }else{
      queryParameters={"fetch_type":"my_bought","is_over":widget.spProIsOver,"page":(page+1).toString(),};
    }
    await  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: queryParameters,spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){
          if(list.spProSchemeList.length==0){
            spProRefreshController.finishLoad(noMore: true);
          }else{
            page++;
            spProRefreshController.finishLoad(noMore: false);

          }

          if(mounted){
            setState(() {
              spProSchemeList.addAll(list.spProSchemeList);
            });
          }
        },
        onError: (value){
          spProRefreshController.finishLoad(success: false);

        }
    ));

  }



}