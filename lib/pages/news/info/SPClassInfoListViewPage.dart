import 'dart:async';
import 'dart:math';
import 'package:sport/pages/news/SPClassWebPageState.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/SPClassEncryptImage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBannerItem.dart';
import 'package:sport/model/SPClassSportInfo.dart';
import 'package:sport/model/SPClassSportTag.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';

import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';

class SPClassInfoListViewPage extends StatefulWidget // ignore: must_be_immutable
{
  SPClassSportTag spProSportTag;
  String spProInfoType;
  SPClassInfoListViewPage(this.spProSportTag,this.spProInfoType);
  SPClassInfoListViewPageState spProState;
  SPClassInfoListViewPageState createState()=>(spProState=SPClassInfoListViewPageState(spProSportTag));

}

class SPClassInfoListViewPageState extends State<SPClassInfoListViewPage> with AutomaticKeepAliveClientMixin
{

  SPClassSportTag spProSportTag;
  List spProListData= List();
  SPClassInfoListViewPageState(this.spProSportTag);
  EasyRefreshController spProRefreshController;
  String spProShowTopTitle="";
  GlobalKey key=GlobalKey();
  List<SPClassBannerItem> banners;
  String spProReFreshInfoFlowKey="";
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    spProRefreshController= EasyRefreshController();

  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return  Column(
      key: key,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          child:  Container(
            alignment: Alignment.center,
            child: Text(spProShowTopTitle,style: TextStyle(fontSize: sp(16),color: Theme.of(context).primaryColor)),
          ),
          width: ScreenUtil.screenWidth,
          height:spProShowTopTitle.isNotEmpty? height(30):0,
          color: Color(0x7AE3494B),
        ),
        Expanded(
          child:EasyRefresh.custom(
            firstRefresh: true,
            controller:spProRefreshController ,
            header: SPClassBallHeader(
                textColor: Color(0xFF666666)
            ),
            footer: SPClassBallFooter(
                textColor: Color(0xFF666666)
            ),
          onRefresh: spFunOnRefresh,
          onLoad: spFunOnLoading,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (c, i) =>
                ( spProListData[i] is SPClassSportInfo)?  GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child:(spProListData[i] as SPClassSportInfo).spProInfoFlowType=="info"?  spFunBuildNewsView(i):spFunBuildVideo(i),
                  onTap: () {
                    SPClassSportInfo videoItem=spProListData[i] as SPClassSportInfo;

                    if(spProListData[i].spProInfoFlowId.isNotEmpty){
                      SPClassApiManager.spFunGetInstance().spFunInfoFlowClick(queryParameters:  {"info_flow_id":spProListData[i].spProInfoFlowId});
                    }


                    if(videoItem.spProPageUrl!=null&&videoItem.spProPageUrl.isNotEmpty) {
                        SPClassNavigatorUtils.spFunPushRoute(
                            context,SPClassWebPage(videoItem.spProPageUrl,videoItem.title));

                    }

                    if(SPClassApplicaion.spProNewsHistory.indexOf(spProListData[i].spProInfoFlowKey)==-1){
                      setState(() { SPClassApplicaion.spProNewsHistory.add(spProListData[i].spProInfoFlowKey);});
                    }
                  },
                )
                    :Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                  ),
                  child:spProListData[i],
                ),
                itemCount: spProListData.length,
              ),
            )
          ],
          ),
        ),

      ],
    );
  }


  Future<void> spFunOnRefresh() async{

     return SPClassApiManager.spFunGetInstance().spFunSportInfoFlow<SPClassSportInfo>(spProCallBack:SPClassHttpCallBack(
         spProOnSuccess: (result){
           spProListData.clear();
           spProListData.insertAll(0,result.spProDataList);
           if(result.spProDataList.length>0){
             spProReFreshInfoFlowKey=result.spProDataList[0].spProInfoFlowKey;
             spProShowTopTitle="为你推荐${result.spProDataList.length.toString()}条内容";
             Timer(Duration(seconds: 2),(){
               if(mounted) setState(() {spProShowTopTitle="";});
             });
           }
           if(mounted) setState(() {});
           spProRefreshController.finishLoad();
         },
       onError: (e){
         spProRefreshController.finishLoad(success: false);

       }
     ) ,queryParameters: {
       "tag":spProSportTag.tag,
       "info_flow_type":widget.spProInfoType,
       "ref_info_flow_key":spProListData.length==0? "":spProReFreshInfoFlowKey,
       "direction":spProListData.length==0? "":"before"});

  }

  Future<void> spFunOnLoading() async{

    return SPClassApiManager.spFunGetInstance().spFunSportInfoFlow<SPClassSportInfo>(spProCallBack:SPClassHttpCallBack(
        spProOnSuccess: (result){
          if(result.spProDataList.length>0){
            spProListData.addAll(result.spProDataList);
            if(mounted)
              setState(() {
              });

            spProRefreshController.finishLoad(success: true);
          }else{
            spProRefreshController.finishLoad(noMore: true);
          }
        },
        onError: (e){
          spProRefreshController.finishLoad(success: false);

        }
    ) ,queryParameters: {
      "tag":spProSportTag.tag,
      "info_flow_type":
      widget.spProInfoType,
      "ref_info_flow_key":spProListData.length==0 ? "":spProListData[spProListData.length-1].spProInfoFlowKey,
      "direction":"after"});



  }

  spFunBuildNewsView(int i) {


   return Container(
      padding: EdgeInsets.only(left: width(13),right: width(13)),
      height: height(92),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: height(14)),
            child: (spProListData[i].spProIconUrl==null||spProListData[i].spProIconUrl.isEmpty)
                ? SPClassEncryptImage.asset(
              getNewsDefaulf(),
              fit: BoxFit.cover,
              width: height(87),
              height:  height(65),
            ):Image.network(
              spProListData[i].spProIconUrl,
              fit: BoxFit.cover,
              width: height(87),
              height:  height(65),
              loadingBuilder:(BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                if (loadingProgress == null){
                  return child;
                }{
                  return SPClassEncryptImage.asset(
                    SPClassImageUtil.spFunGetImagePath('ic_news_default'),
                    fit: BoxFit.contain,
                    width: height(87),
                    height:  height(65),
                  );
                }
              },
            ),
          ),
          SizedBox(width: width(11),),
          Flexible(
            flex: 1,
            child: Container(
                margin: EdgeInsets.only(top: height(11)),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height:  height(68),
                      alignment: Alignment.topLeft,
                      child:  Text(
                        spProListData[i].title,
                        style: TextStyle(fontSize: sp(16),color:SPClassApplicaion.spProNewsHistory.indexOf(spProListData[i].spProInfoFlowKey)==-1? Color(0xFF333333): Colors.grey,letterSpacing: 0),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Row(
                        children: <Widget>[
                          Text(spProListData[i].spProAddTime.substring(5,spProListData[i].spProAddTime.length-3),style: TextStyle(fontSize: sp(11),color: Color(0xFFADADAD)),),
                          /*  Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    ImageUtil.getImagePath('ic_news_comment_num'),
                                    fit: BoxFit.contain,
                                    width: height(10),
                                    height:  height(10),
                                  ),
                                  SizedBox(width: 3,),
                                  Text(('${spProListData[i].spProCommentNum}评论').toString(),style: TextStyle(fontSize: sp(11),color: Color(0xFFADADAD)),),
                                ],
                              ),
                            )*/
                        ],
                      ),
                    )
                  ],
                )
            ),
          )

        ],
      ) ,
    );
  }

  spFunBuildVideo(int i) {
    return Container(
    height: height(150),
    margin: EdgeInsets.only(bottom: 10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
    color: Colors.white,
    border: Border(bottom: BorderSide(width: 1,color: Colors.grey[200]))
    ),
    child: Stack(
      fit: StackFit.loose,
      children: <Widget>[
        (spProListData[i].spProIconUrl==null||spProListData[i].spProIconUrl.isEmpty)
            ? SPClassEncryptImage.asset(
          getNewsDefaulf(),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: height(150),
        ):
        Image.network(
          spProListData[i].spProIconUrl,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: height(150),
        ),
        Positioned(
          left: 5,
          right: 5,
          top: 5,
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Text( spProListData[i].title,style: TextStyle(fontSize: sp(16),color: Colors.white),
                  maxLines: 2, overflow: TextOverflow.ellipsis,),
              )
            ],
          ),
        )
      ],

    ) );


  }

  String getNewsDefaulf() {

    var list =[SPClassImageUtil.spFunGetImagePath('ic_news_randow_oen'),SPClassImageUtil.spFunGetImagePath('ic_news_randow_two'),SPClassImageUtil.spFunGetImagePath('ic_news_randow_three')
      ,SPClassImageUtil.spFunGetImagePath('ic_news_randow_four'),SPClassImageUtil.spFunGetImagePath('ic_news_randow_five')];


    return list[Random().nextInt(list.length)];


  }



  spFunBuildNoData() {
    return   Container(

      height:(key.currentContext.findRenderObject() as RenderBox).size.height,
      alignment: Alignment.center,
      child: SPClassNoDataView() ,
    );
  }










}