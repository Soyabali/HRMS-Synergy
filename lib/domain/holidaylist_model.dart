class HolidayListModel {

  final String sDate;
  final String sDayName;
  final String sHolidayName;

  HolidayListModel({
    required this.sDate,
    required this.sDayName,
    required this.sHolidayName,
  });

  factory HolidayListModel.fromJson(Map<String, dynamic> json) {
    return HolidayListModel(
      sDate: json['sDate'].toString(),
      sDayName: json['sDayName'],
      sHolidayName: json['sHolidayName'].toString(),
    );
  }
  // Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)
  String getMonth() {
    return sDate.split(' ')[0]; // Assuming date format like "Jan 01"
  }
}