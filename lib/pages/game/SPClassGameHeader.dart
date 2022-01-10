import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/pages/game/SPClassSearchGame.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassStringUtils.dart';
class SPClassGameHeader extends StatefulWidget {
  const SPClassGameHeader({Key key}) : super(key: key);

  @override
  _SPClassGameHeaderState createState() => _SPClassGameHeaderState();
}

class _SPClassGameHeaderState extends State<SPClassGameHeader> {
  @override
  void initState() {
    // TODO: implement initState
    SPClassApplicaion.spProEventBus.on<String>().listen((event) {//人物头部
      if(event=="login:gameout"){
        SPClassApplicaion.spFunClearUserState();
        setState(() {});
      }
      if(event=="login:gamelist"){
        SPClassApplicaion.spFunGetUserInfo(isFire: false);
        setState(() {});
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SPClassApplicaion.spFunGetUserInfo(isFire: false);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width(10)),
      padding:  EdgeInsets.only(top:width(statusBarHeight),bottom:width(20) ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _user(),
          _search(),
        ],
      ),
    );
  }
  _user(){
   return Row(
     children: <Widget>[
       ClipRRect(
         borderRadius: BorderRadius.circular(width(25.5)),
         child:
         (!SPClassApplicaion.spFunIsExistUserInfo() ||
             SPClassApplicaion.spProUserInfo
                 .spProAvatarUrl.isEmpty)
             ? SPClassEncryptImage.asset(
           SPClassImageUtil.spFunGetImagePath(
               "ic_default_avater"),
           width: width(51),
           height: width(51),
         )
             : Image.network(
           SPClassApplicaion
               .spProUserInfo.spProAvatarUrl,
           fit: BoxFit.cover,
           width: width(51),
           height: width(51),
         ),
       ),
       Container(
         width: SPClassApplicaion.spFunIsExistUserInfo()?width(70):width(45),
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal:2),
           child:
           Text('${SPClassApplicaion.spFunIsExistUserInfo() ?SPClassApplicaion.spProUserInfo.spProNickName:'游客'}',
             style: TextStyle(fontSize: ScreenUtil().setSp(20)),
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
           ),
         ),
       ),
       Container(
         height: height(50),
         alignment: Alignment.centerLeft,
         child: Stack(
           children: <Widget>[
             Container(
               width: SPClassApplicaion.spFunIsExistUserInfo()?int.parse(SPClassStringUtils.spFunSqlitZero(SPClassApplicaion.spProUserInfo.spProDiamond))>99?width(50):width(38):width(38),
               height: height(16),
               margin: EdgeInsets.only(top: width(10),bottom: width(3),left: width(8)),
               decoration: BoxDecoration(
                 border: Border.all(
                  color: Colors.amber
                ),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(50),right: Radius.circular(50))
               ),
               child: Padding(
                 padding:EdgeInsets.only(right: width(5)),
                 child: Text('${SPClassApplicaion.spFunIsExistUserInfo()?SPClassStringUtils.spFunSqlitZero(SPClassApplicaion.spProUserInfo.spProDiamond):0}',
                 textAlign: TextAlign.right,
                 style: TextStyle(fontSize: ScreenUtil().setSp(10)),),
               ),
             ),
             Positioned(
               left: 0,
               top: width(2),
               width:width(28),
               child: GestureDetector(
                 onTap: (){
                 },
                 child: Image.asset('assets/images/ic_diamond.png'
                   ,alignment: Alignment.centerLeft
                   ,fit: BoxFit.fill,),
               ),
             ),
           ],
         ),
       )
     ],
   );
  }
  _search(){
    return GestureDetector(
      onTap: (){
        showSearch(context: context, delegate: SPClassSearchGame(

        ));
      },
      child: SPClassEncryptImage.asset(
        SPClassImageUtil.spFunGetImagePath("ic_search"),
        width: width(25),
        fit: BoxFit.fill,
        color: Color(0xFF333333),
      ),
    );
  }
}