

class SPClassPkRanking {
  String spProWinCnt;
  String spProPkCnt;
  String spProWinRate;
  String spProNickName;
  String spProAvatarUrl;
  String points;
  String ranking;
  String spProRewardMoney;



  SPClassPkRanking({Map json}){
    if(json!=null){
      fromJson(json);
    }
  }
  fromJson(Map<String,dynamic> json){

    spProWinCnt=json["win_cnt"].toString();
    spProPkCnt=json["pk_cnt"].toString();
    spProWinRate=json["win_rate"].toString();
    spProNickName=json["nick_name"].toString();
    spProAvatarUrl=json["avatar_url"].toString();
    points=json["points"].toString();
    ranking=json["ranking"].toString();
    spProRewardMoney=json["reward_money"].toString();

  }


  copyObject({dynamic json}){
    return new SPClassPkRanking(json: json);
  }
}