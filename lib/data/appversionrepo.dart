import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Helpers/loader_helper.dart';
import 'baseurl.dart';


class AppVersionRepo {

  // this is a loginApi call functin

  Future appversion(BuildContext context, String version) async {

    try {
      print('----version--15---$version');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "VerifyAppVersion/VerifyAppVersion";
      var versionApi = "$baseURL$endPoint";
      print('------------17---versionApi---$versionApi');

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse('$versionApi'));
      request.body = json.encode({"sVersion": version});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---version RESPONSE----$map');

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
