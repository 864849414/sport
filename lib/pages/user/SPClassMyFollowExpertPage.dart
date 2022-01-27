import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassExpertListEntity.dart';
import 'package:sport/pages/common/SPClassLoadingPage.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassMatchDataUtils.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/utils/colors.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/widgets/SPClassSkeletonList.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';


///关注专家
class SPClassMyFollowExpertPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMyFollowExpertPageState();
  }

}

class SPClassMyFollowExpertPageState  extends State<SPClassMyFollowExpertPage>{
  List<SPClassExpertListExpertList> spProMyFollowingList =List();
  List<SPClassExpertListExpertList> recommendedExpertsList =List();
  EasyRefreshController controller;
  int page=1;
  bool isLoaded =false;//是否加载完成
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=EasyRefreshController();
    spFunOnReFresh();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return !isLoaded?SPClassLoadingPage():
    spProMyFollowingList.isEmpty?
    Container(
        color: Colors.white,
        child: Container(
          child: EasyRefresh.custom(
            firstRefresh: true,
            controller:controller ,
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
            onRefresh: spFunOnReFresh,
            onLoad: spFunOnLoad,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SPClassNoDataView(content: '你还没有关注的专家',height: width(246),iconSize: Size(width(180),height(173)),),
                    Container(
                      margin: EdgeInsets.only(left: width(15),bottom: width(10)),
                      alignment: Alignment.centerLeft,
                      child: Text('推荐专家', style: GoogleFonts.notoSansSC(textStyle: TextStyle(color:Color(0xFF333333),),fontSize: sp(17),fontWeight: FontWeight.bold),),
                    ),
                  ]
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      child: itemWidget(recommendedExpertsList),
                    )
                  ]
                ),
              ),
            ],
          ),
        )
    )
        :
    Container(
        color: Colors.white,
        child: Container(
          child: EasyRefresh.custom(
            firstRefresh: true,
            controller:controller ,
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
            emptyWidget: spProMyFollowingList.length==0 ?SPClassNoDataView(content: '你还没有关注的专家',):null,
            onRefresh: spFunOnReFresh,
            onLoad: spFunOnLoad,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  // padding: EdgeInsets.only(top: width(12),bottom: width(12)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(width(7))
                  ),
                  child: itemWidget(spProMyFollowingList),
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget itemWidget(List<SPClassExpertListExpertList> data){
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (c,index){
          var item=data[index];
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.only(left: width(14),right: width(14),top: width(12),bottom: width(12)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child:( item?.spProAvatarUrl==null||item.spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                          SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                          width: width(46),
                          height: width(46),
                        ):Image.network(
                          item.spProAvatarUrl,
                          width: width(46),
                          height: width(46),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child:(item.spProNewSchemeNum!="null"&&int.tryParse(item.spProNewSchemeNum)>0)? Container(
                          alignment: Alignment.center,
                          width: width(12),
                          height: width(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width(6)),
                            color: Color(0xFFE3494B),
                          ),
                          child:Text(item.spProNewSchemeNum,style: TextStyle(fontSize: sp(8),color: Colors.white),),
                        ):Container(),
                      )
                    ],
                  ),
                  SizedBox(width: width(8),),
                  Expanded(
                    child: Text("${item.spProNickName}",style: TextStyle(fontSize: sp(17),color: Color(0xFF333333)),),
                  ),
                  // Text("胜率${(double.tryParse(item.spProCorrectRate) *100).toStringAsFixed(0)}%",
                  Text("胜率${(SPClassMatchDataUtils.spFunCalcBestCorrectRate(item.spProLast10Result) * 100).toStringAsFixed(0)}%",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      textStyle: TextStyle(
                        letterSpacing: 0,
                        wordSpacing: 0,
                        fontSize: sp(17),
                        color: Color(0xFFE3494B),),),
                  ),
                  SizedBox(width:width(15),),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      if(spFunIsLogin(context: context)){
                        SPClassApiManager.spFunGetInstance().spFunFollowExpert(isFollow: !item.spProIsFollowing,spProExpertUid: item.spProUserId,context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                            spProOnSuccess: (result){
                              if(!item.spProIsFollowing){
                                SPClassToastUtils.spFunShowToast(msg: "关注成功");
                                item.spProIsFollowing=true;
                              }else{
                                item.spProIsFollowing=false;
                              }
                                setState(() {});
                            }
                        ));
                      }
                    },
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: width(8),vertical: width(4)),
                      width: width(61),
                      height: width(27),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color:item.spProIsFollowing?MyColors.grey_cc: MyColors.main1,width: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(item.spProIsFollowing? Icons.check:Icons.add,color: item.spProIsFollowing?MyColors.grey_cc:MyColors.main1,size: width(15),),
                          Text(item.spProIsFollowing? "已关注":"关注",style: TextStyle(color:item.spProIsFollowing?MyColors.grey_cc: MyColors.main1,fontSize: sp(12)),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: (){
              SPClassApiManager.spFunGetInstance().spFunExpertInfo(queryParameters: {"expert_uid":item.spProUserId},
                  context:context,spProCallBack: SPClassHttpCallBack(
                      spProOnSuccess: (info){
                        SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertDetailPage(info));
                      }
                  ));
            },

          );
        });
  }

  Future<void> spFunOnReFresh() async {
    page=1;
    await  SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"fetch_type":"my_following","page":"1"},spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
      spProOnSuccess: (list){
         setState(() {
           isLoaded=true;
           spProMyFollowingList=list.spProExpertList;
         });
         SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"order_key":"correct_rate","page":1,'ranking_type':'近10场',"is_zq_expert": 1},spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
             spProOnSuccess: (list){
               setState(() {
                 recommendedExpertsList = list.spProExpertList.length>3? list.spProExpertList.sublist(0,3):list.spProExpertList;
               });
             },
             onError: (result){
             }
         ));

      },
      onError: (result){
        setState(() {
          isLoaded=true;
        });
      }
    ));
  }
  Future<void> spFunOnLoad() async{
    await  SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"fetch_type":"my_following","page":"${page+1}"},spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
      spProOnSuccess: (list){
        if(list.spProExpertList.length==0){
          controller.finishLoad(noMore: true);
        }else{
          page++;
        }
         setState(() {
           spProMyFollowingList.addAll(list.spProExpertList);
         });
      },
      onError: (result){
      }
    ));
  }



}