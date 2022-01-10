import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/generated/json/base/json_filed.dart';

class SPClassMatchLineupEntity with JsonConvert<SPClassMatchLineupEntity> {
	List<SPClassMatchLineupMatchLineup> spProMatchLineup;
}

class SPClassMatchLineupMatchLineup with JsonConvert<SPClassMatchLineupMatchLineup> {
	String spProTeamOneLineup;
	String spProTeamTwoLineup;
}
