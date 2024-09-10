class TripDetailModel {
  String sStartLocation;
  String dTripStart;
  String sTripEndLocation;
  String dTripEnd;
  String fStartOdometers;
  String fEndOdometers;
  String fDistance;
  String sDuration;
  String fTripStartLat;
  String fTripStartLon;
  String sTripStartImage;
  String fTripEndLat;
  String fTripEndLon;
  String sTripEndImage;
  String sEmpName;
  String sDsgName;

  TripDetailModel({
    required this.sStartLocation,
    required this.dTripStart,
    required this.sTripEndLocation,
    required this.dTripEnd,
    required this.fStartOdometers,
    required this.fEndOdometers,
    required this.fDistance,
    required this.sDuration,
    required this.fTripStartLat,
    required this.fTripStartLon,
    required this.sTripStartImage,
    required this.fTripEndLat,
    required this.fTripEndLon,
    required this.sTripEndImage,
    required this.sEmpName,
    required this.sDsgName,
  });

  factory TripDetailModel.fromJson(Map<String, dynamic> json) {
    return TripDetailModel(
      sStartLocation: json['sStartLocation'],
      dTripStart: json['dTripStart'],
      sTripEndLocation: json['sTripEndLocation'] ?? "",
      dTripEnd: json['dTripEnd'] ?? "",
      fStartOdometers: json['fStartOdometers'] ?? "0",
      fEndOdometers: json['fEndOdometers'] ?? "0",
      fDistance: json['fDistance'] ?? "0",
      sDuration: json['sDuration'] ?? "",
      fTripStartLat: json['fTripStartLat'] ?? "",
      fTripStartLon: json['fTripStartLon'] ?? "",
      sTripStartImage: json['sTripStartImage'] ?? "",
      fTripEndLat: json['fTripEndLat'] ?? "",
      fTripEndLon: json['fTripEndLon'] ?? "",
      sTripEndImage: json['sTripEndImage'] ?? "",
      sEmpName: json['sEmpName'] ?? "",
      sDsgName: json['sDsgName'] ?? "",
    );
  }

//   Map<String, dynamic> toJson() {
//     return {
//       'sStartLocation': sStartLocation,
//       'dTripStart': dTripStart,
//       'sTripEndLocation': sTripEndLocation,
//       'dTripEnd': dTripEnd,
//       'fStartOdometers': fStartOdometers,
//       'fEndOdometers': fEndOdometers,
//       'fDistance': fDistance,
//       'sDuration': sDuration,
//       'fTripStartLat': fTripStartLat,
//       'fTripStartLon': fTripStartLon,
//       'sTripStartImage': sTripStartImage,
//       'fTripEndLat': fTripEndLat,
//       'fTripEndLon': fTripEndLon,
//       'sTripEndImage': sTripEndImage,
//       'sEmpName': sEmpName,
//       'sDsgName': sDsgName,
//     };
//   }
// }
//
// // Function to parse JSON data into a list of Trip objects
// List<Trip> parseTrips(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<Trip>((json) => Trip.fromJson(json)).toList();
// }
}
