import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/generated/json/player_stat_list_entity_helper.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/pages/common/SPClassNoDataView.dart';
import 'package:sport/utils/SPClassClipboardUtil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';
import 'package:sport/widgets/SPClassBallFooter.dart';
import 'package:sport/widgets/SPClassBallHeader.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/pages/h5/SPClassWebView.dart';
class SPClassGameList extends StatefulWidget {
  const SPClassGameList({Key key}) : super(key: key);

  @override
  _SPClassGameListState createState() => _SPClassGameListState();
}

class _SPClassGameListState extends State<SPClassGameList> {
  List _latelyGameList = [];
  int _page =1;
  EasyRefreshController controller ;
  Future<void> _getGameList() async {//游戏列表
    if(_page==1){
     await SPClassApiManager.spFunGetInstance().spFunGetGameList<SPClassBaseModelEntity>(page: _page,limit:5,spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (scs){
          if(_page==1){
            _latelyGameList =  scs.data ;
            _page++;
          }else if(scs.data.length==0){
            controller.finishLoad(noMore: true);
            return ;
          }else{
            _latelyGameList.addAll(scs.data);
            _page++;
          }
          setState(() {});
        },
         onError: (value){
           _page =1;
           controller.finishLoad(success: false);
         }
      )
      );
    }else{
       await SPClassApiManager.spFunGetInstance().spFunGetGameList<SPClassBaseModelEntity>(page: _page,limit:5,spProCallBack: SPClassHttpCallBack(
          spProOnSuccess: (scs){
            if(_page==1){
              _latelyGameList =  scs.data ;
              _page+=1;
            }else if(scs.data.length==0){
              controller.finishLoad(noMore: true);
              controller.resetLoadState();
              return ;
            }else{
              _latelyGameList.addAll(scs.data);
              _page+=1;
            }
            setState(() {});
          },
           onError: (value){
             controller.finishLoad(success: false);
           }
        )
        );

    }


  }
  @override
  void initState (){
    _getGameList();
    controller = EasyRefreshController();
    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="login:gameout"){
        _page =1;
        _getGameList();
      }
      setState(() {});
    });

    super.initState();

  }
  Widget build(BuildContext context) {
      return   EasyRefresh.custom(
        controller: controller ,
        topBouncing: false,
        footer: SPClassBallFooter(
            textColor: Color(0xFF666666)
        ),
        onLoad: _getGameList,
        header:SPClassBallHeader(
            textColor: Color(0xFF666666)
        ),
        slivers: <Widget> [
          SliverToBoxAdapter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _latelyGameList.length,
              itemBuilder: (context,item){
                return _latelyGameList.length==0?Container():Container(
                  height:width(85),
                  padding: EdgeInsets.only(right: width(12),left: width(5),bottom: width(15)),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: width(65),
                            height: width(65),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage('${_latelyGameList[item]['game_icon']}')
                                )
                            ),
                          ),
                          Container(
                              width:width(180),
                              padding:EdgeInsets.only(left:width(5)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: width(5)),
                                    child: Text('${_latelyGameList[item]['game_name']}',
                                      style: TextStyle(fontSize:ScreenUtil().setSp(16),fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: width(5)),
                                    child: Text('${123}人在玩',
                                      style: TextStyle(fontSize:ScreenUtil().setSp(12),color: Colors.red),),
                                  ),
                                  Text('${_latelyGameList[item]['game_desc']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize:ScreenUtil().setSp(12),color: Colors.grey),),
                                ],
                              )
                          ),
                          GestureDetector(
                            onTap:(){
                              SPClassNavigatorUtils.spFunPushRoute(context,SPClassWebView());
                            },
                            child: Image.asset('assets/images/ic_play.png',
                              width: width(50),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ]);
  }


}
