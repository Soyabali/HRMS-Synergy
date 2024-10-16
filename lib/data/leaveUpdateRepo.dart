import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class LeaveUpdateRepo {

  // this is a loginApi call functin

  Future leaveUpdate(BuildContext context, String queryTitle, String iTranId) async {

    try {
      //print('----16---$sTranCode');
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      String? sContactNo = prefs.getString('sContactNo');
      print('----sToken--19---$sToken');
      print('----queryTitle--19---$queryTitle');
      print('-----23------$iTranId');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsupdateleavestatus/hrmsupdateleavestatus";
      var leaveUpdateApi = "$baseURL$endPoint";
      print('------------17---leaveUpdateApi Api ---$leaveUpdateApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$leaveUpdateApi'));
      request.body = json.encode({
        "iTranId": "2165",
        "sAction": "Testing",
        "sRemarks":"Testing",
        "iLeaveYear":"2024",
        "sUserId":"5986145234"
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
