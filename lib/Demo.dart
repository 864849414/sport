import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  const Demo({Key key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  void initState() {
    print('初始化');
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    print('销毁');

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.red,
      margin: EdgeInsets.only(top: 20),
    );
  }
}
