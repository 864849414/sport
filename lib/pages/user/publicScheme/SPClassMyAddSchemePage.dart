import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassNavigatorUtils.dart';
import 'package:sport/pages/dialogs/SPClassAddSchemeRuleTipDialog.dart';
import 'package:sport/pages/user/publicScheme/SPClassMyAddSchemeListPage.dart';
import 'package:sport/pages/user/publicScheme/SPClassPublicSchemePage.dart';
import 'package:sport/pages/user/publicScheme/SPClassSchemeIncomeReportPage.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassMyAddSchemePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassMyAddSchemePageState();
  }

}

class SPClassMyAddSchemePageState extends State<SPClassMyAddSchemePage> with TickerProviderStateMixin {
  var spProTabTitle=["发布的方案","方案的收益"];
  TabController spProTabController;
  List<Widget> views;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spProTabController=TabController(length: spProTabTitle.length,vsync: this);
    views=[SPClassMyAddSchemeListPage(),SPClassSchemeIncomeReportPage(),];

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SPClassToolBar(
        context,
        title:"我的发布",
        actions: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: <Widget>[

                SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_shceme_public"),width: width(14),),
                SizedBox(width: width(3),),
                Text("发布",style: TextStyle(color: Color(0xFF318BDE)),),
                SizedBox(width:width(15) ,),
              ],
            ),
            onTap: (){
              SPClassNavigatorUtils.spFunPushRoute(context, SPClassPublicSchemePage());



            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
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
                    return Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: height(35),
                          child:Text(spProTabTitle,style: TextStyle(letterSpacing: 0,wordSpacing: 0,fontSize: sp(15)),),
                        ),
                       spProTabTitle=="方案的收益"? Positioned(
                          top: 0,
                          right: width(20),
                          child:   GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_rulu_tip"),width: width(12),),
                            ),
                            onTap: (){
                              showDialog(context: context,child: SPClassAddSchemeRuleTipDialog(callback: (){
                              },));
                            },
                          ),

                        ):SizedBox()
                      ],
                    );
                  }).toList()
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: spProTabController,
                children:views,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}