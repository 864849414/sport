

class SPClassIncomeReport{
  String spProPaidIncome;
  String spProUnpaidIncome;

  SPClassIncomeReport({Map json}){
    if(json!=null){
      fromJson(json);
    }
  }
  fromJson(Map<String,dynamic> json){
    json=json["income_report"];
    spProPaidIncome=json["paid_income"]?.toString();
    spProUnpaidIncome=json["unpaid_income"]?.toString();
  }



}