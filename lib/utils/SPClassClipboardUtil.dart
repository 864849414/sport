//复制粘贴
import 'package:flutter/services.dart';
import 'package:sport/utils/SPClassToastUtils.dart';

class SPClassClipboardUtil {
  //复制内容
  static setData(String data) {
    if (data != null && data != '') {
      Clipboard.setData(ClipboardData(text: data));
    }
  }

  //复制内容
  static setDataToast(String data) {
    if (data != null && data != '') {
      Clipboard.setData(ClipboardData(text: data));
      SPClassToastUtils.spFunShowToast(msg: "复制成功");
    }
  }

  //复制内容
  static setDataToastMsg(String data, {String toastMsg = '复制成功'}) {
    if (data != null && data != '') {
      Clipboard.setData(ClipboardData(text: data));
    }
  }

  //获取内容
  static Future getData() {
    return Clipboard.getData(Clipboard.kTextPlain);
  }

//使用
//   ClipboardUtil.setData('123');
//   ClipboardUtil.getData().then((data){}).catchError((e){});

}
