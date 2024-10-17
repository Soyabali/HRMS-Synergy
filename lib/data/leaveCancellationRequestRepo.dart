import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class LeaveCancellationRequestRepo {

  // this is a loginApi call functin

  Future leaveCancellationRequest(BuildContext context, sTranCode, String takeAction) async {

    try {
      print('----16---$sTranCode');
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      print('----sToken--19---$sToken');
      print('----sTranCode--20---$sTranCode');
      print('----takeAction--21---$takeAction');



      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsLeaveCancellationRequest/hrmsLeaveCancellationRequest";
      var leaveCancellationReqestApi = "$baseURL$endPoint";
      //print('------------17---leaveCancellationReqestApi Api ---$leaveCancellationReqestApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$leaveCancellationReqestApi'));
      request.body = json.encode({
        "iTranId": sTranCode,
        "sCancellationReasion": takeAction,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      //print('---------48---LeaveCacellation response----$map');

      if (response.statusCode == 200) {
        hideLoader();
       // print('----------22-----$map');
        return map;
      } else {
        //print('----------29---LeaveCancellation Request----$map');
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
