import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/generated/json/base/json_filed.dart';

class SPClassMatchStatListEntity with JsonConvert<SPClassMatchStatListEntity> {
	List<SPClassMatchStatListMatchStat> spProMatchStat;
}

class SPClassMatchStatListMatchStat with JsonConvert<SPClassMatchStatListMatchStat> {
	String spProStatType;
	String spProTeamOneVal;
	String spProTeamTwoVal;
	double spProProgressOne;
	double spProProgressTwo;
}
