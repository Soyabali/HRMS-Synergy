class HrmsLeaveStatusModel {
  String iTranId;
  String sEmpCode;
  String dApplyDate;
  String sEmpName;
  String sContactNo;
  String sDsgName;
  String sAppRejReason;
  String dAppRejDate;
  String dFromDate;
  String dToDate;
  String sLvDesc;
  String sLvType;
  String sLeaveReason;
  String sLeaveStatus;
  String iDays;

  HrmsLeaveStatusModel({
    required this.iTranId,
    required this.sEmpCode,
    required this.dApplyDate,
    required this.sEmpName,
    required this.sContactNo,
    required this.sDsgName,
    required this.sAppRejReason,
    required this.dAppRejDate,
    required this.dFromDate,
    required this.dToDate,
    required this.sLvDesc,
    required this.sLvType,
    required this.sLeaveReason,
    required this.sLeaveStatus,
    required this.iDays,
  });

  // Factory method to create an instance from JSON
  factory HrmsLeaveStatusModel.fromJson(Map<String, dynamic> json) {
    return HrmsLeaveStatusModel(
      iTranId: json['iTranId'],
      sEmpCode: json['sEmpCode'],
      dApplyDate: json['dApplyDate'],
      sEmpName: json['sEmpName'],
      sContactNo: json['sContactNo'],
      sDsgName: json['sDsgName'],
      sAppRejReason: json['sAppRejReason'] ?? '',
      dAppRejDate: json['dAppRejDate'] ?? '',
      dFromDate: json['dFromDate'],
      dToDate: json['dToDate'],
      sLvDesc: json['sLvDesc'],
      sLvType: json['sLvType'],
      sLeaveReason: json['sLeaveReason'],
      sLeaveStatus: json['sLeaveStatus'],
      iDays: json['iDays'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'iTranId': iTranId,
      'sEmpCode': sEmpCode,
      'dApplyDate': dApplyDate,
      'sEmpName': sEmpName,
      'sContactNo': sContactNo,
      'sDsgName': sDsgName,
      'sAppRejReason': sAppRejReason,
      'dAppRejDate': dAppRejDate,
      'dFromDate': dFromDate,
      'dToDate': dToDate,
      'sLvDesc': sLvDesc,
      'sLvType': sLvType,
      'sLeaveReason': sLeaveReason,
      'sLeaveStatus': sLeaveStatus,
      'iDays': iDays,
    };
  }
}
