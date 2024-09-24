class EducationModel {
  final String sQualdName;
  final String sInstitutation;
  final String dPassedOut;
  final String sSubjects;
  final String fPercentage;

  EducationModel({
    required this.sQualdName,
    required this.sInstitutation,
    required this.dPassedOut,
    required this.sSubjects,
    required this.fPercentage,
  });

  factory EducationModel.fromJson(Map<String,dynamic> json) {
    return EducationModel(
      sQualdName: json['sQualdName'].toString(),
      sInstitutation: json['sInstitutation'].toString(),
      dPassedOut: json['dPassedOut'].toString(),
      sSubjects: json['sSubjects'].toString(),
      fPercentage: json['fPercentage'].toString(),
    );
  }
  // Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)

}