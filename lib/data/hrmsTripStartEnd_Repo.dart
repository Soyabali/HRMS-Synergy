import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/app/generalFunction.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmstripstartendRepo {

   GeneralFunction generalFunction = GeneralFunction();
  Future tripStart(BuildContext context, String sContactNo, double? lat, double? long, String randomNumber, uplodedImage, String edtOdometer, dTripDateTime, locationAddress) async {
    try {
      print('---Scontact----$sContactNo');
      print('---lat----$lat');
      print('---long----$long');
      print('---randomNumber----$randomNumber');
      print('---uplodedImage----$uplodedImage');
      print('---edtOdometer----$edtOdometer');
      print('---dTripDateTime----$dTripDateTime');
      print('-----locationAddress----21----$locationAddress');

      // get a token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsTripStartEnd/hrmsTripStartEnd";
      var tripStartApi = "$baseURL$endPoint";
      print('------------17---tripStartApi---$tripStartApi');

      // Show loader
      showLoader();

      // Headers for the request
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json',
      };

      // Body of the POST request
      var body = json.encode({
        "sContactNo": sContactNo,
        "dTripDateTime": dTripDateTime,
        "iTripFor": "1",
        "fLat": lat,
        "sTranNo": randomNumber,
        "fLon": long,
        "sImage": uplodedImage,
        "fOdometers": edtOdometer,
        "sLocation": locationAddress
      });

      // Sending POST request
      var response = await http.post(
        Uri.parse(tripStartApi),
        headers: headers,
        body: body,
      );

      // Check for response
      if (response.statusCode == 200) {
        print('----47--${response.statusCode}');
        hideLoader();
        var map = json.decode(response.body);
        print('----------22-----$map');
        return map;
      }
      else if(response.statusCode==200){
        generalFunction.logout(context);
      }
      else {
        print('----53--${response.statusCode}');
        hideLoader();
        print('----------29---API RESPONSE ERROR: ${response.reasonPhrase}');
        return json.decode(response.body);
      }
    } catch (e) {

      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }
}
