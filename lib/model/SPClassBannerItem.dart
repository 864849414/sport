


class SPClassBannerItem{
  String spProImgUrl;
  String spProPageUrl;
  String spProBannerId;
  String title;

  SPClassBannerItem({Map json}){
    if(json!=null){
      fromJson(json);
    }
  }
  fromJson(Map<String ,dynamic> json){
     spProImgUrl=json['img_url'];
     spProPageUrl=json['page_url'];
     spProBannerId=json['banner_id'].toString();
     title=json['title'];
  }
  copyObject({dynamic json}){
    return new SPClassBannerItem(json: json);
  }
}