import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmsWorkEntryNewRepo {
  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future hrmsWorkEntryNew(BuildContext context, String combinedList) async {
    // sharedP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('sToken');
    var sEmpCode = prefs.getString('sEmpCode');

    try {
      var baseURL = BaseRepo().baseurl;
      /// TODO CHANGE HERE
      var endPoint = "hrmsworkstatusentrynew/hrmsworkstatusentrynew";
      var hrmsWorkStatusApi = "$baseURL$endPoint";
      print('------------39---hrmsWorkStatusApi---$hrmsWorkStatusApi');
      // here pass parameter as  a array :
      String jsonResponse = '{"sEmpCode":"$sEmpCode","TEmployeeWorkStatusType":$combinedList}';

// Print the updated JSON response (optional)
      print(jsonResponse);
      print('---55-----$jsonResponse');

//Your API call
      var headers = {'token': '$token', 'Content-Type': 'application/json'};

      var request = http.Request(
          'POST',
          Uri.parse('$hrmsWorkStatusApi'));
      request.body = jsonResponse; // Assign the JSON string to the request body
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('-------89--$map');
      print('---90---${response.statusCode}');
      // var response;
      // var map;
      //print('----------20---LOGINaPI RESPONSE----$map');
      if (response.statusCode == 200) {
        print('------92----xxxxxxxxxxxxxxx----');
        hideLoader();
        print('----------96-----$map');
        return map;
      } else if(response.statusCode==401)
      {
        generalFunction.logout(context);
      }else{
        print('----------99----$map');
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