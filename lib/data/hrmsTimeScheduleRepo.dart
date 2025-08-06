import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


// class HrmsTimeScheduleRepo
// {
//   List<dynamic>  distList = [];
//   Future<List> timeScheduleList(BuildContext context) async
//   {
//     showLoader();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//     String? sEmpCode = prefs.getString('sEmpCode');
//
//     print('-----19---$sToken');
//
//     var baseURL = BaseRepo().baseurl;
//     var endPoint = "hrmstimeschedule/hrmstimeschedule";
//     var hrmsTimeScheduleList = "$baseURL$endPoint";
//     print('------------17---hrmsTimeScheduleList---$hrmsTimeScheduleList');
//
//     //showLoader();
//
//     try
//     {
//       var headers = {
//         'token': '$sToken',
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request('POST', Uri.parse('$hrmsTimeScheduleList'));
//       request.body = json.encode({
//         // "dMonth": '31/Aug/2024',
//         "sEmpCode": sEmpCode,
//       });
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200)
//       {
//         hideLoader();
//         var data = await response.stream.bytesToString();
//         //print('--74---xxx---${jsonDecode(data)}');
//         // Map<String, dynamic> parsedJson = jsonDecode(data);
//         //distList = parsedJson['Data'];
//         // distList = jsonDecode(data);
//         List<dynamic> distList = jsonDecode(data);
//         return distList;
//       } else
//       {
//         hideLoader();
//         return distList;
//       }
//     } catch (e)
//     {
//       hideLoader();
//       throw (e);
//     }
//   }
// }
class HrmsTimeScheduleRepo {
  Future<List<Map<String, dynamic>>> timeScheduleList(BuildContext context) async {
    showLoader();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmstimeschedule/hrmstimeschedule";
    var hrmsTimeScheduleListUrl = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json',
      };
      var request = http.Request('POST', Uri.parse(hrmsTimeScheduleListUrl));
      request.body = json.encode({
        "sEmpCode": sEmpCode,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        List<dynamic> rawList = jsonDecode(data);
        print("-----91----$rawList");

        // Convert to List<Map<String, String>>
        List<Map<String, dynamic>> formattedList = rawList.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        return formattedList;
      } else {
        hideLoader();
        return [];
      }
    } catch (e) {
      hideLoader();
      throw (e);
    }
  }
}

