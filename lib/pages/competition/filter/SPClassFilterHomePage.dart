import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/app/SPClassApplicaion.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/pages/competition/filter/SPClassFilterleagueMatchPage.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
typedef CallBack = void Function(String value,String spProIsLottery);

class SPClassFilterHomePage extends StatefulWidget{
  bool spProIsHot;
  CallBack callback;
  String spProChooseLeagueName;
  Map<String,dynamic> param;

  SPClassFilterHomePage(this.spProChooseLeagueName,{this.param,this.callback,this.spProIsHot});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassFilterHomePageState();
  }

}

class SPClassFilterHomePageState extends State<SPClassFilterHomePage> with TickerProviderStateMixin{
  var spProTabTitle=["全部","竞彩"];
  TabController spProTabController;
  List<Widget> views;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProTabController=TabController(length: spProTabTitle.length,vsync: this);
    views=[
      SPClassFilterleagueMatchPage("",widget.spProChooseLeagueName, param: widget.param, callback: widget.callback,spProIsHot: widget.spProIsHot,),
      SPClassFilterleagueMatchPage("1",widget.spProChooseLeagueName, param: widget.param, callback: widget.callback,spProIsHot: widget.spProIsHot,),
   ];
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title:"赛事筛选",
      ),
      body: Container(
        child: Column(
          children: <Widget>[
           SPClassApplicaion.spFunIsShowIosUI() ?SizedBox():Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(width: 0.4,color: Colors.grey[300]),top: BorderSide(width: 0.4,color: Colors.grey[300]))
              ),
              child: TabBar(
                  labelColor: Color(0xFFE3494B),
                  unselectedLabelColor: Color(0xFF333333),
                  isScrollable: false,
                  indicatorColor: Color(0xFFE3494B),
                  labelStyle: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.bold),
                  unselectedLabelStyle: GoogleFonts.notoSansSC(fontSize: sp(14),fontWeight: FontWeight.w400),
                  controller: spProTabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs:spProTabTitle.map((spProTabTitle){
                    return Container(
                      alignment: Alignment.center,
                      height: height(35),
                      child:Text(spProTabTitle,style: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: sp(15)),),
                    );
                  }).toList()
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: spProTabController,
                children:views,
              ),
            )
          ],
        ),
      ),
    );
  }


}