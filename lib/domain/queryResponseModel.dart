class QueryResponsemodel {
  final String sTitle;
  final String sDescription;
  final String dRequestTime;
  final String sResponse;
  final String dResponseDate;
  final String sResponseBy;


  QueryResponsemodel({
    required this.sTitle,
    required this.sDescription,
    required this.dRequestTime,
    required this.sResponse,
    required this.dResponseDate,
    required this.sResponseBy,

  });

  factory QueryResponsemodel.fromJson(Map<String, dynamic> json) {
    return QueryResponsemodel(
      sTitle: json['sTitle'].toString(),
      sDescription: json['sDescription'],
      dRequestTime: json['dRequestTime'].toString(),
      sResponse: json['sResponse'].toString(),
      dResponseDate: json['dResponseDate'].toString(),
      sResponseBy: json['sResponseBy'].toString(),

    );
  }
}