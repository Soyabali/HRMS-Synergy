class LeaveCancellationListModel {
  final String iTranId;
  final String sEmpCode;
  final String sEmpName;
  final String sAppRejReason;
  final String dAppRejDate;
  final String dFromDate;
  final String dToDate;
  final String iDays;
  final String sDsgName;
  final String dCancellationTime;
  final String sCancellationReasion;
  final String sImageLink;

  LeaveCancellationListModel({
    required this.iTranId,
    required this.sEmpCode,
    required this.sEmpName,
    required this.sAppRejReason,
    required this.dAppRejDate,
    required this.dFromDate,
    required this.dToDate,
    required this.iDays,
    required this.sDsgName,
    required this.dCancellationTime,
    required this.sCancellationReasion,
    required this.sImageLink,
  });

  factory LeaveCancellationListModel.fromJson(Map<String,dynamic> json) {
    return LeaveCancellationListModel(
      iTranId: json['iTranId'].toString(),
      sEmpCode: json['sEmpCode'].toString(),
      sEmpName: json['sEmpName'].toString(),
      sAppRejReason: json['sAppRejReason'].toString(),
      dAppRejDate: json['dAppRejDate'].toString(),
      dFromDate: json['dFromDate'].toString(),
      dToDate: json['dToDate'].toString(),
      iDays: json['iDays'].toString(),
      sDsgName: json['sDsgName'].toString(),
      dCancellationTime: json['dCancellationTime'].toString(),
      sCancellationReasion: json['sCancellationReasion'].toString(),
      sImageLink: json['sImageLink'].toString(),
    );
  }
// Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)

}