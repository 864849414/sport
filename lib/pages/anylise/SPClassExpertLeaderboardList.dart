
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassExpertListEntity.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';

import 'SPClassExpertDetailPage.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassExpertLeaderboardList extends StatefulWidget{
  String spProOrderKey="";
  String spProRankingType="";
  SPClassExpertLeaderboardList(this.spProOrderKey,this.spProRankingType);
  SPClassExpertLeaderboardListState spProState;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState=SPClassExpertLeaderboardListState();
  }



}

class SPClassExpertLeaderboardListState extends State<SPClassExpertLeaderboardList> with AutomaticKeepAliveClientMixin{
  EasyRefreshController spProRefreshController;
  List<SPClassExpertListExpertList> spProExpertList=List();
  int page=1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProRefreshController=EasyRefreshController();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: height(30),
            color: Color(0xFFF1F1F1),
            child: Row(
              children: <Widget>[
                Container(
                  width: width(50),
                  alignment: Alignment.center,
                  child:Text("排行",style: TextStyle(fontSize: sp(12),color: Color(0xFF666666),fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.only(left: width(5)),
                  width: width(110),
                  alignment: Alignment.centerLeft,
                  child:Text("专家",style: TextStyle(fontSize: sp(12),color: Color(0xFF666666),fontWeight: FontWeight.bold),maxLines: 1,),
                ),
                Expanded(
                  child:Container(
                    alignment: Alignment.center,
                    child: Text(widget.spProOrderKey=="correct_rate"? "胜率":widget.spProOrderKey=="max_red_num"? "最高连红":"人气榜",style: TextStyle(fontSize: sp(11.5),color: Color(0xFF666666),fontWeight: FontWeight.bold),maxLines: 1,),
    ),
                ),
                widget.spProOrderKey=="popularity"? SizedBox():  Expanded(
                  flex: 2,
                  child:Container(
                    alignment: Alignment.center,
                    child: Text(widget.spProOrderKey=="popularity"? "查看/付费人数":"成绩",style: TextStyle(fontSize: sp(12),color: Color(0xFF666666),fontWeight: FontWeight.bold),maxLines: 1,),
                  ),
                ),
                SizedBox(width: width(54),),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: EasyRefresh.custom(
                header:SPClassBallHeader(
                    textColor: Color(0xFF666666)
                ),
              footer: SPClassBallFooter(
                  textColor: Color(0xFF666666)
              ),
                firstRefresh: true,
                controller: spProRefreshController,
                onRefresh: spFunOnRefresh,
                onLoad: spFunOnLoading,
                slivers: <Widget>[
                  SliverList(
                   delegate: SliverChildBuilderDelegate((c,i){
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                        ),
                        height: height(53),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: width(50),
                              height: height(53),
                              alignment: Alignment.center,
                              child: (i<3&&i>=0) ?
                              spFunBuildMedal(i+1):Text((i+1).toString(),style: TextStyle(fontSize: sp(13),color: Color(0xFF999999)),),
                            ),
                            Container(
                              width: width(110),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1,color: Colors.grey[200]),
                                        borderRadius: BorderRadius.circular(width(18))),
                                    child:  ClipRRect(
                                      borderRadius: BorderRadius.circular(width(18)),
                                      child:( spProExpertList[i]?.spProAvatarUrl==null||spProExpertList[i].spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                                        SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                                        width: width(36),
                                        height: width(36),
                                      ):Image.network(
                                        spProExpertList[i].spProAvatarUrl,
                                        width: width(36),
                                        height: width(36),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2,),
                                  Expanded(
                                    child:Text(spProExpertList[i]?.spProNickName,style: TextStyle(fontSize: sp(13),color: Color(0xFF333333)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ),
                                ],
                              ),

                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(widget.spProOrderKey=="correct_rate"? "${(double.tryParse(spProExpertList[i].spProCorrectRate) *100).toStringAsFixed(0)}%":widget.spProOrderKey=="max_red_num"? spProExpertList[i].spProMaxRedNum:spProExpertList[i].popularity,style: TextStyle(fontSize: sp(13),color: Color(0xFFE3494B)),maxLines: 1,),
                              ),
                            ),
                            widget.spProOrderKey=="popularity"? SizedBox(): Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(widget.spProOrderKey=="popularity"?  "${spProExpertList[i].spProSchemeViewNum}/${spProExpertList[i].spProSchemeBuyNum}":"${spProExpertList[i].spProCorrectSchemeNum}"+
                                    "红"+
                                    "${spProExpertList[i].spProDrawSchemeNum}"+
                                    "走"+
                                    "${spProExpertList[i].spProWrongSchemeNum}"+
                                    "黑",style: TextStyle(fontSize: sp(13),color: Color(0xFFE3494B)),maxLines: 1,),
                              ),
                            ),

                            Container(
                              alignment: Alignment.centerLeft,
                              width: width(54),
                              child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(width(5)),
                                        gradient: LinearGradient(
                                            colors: spProExpertList[i].spProIsFollowing? [Color(0xFFC6C6C6),Color(0xFFC6C6C6)]:[Color(0xFFF1585A),Color(0xFFF77273)]
                                        )
                                    ),
                                    width: width(44),
                                    height: height(22),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text( spProExpertList[i].spProIsFollowing? "已关注":"关注",style: TextStyle(fontSize: sp(11),color: Colors.white),),

                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    if(spFunIsLogin(context: context)){
                                      SPClassApiManager.spFunGetInstance().spFunFollowExpert(isFollow: !spProExpertList[i].spProIsFollowing,spProExpertUid: spProExpertList[i].spProUserId,context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                          spProOnSuccess: (result){
                                            if(!spProExpertList[i].spProIsFollowing){
                                              SPClassToastUtils.spFunShowToast(msg: "关注成功");
                                              spProExpertList[i].spProIsFollowing=true;
                                            }else{
                                              spProExpertList[i].spProIsFollowing=false;
                                            }
                                            if(mounted){
                                              setState(() {});
                                            }
                                          }
                                      ));
                                    }
                                  }
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        SPClassApiManager.spFunGetInstance().spFunExpertInfo(queryParameters: {"expert_uid":spProExpertList[i].spProUserId},
                            context:context,spProCallBack: SPClassHttpCallBack(
                                spProOnSuccess: (info){
                                  SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertDetailPage(info));
                                }
                            ));
                      },

                    );
                  },
                 childCount: spProExpertList.length,),
                )

                ],
            )
          )
        ],
      ),

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  Future<void>  spFunOnRefresh() async{
    page=1;
    await Future.delayed(Duration(seconds: 1));
    await  SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"order_key":widget.spProOrderKey,"page":"1","ranking_type":widget.spProRankingType},spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
        spProOnSuccess: (list){
          spProRefreshController.finishLoad(success: true);
          spProRefreshController.resetRefreshState();
          if(mounted){
            setState(() {
              spProExpertList=list.spProExpertList;
            });
          }
        },
      onError: (value){
        spProRefreshController.finishLoad(success: false);
      }
    ));
  }

  Future<void>  spFunOnLoading() async{
   await SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"order_key":widget.spProOrderKey,"page":"${(page+1).toString()}","ranking_type":widget.spProRankingType},spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
        spProOnSuccess: (list){
          if(list.spProExpertList?.length==0){
            spProRefreshController.finishLoad(noMore: true);
          }else{
            spProRefreshController.finishLoad(success: true);
            page++;
          }
          if(mounted){
            setState(() {
              spProExpertList.addAll(list.spProExpertList);
            });
          }
        },
        onError: (value){
          spProRefreshController.finishLoad(success: false);
        }
    ));
  }

  spFunBuildMedal(int ranking) {
    return SPClassEncryptImage.asset(
      SPClassImageUtil.spFunGetImagePath(ranking==1? "ic_leaderbord_one":(ranking==2? "ic_leaderbord_two":"ic_leaderbord_three")),
      width: 30,
      height: 30,
    );

  }
}