

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/model/SPClassCommentList.dart';
import 'package:sport/model/SPClassCircleInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/utils/SPClassToastUtils.dart';

import 'package:sport/utils/api/SPClassNetConfig.dart';import 'package:sport/pages/common/SPClassShareView.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:sport/SPClassEncryptImage.dart';


class SPClassCircleInfoDetailPage extends StatefulWidget{
  SPClassCircleInfo info;

  SPClassCircleInfoDetailPage(this.info);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassCircleInfoDetailPageState();
  }


}

class SPClassCircleInfoDetailPageState extends State<SPClassCircleInfoDetailPage>{
  List<SPClassCommentItem> spProCommentList=List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 //   getComments();
    SPClassApiManager.spFunGetInstance().spFunCircleInfoClick(queryParameters: {"circle_info_id":widget.info.spProCircleInfoId});

    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="comment:info"){
       // getComments();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(context,
        title: "详情",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: buildItems(),
          ),
        ),
      ),
      /*bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(width: 1,color: Colors.grey[200]))
        ),
        height: height(50),
        child: Row(
           children: <Widget>[
             SizedBox(width: width(15),),
             Flexible(
               fit: FlexFit.tight,
               flex: 1,
               child:GestureDetector(
                 child: Container(
                   decoration: BoxDecoration(
                       color: Color(0xFFF1F1F1),
                       borderRadius: BorderRadius.circular(height(15))
                   ),
                   height: height(30),
                   padding: EdgeInsets.only(left: 10),
                   alignment: Alignment.centerLeft,
                   child: Text("说说你的看法",style: TextStyle(color: Color(0xFFAAAAAA),fontSize: sp(11)),),
                 ) ,
                 onTap: (){
                   NavigatorUtils.pushRoute(context,  newConmmentPage(widget.info));
                 },
               ) ,
             ),
             SizedBox(width: width(10),),
             GestureDetector(
               child:  SPClassEncryptImage.asset(
                 ImageUtil.getImagePath('ic_share_info'),
                 fit: BoxFit.contain,
                 width: width(21),
               ),
               onTap: (){
                 showShare();
               },
             ),
             SizedBox(width: width(20),),
           ],
        ),
      ),*/
    );
  }


  void getComments() {

 /*   AppApi.getInstance().getComment(context, false, {"target_id":widget.info.spProCircleInfoId,"target_type":"circle_info"}).then((result){

      if(result.isSuccess()){
        spProCommentList=CommentList.fromJson(result.data).spProCommentList;
        setState(() {});
      }
    });*/
  }

  buildItems() {
    List<Widget> list=List();



    list.add(Container(
      color: Colors.white,
      padding: EdgeInsets.all(height(17)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(width(17.5)),
                    child: widget.info.spProAvatarUrl.isNotEmpty?   Image.network(
                      widget.info.spProAvatarUrl,
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
                    Text(widget.info.spProNickName,style: TextStyle(color:Colors.black,fontSize: sp(16)),),
                    Text(SPClassDateUtils.spFunDateFormatByString(widget.info.spProAddTime, "yyyy - MM-dd HH:mm"),style: TextStyle(color:Color(0xFF333333),fontSize: sp(12)),),
                  ],
                ),),

                (spFunIsLogin()&&widget.info.spProUserId==SPClassApplicaion.spProUserLoginInfo.spProUserId.toString()) ?  SizedBox():GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width(2)),
                        gradient: LinearGradient(
                            colors: widget.info.spProIsFollowing=="1"? [Color(0xFFC6C6C6),Color(0xFFC6C6C6)]:[Color(0xFFFAAB2A),Color(0xFFFF9511)]
                        ),
                        boxShadow:widget.info.spProIsFollowing=="1"?null:[
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
                          Icon(widget.info.spProIsFollowing=="1"? Icons.check:Icons.add,color: Colors.white,size: width(15),),
                          Text( widget.info.spProIsFollowing=="1"? "已关注":"关注",style: TextStyle(fontSize: sp(11),color: Colors.white),),

                        ],
                      ),
                    ),
                    onTap: (){
                      if(spFunIsLogin(context: context)){
                        SPClassApiManager.spFunGetInstance().spFunFollowUser(isFollow: widget.info.spProIsFollowing!="1",uid: widget.info.spProUserId,context: context,spProCallBack: SPClassHttpCallBack<SPClassBaseModelEntity>(
                            spProOnSuccess: (result){
                              if(widget.info.spProIsFollowing!="1"){
                                SPClassToastUtils.spFunShowToast(msg: "关注成功");
                                widget.info.spProIsFollowing="1";
                              }else{
                                widget.info.spProIsFollowing="0";
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
          SizedBox(height: height(13),),
          Text( widget.info.title,style: TextStyle(color:Colors.black,fontSize: sp(16),fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
          SizedBox(height: height(13),),
          widget.info.spProTextType=="pure_text" ?Row(
            children: <Widget>[
              Expanded(
                child:Text( widget.info.content,style: TextStyle(color:Colors.black,fontSize: sp(16)),),
              )
            ],
          ): MarkdownBody(
            shrinkWrap: true,
            fitContent: true,
            data: html2md.convert(widget.info.content),
          ),
          SizedBox(height: height(17),),
        ],
      ),
    ));
    if(widget.info.spProTextType=="pure_text"){
      list.addAll( widget.info.spProImgUrls.map((picItem){
        return Container(
          padding: EdgeInsets.only(left: width(17),right: width(17)),
          child: Image.network(picItem,
            width: ScreenUtil.screenWidth,
          ),
        );
      }).toList());
    }
    list.add(Container(
      height: 1,
      color: Colors.grey[200],
    ));
  /*  list.add(Container(
      color: Colors.white,
      child:  Row(
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
                  SizedBox(height: height(48),width: height(6),),
                  Text("分享",style: TextStyle(color:Colors.black,fontSize: sp(13)),),
                ],
              ),
              onTap: (){
                 showShare();
              },
            ),
          ),
          Container(
            width: 1,
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
                    color: widget.info.liked ? Theme.of(context).primaryColor:null,
                  ),
                  SizedBox(height: height(48),width: height(6),),
                  Text(widget.info.spProLikeNum,style: TextStyle(color:widget.info.liked ? Theme.of(context).primaryColor:Colors.black,fontSize: sp(13)),),
                ],
              ),
              onTap: (){

                if(!widget.info.liked){
                  ApiManager.getInstance().addLike(queryParameters: {"target_id":widget.info.spProCircleInfoId,"target_type":"circle_info"},
                      spProCallBack: HttpCallBack(spProOnSuccess: (result){
                        widget.info.spProLikeNum=(int.tryParse(widget.info.spProLikeNum)+1).toString();
                        setState(() {widget.info.liked=true;});
                      })
                  );
                }else{
                  ApiManager.getInstance().cancelLike(queryParameters: {"target_id":widget.info.spProCircleInfoId,"target_type":"circle_info"},
                      spProCallBack: HttpCallBack(spProOnSuccess: (result){
                        widget.info.spProLikeNum=(int.tryParse(widget.info.spProLikeNum)-1).toString();
                        setState(() {widget.info.liked=false;});
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
                  NavigatorUtils.pushRoute(context, SPClassComplainPage(spProComplainType: "circle_info",spProComplainedId: widget.info.spProCircleInfoId,));
                }


              },
            ),
          ),
        ],
      ),
    ));*/
   /* list.add( Container(
       color: Color(0xFFEBEBEB),
        height: height(10),));
      list.add( Container(
        color: Color(0xFFF8F8F8),
       margin:  EdgeInsets.only(left: width(15)),
        height: height(30),
        alignment: Alignment.centerLeft,
         child: Text("热门评论",style: TextStyle(color:Colors.black,fontSize: sp(13)),),
    ));*/



  /*  list.addAll( spProCommentList.map((commentItem){
      return Container(
        padding: EdgeInsets.only(left: width(13),right:width(13) ,top: height(18),),

        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(right:width(12) ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width(17.5)),
                child: commentItem.spProAvatarUrl.isNotEmpty?   Image.network(
                  commentItem.spProAvatarUrl,
                  fit: BoxFit.fill,
                  width: width(35),
                  height: width(35),
                ):
                SPClassEncryptImage.asset(
                  ImageUtil.getImagePath("ic_default_avater"),
                  fit: BoxFit.fill,
                  width: width(35),
                  height: width(35),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text( commentItem.spProNickName,style: TextStyle(color:Color(0xFFE3494B),fontSize: sp(13)),),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Row(
                           mainAxisAlignment:MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SPClassEncryptImage.asset(
                                    ImageUtil.getImagePath("ic_comment_like"),
                                    width: width(17),
                                    color: commentItem.liked ? Theme.of(context).primaryColor:null,
                                  ),
                                  SizedBox(width: height(6),),
                                  Text(commentItem.spProLikeNum,style: TextStyle(color:Colors.black,fontSize: sp(13)),),
                                ],
                              ),
                              onTap: (){
                                if(!commentItem.liked){
                                  AppApi.getInstance().addLike(context, true, {"target_id":commentItem.spProCommentId,"target_type":"comment"}).then((result){
                                    if(result.isSuccess()){
                                      setState(() {commentItem.liked=true;});
                                    }
                                  });
                                }else{
                                  AppApi.getInstance().cancelLike(context, true, {"target_id":commentItem.spProCommentId,"target_type":"comment"}).then((result){
                                    if(result.isSuccess()){
                                      setState(() {commentItem.liked=false;});
                                    }
                                  });
                                }

                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:Text(commentItem.content,style: TextStyle(color:Colors.black,fontSize: sp(16)),),
                      )
                    ],
                  ),
                  SizedBox(height: height(5),),
                  Row(
                    children: <Widget>[
                      Text( commentItem.spProAddTime.substring(5),style: TextStyle(color:Color(0xFF333333),fontSize: sp(11)),),
                      SizedBox(width: width(5),),


                     GestureDetector(
                       child:  Container(
                         padding: EdgeInsets.only(left: width(5),right: width(5)),
                         alignment: Alignment.centerLeft,
                         decoration: BoxDecoration(
                             color: Color(0xFFF2F3F3),
                             borderRadius: BorderRadius.circular(height(11))
                         ),
                         height: height(20),
                         child:Text( int.parse(commentItem.spProReplyNum)>0 ?'${commentItem.spProReplyNum}条回复':"回复",style: TextStyle(color:Color(0xFF333333),fontSize: sp(11)),),
                       ),
                       onTap: (){
                         NavigatorUtils.pushRoute(context,  newConmmentPage(widget.info,spProReplyCommentId: commentItem.spProCommentId,spProReplyName: commentItem.spProNickName,));
                       },
                     )

                    ],
                  ),
                  SizedBox(height: height(10),),
                  Container(
                    height: 1,
                    color: Colors.grey[200],
                  )

                ],
              ),
            )

          ],
        ),
      );
    }).toList());*/


    return list;

  }

  void showShare() {

    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SPClassShareView(title: "热门推荐",spProDesContent:widget.info.content,spProPageUrl: "${SPClassNetConfig.spFunGetBaseShareUrl()}circle_info.html?circle_info_id=${widget.info.spProCircleInfoId}",spProIconUrl: "",);
        });



  }

}