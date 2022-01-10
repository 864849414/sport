import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sport/SPClassEncodeUtil.dart';

import 'package:sport/SPClassEncryptImage.dart';

// ignore: must_be_immutable
class SPClassEncryptImage extends StatefulWidget{
  String spProFileName;
  double height;
  BoxFit fit;
  Color color;
  double width;
  SPClassEncryptImage.asset(this.spProFileName,{this.width,this.height,this.fit:BoxFit.cover,this.color}):assert(spProFileName!=null);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassEncryptImageState();
  }
}


class SPClassEncryptImageState extends State<SPClassEncryptImage> with AutomaticKeepAliveClientMixin<SPClassEncryptImage>{
  Uint8List spProImgData;
  String spProFileName;
  Container spProContainer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFile();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    spProImgData=null;

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    if(spProImgData!=null&&widget.spProFileName!=spProFileName){
      _getFile();
    }
    return spProImgData==null? Image.asset(widget.spProFileName,
      width: widget.width,
      height: widget.height,
      color: widget.color,
      fit: widget.fit,
     ) : Image.memory(
      spProImgData,
      width: widget.width,
      height: widget.height,
      color: widget.color,
      fit: widget.fit,
    );
  }

  Future<void> _getFile() async {
    spProFileName=widget.spProFileName;
    var realPath  = widget.spProFileName.trim();
    var encryptImgPath = SPClassEncodeUtil.spFunImgPath(realPath);
    try{
      var value =await rootBundle.load(encryptImgPath);
      if(value != null){
        spProImgData = SPClassEncodeUtil.spFunDecodeImgData(value.buffer.asUint8List());
        setState(() {});
      }
    }catch(e1){
      //没有加密的图片则加载原始图片
      /*try {
        var value = await rootBundle.load(realPath);
        if (value != null) {
          spProImgData = value.buffer.asUint8List();
        }
      }catch(e2){
        SPClassUtilsLog.spFunPrintLog(e2.toString());
      }*/
    }
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

