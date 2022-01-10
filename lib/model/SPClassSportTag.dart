



class SPClassSportTag  {


  SPClassSportTag({json}){
    if(json!=null){
      fromJson(json);
    }
  }

  String tag;
  String tagType;
  String sortKey;
  fromJson(Map<String, dynamic> json) {
    tag = json["tag"];
    tagType = json["tag_type"];
    sortKey = json["sort_key"];
  }

  copyObject({dynamic json}){
    return new SPClassSportTag(json: json);
  }
}
