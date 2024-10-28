import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmsAttendanceRepo {

  // this is a loginApi call functin

  Future attendance(BuildContext context,String selectedMonth) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sEmpCode = prefs.getString('sEmpCode');
    var sToken = prefs.getString('sToken');
    // to pick a current year and current month

    DateTime now = DateTime.now();
    var currentYear = now.year;
    print('------21-----current YEAR ----$currentYear');
    try {
      showLoader();
      print('----sEmpCode--24---$sEmpCode');
      print('----currentYear--25---$currentYear');
      print('----selectedMonth--26---$selectedMonth');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmAttendanceApi/hrmAttendanceApi";
      var attendanceApi = "$baseURL$endPoint";
      print('------------17---attendanceApi---$attendanceApi');

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      //var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$attendanceApi'));
      request.body = json.encode({
        "sEmpCode": sEmpCode,
        "sMonth": selectedMonth,
        "sYear": currentYear
        // "sYear": currentYear.toString(),
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------47---attendance RESPONSE----$map');
      if (response.statusCode == 200) {
        hideLoader();
        print('----------50-----$map');
        return map;
      } else {
        print('----------29---Attendace RESPONSE----$map');
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
