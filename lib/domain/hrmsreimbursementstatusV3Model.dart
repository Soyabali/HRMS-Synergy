class Hrmsreimbursementstatusv3model {
  final String sTranCode;
  final String sEmpCode;
  final String sProjectName;
  final String sExpHeadName;
  final String dEntryAt;
  final String fAmount;
  final String sExpDetails;
  final String sExpBillPhoto;
  final String sStatusName;
  final String sEmpName;
  final String sRemarks;
  final String dRemarksAt;
  final String sProjectCode;
  final String sExpHeadCode;
  final String dExpDate;

  Hrmsreimbursementstatusv3model({
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

  // Factory constructor to create an instance from JSON
  factory Hrmsreimbursementstatusv3model.fromJson(Map<String, dynamic> json) {
    return Hrmsreimbursementstatusv3model(
      sTranCode: json['sTranCode'],
      sEmpCode: json['sEmpCode'],
      sProjectName: json['sProjectName'],
      sExpHeadName: json['sExpHeadName'],
      dEntryAt: json['dEntryAt'],
      fAmount: json['fAmount'],
      sExpDetails: json['sExpDetails'],
      sExpBillPhoto: json['sExpBillPhoto'],
      sStatusName: json['sStatusName'],
      sEmpName: json['sEmpName'],
      sRemarks: json['sRemarks'],
      dRemarksAt: json['dRemarksAt'],
      sProjectCode: json['sProjectCode'],
      sExpHeadCode: json['sExpHeadCode'],
      dExpDate: json['dExpDate'],
    );
  }

// Method to convert an instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'sTranCode': sTranCode,
//       'sEmpCode': sEmpCode,
//       'sProjectName': sProjectName,
//       'sExpHeadName': sExpHeadName,
//       'dEntryAt': dEntryAt,
//       'fAmount': fAmount,
//       'sExpDetails': sExpDetails,
//       'sExpBillPhoto': sExpBillPhoto,
//       'sStatusName': sStatusName,
//       'sEmpName': sEmpName,
//       'sRemarks': sRemarks,
//       'dRemarksAt': dRemarksAt,
//       'sProjectCode': sProjectCode,
//       'sExpHeadCode': sExpHeadCode,
//       'dExpDate': dExpDate,
//     };
//   }
// }
//
// // To parse a list of ExpenseEntry from JSON
// List<ExpenseEntry> parseExpenseEntryList(List<dynamic> list) {
//   return list.map((json) => ExpenseEntry.fromJson(json)).toList();
// }
}
