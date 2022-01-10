
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassSystemMsg.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';

import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/news/SPClassWebPageState.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';

import 'SPClassSysMsgDetailPage.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';

class SPClassSystemMsgPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassSystemMsgPageState();
  }

}


class SPClassSystemMsgPageState extends State<SPClassSystemMsgPage>{
  List<SPClassSystemMsg>  spProMsgList=List();
  EasyRefreshController spProController;

  var spProUserSubscription;

  int spProPage=1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProController=EasyRefreshController();


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,title: "系统消息",),
      body: buildContent(),
    );
  }


  Widget buildContent() {


      return Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1F1F1),
          border: Border(top: BorderSide(width: 0.4,color: Colors.grey[300]))
        ),
        child: EasyRefresh.custom(
          header: SPClassBallHeader(
              textColor: Color(0xFF666666)
          ),
          footer: SPClassBallFooter(
              textColor: Color(0xFF666666)
          ),
          firstRefresh: true,
          controller:spProController ,
          onRefresh: spFunGetList,
          onLoad: spFunGetMoreList,
          emptyWidget:spProMsgList.length ==0? SPClassNoDataView():null,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((c,i){
                return  GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                        border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    child:Row(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(width(4)),
                              width: width(30),
                              height: width(30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(width(15)),
                                color: Color(0xFFF1F1F1),
                              ),
                              child: SPClassEncryptImage.asset(
                                SPClassImageUtil.spFunGetImagePath("ic_sysmgs"),
                                width: width(19),
                                height: width(19),

                              ),
                            ),
                            spProMsgList[i].spProIsRead  ? Container()
                                : Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(width: 2,color: Colors.white),
                                  borderRadius: BorderRadius.circular(width(6))),
                              width: width(12),
                              height: width(12),
                            )
                          ],
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(spProMsgList[i].title,style: TextStyle(fontSize: 15,color:Color(0xFF333333)),),
                              Text(spProMsgList[i].spProAddTime,style: TextStyle(fontSize: 10,color:Colors.grey),),
                              Text(spProMsgList[i].content,style: TextStyle(fontSize: 13,color:Color(0xFF333333)),),
                            ],
                          ),

                        ),


                      ],
                    ),
                  ),
                  onTap: (){
                    SPClassApiManager.spFunGetInstance().spFunReadMsg(context: context,queryParameters: {"msg_id":spProMsgList[i].spProMsgId},
                        spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                            spProOnSuccess: (result){
                              spProMsgList[i].spProIsRead=true;

                              spFunGetList();
                            }
                        )
                    );

                    if(spProMsgList[i].spProPageUrl.isEmpty){
                      SPClassNavigatorUtils.spFunPushRoute(context,  SPClassSysMsgDetailPage(spProMsgList[i]));
                    }else{
                      SPClassNavigatorUtils.spFunPushRoute(context,  SPClassWebPage(spProMsgList[i].spProPageUrl,spProMsgList[i].title));
                    }




                  },
                );
              },
                childCount: spProMsgList.length,
              ),
            )
          ],
        ),
      );

  }

  Future<void>  spFunGetList() async{
    spProPage=1;
  return  SPClassApiManager.spFunGetInstance().spFunMsgList<SPClassSystemMsg>(queryParameters: {"page":"1"},
    spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
      spProMsgList=result.spProDataList;
      var unreadNum=0;
      spProMsgList.forEach((item){
        if(!item.spProIsRead){
          unreadNum++;
        }
      });
      if(unreadNum==0){
        if(SPClassApplicaion.spProUserLoginInfo.spProUnreadMsgNum!=null&&double.parse(SPClassApplicaion.spProUserLoginInfo.spProUnreadMsgNum)>=0){
          SPClassApplicaion.spProUserLoginInfo.spProUnreadMsgNum="0";
          SPClassApplicaion.spFunGetUserInfo();
        }
      }
      spProController.finishRefresh(success: true);
      spProController.resetLoadState();
      if(mounted){setState(() {});}
    },
    onError: (e){
      spProController.finishRefresh(success: false);

    }
    )
  );
  }

  Future<void>  spFunGetMoreList() {
    return  SPClassApiManager.spFunGetInstance().spFunMsgList<SPClassSystemMsg>(queryParameters: {"page":(spProPage+1).toString()},
        spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
          spProMsgList.addAll(result.spProDataList);
          if(result.spProDataList.length>0){
            spProPage++;
            spProController.finishLoad(success: true);
          }else{
            spProController.finishLoad(noMore: true);
          }
          if(mounted){setState(() {});}
        },
            onError: (e){
              spProController.finishLoad(success: false);

            }
        )
    );


  }
}