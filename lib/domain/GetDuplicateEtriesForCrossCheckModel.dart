class DuplicateEntriesForCrossCheck {
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
  final String sLastActionRemarks;
  final String sEmpName;
  final String dExpDate;
  final String sStatus;
  final String dLastActionRemarksAt;
  final String sLastActionRemarksBy;
  final String sMngrName;

  // Constructor
  DuplicateEntriesForCrossCheck({
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
    required this.sLastActionRemarks,
    required this.sEmpName,
    required this.dExpDate,
    required this.sStatus,
    required this.dLastActionRemarksAt,
    required this.sLastActionRemarksBy,
    required this.sMngrName,
  });

  // Factory constructor to create an instance from JSON
  factory DuplicateEntriesForCrossCheck.fromJson(Map<String, dynamic> json) {
    return DuplicateEntriesForCrossCheck(
      sTranCode: json['sTranCode'],
      sEmpCode: json['sEmpCode'],
      sProjectName: json['sProjectName'],
      sExpHeadName: json['sExpHeadName'],
      dEntryAt: json['dEntryAt'],
      fAmount: json['fAmount'],
      sExpDetails: json['sExpDetails'],
      sExpBillPhoto: json['sExpBillPhoto'],
      sExpBillPhoto2: json['sExpBillPhoto2'],
      sExpBillPhoto3: json['sExpBillPhoto3'],
      sExpBillPhoto4: json['sExpBillPhoto4'],
      sStatusName: json['sStatusName'],
      sLastActionRemarks: json['sLastActionRemarks'],
      sEmpName: json['sEmpName'],
      dExpDate: json['dExpDate'],
      sStatus: json['sStatus'],
      dLastActionRemarksAt: json['dLastActionRemarksAt'],
      sLastActionRemarksBy: json['sLastActionRemarksBy'],
      sMngrName: json['sMngrName'],
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
      'sLastActionRemarks': sLastActionRemarks,
      'sEmpName': sEmpName,
      'dExpDate': dExpDate,
      'sStatus': sStatus,
      'dLastActionRemarksAt': dLastActionRemarksAt,
      'sLastActionRemarksBy': sLastActionRemarksBy,
      'sMngrName': sMngrName,
    };
  }
}

// Parsing a list of JSON objects to a list of Expense instances
List<DuplicateEntriesForCrossCheck> parseExpenses(List<dynamic> jsonList) {
  return jsonList.map((json) => DuplicateEntriesForCrossCheck.fromJson(json)).toList();
}
