
class SPClassTopicInfo
{
  String spProTopicTitle;
  String spProTopicDetail;
  String spProImgUrl;
  String spProInfoNum;
  String spProViewNum;


  SPClassTopicInfo({json}){
    if(json!=null){
      fromJson(json);
    }
  }
  fromJson(Map<String, dynamic> json) {
    spProTopicTitle = json["topic_title"]?.toString();
    spProTopicDetail = json["topic_detail"]?.toString();
    spProImgUrl = json["img_url"]?.toString();
    spProInfoNum = json["info_num"]?.toString();
    spProViewNum = json["view_num"]?.toString();
  }


  copyObject({dynamic json}){
    return new SPClassTopicInfo(json: json);
  }


}