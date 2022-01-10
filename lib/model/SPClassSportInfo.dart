


class SPClassSportInfo {
  String spProInfoFlowId;
  String title;
  String spProInfoFlowType;
  String spProInfoFlowKey;
  String spProIconUrl;
  String spProPageUrl;
  String spProAddTime;
  String spProCommentNum;
  String spProReadNum;


  SPClassSportInfo({json}){
    if(json!=null){
      fromJson(json);
    }
  }


  copyObject({dynamic json}){
    return new SPClassSportInfo(json: json);
  }

  fromJson(Map<String, dynamic> json) {
    spProInfoFlowId = json["info_flow_id"];
    title = json["title"];
    spProInfoFlowType = json["info_flow_type"];
    spProInfoFlowKey = json["info_flow_key"];
    spProPageUrl = json["page_url"];
    spProIconUrl = json["icon_url"];
    spProAddTime = json["publish_time"];
    spProCommentNum = json["comment_num"];
    spProReadNum = json["read_num"];
  }


}
