import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class RequestOtpRepo {

  // this is a loginApi call functin

  Future requestOtp(BuildContext context, String phone) async {

    try {
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      print('----sToken--24---xxx---$sToken');
      print("------20-----$phone");

      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsRequestOtp/hrmsRequestOtp";
      var requestOtpApi = "$baseURL$endPoint";
      print('------------17---requestOtpApi Api ---$requestOtpApi');
      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$requestOtpApi'));
      request.body = json.encode({
        "sContactNo": phone,

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