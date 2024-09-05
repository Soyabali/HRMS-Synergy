class LeaveData {
  final String sLvTypeCode;
  final String sLvDesc;
  final String fOpeningBal;
  final String fEntitlement;
  final String fAvailed;
  final String fClosingBalance;
  final String fYTD;

  LeaveData({
    required this.sLvTypeCode,
    required this.sLvDesc,
    required this.fOpeningBal,
    required this.fEntitlement,
    required this.fAvailed,
    required this.fClosingBalance,
    required this.fYTD,
  });

  factory LeaveData.fromJson(Map<String, dynamic> json) {
    return LeaveData(
      sLvTypeCode: json['sLvTypeCode'].toString(),
      sLvDesc: json['sLvDesc'],
      fOpeningBal: json['fOpeningBal'].toString(),
      fEntitlement: json['fEntitlement'].toString(),
      fAvailed: json['fAvailed'].toString(),
      fClosingBalance: json['fClosingBalance'].toString(),
      fYTD: json['fYTD'].toString(),
    );
  }
}