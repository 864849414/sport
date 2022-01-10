import 'package:sport/generated/json/base/json_convert_content.dart';
import 'package:sport/generated/json/base/json_filed.dart';

class SPClassMatchLineupPlayerEntity with JsonConvert<SPClassMatchLineupPlayerEntity> {
	SPClassMatchLineupPlayerMatchLineupPlayer spProMatchLineupPlayer;
}

class SPClassMatchLineupPlayerMatchLineupPlayer with JsonConvert<SPClassMatchLineupPlayerMatchLineupPlayer> {
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> one;
  List<SPClassMatchLineupPlayerMatchLineupPlayerItem> two;
}

class SPClassMatchLineupPlayerMatchLineupPlayerItem with JsonConvert<SPClassMatchLineupPlayerMatchLineupPlayerItem> {
	String spProPlayerName;
	String avatar;
	String spProShirtNumber;
	String spProWhichTeam;
	String spProIsRegular;
	String spProSeqNum;
}
