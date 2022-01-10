
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/model/SPClassGuessMatchInfo.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/pages/competition/detail/SPClassMatchAnylizePage.dart';
import 'package:sport/pages/competition/detail/SPClassMatchIntelligencePage.dart';
import 'package:sport/pages/competition/detail/SPClassMatchLiveTeamPage.dart';
import 'package:sport/pages/competition/detail/basketball/SPClassMatchAnylizeBasketBallPage.dart';



class SPClassMatchAnylizeIosPage extends StatefulWidget{
  SPClassGuessMatchInfo spProGuessInfo;
  var spProMatchType="" ;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMatchAnylizeIosPageState();
  }

  SPClassMatchAnylizeIosPage(this.spProMatchType,this.spProGuessInfo);

}

class SPClassMatchAnylizeIosPageState extends State<SPClassMatchAnylizeIosPage> with AutomaticKeepAliveClientMixin{
  var spProIndex=0;
  List<Widget> views;
  PageController spProPageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProPageController=PageController();
    views=[widget.spProGuessInfo.spProMatchType=="篮球" ?
    SPClassMatchAnylizeBasketBallPage({widget.spProMatchType:widget.spProGuessInfo.spProGuessMatchId,},widget.spProGuessInfo)
        :SPClassMatchAnylizePage({widget.spProMatchType:widget.spProGuessInfo.spProGuessMatchId,},widget.spProGuessInfo),SPClassMatchLiveTeamPage(widget.spProGuessInfo),SPClassMatchIntelligencePage(widget.spProGuessInfo)];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return Container(
      color: Color(0xFFF1F1F1),
      width: ScreenUtil.screenWidth,
      child: Column(
       children: <Widget>[

          Container(
           margin: EdgeInsets.only(top: height(12),bottom: height(8)),
           width: width(320),
           height: width(33),
           child: Row(
             children: <Widget>[
               Expanded(
                 child: FlatButton(
                   padding: EdgeInsets.zero,
                   child: Container(
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(bottomLeft:Radius.circular(width(5)),topLeft: Radius.circular(width(5))),
                         border: Border.all(color: Color(0xFFDE3C31),width: 0.4),
                         color: spProIndex==0? Color(0xFFDE3C31):Colors.white
                     ),
                     alignment: Alignment.center,
                     child: Text("数据",style: TextStyle(fontSize: sp(14),color: spProIndex==0? Colors.white :Color(0xFFDE3C31)),),
                   ),
                   onPressed: (){
                     setState(() {
                       spProIndex=0;
                     });
                     spProPageController.jumpToPage(spProIndex);

                   },
                 ),
               ),
               Expanded(
                 child: FlatButton(
                   padding: EdgeInsets.zero,
                   child: Container(
                     decoration: BoxDecoration(
                         border: Border(top: BorderSide(color: Color(0xFFDE3C31),width: 0.4),bottom: BorderSide(color: Color(0xFFDE3C31),width: 0.4)),
                         color: spProIndex==1? Color(0xFFDE3C31):Colors.white
                     ),
                     alignment: Alignment.center,
                     child: Text("阵容",style: TextStyle(fontSize: sp(14),color: spProIndex==1? Colors.white :Color(0xFFDE3C31)),),
                   ),
                   onPressed: (){
                     setState(() {
                       spProIndex=1;
                     });
                     spProPageController.jumpToPage(spProIndex);

                   },
                 ),
               ),
               Expanded(
                 child: FlatButton(
                   padding: EdgeInsets.zero,
                   child: Container(
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(bottomRight:Radius.circular(width(5)),topRight: Radius.circular(width(5))),
                         border: Border.all(color: Color(0xFFDE3C31),width: 0.4),
                         color: spProIndex==2? Color(0xFFDE3C31):Colors.white
                     ),
                     alignment: Alignment.center,
                     child: Text("情报",style: TextStyle(fontSize: sp(14),color: spProIndex==2? Colors.white :Color(0xFFDE3C31)),),
                   ),
                   onPressed: (){
                     setState(() {
                       spProIndex=2;
                     });
                     spProPageController.jumpToPage(spProIndex);
                   },
                 ),
               ),
             ],
           ),
         ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: spProPageController,
              children:views,
            ),
          )

       ],
     ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



}