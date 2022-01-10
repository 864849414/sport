import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/generated/json/base/json_filed.dart';

class SPClassMatchIntelligenceEntity with JsonConvert<SPClassMatchIntelligenceEntity> {
	SPClassMatchIntelligenceMatchIntelligence spProMatchIntelligence;
}

class SPClassMatchIntelligenceMatchIntelligence with JsonConvert<SPClassMatchIntelligenceMatchIntelligence> {
  List<SPClassMatchIntelligenceMatchIntelligenceItem> one;
	List<SPClassMatchIntelligenceMatchIntelligenceItem> two;
}
class SPClassMatchIntelligenceMatchIntelligenceItem with JsonConvert<SPClassMatchIntelligenceMatchIntelligenceItem> {
	String information;
	String status;
	String spProWhichTeam;
}


