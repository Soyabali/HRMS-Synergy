class Hrmsleavebalancev2Model {

  final String sLvTypeCode;
  final String sLvDesc;
  final String fOpeningBal;
  final String fEntitlement;
  final String fAvailed;
  final String fClosingBalance;
  final String fYTD;

  Hrmsleavebalancev2Model({
    required this.sLvTypeCode,
    required this.sLvDesc,
    required this.fOpeningBal,
    required this.fEntitlement,
    required this.fAvailed,
    required this.fClosingBalance,
    required this.fYTD,
  });

  factory Hrmsleavebalancev2Model.fromJson(Map<String, dynamic> json) {
    return Hrmsleavebalancev2Model(
      sLvTypeCode: json['sLvTypeCode'],
      sLvDesc: json['sLvDesc'] ,
      fOpeningBal: json['fOpeningBal'],
      fEntitlement: json['fEntitlement'],
      fAvailed: json['fAvailed'],
      fClosingBalance: json['fClosingBalance'],
      fYTD: json['fYTD'],
    );
  }
  @override
  String toString() {
    return 'Hrmsleavebalancev2Model(sLvTypeCode: $sLvTypeCode, sLvDesc: $sLvDesc, fOpeningBal: $fOpeningBal, fEntitlement: $fEntitlement, fAvailed: $fAvailed, fClosingBalance: $fClosingBalance, fYTD: $fYTD)';
  }
}
