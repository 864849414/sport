


class SPClassCircleInfo{
  String spProCircleInfoId;
  String title;
  String spProAddTime;
  List<String> spProImgUrls=List();
  String spProLikeNum;
  String spProCommentNum;
  String spProNickName;
  String spProUserId;
  String spProIsFollowing;
  String spProAvatarUrl;
  String spProIconUrl;
  String content;
  String spProTextType;
  String spProTopicTitle;
  bool liked;


  fromJson(Map<String,dynamic> json){
    if(json["circle_info"]!=null){
       json=json["circle_info"];
    }
    spProCircleInfoId=json["circle_info_id"].toString();
    title=json["title"].toString();
    spProAddTime=json["add_time"].toString();
    spProUserId=json["user_id"].toString();
    spProLikeNum=json["like_num"].toString();
    spProIsFollowing=json["is_following"].toString();
    spProCommentNum=json["comment_num"].toString();
    spProIconUrl=json["icon_url"].toString();
    spProTextType=json["text_type"].toString();
    spProNickName=json["nick_name"].toString();
    spProTopicTitle=json["topic_title"].toString();
    content=json["content"].toString();
    spProAvatarUrl=json["avatar_url"].toString();
    liked=int.parse(json["liked"].toString())==1? true:false;
    if(json["img_urls"]!=null){
      spProImgUrls=json["img_urls"].toString().split(";");
    }
  }

  SPClassCircleInfo({Map json}){
    if(json!=null){
      fromJson(json);
    }
  }

  copyObject({dynamic json}){
    return new SPClassCircleInfo(json: json);
  }
}