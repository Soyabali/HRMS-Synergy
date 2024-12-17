import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class PersonaldetailRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future personal_detail(BuildContext context) async {

    try {
      // get a local database value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      String? sEmpCode = prefs.getString('sEmpCode');
      // you have to  pass contactNo to sEmpCode fields

      String? sContactNo = prefs.getString('sContactNo');

      print('----sToken--19---$sToken');
      print('----sContactNo--19---$sContactNo');
      print('----sPolicyCode--19---$sEmpCode');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsPersonalDetails/hrmsPersonalDetails";
      var personalDetailApi = "$baseURL$endPoint";
      print('------------17---personalDetailApi Api ---$personalDetailApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      // todo in a reject case you should forware 0 and accept case you should pass 1 in a iStatus code
      var request = http.Request('POST', Uri.parse('$personalDetailApi'));
      request.body = json.encode({
        "sEmpCode": sEmpCode,

      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('---------48---persoalDetail response----$map');

      if (response.statusCode == 200) {
        hideLoader();
        print('----------22-----$map');
        return map;
      }else if(response.statusCode==401){
        hideLoader();
        generalFunction.logout(context);
      }

      else {
        print('----------29---personalDetail RESPONSE----$map');
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
