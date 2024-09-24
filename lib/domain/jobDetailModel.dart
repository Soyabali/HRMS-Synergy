class JobDetailmodel {
  final String sCompanyName;
  final String dFromDate;
  final String dToDate;
  final String fLastSalary;
  final String sLeavingReason;

  JobDetailmodel({
    required this.sCompanyName,
    required this.dFromDate,
    required this.dToDate,
    required this.fLastSalary,
    required this.sLeavingReason,
  });

  factory JobDetailmodel.fromJson(Map<String,dynamic> json) {
    return JobDetailmodel(
      sCompanyName: json['sCompanyName'].toString(),
      dFromDate: json['dFromDate'].toString(),
      dToDate: json['dToDate'].toString(),
      fLastSalary: json['fLastSalary'].toString(),
      sLeavingReason: json['sLeavingReason'].toString(),
    );
  }
// Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)

}