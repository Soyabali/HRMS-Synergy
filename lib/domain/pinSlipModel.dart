
class PinSlipModel {

  final String dPayDate;
  final String sMonthName;
  final String sPaySlip;

  PinSlipModel({
    required this.dPayDate,
    required this.sMonthName,
    required this.sPaySlip,

  });

  factory PinSlipModel.fromJson(Map<String,dynamic> json) {
    return PinSlipModel(
      dPayDate: json['dPayDate'].toString(),
      sMonthName: json['sMonthName'].toString(),
      sPaySlip: json['sPaySlip'].toString(),

    );
  }
// Extract the month part from the sDate (e.g., "Jan", "Feb", etc.)
}