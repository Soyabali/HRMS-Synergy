class LeaveStatusModel {
  final String sName;
  final String sImageLink;
  final String sDesg;
  final String sLeaveType;
  final String dLeaveAt;
  final String sLeaveApplyFor;
  final String sLeaveStatus;

  LeaveStatusModel({
    required this.sName,
    required this.sImageLink,
    required this.sDesg,
    required this.sLeaveType,
    required this.dLeaveAt,
    required this.sLeaveApplyFor,
    required this.sLeaveStatus,
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
    );
  }
// Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)

}