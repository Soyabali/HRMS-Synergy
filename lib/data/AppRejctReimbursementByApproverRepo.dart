import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class ApprejctreimbursementbyapproverrepoRepo {
  // this is a loginApi call functin

  Future apprejectReim(
      BuildContext context, String sTranCode, iStatus, String sRemarks) async {
    try {
      //uplodedImage2, uplodedImage3, uplodedImage4
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      var sContactNo = prefs.getString('sContactNo');


      print('----sToken--18---$sToken');
      print('----sTranCode--21---$sTranCode');
      print('----iStatus--21---$iStatus');
      print('----sRemarks--21---$sRemarks');



      var baseURL = BaseRepo().baseurl;
      var endPoint = "AppRejctReimbursementByApprover/AppRejctReimbursementByApprover";
      var hrmsPostReimbursementApi = "$baseURL$endPoint";
      print('------------17---hrmsPostReimbursementApi---$hrmsPostReimbursementApi');

      showLoader();
      var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$hrmsPostReimbursementApi'));

      request.body = json.encode({
        "sTranCode": sTranCode,
        "iStatus": iStatus,
        "sActionBy":sContactNo,
        "sRemarks":sRemarks

      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20-------$map');
      if (response.statusCode == 200) {
        hideLoader();
        print('----------71-----$map');
        return map;
      } else {
        print('----------74------$map');
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
