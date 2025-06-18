
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class PostImageRepo {

  // this is a loginApi call functin

  Future postImage(BuildContext context, File? imageFile) async {

    /// Here you should get a value from a sharedPreferenc that is stored at a login time.
    ///
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? iUserId = prefs.getString('iUserId');

    print('-----22---$sToken');
    print('-----23---$iUserId');
    print('----25---$imageFile');

    try {

      var baseURL = BaseRepo().baseurl;
      var endPoint = "PostImage/PostImage";
      var postImageApi = "$baseURL$endPoint";
      print('------------17---sectorApi---$postImageApi');

      showLoader();
      // var headers = {
      //   'token': '$sToken'
      // };
      // var request = http.MultipartRequest('POST', Uri.parse('$postImageApi'));
      // request.files.add(await http.MultipartFile.fromPath('sImagePath', '/C:/Users/SynergyTelematics/Desktop/WhatsApp Image 2024-04-23 at 3.59.09 PM.jpeg'));
      // request.headers.addAll(headers);
      // http.StreamedResponse response = await request.send();
      //
      // var map;
      // var data = await response.stream.bytesToString();
      // map = json.decode(data);
      // print('----------50---poarImage Response----$map');

      var headers = {
        'token': '$sToken'
      };
      var request = http.MultipartRequest('POST', Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));
      request.files.add(await http.MultipartFile.fromPath('', '/C:/Users/SynergyTelematics/Desktop/WhatsApp Image 2024-04-23 at 3.59.09 PM.jpeg'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      // map = json.decode(data);
      // print('----------50---poarImage Response----$map')

      if (response.statusCode == 200) {
        hideLoader();
        print('----------53-----$map');
        return map;
      } else {
        print('----------56  Response----$map');
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
