import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class PolicydocAcceptRepo {

  // this is a loginApi call functin

  Future policydocAccept(BuildContext context, String sPolicyCode) async {

    try {
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      // you have to  pass contactNo to sEmpCode fields

      String? sContactNo = prefs.getString('sContactNo');

      print('----sToken--19---$sToken');
      print('----sContactNo--19---$sContactNo');
      print('----sPolicyCode--19---$sPolicyCode');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsactiononpolicy/hrmsactiononpolicy";
      var policyDocRejectApi = "$baseURL$endPoint";
      print('------------17---policyDocRejectApi Api ---$policyDocRejectApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      // todo in a reject case you should forware 0 and accept case you should pass 1 in a iStatus code
      var request = http.Request('POST', Uri.parse('$policyDocRejectApi'));
      request.body = json.encode({
        "sPolicyCode": sPolicyCode,
        "sEmpCode": sContactNo,
        "sRemarks": "NA",
        "iStatus": "1",
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
