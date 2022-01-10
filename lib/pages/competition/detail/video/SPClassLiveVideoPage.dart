import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/widgets/SPClassToolBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SPClassLiveVideoPage extends StatefulWidget{
  String title;
  String url;

  SPClassLiveVideoPage({@required this.title,@required this.url});

  @override
  State<StatefulWidget> createState() => SPClassLiveVideoPageState();

}

class SPClassLiveVideoPageState extends State<SPClassLiveVideoPage>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child:Stack(
          children: <Widget>[
            WebView(
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
            Positioned(
              left: 0,top: 0,right: 0,
              height: kToolbarHeight,
              child:SPClassToolBar(
                  context,
                  spProBgColor: Colors.transparent,
                  iconColor: 0xFFFFFFFF,
                  title:"${widget.title}"
              ))
          ],
        ),
      ),
    );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

}