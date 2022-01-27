

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'SPClassHomePage.dart';
import 'SPClassSchemeItemView.dart';


class SPClassHomeSchemeList extends StatefulWidget{
  String spProFetchType="";
  String spProPayWay;
  bool spProShowProfit;
  int type ;

  SPClassHomeSchemeList({this.spProFetchType,this.spProPayWay,this.spProShowProfit:true,this.type=0});
  SPClassHomeSchemeListState spProState;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState=SPClassHomeSchemeListState();
  }

}

class SPClassHomeSchemeListState extends State<SPClassHomeSchemeList> with AutomaticKeepAliveClientMixin<SPClassHomeSchemeList>{
  List<SPClassSchemeListSchemeList> spProSchemeList=List();//全部
  EasyRefreshController spProRefreshController;
  String spProPayWay="";
  String spProMatchType="足球";
  int page;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProRefreshController=EasyRefreshController();
    // spProMatchType= SPClassHomePageState.spProHomeMatchType;
    spProMatchType = widget.type==0?'足球':'篮球';
    spFunOnRefresh(widget.spProPayWay,spProMatchType);

    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event.startsWith("scheme:refresh")){
        spFunOnRefresh(widget.spProPayWay,spProMatchType/*SPClassHomePageState.*/);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return EasyRefresh.custom(
      topBouncing: false,
      controller:spProRefreshController ,
      footer: SPClassBallFooter(
        textColor: Color(0xFF8F8F8F),
      ),
      onLoad: spFunOnMore,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child:spProSchemeList.length==0?  SPClassNoDataView():SizedBox(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              var schemeItem=spProSchemeList[index];
              return SPClassSchemeItemView(schemeItem,spProShowProFit: widget.spProShowProfit,);
            },
            childCount: spProSchemeList.length,
          ),
        ),
      ],
    );
  }

  Future<void>  spFunOnRefresh(String spProPayWay,String spProMatchType) async {
    page=1;
    this.spProPayWay=spProPayWay;
    this.spProMatchType=spProMatchType;
    return  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":widget.spProFetchType,"page":page.toString(),"playing_way":spProPayWay,"match_type":spProMatchType},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
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
    await  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":widget.spProFetchType,"page":(page+1).toString(),"playing_way":spProPayWay,"match_type":spProMatchType},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){

          if(list.spProSchemeList.length==0){
            spProRefreshController.finishLoad(noMore: true);
          }else{
            page++;

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


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}