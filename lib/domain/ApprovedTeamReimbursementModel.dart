class ApprovedTeamReimbursementModel {
  final String sTranCode;
  final String sEmpCode;
  final String sProjectName;
  final String sExpHeadName;
  final String dEntryAt;
  final String fAmount;
  final String sExpDetails;
  final String sExpBillPhoto;
  final String sExpBillPhoto2;
  final String sExpBillPhoto3;
  final String sExpBillPhoto4;
  final String sStatusName;
  final String iStatus;
  final String sEmpName;
  final String dExpDate;
  final String sProjectCode;
  final String sExpHeadCode;
  final String dActionEntryAt;
  final String sRemarks;

  ApprovedTeamReimbursementModel({
    required this.sTranCode,
    required this.sEmpCode,
    required this.sProjectName,
    required this.sExpHeadName,
    required this.dEntryAt,
    required this.fAmount,
    required this.sExpDetails,
    required this.sExpBillPhoto,
    required this.sExpBillPhoto2,
    required this.sExpBillPhoto3,
    required this.sExpBillPhoto4,
    required this.sStatusName,
    required this.iStatus,
    required this.sEmpName,
    required this.dExpDate,
    required this.sProjectCode,
    required this.sExpHeadCode,
    required this.dActionEntryAt,
    required this.sRemarks,
  });

  // Factory method to create an instance from JSON
  factory ApprovedTeamReimbursementModel.fromJson(Map<String, dynamic> json) {
    return ApprovedTeamReimbursementModel(
      sTranCode: json['sTranCode'] ?? '',
      sEmpCode: json['sEmpCode'] ?? '',
      sProjectName: json['sProjectName'] ?? '',
      sExpHeadName: json['sExpHeadName'] ?? '',
      dEntryAt: json['dEntryAt'] ?? '',
      fAmount: json['fAmount'] ?? '',
      sExpDetails: json['sExpDetails'] ?? '',
      sExpBillPhoto: json['sExpBillPhoto'] ?? '',
      sExpBillPhoto2: json['sExpBillPhoto2'] ?? '',
      sExpBillPhoto3: json['sExpBillPhoto3'] ?? '',
      sExpBillPhoto4: json['sExpBillPhoto4'] ?? '',
      sStatusName: json['sStatusName'] ?? '',
      iStatus: json['iStatus'] ?? '',
      sEmpName: json['sEmpName'] ?? '',
      dExpDate: json['dExpDate'] ?? '',
      sProjectCode: json['sProjectCode'] ?? '',
      sExpHeadCode: json['sExpHeadCode'] ?? '',
      dActionEntryAt: json['dActionEntryAt'] ?? '',
      sRemarks: json['sRemarks'] ?? '',
    );
  }

  // Method to convert an instance to JSON
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
      'sExpBillPhoto2': sExpBillPhoto2,
      'sExpBillPhoto3': sExpBillPhoto3,
      'sExpBillPhoto4': sExpBillPhoto4,
      'sStatusName': sStatusName,
      'iStatus': iStatus,
      'sEmpName': sEmpName,
      'dExpDate': dExpDate,
      'sProjectCode': sProjectCode,
      'sExpHeadCode': sExpHeadCode,
      'dActionEntryAt': dActionEntryAt,
      'sRemarks': sRemarks,
    };
  }
}


