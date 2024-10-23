
class EmployeeListModel {

  final String sEmpCode;
  final String sEmpName;
  final String sContactNo;
  final String sLocName;
  final String sDsgName;
  final String sEmpImage;


  EmployeeListModel({
    required this.sEmpCode,
    required this.sEmpName,
    required this.sContactNo,
    required this.sLocName,
    required this.sDsgName,
    required this.sEmpImage,
  });

  factory EmployeeListModel.fromJson(Map<String,dynamic> json) {
    return EmployeeListModel(
      sEmpCode: json['sEmpCode'].toString(),
      sEmpName: json['sEmpName'].toString(),
      sContactNo: json['sContactNo'].toString(),
      sLocName: json['sLocName'].toString(),
      sDsgName: json['sDsgName'].toString(),
      sEmpImage: json['sEmpImage'].toString(),
    );
  }
// Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)
}