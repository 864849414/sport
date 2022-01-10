import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassExpertInfo.dart';

import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/home/SPClassSchemeItemView.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/widgets/SPClassSkeletonList.dart';

import 'SPClassHomePage.dart';

class SPClassFreeShemeItemPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassFreeShemeItemPageState();
  }

}

class SPClassFreeShemeItemPageState extends State<SPClassFreeShemeItemPage>{
  List<SPClassSchemeListSchemeList> spProSchemeList=List();//免费
  List<SPClassSchemeListSchemeList> spProSchemeListAll=List();//全部
  EasyRefreshController spProRefreshController;
  int page;
  int spProPageAll=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProRefreshController=EasyRefreshController();
    SPClassApiManager.spFunGetInstance().spFunLogAppEvent(spProEventName: "free_scheme_list",);

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:SPClassToolBar(
        context,title: "免费方案",
      ),
      body: Container(
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
          firstRefreshWidget: SPClassSkeletonList(
              length: 10,
              builder: (c,index)=>
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.4,color: Colors.grey[300]),
                    ),
                    padding: EdgeInsets.only(top: height(11),bottom: height(11),left: width(17) ),
                    alignment: Alignment.center,
                    child:   Row(
                      children: <Widget>[
                        Container(
                          width: width(40),
                          height: width(40),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(width(20))),
                        ),
                        SizedBox(width: width(7),),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(height: height(10),width: width(60),color: Colors.red,),
                              SizedBox(height: height(5),),
                              Container(height: height(10),width: width(100),color: Colors.red,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
          onRefresh: spFunOnRefresh,
          onLoad: spFunOnMore,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                 margin: EdgeInsets.all(width(10)),
                padding: EdgeInsets.only(top: width(5),bottom: width(5)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width(7))

                ),
                child:spProSchemeList.length==0 ? Container(
                  height: height(100),
                  alignment: Alignment.center,
                  child: Text("暂无最新免费方案",style: TextStyle(color: Color(0xFF999999)),),
                ): ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: spProSchemeList.length,
                    itemBuilder: (c,index){
                      return SPClassSchemeItemView(spProSchemeList[index]);
                    }),
              ),
            ),

            SliverToBoxAdapter(
              child:spProSchemeListAll.length==0? SizedBox():Column(
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.only(left: width(10),right: width(10),bottom: width(10)),
                    padding: EdgeInsets.only(top: width(5),bottom: width(5)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width(7))

                    ),
                    child:Column(
                      children: <Widget>[
                        Container(
                          height: height(35),
                          padding: EdgeInsets.only(left: width(13),right: width(13)),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: height(4),
                                height: height(15),
                                decoration: BoxDecoration(
                                    color: Color(0xFFDE3C31),
                                    borderRadius: BorderRadius.circular(100)
                                ),
                              ),
                              SizedBox(width: 4,),
                              Text("推荐方案",style: GoogleFonts.notoSansSC(fontWeight: FontWeight.w500,fontSize: width(16)),),

                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: spProSchemeListAll.length,
                            itemBuilder: (c,index){
                              return SPClassSchemeItemView(spProSchemeListAll[index]);
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void>  spFunOnRefresh() async {
    page=1;
    spProPageAll=0;
    return  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":"free","is_over":"0", "page":page.toString(),"match_type":SPClassHomePageState.spProHomeMatchType},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){
          spProRefreshController.finishRefresh(noMore: false,success: true);
          spProRefreshController.resetLoadState();

          if(list.spProSchemeList.length==0){
            spFunOnMoreAll();
          }else{
            if(list.spProSchemeList.length<20){
              spFunOnMoreAll();
            }
            if(mounted){
              setState(() {
                spProSchemeList=list.spProSchemeList;
              });
            }

          }
        },
        onError: (value){
          spProRefreshController.finishRefresh(success: false);
        }
    ));
  }

  Future<void>  spFunOnMore() async {
    await  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":"free","is_over":"0","page":(page+1).toString(),"match_type":SPClassHomePageState.spProHomeMatchType},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){

          if(list.spProSchemeList.length==0){
            spFunOnMoreAll();
          }else{
            page++;
            if(mounted){
              setState(() {
                spProSchemeList.addAll(list.spProSchemeList);
              });
            }
          }

        },
        onError: (value){
          spProRefreshController.finishLoad(success: false);

        }
    ));

  }

  Future<void>  spFunOnMoreAll() async {
    await  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"fetch_type":"recent_correct_rate","page":(spProPageAll+1).toString(),"match_type":SPClassHomePageState.spProHomeMatchType},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){

          if(list.spProSchemeList.length==0){
            spProRefreshController.finishLoad(noMore: true);
          }else{
            spProPageAll++;
          }
          if(mounted){
            setState(() {
              spProSchemeListAll.addAll(list.spProSchemeList);
            });
          }
        },
        onError: (value){
          spProRefreshController.finishLoad(success: false);
        }
    ));

  }


}