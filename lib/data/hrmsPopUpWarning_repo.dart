import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class HrmsPopUpWarningRepo {

  // this is a loginApi call functin

  Future hrmsPopUpWarnging(BuildContext context, String sEmpCode, dExpDate, String amount) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      print('----sEmpCode--15---$sEmpCode');
      print('----dExpDate--15---$dExpDate');
      print('----amount--15---$amount');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsReimPopupWarning/hrmsReimPopupWarning";
      var hrmsPopUpWarngingApi = "$baseURL$endPoint";
      print('------------17---loginApi---$hrmsPopUpWarngingApi');

      showLoader();
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsPopUpWarngingApi'));
      request.body = json.encode({
        "sEmpCode": sEmpCode,
        "dExpDate": dExpDate,
        "fAmount": amount,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
     // print('----------20---login RESPONSE----$map');
      if (response.statusCode == 200) {
        hideLoader();
        //print('----------22-----$map');
        return map;
      } else {
       // print('----------29---LOGINaPI RESPONSE----$map');
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
