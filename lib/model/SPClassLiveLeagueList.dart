

class SPClassLiveLeagueList{
  List<SPClassLiveLeague> spProHotLeagueList;
  List<SPClassLiveLeague> LeagueList;


  SPClassLiveLeagueList.formJson(Map<String, dynamic> json) {
    if (json["hot_league_list"] != null) {
      spProHotLeagueList = new List<SPClassLiveLeague>();
      json["hot_league_list"].forEach((v) {
        spProHotLeagueList.add(new SPClassLiveLeague.fromJson(v));
      });
    }

    if (json["league_list"] != null) {
      LeagueList = new List<SPClassLiveLeague>();
      json["league_list"].forEach((v) {
        LeagueList.add(new SPClassLiveLeague.fromJson(v));
      });
    }
  }

}

class SPClassLiveLeague{
  String  spProLeagueName;
  String  spProPinyinInitial;
  bool  spProIsHot;
  bool  spProIsSelect=false;
  SPClassLiveLeague(this.spProLeagueName,this.spProIsSelect);
  SPClassLiveLeague.fromJson(Map<String, dynamic> json){
    spProLeagueName=json["league_name"];
    spProPinyinInitial=json["pinyin_initial"];
    spProIsHot=json["is_hot"]==1? true:false;
  }

}