class StafListModel {

  String sEmpCode;
  String sEmpName;
  String sContactNo;
  String sLocName;
  String sDsgName;
  String sEmpImage;

  StafListModel({
    required this.sEmpCode,
    required this.sEmpName,
    required this.sContactNo,
    required this.sLocName,
    required this.sDsgName,
    required this.sEmpImage,

  });

  // Factory method to create an instance from JSON
  factory StafListModel.fromJson(Map<String,dynamic> json) {
    return StafListModel(
      sEmpCode: json['sEmpCode'],
      sEmpName: json['sEmpName'],
      sContactNo: json['sContactNo'],
      sLocName: json['sLocName'],
      sDsgName: json['sDsgName'],
      sEmpImage: json['sEmpImage'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'sEmpCode': sEmpCode,
      'sEmpName': sEmpName,
      'sContactNo': sContactNo,
      'sLocName': sLocName,
      'sDsgName': sDsgName,
      'sEmpImage': sEmpImage,

    };
  }
}
