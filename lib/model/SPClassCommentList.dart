
class SPClassCommentList{
  List<SPClassCommentItem> spProCommentList=List();

  SPClassCommentList.fromJson(Map<String,dynamic> json){
    if(json["comment_list"]!=null){
      json["comment_list"].forEach((item){
        spProCommentList.add(SPClassCommentItem.fromJson(item));
      });
    }
  }

}


class SPClassCommentItem{

  String spProCommentId;
  String spProUserId;
  String spProReplyCommentId;
  String spProTopCommentId;
  String content;
  String spProAddTime;
  String spProReplyNum;
  String spProLikeNum;
  String spProNickName;
  String spProAvatarUrl;
  bool liked;

  SPClassCommentItem.fromJson(Map<String,dynamic> json){
     spProCommentId=json["comment_id"].toString();
     spProUserId=json["user_id"].toString();
     spProReplyCommentId=json["reply_comment_id"].toString();
     spProTopCommentId=json["top_comment_id"].toString();
     content=json["content"].toString();
     spProAddTime=json["add_time"].toString();
     spProReplyNum=json["reply_num"].toString();
     spProLikeNum=json["like_num"].toString();
     spProNickName=json["nick_name"].toString();
     spProAvatarUrl=json["avatar_url"].toString();
     liked=int.parse(json["liked"].toString())==1? true:false;

  }


}