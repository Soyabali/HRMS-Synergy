import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class UpdateLeaveStatusRepo {

  // this is a loginApi call functin

  Future updateLeaeStatus(BuildContext context, sTranCode, String action, String sRemarks) async {

    try {
      showLoader();
      print('----16---$sTranCode');
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      String? sContactNo = prefs.getString('sContactNo');
      print('----sToken--19---$sToken');
      print("-----23----$sTranCode");
      print("-----24----$action");

      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsupdateleavestatus/hrmsupdateleavestatus";
      var updateLeaveStatusApi = "$baseURL$endPoint";
      print('------------17---updateLeaveStatusApi Api ---$updateLeaveStatusApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$updateLeaveStatusApi'));
      request.body = json.encode({
        "iTranId": sTranCode,   // iTrainId take a button click
        "sAction": action,  // R or S behafe of button
        "sRemarks": sRemarks,  // edittext Field
        "iLeaveYear": "2024",  // current Year
        "sUserId": sContactNo,  // contact Number

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
