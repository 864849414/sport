import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassExpertListEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'package:sport/utils/SPClassLogUtils.dart';
import 'package:sport/pages/anylise/SPClassExpertDetailPage.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/pages/home/SPClassHomePage.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassExpertListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassExpertListPageState();
  }

}

class SPClassExpertListPageState extends State<SPClassExpertListPage> with TickerProviderStateMixin ,AutomaticKeepAliveClientMixin{

   EasyRefreshController controller;
   ScrollController scrollController;
   List<SPClassExpertListExpertList> spProExpertList=List();
   List<String> spProChartList=List();
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=EasyRefreshController();
    scrollController=ScrollController();
    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event.startsWith("scheme:refresh")){

        spFunOnRefresh();

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return  Stack(
      children: <Widget>[
        Container(
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
          padding: EdgeInsets.only(top: height(5)),
          margin: EdgeInsets.only(left: width(10),right: width(10),top: width(10)),
          child: EasyRefresh.custom(
            controller: controller,
            onRefresh: spFunOnRefresh,
            scrollController: scrollController,
            firstRefresh: true,
            header: SPClassBallHeader(
                textColor: Color(0xFF666666)
            ),
            emptyWidget: spProExpertList.length==0? SPClassNoDataView():null,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    var item=spProExpertList[index];
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: height(14),right: height(14),top: height(14)),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
                        ),
                        height: width(102),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[

                                Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child:( item?.spProAvatarUrl==null||item.spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                                        SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                                        width: width(40),
                                        height: width(40),
                                      ):Image.network(
                                        item.spProAvatarUrl,
                                        width: width(40),
                                        height: width(40),
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

                                SizedBox(height: height(6),),
                                GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(width(2)),
                                        gradient: LinearGradient(
                                            colors: item.spProIsFollowing? [Color(0xFFC6C6C6),Color(0xFFC6C6C6)]:[Color(0xFFF2150C),Color(0xFFF24B0C)]
                                        ),
                                        boxShadow:item.spProIsFollowing?null:[
                                          BoxShadow(
                                            offset: Offset(3,3),
                                            color: Color(0x4DF23B0C),
                                            blurRadius:width(5,),),
                                          BoxShadow(
                                            offset: Offset(-2,1),
                                            color: Color(0x4DF23B0C),
                                            blurRadius:width(5,),),
                                        ],
                                      ),
                                      width: width(47),
                                      height: width(20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(item.spProIsFollowing? Icons.check:Icons.add,color: Colors.white,size: width(10),),
                                          Text( item.spProIsFollowing? "已关注":"关注",style: TextStyle(fontSize: sp(10),color: Colors.white),),

                                        ],
                                      ),
                                    ),
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
                            SizedBox(width: width(6),),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text("${item.spProNickName}",style: TextStyle(fontSize: sp(14),color: Color(0xFF333333)),),
                                                SizedBox(width: 3,),
                                                Visibility(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: width(5),right:  width(5),top: width(0.8)),
                                                    alignment: Alignment.center,
                                                    height: width(16),
                                                    constraints: BoxConstraints(
                                                        minWidth: width(52)
                                                    ),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [Color(0xFFF2150C),Color(0xFFF24B0C)]
                                                      ),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child:Text("近"+
                                                        "${item.spProLast10Result.length.toString()}"+
                                                        "中"+
                                                        "${item.spProLast10CorrectNum}",style: TextStyle(fontSize: sp(9),color: Colors.white,letterSpacing: 1),),
                                                  ),
                                                  visible:  (item.spProSchemeNum!=null&&(double.tryParse(item.spProLast10CorrectNum)/double.tryParse(item.spProLast10Result.length.toString()))>=0.6),
                                                ),
                                                SizedBox(width: 3,),
                                                int.tryParse( item.spProCurrentRedNum)>2?  Stack(
                                                  children: <Widget>[
                                                    SPClassEncryptImage.asset(item.spProCurrentRedNum.length>1  ? SPClassImageUtil.spFunGetImagePath("ic_recent_red2"):SPClassImageUtil.spFunGetImagePath("ic_recent_red"),
                                                      height:width(16) ,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                    Positioned(
                                                      left: width(item.spProCurrentRedNum.length>1  ? 5:7),
                                                      bottom: 0,
                                                      top: 0,
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: Text("${item.spProCurrentRedNum}",style: GoogleFonts.roboto(textStyle: TextStyle(color:Color(0xFFDE3C31) ,fontSize: sp(14.8),fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: width(7),
                                                      bottom: 0,
                                                      top: 0,
                                                      child: Container(
                                                        padding: EdgeInsets.only(top: width(0.8)),
                                                        alignment: Alignment.center,
                                                        child: Text("连红",style: TextStyle(color:Colors.white ,fontSize: sp(9),fontStyle: FontStyle.italic)),
                                                      ),
                                                    )
                                                  ],
                                                ):SizedBox()
                                              ],
                                            ),
                                            SizedBox(height: width(2),),
                                            (item.spProGoodAtLeagues==null||item.spProGoodAtLeagues.isEmpty)?SizedBox(): Row(
                                              children: <Widget>[
                                                Text("擅长联赛：",style: TextStyle(fontSize: sp(11),color: Color(0xFF333333)),),
                                                Text("${item.spProGoodAtLeagues}",style: TextStyle(fontSize: sp(11),color: Color(0xFFDE3C31)),),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Stack(
                                         alignment: Alignment.topRight,
                                        children: <Widget>[
                                          SizedBox(height: width(40),child: Text("近10场回报率",style: TextStyle(
                                              fontSize: sp(10),
                                              letterSpacing: 0,
                                              wordSpacing: 0,
                                              color: Colors.white)),),
                                          Text("${(double.tryParse(item.spProRecentProfitSum)*100).toStringAsFixed(0)}%",
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              textStyle: TextStyle(
                                                letterSpacing: 0,
                                                wordSpacing: 0,
                                                fontSize: sp(24),
                                                color: Color(0xFFE3494B),),),
                                          ),
                                          Positioned(
                                            child:  Text("近10场回报率",style: TextStyle(
                                                fontSize: sp(10),
                                                letterSpacing: 0,
                                                wordSpacing: 0,
                                                color: Color(0xFF666666)),
                                            ),
                                            right: 0,
                                            bottom: 0,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height(5),),
                                  Text("${item.intro}",style: TextStyle(fontSize: sp(11),color: Color(0xFF666666)),maxLines: 2,overflow: TextOverflow.ellipsis,)

                                ],
                              ),
                            ),
                            SizedBox(width: 3,),


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
                  },
                  childCount: spProExpertList.length,
                ),
              ),
            ],
          ),

        ),
        Positioned(
          top: 0,
          right: width(10),
          bottom: 0,
          child: Container(
            width: width(10),
            alignment: Alignment.center,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: spProChartList.length,
                itemBuilder: (c,index){
                  var item= spProChartList[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Text(item,style: TextStyle(color: Color(0xFF202020),fontSize: sp(9)),),
                    onTap: (){
                      spFunSearchChatPosition(item);
                    },
                  );
                }),
          ),
        )
      ],
    ) ;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

   Future<void>  spFunOnRefresh() async{
     await  SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"fetch_type":"all","${SPClassHomePageState.spProHomeMatchTypeKey}":"1"},spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
         spProOnSuccess: (list){
           controller.finishLoad(success: true);
           controller.resetRefreshState();

           spProChartList.clear();
           list.spProExpertList.forEach((item){
             if(item.spProNickNamePy!=null&&item.spProNickNamePy.isNotEmpty){
               if(spProChartList.indexOf(item.spProNickNamePy.substring(0,1))==-1){
                 spProChartList.add(item.spProNickNamePy.substring(0,1));
               }
             }

           });
           if(mounted){
             setState(() {
               spProExpertList=list.spProExpertList;
             });
           }

         },
         onError: (value){
           controller.finishLoad(success: false);
         }
     ));
   }

  void spFunSearchChatPosition(String value) {
    double index;
    spProExpertList.forEach((item){
      if(index==null&&item.spProNickNamePy!=null&&item.spProNickNamePy.isNotEmpty){
        if(item.spProNickNamePy.substring(0,1).contains(value)){
          index= spProExpertList.indexOf(item).toDouble();
        }
      }
    });
    SPClassLogUtils.spFunPrintLog(index.toString());
    scrollController.animateTo((width(102)*index), duration: Duration(milliseconds: 500), curve: Curves.linear);

  }




}