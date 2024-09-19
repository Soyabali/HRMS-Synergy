import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class NotificatindeleteRepo {

  // this is a loginApi call functin

  Future notification(BuildContext context, iTranId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sContactNo = prefs.getString('sContactNo');
    print('------19----$iTranId');

    print('-----22---$sToken');

    try {

      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsdeletenotification/hrmsdeletenotification";
      var notificationDeleteApi = "$baseURL$endPoint";
      print('------------17---notificationDeleteApi---$notificationDeleteApi');

      showLoader();
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$notificationDeleteApi'));
      request.body = json.encode({
        "sContactNo": sContactNo,
        "iTranId": iTranId,

      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);

      if (response.statusCode == 200) {
        // create an instance of auth class
        print('----44-${response.statusCode}');
        hideLoader();
        print('----------53-----$map');
        return map;
      } else {
        print('----------29---LOGINaPI RESPONSE----$map');
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
