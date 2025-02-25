import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/app/generalFunction.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class HrmsUpdateGsmidIosRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future updateGsmidIos(BuildContext context, token) async {

    try {
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      String? sContactNo = prefs.getString('sContactNo');
      String? sLocation = prefs.getString('sLocation');
      print('----sToken--19---$sToken');
      print('----token--24---$token');
      print('----sContactNo--25---xxx---$sContactNo');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsupdategsmidios/hrmsupdategsmidios";
      var attendanceApi = "$baseURL$endPoint";
      print('------------17---Attendance Api ---$attendanceApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$attendanceApi'));
      request.body = json.encode({
        "sContactNo": sContactNo,
        "sGSMID": token,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('---------52---Attendance notification Response----$map');

      if (response.statusCode == 200) {
        hideLoader();
        print('----------22-----$map');
        return map;
      }
      else if(response.statusCode==401){
        generalFunction.logout(context);
        throw Exception("Unauthorized access");
      }
      else {
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
