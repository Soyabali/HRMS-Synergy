class HrmsReimbursementClarificationModel {
  String sTranCode;
  String sEmpCode;
  String sProjectName;
  String sExpHeadName;
  String dEntryAt;
  String fAmount;
  String sExpDetails;
  String sExpBillPhoto;
  String sStatusName;
  String sEmpName;
  String sRemarks;
  String dRemarksAt;
  String sProjectCode;
  String sExpHeadCode;
  String dExpDate;

  HrmsReimbursementClarificationModel({
    required this.sTranCode,
    required this.sEmpCode,
    required this.sProjectName,
    required this.sExpHeadName,
    required this.dEntryAt,
    required this.fAmount,
    required this.sExpDetails,
    required this.sExpBillPhoto,
    required this.sStatusName,
    required this.sEmpName,
    required this.sRemarks,
    required this.dRemarksAt,
    required this.sProjectCode,
    required this.sExpHeadCode,
    required this.dExpDate,
  });

  // Factory constructor to create an object from JSON
  factory HrmsReimbursementClarificationModel.fromJson(Map<String, dynamic> json) {
    return HrmsReimbursementClarificationModel(
      sTranCode: json['sTranCode'] as String,
      sEmpCode: json['sEmpCode'] as String,
      sProjectName: json['sProjectName'] as String,
      sExpHeadName: json['sExpHeadName'] as String,
      dEntryAt: json['dEntryAt'] as String,
      fAmount: json['fAmount'] as String,
      sExpDetails: json['sExpDetails'] as String,
      sExpBillPhoto: json['sExpBillPhoto'] as String,
      sStatusName: json['sStatusName'] as String,
      sEmpName: json['sEmpName'] as String,
      sRemarks: json['sRemarks'] as String,
      dRemarksAt: json['dRemarksAt'] as String,
      sProjectCode: json['sProjectCode'] as String,
      sExpHeadCode: json['sExpHeadCode'] as String,
      dExpDate: json['dExpDate'] as String,
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'sTranCode': sTranCode,
      'sEmpCode': sEmpCode,
      'sProjectName': sProjectName,
      'sExpHeadName': sExpHeadName,
      'dEntryAt': dEntryAt,
      'fAmount': fAmount,
      'sExpDetails': sExpDetails,
      'sExpBillPhoto': sExpBillPhoto,
      'sStatusName': sStatusName,
      'sEmpName': sEmpName,
      'sRemarks': sRemarks,
      'dRemarksAt': dRemarksAt,
      'sProjectCode': sProjectCode,
      'sExpHeadCode': sExpHeadCode,
      'dExpDate': dExpDate,
    };
  }
}
