

class SPClassPrizeDrawInfo {
  String spProProductId;
  String price;
  String spProProductName;
  String spProAddTime;
  String status;
  String spProIconUrl;
  String spProProductType;
SPClassPrizeDrawInfo({Map json}){
  if(json!=null){
    fromJson(json);
  }
}
fromJson(Map<String,dynamic> json){

  spProProductId=json["product_id"].toString();
  spProProductType=json["product_type"].toString();
  price=json["price"].toString();
  spProProductName=json["product_name"].toString();
  spProAddTime=json["add_time"].toString();
  status=json["status"].toString();
  spProIconUrl=json["icon_url"].toString();
}


copyObject({dynamic json}){
  return new SPClassPrizeDrawInfo(json: json);
}
}