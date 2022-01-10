
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassExpertListEntity.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';
import 'SPClassExpertDetailPage.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassSearchExpertPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassSearchExpertPageState();
  }

}

class SPClassSearchExpertPageState extends State<SPClassSearchExpertPage>{
  var spProSearchKey="";
  List<SPClassExpertListExpertList> spProExpertList=List();
  TextEditingController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing:0,
        title: Container(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: width(13)) ,
            padding: EdgeInsets.only(left: width(13),right: width(13),),
            height: height(32),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height(16)),
                color: Colors.white
            ),
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: SPClassEncryptImage.asset(
                    SPClassImageUtil.spFunGetImagePath("ic_search"),
                    width: width(16),
                    color: Color(0xFFDDDDDD),
                  ),
                ),
                SizedBox(width: 7,),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: height(5)),
                    alignment: Alignment.center,
                    child: TextField(
                      cursorWidth: 1,
                      autofocus: true,
                      controller: controller,
                      cursorColor: Color(0xFF666666),
                      textInputAction: TextInputAction.search,
                      style: TextStyle(fontSize: sp(15),color:Color(0xFF333333),textBaseline: TextBaseline.alphabetic,),
                      decoration: InputDecoration(
                          hintText: "搜索专家",
                          hintStyle:  TextStyle(fontSize: sp(13),color:Color(0xFFDDDDDD)),
                          contentPadding: EdgeInsets.only(bottom: sp(15)),
                          border: InputBorder.none
                      ),
                      onEditingComplete: (){
                        spFunOnSearchExpert(showToast: true);
                      },
                      onChanged: (value){
                        if(mounted){
                          setState(() {
                            spProSearchKey=value;
                          });
                        }
                        spFunOnSearchExpert(showToast: false,spProIsLoading: false);
                      },
                    ),
                  ),
                ),
                spProSearchKey.length>0? GestureDetector(
                  child:Container(
                    height: width(16),
                    width: width(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width(8)),
                        color: Color(0xFFDDDDDD)
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.close,color: Colors.white,size: width(12)),
                  ),
                  onTap: (){
                    controller.clear();

                    if(mounted){
                      setState(() {
                        spProSearchKey="";
                      });
                    }
                  },
                ):SizedBox()
              ],
            ),
          ),
        ),
        actions: <Widget>[
         GestureDetector(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: width(13),right: width(13),),
              child: Text("取消",style: TextStyle(fontSize: sp(16),color: Colors.white)),
            ),
            onTap: (){
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: spProExpertList.length,
          itemBuilder:(c,index){
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(width(10)),
            decoration: BoxDecoration(
              color: Colors.white,
                border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]))
            ),
            child:Row(
              children: <Widget>[
                Container(
                  child: SPClassEncryptImage.asset(
                    SPClassImageUtil.spFunGetImagePath("ic_search"),
                    width: width(16),
                    color: Color(0xFFDDDDDD),
                  ),
                ),
                SizedBox(width: 10,),
                 Expanded(
                   child:Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[


                       ClipRRect(
                         borderRadius: BorderRadius.circular(width(20)),
                         child:( spProExpertList[index]?.spProAvatarUrl==null||spProExpertList[index].spProAvatarUrl.isEmpty)? SPClassEncryptImage.asset(
                           SPClassImageUtil.spFunGetImagePath("ic_default_avater"),
                           width: width(40),
                           height: width(40),
                         ):Image.network(
                           spProExpertList[index].spProAvatarUrl,
                           width: width(40),
                           height: width(40),
                           fit: BoxFit.fill,
                         ),
                       ),
                       SizedBox(width: width(5),),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Text(spProExpertList[index].spProNickName,style: TextStyle(color: Color(0xFF333333),fontSize: sp(13)),),
                           SizedBox(height: height(4),),
                           Row(
                             children: <Widget>[
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
                                       "${spProExpertList[index].spProLast10Result.length.toString()}"+
                                       "中"+
                                       "${spProExpertList[index].spProLast10CorrectNum}",style: TextStyle(fontSize: sp(9),color: Colors.white,letterSpacing: 1),),
                                 ),
                                 visible:  (spProExpertList[index].spProSchemeNum!=null&&(double.tryParse(spProExpertList[index].spProLast10CorrectNum)/double.tryParse(spProExpertList[index].spProLast10Result.length.toString()))>=0.6),
                               ),
                               SizedBox(width: 3,),
                               int.tryParse( spProExpertList[index].spProCurrentRedNum)>2?  Stack(
                                 children: <Widget>[
                                   SPClassEncryptImage.asset(spProExpertList[index].spProCurrentRedNum.length>1  ? SPClassImageUtil.spFunGetImagePath("ic_recent_red2"):SPClassImageUtil.spFunGetImagePath("ic_recent_red"),
                                     height:width(16) ,
                                     fit: BoxFit.fitHeight,
                                   ),
                                   Positioned(
                                     left: width(spProExpertList[index].spProCurrentRedNum.length>1  ? 5:7),
                                     bottom: 0,
                                     top: 0,
                                     child: Container(
                                       alignment: Alignment.center,
                                       child: Text("${spProExpertList[index].spProCurrentRedNum}",style: GoogleFonts.roboto(textStyle: TextStyle(color:Color(0xFFDE3C31) ,fontSize: sp(14.8),fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
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
                           )

                         ],

                       ),
                       SizedBox(width: 5,),
                     ],
                   ) ,
                 ),

                GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width(5)),
                          gradient: LinearGradient(
                              colors: spProExpertList[index].spProIsFollowing? [Color(0xFFC6C6C6),Color(0xFFC6C6C6)]:[Color(0xFFF1585A),Color(0xFFF77273)]
                          )
                      ),
                      alignment: Alignment.center,
                      width: width(57),
                      height: width(27),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(spProExpertList[index].spProIsFollowing?Icons.check:Icons.add,color:Colors.white,size: width(13),),
                          Text(spProExpertList[index].spProIsFollowing? "已关注":"关注",style: TextStyle(fontSize: sp(12),color: Colors.white),),

                        ],
                      ),
                    ),
                    onTap: (){
                      if(spFunIsLogin(context: context)){
                        SPClassApiManager.spFunGetInstance().spFunFollowExpert(isFollow: !spProExpertList[index].spProIsFollowing,spProExpertUid: spProExpertList[index].spProUserId,context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                            spProOnSuccess: (result){
                              if(!spProExpertList[index].spProIsFollowing){
                                SPClassToastUtils.spFunShowToast(msg: "关注成功");
                                spProExpertList[index].spProIsFollowing=true;
                              }else{
                                spProExpertList[index].spProIsFollowing=false;
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
          ),
          onTap: (){
            if(spFunIsLogin(context: context)){
              SPClassApiManager.spFunGetInstance().spFunExpertInfo(queryParameters: {"expert_uid":spProExpertList[index].spProUserId},
                  context:context,spProCallBack: SPClassHttpCallBack(
                      spProOnSuccess: (info){
                        SPClassNavigatorUtils.spFunPopAll(context);
                        SPClassNavigatorUtils.spFunPushRoute(context,  SPClassExpertDetailPage(info));
                      }
                  ));
            }

          },
        );
      }),
    );
  }

  spFunOnSearchExpert({bool showToast,bool  spProIsLoading:true}){
    if(spProSearchKey.isEmpty){
      return;
    }
    SPClassApiManager.spFunGetInstance().spFunExpertList(queryParameters: {"search_key":spProSearchKey},spProIsLoading: spProIsLoading,context: context,spProCallBack: SPClassHttpCallBack<SPClassExpertListEntity>(
        spProOnSuccess: (list){

          if(list?.spProExpertList!=null){
            if(mounted){
              setState(() {
               spProExpertList=list.spProExpertList;
              });
            }
          }
          if(spProExpertList.length==0&&showToast){
            SPClassToastUtils.spFunShowToast(msg: "暂无相关数据");
          }

        }
    ));
  }



}