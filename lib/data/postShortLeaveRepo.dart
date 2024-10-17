import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class PostShortLeaveRepo {

  // this is a loginApi call functin

  Future shortLeave(BuildContext context, String? sEmpCode, String? formattedDate, String reason) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "PostShortLeave/PostShortLeave";
      var shortleaveApi = "$baseURL$endPoint";

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$shortleaveApi'));
      request.body = json.encode({
        "sEmpCode": sEmpCode,
        "dDate": formattedDate,
        "sReason": reason,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('---------48---ShortLeave response----$map');

      if (response.statusCode == 200) {
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---ShortLeave RESPONSE----$map');
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
