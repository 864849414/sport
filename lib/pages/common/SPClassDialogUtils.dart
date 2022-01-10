import 'package:flutter/material.dart';
import 'package:sport/pages/common/SPClassLoadingBall.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';

class SPClassDialogUtils {

  static void spFunShowConfirmDialog(BuildContext context,Widget showChild,VoidCallback callback,{bool barrierDismissible=true,bool showCancelBtn:true}){
    showDialog<void>(context: context, barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
           return WillPopScope(
          child: Dialog(
              child: Container(
                height: width(210),
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child:showChild ,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        showCancelBtn? Expanded(
                         child:  GestureDetector(
                           child: Container(
                             alignment: Alignment.center,
                             height: width(45),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(5),
                                 border: Border.all(color: Colors.grey[200],width: 1)
                             ),
                             child: Text("取消",style: TextStyle(fontSize: sp(16),color: Color(0xFF333333)),),
                           ),
                           onTap: (){
                             Navigator.of(context).pop();
                           },
                         ),
                       ):SizedBox(),
                        showCancelBtn?  SizedBox(width: width(20),):SizedBox(),
                        Expanded(child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            height: width(45),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFE3494B),
                            ),
                            child: Text("确定",style: TextStyle(fontSize: sp(16),color: Colors.white),),
                          ),
                          onTap: (){
                            callback();
                            Navigator.of(context).pop();
                          },
                        ),)
                      ],
                    ),
                  ],
                ),
              )
          ),
          onWillPop: () async {
            return barrierDismissible;
          },
        );
      },
    );// user must tap button!)
  }


  static void spFunShowLoadingDialog(BuildContext context,{bool barrierDismissible=false,String content,VoidCallback dismiss}){
    showDialog<void>(context: context, barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
              child: Container(
                height: width(120),
                child: Center(
                  child: SPClassLoadingBall(content: content,dismiss: dismiss,),
                ),
              ),
          ),
          onWillPop: () async {
            return barrierDismissible;
          },
        );
      },
    );// user must tap button!)
  }

  static Future<T> spFunShowTranslateDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    @Deprecated(
        'Instead of using the "child" argument, return the child from a closure '
            'provided to the "builder" argument. This will ensure that the BuildContext '
            'is appropriate for widgets built in the dialog.'
    ) Widget child,
    WidgetBuilder builder,
  }) {
    assert(child == null || builder == null);
    assert(debugCheckHasMaterialLocalizations(context));

    final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = child ?? Builder(builder: builder);
        return SafeArea(
          child: Builder(
              builder: (BuildContext context) {
                return theme != null
                    ? Theme(data: theme, child: pageChild)
                    : pageChild;
              }
          ),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations
          .of(context)
          .modalBarrierDismissLabel,
      barrierColor:Color(0x03000000),
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _spFunBuildMaterialDialogTransitions,
    );

  }


 static Widget _spFunBuildMaterialDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}