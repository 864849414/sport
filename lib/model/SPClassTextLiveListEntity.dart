import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/generated/json/base/json_filed.dart';

class SPClassTextLiveListEntity with JsonConvert<SPClassTextLiveListEntity> {
	List<SPClassTextLiveListTextLiveList> spProTextLiveList;
	SPClassTextLiveListGuessMatch spProGuessMatch;
}

class SPClassTextLiveListTextLiveList with JsonConvert<SPClassTextLiveListTextLiveList> {
	String spProSeqNum;
	String section;
	String spProLeftTime;
	String msg;
	String spProTeamName;
}

class SPClassTextLiveListGuessMatch with JsonConvert<SPClassTextLiveListGuessMatch> {
	String spProIsRealtimeOver;
	String spProScoreOne;
	String spProScoreTwo;
	String spProIsOver;
	String spProStatusDesc;
}
