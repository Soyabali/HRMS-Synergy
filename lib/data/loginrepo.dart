import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'baseurl.dart';
import 'loader_helper.dart';


class LoginRepo {

  // this is a loginApi call functin

  Future login(BuildContext context, String mobileNo,String password) async {

    try {
      print('----mobileNo--15---$mobileNo');
      print('----password--15---$password');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsLogin/hrmsLogin";
      var loginApi = "$baseURL$endPoint";
      print('------------17---loginApi---$loginApi');

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$loginApi'));
      request.body = json.encode({
        "sContactNo": mobileNo,
        "sPassword": password,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---login RESPONSE----$map');
      if (response.statusCode == 200) {
        hideLoader();
        print('----------22-----$map');
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
