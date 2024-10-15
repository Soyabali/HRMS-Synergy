class HrmsLeavePendingForApprovalModel {
  final String iTranId;
  final String sEmpCode;
  final String dApplyDate;
  final String sEmpName;
  final String sContactNo;
  final String sDsgName;
  final String sAppRejReason;
  final String dAppRejDate;
  final String dFromDate;
  final String dToDate;
  final String sLvDesc;
  final String sLvType;
  final String sLeaveReason;
  final String sLeaveStatus;
  final String iDays;

  HrmsLeavePendingForApprovalModel({
    //required this.sName,
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
    required this.iDays
  });

  factory HrmsLeavePendingForApprovalModel.fromJson(Map<String,dynamic> json) {
    return HrmsLeavePendingForApprovalModel(
      iTranId: json['iTranId'].toString(),
      sEmpCode: json['sEmpCode'].toString(),
      dApplyDate: json['dApplyDate'].toString(),
      sEmpName: json['sEmpName'].toString(),
      sContactNo: json['sContactNo'].toString(),
      sDsgName: json['sDsgName'].toString(),
      sAppRejReason: json['sAppRejReason'].toString(),
      dAppRejDate: json['dAppRejDate'].toString(),
      dFromDate: json['dFromDate'].toString(),
      dToDate: json['dToDate'].toString(),
      sLvDesc: json['sLvDesc'].toString(),
      sLvType: json['sLvType'].toString(),
      sLeaveReason: json['sLeaveReason'].toString(),
      sLeaveStatus: json['sLeaveStatus'].toString(),
      iDays: json['iDays'].toString(),

    );
  }
// Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)

}
