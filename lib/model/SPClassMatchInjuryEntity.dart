import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/generated/json/base/json_filed.dart';

class SPClassMatchInjuryEntity with JsonConvert<SPClassMatchInjuryEntity> {
	SPClassMatchInjuryMatchInjury spProMatchInjury;
}

class SPClassMatchInjuryMatchInjury with JsonConvert<SPClassMatchInjuryMatchInjury> {
  List<SPClassMatchInjuryMatchInjuryItem> one;
  List<SPClassMatchInjuryMatchInjuryItem> two;
}

class SPClassMatchInjuryMatchInjuryItem with JsonConvert<SPClassMatchInjuryMatchInjuryItem> {
	String spProWhichTeam;
	String reason;
	String spProPlayerName;
	String spProShirtNumber;
}


