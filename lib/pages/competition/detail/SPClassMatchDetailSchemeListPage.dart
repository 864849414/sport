import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/model/SPClassSchemeListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/home/SPClassSchemeItemView.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';

class SPClassMatchDetailSchemeListPage extends StatefulWidget{
  SPClassGuessMatchInfo spProGuessInfo;

  SPClassMatchDetailSchemeListPage(this.spProGuessInfo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMatchDetailSchemeListPageState();
  }

}

class SPClassMatchDetailSchemeListPageState extends State<SPClassMatchDetailSchemeListPage>{
  int page=1;
  EasyRefreshController controller;
  List<SPClassSchemeListSchemeList> spProSchemeList=List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller=EasyRefreshController();
    spFunOnRefresh();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow:[
            BoxShadow(
              offset: Offset(2,5),
              color: Color(0x0C000000),
              blurRadius:width(6,),),
            BoxShadow(
              offset: Offset(-5,1),
              color: Color(0x0C000000),
              blurRadius:width(6,),
            )
          ],
          borderRadius: BorderRadius.circular(width(7))
      ),
      margin: EdgeInsets.only(left: width(10),right: width(10),top: width(7)),
      child: EasyRefresh.custom(
        controller: controller,
        onRefresh: spFunOnRefresh,
        onLoad: spFunOnMore,
        header: SPClassBallHeader(
            textColor: Color(0xFF666666)
        ),
        footer: SPClassBallFooter(
            textColor: Color(0xFF666666)
        ),
        emptyWidget: spProSchemeList.length==0? SPClassNoDataView():null,
        slivers: <Widget>[
          SliverToBoxAdapter(child: SizedBox(height: height(5),),),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                var schemeItem=spProSchemeList[index];
                return SPClassSchemeItemView(schemeItem);

              },
              childCount: spProSchemeList.length,
            ),
          ),
        ],
      ),

    );
  }

  Future<void>  spFunOnRefresh() async{
    page=1;

    return  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"guess_match_id":widget.spProGuessInfo.spProGuessMatchId,"page":page.toString(),"fetch_type":"guess_match"},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){
          controller.finishRefresh(success: true);
          controller.resetLoadState();
          if(mounted){
            setState(() {
              spProSchemeList=list.spProSchemeList;
            });
          }
        },
        onError: (value){
          controller.finishRefresh(success: false);
        }
    ));

  }

  Future<void>  spFunOnMore() async {
    await  SPClassApiManager.spFunGetInstance().spFunSchemeList(queryParameters: {"guess_match_id":widget.spProGuessInfo.spProGuessMatchId,"page":(page+1).toString(),"fetch_type":"guess_match"},spProCallBack: SPClassHttpCallBack<SPClassSchemeListEntity>(
        spProOnSuccess: (list){

          if(list.spProSchemeList.length==0){
            controller.finishLoad(noMore: true);
          }else{
            page++;
            controller.finishLoad(success: true);

          }
          if(mounted){
            setState(() {
              spProSchemeList.addAll(list.spProSchemeList);
            });
          }
        },
        onError: (value){
          controller.finishLoad(success: false);

        }
    ));
  }

}