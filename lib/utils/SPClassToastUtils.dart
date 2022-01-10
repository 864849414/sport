

import 'package:fluttertoast/fluttertoast.dart';

class SPClassToastUtils {


  static void spFunShowToast({String msg,ToastGravity gravity:ToastGravity.CENTER}){
    Fluttertoast.showToast(msg: msg,gravity:gravity,toastLength:Toast.LENGTH_LONG );
  }

}