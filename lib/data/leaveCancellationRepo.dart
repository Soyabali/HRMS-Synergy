import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class LeaveCancellationRepo {

  // this is a loginApi call functin

  Future leaveCancellation(BuildContext context, String queryTitle, String iTranId) async {

    try {
      //print('----16---$sTranCode');
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsLeaveCancellationRequest/hrmsLeaveCancellationRequest";
      var leaveCancellationApi = "$baseURL$endPoint";
      print('------------17---leaveCancellationApi Api ---$leaveCancellationApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$leaveCancellationApi'));
      request.body = json.encode({
        "iTranId": iTranId,
        "sCancellationReasion": queryTitle,
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
