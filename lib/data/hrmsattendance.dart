import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class HrmsAttendanceRepo {

  // this is a loginApi call functin

  Future hrmsattendance(BuildContext context, double? lat, double? long) async {

    try {
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      String? sEmpCode = prefs.getString('sEmpCode');
      String? sLocation = prefs.getString('sLocation');
      print('----sToken--19---$sToken');
      print('----lat--20---$lat');
      print('----long--21---$long');
      print('----sEmpCode--24---xxx---$sEmpCode');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsOnSiteAttendance/hrmsOnSiteAttendance";
      var attendanceApi = "$baseURL$endPoint";
      print('------------17---Attendance Api ---$attendanceApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$attendanceApi'));
      request.body = json.encode({
        "sEmpCode": sEmpCode,
        "fLatitude": lat ?? 0,
        "fLongitude": long ?? 0,
        "sLocation": sLocation,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('---------48---Attendance response----$map');

      if (response.statusCode == 200) {
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---LOGINaPI RESPONSE----$map');
        print('------61---${response.statusCode}');
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }
}
