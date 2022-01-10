import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/api/SPClassApiManager.dart';
import 'package:sport/utils/api/SPClassHttpCallBack.dart';

// 添加了请求
List _list=[];
Future  _requestData(String queryContent, BuildContext context) async {
  await Future.delayed(Duration(seconds: 2), () {
    // 模拟有数据
      SPClassApiManager.spFunGetInstance().spFunGetGameList<SPClassBaseModelEntity>(gameCategory:'',gameName:queryContent,spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (scs){
           scs.data.forEach((key,value) {
            _list.add(value);
          });
        },
      )
      );
     // 模拟加载出错
//      throw AssertionError("ERROR");
  });
  return _list;

}
  class SPClassSearchGame extends SearchDelegate<String>{
    Suggestion _changeSug =new Suggestion();
  @override
  String get searchFieldLabel => '搜索游戏';
  List<Widget> buildActions(BuildContext context) {
  return  [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => query = "",
    )
  ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return FutureBuilder(
        future: _requestData(query, context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Container();
          // 当前没有连接到任何的异步任务
            case ConnectionState.waiting:
            // 连接到异步任务并等待进行交互
            case ConnectionState.active:
              print("--------->loading");
              return Container(
                child: Center(
                  child: Text("加载数据中..."),
                ),
              );
          // 连接到异步任务并开始交互
            case ConnectionState.done:
              print("--------->done");
              if(snapshot.hasError){
                print("--------->error");
                return Container(
                  child: Center(
                    child: Text("加载数据失败"),
                  ),
                );
              }else {
                print("--------->data----${snapshot}");
                return Padding(
                  padding:  EdgeInsets.only(top: width(20)),
                  child: SizedBox(
                    height: width(400),
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: _list.length,
                      itemBuilder: (context,item){
                        print('------$item');
                        print(_list[item]);
                        return Container(
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
                                            image: NetworkImage('${_list[item]['game_icon']}')
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
                                            child: Text('${_list[item]['game_name']}',
                                              style: TextStyle(fontSize:ScreenUtil().setSp(16),fontWeight: FontWeight.bold),),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(bottom: width(5)),
                                            child: Text('${123}人在玩',
                                              style: TextStyle(fontSize:ScreenUtil().setSp(12),color: Colors.red),),
                                          ),
                                          Text('${_list[item]['game_desc']}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize:ScreenUtil().setSp(12),color: Colors.grey),),
                                        ],
                                      )
                                  ),
                                  GestureDetector(
                                    onTap:(){
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
                  ),
                );
              }
          }
          return Container();
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? _changeSug.searchListTitle : _changeSug.searchListTitle.where((
        input) => input.startsWith(query)).toList();
    _changeSug.setSug(query);
    if(query.isEmpty){
      _changeSug.isEmpty();
    }else{
      _changeSug.addListener(() {});
    }
    // TODO: implement buildSuggestions
    return _changeSug.searchList.length==0?Container():
//      ListView.builder(
//      itemCount: suggestionList.length,
//      itemBuilder:(context,index) =>
//          ListTile(
//            title:RichText(
//              text: TextSpan(
//                  text:suggestionList[index].toString().substring(0,query.length) ,
//                  style: TextStyle(
//                      color:Colors.black,fontWeight: FontWeight.bold
//                  ),
//                  children:[
//                    TextSpan(
//                        text:suggestionList[index].toString().substring(query.length) ,
//                        style: TextStyle(
//                            color: Colors.grey
//                        )
//                    )
//                  ]
//              ),
//            ),
//          ),
//    );
    Padding(
      padding:  EdgeInsets.only(top: width(20)),
      child: _gameList(suggestionList)
    );
  }
  _gameList(suggestionList){
    return  SizedBox(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: suggestionList.length,
        itemBuilder: (context,index){
          return Padding(
            padding: EdgeInsets.only(right: width(12),left: width(5),bottom: width(15)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: width(85),
                      height: width(85),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage('${_changeSug._searchListImage[index]}')
                          )
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        width:width(180),
                        height: width(85),
                        padding:EdgeInsets.only(left:width(5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title:RichText(
                                text: TextSpan(
                                    text:suggestionList[index].toString().substring(0,query.length) ,
                                    style: TextStyle(
                                        color:Colors.black,fontWeight: FontWeight.bold
                                    ),
                                    children:[
                                      TextSpan(
                                          text:suggestionList[index].toString().substring(query.length) ,
                                          style: TextStyle(
                                              color: Colors.grey
                                          )
                                      )
                                    ]
                                ),
                              ),
                            ),
//                            Text('${_latelyGameList[item]['game_name']}',
//                              style: TextStyle(fontSize:ScreenUtil().setSp(20),fontWeight: FontWeight.bold),),
//                            Text('${123}人在玩',
//                              style: TextStyle(fontSize:ScreenUtil().setSp(15),color: Colors.red),),
                          ],
                        )
                    ),
                    GestureDetector(
                      child: Image.asset('assets/images/ic_play.png',
                        width: width(50),
                        height: width(50),),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
class Suggestion extends ChangeNotifier{
  List  _searchList = [];
  List _searchListTitle = [];
  List _searchListImage = [];
  List _searchListId = [];
  List get searchList => _searchList;
  List get searchListId => _searchListId;
  List get searchListImage => _searchListImage;
  List get searchListTitle => _searchListTitle;
  setSug(text) async{

      List  _list = [];
      List _title = [];
      List _image = [];
      List _id = [];
    await  SPClassApiManager.spFunGetInstance().spFunGetGameList<SPClassBaseModelEntity>(gameName:text,gameCategory:'',spProCallBack: SPClassHttpCallBack(
        spProOnSuccess: (scs){
          _list = scs.data;
          for(var i in _list){
          _id.add(i['game_id']);
          _title.add(i['game_name']);
          _image.add(i['game_icon']);
          _searchList = _list;
          _searchListId = _id;
          _searchListTitle = _title;
          _searchListImage = _image;
          }

        },
      )
      );
  }
  isEmpty(){
    _searchList = [];
    _searchListId = [];
    _searchListTitle =  [];
    _searchListImage =  [];
  }
  notifyListeners();
}
