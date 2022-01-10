import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class SPClassWebView extends StatefulWidget {
  @override
  _SPClassWebViewState createState() => _SPClassWebViewState();
}

class _SPClassWebViewState extends State<SPClassWebView> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      initialUrl: "https://flutterchina.club/",
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
