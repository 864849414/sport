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
import 'package:sport/utils/SPClassToastUtils.dart';

class SPClassGameGift extends StatefulWidget {
  const SPClassGameGift({Key key}) : super(key: key);

  @override
  _SPClassGameGiftState createState() => _SPClassGameGiftState();
}

class _SPClassGameGiftState extends State<SPClassGameGift> {
  List _latelyGameList = [];
  List _latelyGameGiftList = [];
  int _page =1;
  EasyRefreshController controller ;
  Future<void> _getGameList() async {
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
  _getGameGiftList() async{//模拟最近在玩数据
    await SPClassApiManager.spFunGetInstance().spFunGetGameList<SPClassBaseModelEntity>(ifExistence:'是',gameCategory:'',gameName:'',spProCallBack: SPClassHttpCallBack(
      spProOnSuccess: (scs) {
        _latelyGameGiftList = scs.data;
        setState(() {});
      },

    )
    );
  }
  _chickGetgift(int id){
    String _giftId;
    SPClassApiManager.spFunGetInstance().spFunGetGift<SPClassBaseModelEntity>(gameId: id,spProCallBack: SPClassHttpCallBack(
      spProOnSuccess: (scs){
        _giftId = scs.data;
        _getGameGiftList();
        _showDialog(_giftId);
      },
    )
    );
  }
  @override
  void initState (){
    super.initState();
    _getGameGiftList();
    _getGameList();
    SPClassApplicaion.spProEventBus.on<String>().listen((event) {
      if(event=="login:out"){
        print('重新获得礼包');
        _page =1;
        _getGameGiftList();
        _getGameList();
      }
      if(event == 'login:gamelist'){
        _page =1;
        _getGameGiftList();
        _getGameList();
      }
      setState(() {});
    });
    controller = EasyRefreshController();
  }
  _showDialog(String code){
    showDialog(context:context,builder:(BuildContext context) {
      return Stack(
        children: <Widget>[
          Positioned(
            top:width(200),
            left:width(50),
            child: Container(
              width: width(255),
              height: width(155),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(top: width(20)),
                    child: Text('兑换成功！',style: TextStyle(fontSize: ScreenUtil().setSp(16),decoration: TextDecoration.none,color: Colors.black,fontWeight: FontWeight.w100),),
                  ),
                  Container(
                    padding:  EdgeInsets.only(left: width(10)),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('兑换码:',style: TextStyle(fontSize:ScreenUtil().setSp(15),decoration: TextDecoration.none,color: Color.fromRGBO(0, 0, 0, 0.5),fontFamily: 'Raleway',fontWeight: FontWeight.w500,),),
                            Container(
                              color: Color.fromRGBO(234, 234, 234, 1),
                              width: width(75),
                              height: width(25),
                              child: Center(child: Text('$code',style: TextStyle(fontSize: ScreenUtil().setSp(15),decoration: TextDecoration.none,color: Color.fromRGBO(131, 131, 131, 1),fontFamily: 'Raleway',fontWeight: FontWeight.w400,fontStyle: FontStyle.italic,))),
                            ),
                            GestureDetector(
                              onTap: (){
                                SPClassClipboardUtil.setDataToast('$code');
                              },
                              child: Container(
                                  width: width(40),
                                  height: width(20),
                                  padding:  EdgeInsets.only(left: width(10)),
                                  child: Text(
                                    '复制',style: TextStyle(fontSize:ScreenUtil().setSp(15),color: Colors.black,decoration: TextDecoration.none,fontWeight: FontWeight.w100),
                                  )
                              ),
                            )
                          ],
                        ),
                        Text('复制兑换码，去游戏中使用',style: TextStyle(fontSize: ScreenUtil().setSp(12),color: Color.fromRGBO(0, 0, 0, 0.5),decoration: TextDecoration.none,fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Container(
                    width: width(255),
                    height: width(30),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(1.2,0.1),
                            blurRadius: 0.4,
                            spreadRadius:0.6,
                          )
                        ]
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(5)),
                                color: Colors.red
                            ),
                            child: Text('前往游戏',style: TextStyle(color: Colors.white,decoration: TextDecoration.none,fontSize: width(15),fontWeight: FontWeight.w200),),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap:(){
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomRight:  Radius.circular(5)),
                              ),
                              alignment: Alignment.center,
                              child: Text('关闭',style: TextStyle(color:Colors.black,decoration: TextDecoration.none,fontSize: width(15),fontWeight: FontWeight.w200),),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: width(10)),
      padding: EdgeInsets.only(bottom: width(10)),
      child: Column(
        children: <Widget>[
          _latelyGame(),
          _hotGift(),
        ],
      ),
    );
  }
  _latelyGame(){
    return Container(
      height: height(140),
      width:width(700),
      margin: EdgeInsets.only(top: width(10)),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset:Offset.fromDirection(3,-2)
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:  EdgeInsets.only(left: width(10),bottom: width(5),top: width(5)),
            child: Text('最近在玩',
              style: TextStyle(fontSize: ScreenUtil().setSp(17),fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              itemCount: _latelyGameList.length,
              itemBuilder: (context,item){
                return Padding(
                  padding: EdgeInsets.only(right: width(12),left: width(5)),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: width(80),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: width(65),
                              height: height(65),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage('${_latelyGameList[item]['game_icon']}')
                                  )
                              ),
                            ),
                            Text('${_latelyGameList[item]['game_name']}',
                              style: TextStyle(fontSize:ScreenUtil().setSp(14) ),)
                          ],
                        )
                      )

                    ],
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
  _hotGift(){
    return Container(
        width:width(400),
        margin: EdgeInsets.only(top: width(10)),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset:Offset.fromDirection(3,-2)
              )
            ]
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(left: width(10),bottom: width(5),top: width(5)),
                    child: Text('热门豪礼',
                      style: TextStyle(fontSize: ScreenUtil().setSp(18),fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(width(7)),
                    child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_btn_right"),
                      width: width(11),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width(260),
                child:_latelyGameGiftList.length==0?Container(): ListView.builder(
                  shrinkWrap: true,
                  physics:  NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  itemCount:3,
                  itemBuilder: (context,item){
                    return Container(
                      height: width(85),
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
                                        image: NetworkImage('${_latelyGameGiftList[item]['game_icon']}')
                                    )
                                ),
                              ),
                              Container(
                                  width:width(180),
                                  padding:EdgeInsets.only(left:width(5)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:  EdgeInsets.only(bottom: width(8)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('${_latelyGameGiftList[item]['game_name']}',
                                              style: TextStyle(fontSize:ScreenUtil().setSp(16),fontWeight: FontWeight.bold),),
                                            Padding(
                                              padding:  EdgeInsets.only(top: width(8),left: width(5)),
                                              child: Text('独家新手礼包',
                                                style: TextStyle(fontSize:ScreenUtil().setSp(10),color: Colors.red),),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(top: width(8)),
                                              child: Image.asset('assets/images/ic_giftBag.png',width: width(12),),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(bottom: width(10)),
                                        child: Text('${_latelyGameGiftList[item]['game_desc']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize:ScreenUtil().setSp(10),color: Colors.grey),
                                        ),
                                      ),
                                      Container(
                                        height: width(13),
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              child: ClipRRect(
                                                borderRadius:BorderRadius.circular(20),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:BorderRadius.circular(20),
                                              child: Align(
                                                //int.parse(_latelyGameGiftList[item]['game_pack_start_num'])
                                                widthFactor:   int.parse(_latelyGameGiftList[item]['game_pack_start_num'])==0||_latelyGameGiftList[item]['game_pack_start_num']==null?0/100:
                                                int.parse(_latelyGameGiftList[item]['game_pack_num'])/int.parse(_latelyGameGiftList[item]['game_pack_start_num']),
                                                child: Container(
                                                  height: width(13),
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            const Color.fromRGBO(149, 122, 255, 1),
                                                            const Color.fromRGBO(66, 191, 250, 1)
                                                          ]
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child:  int.parse(_latelyGameGiftList[item]['game_pack_start_num'])==0||_latelyGameGiftList[item]['game_pack_start_num']==null?
                                              Text('0/100',style: TextStyle(fontSize: ScreenUtil().setSp(10)),):
                                              Text('${ int.parse(_latelyGameGiftList[item]['game_pack_num'])}/''${int.parse(_latelyGameGiftList[item]['game_pack_start_num'])}',style: TextStyle(fontSize: ScreenUtil().setSp(10))),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              _latelyGameGiftList[item]['get_status']==null&&int.parse(_latelyGameGiftList[item]['game_pack_num'])!=0?
                              GestureDetector(
                                onTap: (){
                                  if(spFunIsLogin(context: context)){
                                    if(_chickGetgift(int.parse(_latelyGameGiftList[item]['game_id']))!=null){
                                      _chickGetgift(int.parse(_latelyGameGiftList[item]['game_id']));
                                    }
                                  }
                                },
                                child: Image.asset('assets/images/ic_gift.png',
                                  width: width(50),
                                ),
                              ):
                              (_latelyGameGiftList[item]['get_status']!=null?
                                  GestureDetector(
                                    onTap: (){
                                      if(spFunIsLogin(context: context)){
                                        if(_chickGetgift(int.parse(_latelyGameGiftList[item]['game_id']))!=null){
                                          _chickGetgift(int.parse(_latelyGameGiftList[item]['game_id']));
                                        }
                                      }
                                    },
                                    child: Image.asset('assets/images/ic_received.png',
                                      width: width(50),
                                    ),
                                  ):int.parse(_latelyGameGiftList[item]['game_pack_num'])==0?
                              GestureDetector(
                                onTap: (){
                                  SPClassToastUtils.spFunShowToast(msg: "已领完");
                                },
                                child: Image.asset('assets/images/ic_no_receive.png',
                                  width: width(50),
                                ),
                              ):Container()
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ]
        )
    );
  }


}
