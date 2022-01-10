import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/generated/json/base/json_filed.dart';
import 'package:sport/model/SPClassTextLiveListEntity.dart';

class SPClassMatchEventEntity with JsonConvert<SPClassMatchEventEntity> {
  List<SPClassMatchEventMatchEventItem> spProMatchEvent;
  SPClassTextLiveListGuessMatch spProGuessMatch;
}

class SPClassMatchEventMatchEventItem with JsonConvert<SPClassMatchEventMatchEventItem> {
	String spProWhichTeam;
	String spProEventName;
	String time;
	String spProPlayerName;
	String spProEventImage;
  String spProSeqNum;
  String spProTeamOneScore="0";
  String spProTeamTwoScore="0";
  String content="";

}


