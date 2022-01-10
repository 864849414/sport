




import 'package:flutter/cupertino.dart';
import 'package:sport/model/SPClassBaseModelEntity.dart';

class SPClassHttpCallBack<T>{
  final ValueChanged<T> spProOnSuccess;
  final ValueChanged<double> spProOnProgress;
  final ValueChanged<SPClassBaseModelEntity> onError;

  SPClassHttpCallBack({
    ValueChanged<T> spProOnSuccess,
    ValueChanged<SPClassBaseModelEntity> onError,
     ValueChanged<double> spProOnProgress,
  })  : spProOnSuccess = spProOnSuccess,
        spProOnProgress=spProOnProgress,
        onError = onError;
}