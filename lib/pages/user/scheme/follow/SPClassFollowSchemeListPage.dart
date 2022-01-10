import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/home/SPClassSchemeItemView.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/SPClassEncryptImage.dart';


class SPClassFollowSchemeListPage extends StatefulWidget{
   String spProIsOver;
   SPClassFollowSchemeListPageState spProState;
   SPClassFollowSchemeListPage(this.spProIsOver);
   @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState= SPClassFollowSchemeListPageState();
  }

}

class SPClassFollowSchemeListPageState extends State<SPClassFollowSchemeListPage>{
  List<SPClassSchemeListSchemeList> spProSchemeList=List();//全部
  EasyRefreshController spProRefreshController;
  int page;
  bool spProShowEdit=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProRefreshController=EasyRefreshController();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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

        onRefresh: spFunOnRefresh,
        onLoad: spFunOnMore,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child:spProSchemeList.length==0?  SPClassNoDataView():SizedBox(),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: width(10),right: width(10),bottom: width(10),top: height(5)),
              padding: EdgeInsets.only(top: width(5),bottom: width(5),),
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
                    return Container(
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child:!spProShowEdit? SizedBox(): Row(
                              children: <Widget>[
                                SizedBox(width: width(10),),
                                SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_check_box"), width: width(18),color:schemeItem.check?  Color(0xFFDE3C31): Color(0xFFCCCCCC)),
                                SizedBox(width: width(5),),
                              ],
                            ),
                            onTap: (){
                              setState(() {schemeItem.check=!schemeItem.check;});
                            },
                          ),
                          Expanded(
                            child: SPClassSchemeItemView(schemeItem),
                          )
                        ],
                      ),
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
    return  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":"my_collected","is_over":widget.spProIsOver,"page":page.toString(),},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
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
    await  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":"my_collected","is_over":widget.spProIsOver, "page":(page+1).toString()},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
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

  void spFunShowEditList(bool show,{bool all:false}){
      spProSchemeList.forEach((item){
        item.check=all;
      });

     setState(() {
       spProShowEdit=show;
     });
  }

  Future<void> spFunDeleteCollect(VoidCallback callback) async {
    List<String> schemesIds=List();
    spProSchemeList.forEach((item){
      if(item.check){
        schemesIds.add(item.spProSchemeId);
      }
    });

    if(schemesIds.length==0){
      SPClassToastUtils.spFunShowToast(msg: "请勾选方案");
      return;
    }
    var result= JsonEncoder().convert(schemesIds).replaceAll("[", "").replaceAll("]", "").replaceAll(",", ";").replaceAll("\"", "");

    SPClassApiManager.spFunGetInstance().spFunCancelCollect(context: context,queryParameters: {"target_id":result,"target_type":"scheme"},spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
        spProOnSuccess: (result){
          spProRefreshController.callRefresh();
          setState(() {spProShowEdit=false;});
          callback();
        },
        onError: (reslut){
        }
    ));


  }



}