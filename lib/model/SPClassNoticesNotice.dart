

class SPClassNoticesNotice {
	String title;




  SPClassNoticesNotice({Map json,this.title}){
    if(json!=null){
      fromJson(json);
    }
  }
  fromJson(Map<String,dynamic> json){

    title=json["title"].toString();

  }

  copyObject({dynamic json}){
    return new SPClassNoticesNotice(json: json);
  }
}
