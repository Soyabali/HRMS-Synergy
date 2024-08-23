class HrmsmonthlyattendanceModel {

  final String dDate;
  final String sDay;
  final String sInTime;
  final String sOutTime;
  final String sStatus;

  HrmsmonthlyattendanceModel({
    required this.dDate,
    required this.sDay,
    required this.sInTime,
    required this.sOutTime,
    required this.sStatus,
  });

  factory HrmsmonthlyattendanceModel.fromJson(Map<String, dynamic> json) {
    return HrmsmonthlyattendanceModel(
      dDate: json['dDate'],
      sDay: json['sDay'],
      sInTime: json['sInTime'],
      sOutTime: json['sOutTime'],
      sStatus: json['sStatus'],
    );
  }
}