
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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
import 'package:sport/utils/api/SPClassNetConfig.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/common/SPClassShareView.dart';
import 'package:sport/pages/hot/SPClassComplainPage.dart';
import 'package:sport/pages/hot/circleInfo/SPClassCircleInfoDetailPage.dart';
import 'package:sport/pages/hot/circleInfo/SPClassTopTitleDetailPage.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/SPClassEncryptImage.dart';



class SPClassHotCircleList extends StatefulWidget{
  String spProFetchType;

  SPClassHotCircleList(this.spProFetchType);

  SPClassHotCircleListState spProState;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return spProState=SPClassHotCircleListState();
  }

}

class SPClassHotCircleListState extends State<SPClassHotCircleList> with AutomaticKeepAliveClientMixin<SPClassHotCircleList>{
  List<SPClassCircleInfo> spProCircleInfoList=List();
  EasyRefreshController spProRefreshController;
  List<SPClassTopicInfo> spProTopicList=List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProRefreshController=EasyRefreshController();
    onRefresh();
    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="circle:refresh"||event=="delete:circle"){
        // getSeqNum();
        onRefresh();


      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Container(
      child: EasyRefresh.custom(
        topBouncing: false,
        controller:spProRefreshController ,
        header: SPClassBallHeader(
          textColor: Color(0xFF8F8F8F),
        ),
        footer: SPClassBallFooter(
          textColor: Color(0xFF8F8F8F),
        ),
        onLoad: onMore,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child:(spProCircleInfoList.length==0&&spProTopicList.length==0)?  SPClassNoDataView():SizedBox(),
          ),

          SliverToBoxAdapter(
            child:spProTopicList.length==0?  SizedBox():

            Container(
              height: width(70),
              padding: EdgeInsets.only(top: width(6)),
              decoration: BoxDecoration(
                color:Colors.white,
                border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
              ),
              alignment: Alignment.center,
              child: ScrollNotificationInterceptor(child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: spProTopicList.length,
                  itemBuilder: (c,index){
                    var item=spProTopicList[index];
                    return  GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: width(6)),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(width(5)),
                                child:   Image.network(
                                  item.spProImgUrl,
                                  fit: BoxFit.cover,
                                  width: width(105),
                                  height: width(58),
                                )
                            ),
                            Container(
                              alignment: Alignment.center,
                              width:width(105),
                              height:width(58),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(width(5)),
                              ),
                              child: Text(item.spProTopicTitle,style: TextStyle(color: Colors.white,fontSize: sp(14)),),
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        SPClassNavigatorUtils.spFunPushRoute(context, SPClassTopTitleDetailPage(item));
                      },
                    );
                  }),),
            ),
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
                        ),*/
                    /*    Row(
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
        ],
      ),
    );
  }

  Future<void>  onRefresh() async {

    if(widget.spProFetchType=="all"){
      SPClassApiManager.spFunGetInstance().spFunGetTopic<SPClassTopicInfo>(spProCallBack:SPClassHttpCallBack(spProOnSuccess: (value){
        setState(() {
         spProTopicList=value.spProDataList;

        });
      }) );
    }

    return SPClassApiManager.spFunGetInstance().spFunGetCircleInfo<SPClassCircleInfo>(queryParameters:{"ref_circle_info_id":"0","fetch_type":widget.spProFetchType},
        spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
          spProRefreshController.resetLoadState();
          spProCircleInfoList= result.spProDataList;
            setState(() {
            });

        },onError: (e){
          spProRefreshController.finishLoad(success: false);

        })
    );


  }

  Future<void>  onMore() async {

   return SPClassApiManager.spFunGetInstance().spFunGetCircleInfo<SPClassCircleInfo>(queryParameters: {"ref_circle_info_id":spProCircleInfoList[spProCircleInfoList.length-1].spProCircleInfoId,"direction":"before","fetch_type":widget.spProFetchType},
    spProCallBack: SPClassHttpCallBack(spProOnSuccess: (result){
      if (result.spProDataList.length == 0) {
        spProRefreshController.finishLoad(noMore: true);
      } else {
      }
        setState(() {
          spProCircleInfoList.addAll(result.spProDataList);
        });
    },onError: (e){
      spProRefreshController.finishLoad(success: false);

    })
   );



  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  buildPics(List<String> spProImgUrls) {

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
}