class LeaveStatusModel {
  final String sName;
  final String sImageLink;
  final String sDesg;
  final String sLeaveType;
  final String dLeaveAt;
  final String sLeaveApplyFor;
  final String sLeaveStatus;
  final String sLeaveTypeStatus;

  LeaveStatusModel({
    required this.sName,
    required this.sImageLink,
    required this.sDesg,
    required this.sLeaveType,
    required this.dLeaveAt,
    required this.sLeaveApplyFor,
    required this.sLeaveStatus,
    required this.sLeaveTypeStatus,
  });

  factory LeaveStatusModel.fromJson(Map<String,dynamic> json) {
    return LeaveStatusModel(
      sName: json['sName'].toString(),
      sImageLink: json['sImageLink'].toString(),
      sDesg: json['sDesg'].toString(),
      sLeaveType: json['sLeaveType'].toString(),
      dLeaveAt: json['dLeaveAt'].toString(),
      sLeaveApplyFor: json['sLeaveApplyFor'].toString(),
      sLeaveStatus: json['sLeaveStatus'].toString(),
      sLeaveTypeStatus:json['sLeaveTypeStatus'].toString()
    );
  }
// Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)

}