import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassCircleInfo.dart';
import 'package:sport/model/SPClassTopicInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';

import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';

import 'SPClassCircleInfoDetailPage.dart';
import 'SPClassNewCircleInfoPage.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassTopTitleDetailPage extends StatefulWidget{
  SPClassTopicInfo info;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassTopTitleDetailPageState();
  }

  SPClassTopTitleDetailPage(this.info);

}

class SPClassTopTitleDetailPageState extends State<SPClassTopTitleDetailPage>{
  List<SPClassCircleInfo> spProCircleInfoList=List();
  EasyRefreshController spProRefreshController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProRefreshController=EasyRefreshController();
    spFunOnRefresh();
    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="circle:refresh"||event=="delete:circle"){
        // getSeqNum();
        spFunOnRefresh();


      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      floatingActionButton:GestureDetector(
        child:SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_new_ciricle_info"),
          width: width(70),
        ),
        onTap: (){
          if(spFunIsLogin(context: context)){
            SPClassNavigatorUtils.spFunPushRoute(context, SPClassNewCircleInfoPage(widget.info.spProTopicTitle));
          }
        },
      ),
      body: Container(
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        child: EasyRefresh.custom(
            onRefresh: spFunOnRefresh,
            header: SPClassBallHeader(
              textColor: Color(0xFF8F8F8F),
            ),
            footer: SPClassBallFooter(
              textColor: Color(0xFF8F8F8F),
            ),
            onLoad: spFunOnMore,
            slivers: [
               SliverAppBar(
                 pinned: true,
                 centerTitle: true,
                 title: Text("话题详情",style: TextStyle(fontSize: sp(18)),),
                 elevation: 0,
                 expandedHeight: width(186)-ScreenUtil.statusBarHeight,
                 flexibleSpace: FlexibleSpaceBar(
                   background: Stack(children: <Widget>[
                     Image.network(widget.info.spProImgUrl,width: ScreenUtil.screenWidth,height: width(186)+ScreenUtil.statusBarHeight,fit: BoxFit.cover,),
                     Positioned(
                       left: 0,
                       right: 0,
                       top: 0,
                       bottom: 0,
                       child:Container(
                         padding: EdgeInsets.only(top: kToolbarHeight),
                         color: Colors.black.withOpacity(0.5),
                         child: Row(
                           children: <Widget>[
                             SizedBox(width: height(23),),
                             ClipRRect(
                               borderRadius: BorderRadius.all(Radius.circular(300)),
                               child: Image.network(widget.info.spProImgUrl,width: width(74),height: width(74),fit: BoxFit.cover,),
                             ),
                             SizedBox(width: width(13),),
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text(widget.info.spProTopicTitle,style: TextStyle(color: Colors.white,fontSize: sp(17)),),
                                 SizedBox(height: height(3),),
                                 Text(widget.info.spProTopicDetail,style: TextStyle(color: Colors.grey[200],fontSize: sp(12)),),
                                 SizedBox(height: height(3),),
                                 Text(("帖子 "+widget.info.spProInfoNum+"  |  "+"浏览 "+widget.info.spProViewNum),style: TextStyle(color: Colors.grey[200],fontSize: sp(12)),),

                               ],
                             )

                           ],
                         ),
                       ) ,
                     )

                   ],),
                 ),
               ),
               SliverToBoxAdapter(
                child:(spProCircleInfoList.length==0)?  SPClassNoDataView():SizedBox(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (c, index) {
                    var item=spProCircleInfoList[index];
                    return  GestureDetector(
                      child:Container(
                        color: Colors.white,
                        margin:EdgeInsets.only(bottom:1,),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin:EdgeInsets.symmetric(horizontal: width(15),),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: width(16),),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(width(17.5)),
                                          child: item.spProAvatarUrl.isNotEmpty?   Image.network(
                                            item.spProAvatarUrl,
                                            fit: BoxFit.fill,
                                            width: width(35),
                                            height: width(35),
                                          ):
                                          SPClassEncryptImage.asset(
                                            SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                                            fit: BoxFit.fill,
                                            width: width(35),
                                            height: width(35),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width(7),),

                                      Expanded(child:
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(item.spProNickName,style: TextStyle(color:Colors.black,fontSize: sp(16)),),
                                          Text(SPClassDateUtils.spFunDateFormatByString(item.spProAddTime, "MM-dd HH:mm"),style: TextStyle(color:Color(0xFFC5C5C5),fontSize: sp(10)),),
                                        ],
                                      ),),

                                      (spFunIsLogin()&&item.spProUserId==SPClassApplicaion.spProUserLoginInfo.spProUserId.toString()) ?  SizedBox():GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(width(2)),
                                              gradient: LinearGradient(
                                                  colors: item.spProIsFollowing=="1"? [Color(0xFFC6C6C6),Color(0xFFC6C6C6)]:[Color(0xFFFAAB2A),Color(0xFFFF9511)]
                                              ),
                                              boxShadow:item.spProIsFollowing=="1"?null:[
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
                                                Icon(item.spProIsFollowing=="1"? Icons.check:Icons.add,color: Colors.white,size: width(15),),
                                                Text( item.spProIsFollowing=="1"? "已关注":"关注",style: TextStyle(fontSize: sp(11),color: Colors.white),),

                                              ],
                                            ),
                                          ),
                                          onTap: (){
                                            if(spFunIsLogin(context: context)){
                                              SPClassApiManager.spFunGetInstance().spFunFollowUser(isFollow: item.spProIsFollowing!="1",uid: item.spProUserId,context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                                                  spProOnSuccess: (result){
                                                    if(item.spProIsFollowing!="1"){
                                                      SPClassToastUtils.spFunShowToast(msg: "关注成功");
                                                      item.spProIsFollowing="1";
                                                    }else{
                                                      item.spProIsFollowing="0";
                                                    }
                                                    if(mounted){
                                                      setState(() {});
                                                    }
                                                  }
                                              ));
                                            }
                                          }
                                      ),


                                    ],
                                  ),
                                  SizedBox(height: height(10),),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(item.title,style: TextStyle(color:Colors.black,fontSize: sp(14),fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                            SizedBox(height: width(8),),
                                            item.spProTopicTitle.isNotEmpty? Container(
                                              padding: EdgeInsets.symmetric(horizontal: width(11),vertical:width(2) ),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(300),
                                                  color: Color(0xFFEAEAEA)
                                              ),
                                              child: Text("# "+item.spProTopicTitle,style: TextStyle(fontSize: sp(12)),),
                                            ):SizedBox()
                                          ],
                                        ),
                                      ),
                                      ( (item.spProTextType=="html"&&item.spProIconUrl.isEmpty)||(item.spProTextType=="pure_text"&&item.spProImgUrls.length==0))?SizedBox():
                                      Container(
                                        margin: EdgeInsets.only(left: width(14)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(width(4)),
                                          child: Image.network(item.spProTextType=="html"?item.spProIconUrl:item.spProImgUrls[0],width: width(104),height: width(78),fit: BoxFit.cover,),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: width(16),),

                                ],
                              ),
                            ),
                            SizedBox(height: height(1),),
                         /*   Container(
                              height: 0.4,
                              color: Colors.grey[300],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child:GestureDetector(
                                    child:  Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SPClassEncryptImage.asset(
                                          ImageUtil.getImagePath("ic_share_info"),
                                          width: width(17),
                                        ),
                                        SizedBox(height: height(40),width: height(6),),
                                        Text("分享",style: TextStyle(color:Colors.black,fontSize: sp(13)),),
                                      ],
                                    ),
                                    onTap: (){

                                      showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ShareView(title: "热门推荐",spProDesContent:item.content,spProPageUrl: "${NetConfig.getBaseShareUrl()}circle_info.html?circle_info_id=${item.spProCircleInfoId}",spProIconUrl: "",);
                                          });

                                    },
                                  ),
                                ),
                                Container(
                                  width:0.4,
                                  height: height(30),
                                  color: Colors.grey[200],
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child:GestureDetector(
                                    child:  Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SPClassEncryptImage.asset(
                                          ImageUtil.getImagePath("ic_like"),
                                          width: width(17),
                                          color: item.liked ? Theme.of(context).primaryColor:null,
                                        ),
                                        SizedBox(height: height(40),width: height(6),),
                                        Text(item.spProLikeNum,style: TextStyle(color:item.liked ? Theme.of(context).primaryColor:Colors.black,fontSize: sp(13)),),
                                      ],
                                    ),
                                    onTap: (){
                                      if(!item.liked){
                                        ApiManager.getInstance().addLike(queryParameters: {"target_id":item.spProCircleInfoId,"target_type":"circle_info"},
                                            spProCallBack: HttpCallBack(spProOnSuccess: (result){
                                              item.spProLikeNum=(int.tryParse(item.spProLikeNum)+1).toString();
                                              setState(() {item.liked=true;});
                                            })
                                        );
                                      }else{
                                        ApiManager.getInstance().cancelLike(queryParameters: {"target_id":item.spProCircleInfoId,"target_type":"circle_info"},
                                            spProCallBack: HttpCallBack(spProOnSuccess: (result){
                                              item.spProLikeNum=(int.tryParse(item.spProLikeNum)-1).toString();
                                              setState(() {item.liked=false;});
                                            })
                                        );
                                      }

                                    },
                                  ),
                                ),
                                Container(
                                  width:0.4,
                                  height: height(30),
                                  color: Colors.grey[200],
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child:GestureDetector(
                                    child:  Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SPClassEncryptImage.asset(
                                          ImageUtil.getImagePath("ic_compain"),
                                          color: Color(0xFF333333),
                                          width: width(16),
                                        ),
                                        SizedBox(height: height(40),width: height(6),),
                                        Text("举报",style: TextStyle(color:Colors.black,fontSize: sp(13)),),
                                      ],
                                    ),
                                    onTap: (){
                                      if(isLogin(context:context)){
                                        NavigatorUtils.pushRoute(context, SPClassComplainPage(spProComplainType: "circle_info",spProComplainedId: item.spProCircleInfoId,));
                                      }


                                    },
                                  ),
                                ),
                              ],
                            ),*/
                          ],
                        ),
                      ) ,
                      onTap: (){

                        SPClassApiManager.spFunGetInstance().SpFunCircleInfo<SPClassCircleInfo>(context:context,params:{"circle_info_id":item.spProCircleInfoId},spProCallBack:SPClassHttpCallBack(
                            spProOnSuccess : (value){
                              SPClassNavigatorUtils.spFunPushRoute(context, SPClassCircleInfoDetailPage(value));
                            }));
                      },
                    );
                  },
                  childCount: spProCircleInfoList.length,
                ),
              ),
            ]),
      ),
    );
  }
  spFunBuildPics(List<String> spProImgUrls) {

    return spProImgUrls.map((pic){
      return  GestureDetector(
        child: Container(

          child: Image.network(pic,
            fit: BoxFit.cover,

          ),
        ),
      );
    }).toList();

  }

  Future<void>  spFunOnRefresh() async {

    return SPClassApiManager.spFunGetInstance().spFunGetCircleInfo<SPClassCircleInfo>(queryParameters: {"ref_circle_info_id":"0","topic_title":widget.info.spProTopicTitle},
        spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
          spProRefreshController.resetLoadState();
          spProCircleInfoList= result.spProDataList;
            setState(() {
            });

        },onError: (e){
          spProRefreshController.finishRefresh(success: false);

        })
    );



  }

  Future<void>  spFunOnMore() async {

    return SPClassApiManager.spFunGetInstance().spFunGetCircleInfo<SPClassCircleInfo>(queryParameters: {"ref_circle_info_id":spProCircleInfoList[spProCircleInfoList.length-1].spProCircleInfoId,"direction":"after","topic_title":widget.info.spProTopicTitle},
        spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
          if (result.spProDataList.length == 0) {
            spProRefreshController.finishLoad(noMore: true);
          } else {
          }
          if (mounted) {
            setState(() {
              spProCircleInfoList.addAll(result.spProDataList);
            });
          }

        },onError: (e){
          spProRefreshController.finishLoad(success: false);

        })
    );


  }
}