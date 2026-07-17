import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmsEmpWorkStatusReportRepo {
  // Fetches the employee work status report list shown inside the
  // acknowledgement dialog. Body -> { dDate, sEmpCode }
  // sEmpCode here is the login contact number (sContactNo).

  Future<List> hrmsEmpWorkStatusReport(
      BuildContext context, String dDate, String sEmpCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "HrmsEmpWorkStatusRepot/HrmsEmpWorkStatusRepot";
      var url = "$baseURL$endPoint";
      print('------------HrmsEmpWorkStatusRepot---$url');
      print('------------dDate---$dDate  sEmpCode---$sEmpCode');

      showLoader();
      var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$url'));

      request.body = json.encode({
        "dDate": dDate,
        "sEmpCode": sEmpCode,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      var map = json.decode(data);
      hideLoader();

      if (response.statusCode == 200 && map is List) {
        print('----------WorkStatusReport-----$map');
        return map;
      } else {
        print('----------WorkStatusReport error------$map');
        print(response.reasonPhrase);
        return [];
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      return [];
    }
  }
}
