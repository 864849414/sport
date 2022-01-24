import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/home/SPClassSchemeItemView.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassMyAddSchemeListPage extends StatefulWidget{

  SPClassMyAddSchemeListPage();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMyAddSchemeListPageState();
  }

}

class SPClassMyAddSchemeListPageState extends State<SPClassMyAddSchemeListPage>  {
  List<SPClassSchemeListSchemeList> spProSchemeList=List();//全部
  EasyRefreshController spProRefreshController;
  int page;
  var spProNowDate;

  StreamSubscription<String>  spProSubEvent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spFunOnRefresh();
    spProRefreshController=EasyRefreshController();

    spProSubEvent = SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="refresh:myscheme"){
        spFunOnRefresh();
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: EasyRefresh.custom(
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
              color: Colors.white,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: spProSchemeList.length,
                  itemBuilder: (c,index){
                    var schemeItem=spProSchemeList[index];
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SPClassSchemeItemView(schemeItem,spProShowRate: false,),
                        Positioned(
                          right:  width(13) ,
                          top:width(10),
                          child: SPClassEncryptImage.asset(
                            (schemeItem.spProVerifyStatus=="0")? SPClassImageUtil.spFunGetImagePath("ic_verify_ing"):
                            (schemeItem.spProVerifyStatus=="-1")? SPClassImageUtil.spFunGetImagePath("ic_verify_bad"): "",
                            width: width(46),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right:  width(13) ,
                          child: SPClassEncryptImage.asset(
                            (schemeItem.spProIsWin=="1")? SPClassImageUtil.spFunGetImagePath("ic_result_red"):
                            (schemeItem.spProIsWin=="0")? SPClassImageUtil.spFunGetImagePath("ic_result_hei"):
                            (schemeItem.spProIsWin=="2")? SPClassImageUtil.spFunGetImagePath("ic_result_zou"):"",
                            width: width(46),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),

        ],
      ),
    );
  }

  Future<void>  spFunOnRefresh() async {
    page=1;
    return  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":"mine","page":page.toString(),},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
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
    await  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":"mine","page":(page+1).toString(),},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
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



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    spProSubEvent.cancel();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



}