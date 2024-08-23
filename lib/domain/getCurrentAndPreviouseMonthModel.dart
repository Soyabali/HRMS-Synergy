
class GetcurrentandpreviousemonthModel {

  final String dDate;
  final String sMonthName;
  final String iIsCurrentMonth;

  GetcurrentandpreviousemonthModel({
    required this.dDate,
    required this.sMonthName,
    required this.iIsCurrentMonth,
  });

  factory GetcurrentandpreviousemonthModel.fromJson(Map<String, dynamic> json) {
    return GetcurrentandpreviousemonthModel(
      dDate: json['dDate'],
      sMonthName: json['sMonthName'],
      iIsCurrentMonth: json['iIsCurrentMonth'],
    );
  }
}