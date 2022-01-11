
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/SPClassEncryptImage.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';


class SPClassNoDataView extends StatefulWidget{
  double height;
  Size iconSize;
  String content;

  SPClassNoDataView({this.height,this.iconSize,this.content});

  SPClassNoDataViewState createState()=>SPClassNoDataViewState();
}

class SPClassNoDataViewState extends State<SPClassNoDataView>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      height: widget.height!=null?  widget.height:MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SPClassEncryptImage.asset(
            SPClassImageUtil.spFunGetImagePath('empty'),
            fit: BoxFit.contain,
            width:widget.iconSize!=null? widget.iconSize.width: width(192),
            height:widget.iconSize!=null? widget.iconSize.height:  height(136),
          ),
          Text(widget.content==null?"暂无数据":'${widget.content}',style: TextStyle(fontSize: 16,color: Color(0xFF666666)),)
        ],
      ),
    );
  }

}