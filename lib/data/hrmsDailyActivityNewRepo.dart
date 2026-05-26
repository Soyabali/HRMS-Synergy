import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmsDailyActivityNew {
  // this is a loginApi call functin

  Future hrmsDailyActivityNew(BuildContext context, projectCode, String workDetail, String timeSpent) async {
    try {
      //uplodedImage2, uplodedImage3, uplodedImage4
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      var sContactNo = prefs.getString('sContactNo');
      var sEmpCode = prefs.getString('sEmpCode');

      print("------19  employee code-------$sEmpCode");
      print("------20  project code-------$projectCode");
      print("------21  work detail-------$workDetail");
      print("------22  time spent-------$timeSpent");


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsDailyActivityNew/hrmsDailyActivityNew";
      var hrmsDailyActivityNew = "$baseURL$endPoint";
      print('------------17--hrmsDailyActivityNew/hrmsDailyActivityNew---$hrmsDailyActivityNew');

      showLoader();
      var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$hrmsDailyActivityNew'));

      request.body = json.encode({
        "sEmpCode": sEmpCode,
        "sProjectCode": projectCode,
        "sActivity":workDetail,
        "iWorkingMinutes":timeSpent

      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------41-------$map');
      if (response.statusCode == 200) {
        hideLoader();
        print('----------44-----$map');
        return map;
      } else {
        print('----------47------$map');
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
