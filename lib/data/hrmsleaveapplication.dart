import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmsLeaveApplicationRepo
{
  List<dynamic>  hrmsleaveapplication = [];


  Future<List> hrmsleave(BuildContext context, String? formDate, String? toDate, String reason, String address, String selectedValue, String sFirstName, String sLvDesc, String sLvTypeCode) async
  {


       //showLoader();
    int currentYear = DateTime.now().year;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');
       print('----29---sEmpCode----$sEmpCode');
    print('-------30----sLvType---$sLvTypeCode');
    print('-------31---dFromDate----$formDate');
    print('-------32----dToDate---$toDate');
    print('-------33----sLeaveReason---$reason');
    print('-------34----sContactableAddress---$address');
    print('-------35---sLeaveAppBy----$sFirstName');
    print('-------35----sFullHalfDay---$selectedValue');
    print('-------36----iLeaveYear---$currentYear');

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsLeaveApplication/hrmsLeaveApplication";
    var hrmsLeaveApplication = "$baseURL$endPoint";
    print('------------30---hrmsLeaveApplication---$hrmsLeaveApplication');

    showLoader();

    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsLeaveApplication'));
      request.body = json.encode({
        "sEmpCode": sEmpCode,
        "sLvType": sLvTypeCode,
        "dFromDate": formDate,
        "dToDate": toDate,
        "sLeaveReason": reason,
        "sContactableAddress": address,
        "sLeaveAppBy": sFirstName,
        "sFullHalfDay": selectedValue,
        "iLeaveYear": currentYear,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200)
      {
        hideLoader();
        print('----${response.statusCode}');
        var data = await response.stream.bytesToString();
        //print('--74---xxx---${jsonDecode(data)}');
        // Map<String, dynamic> parsedJson = jsonDecode(data);
        //distList = parsedJson['Data'];
        // distList = jsonDecode(data);
        List<dynamic> hrmsleavebalacev2List = jsonDecode(data);
        print('----75---$hrmsleavebalacev2List');
        return hrmsleavebalacev2List;
      } else
      {
        hideLoader();
        return hrmsleaveapplication;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}


//class HrmsLeaveApplicationRepo {

  // this is a loginApi call functin

//   Future hrmsleaveapplication(BuildContext context) async {
//
//     try {
//
//       showLoader();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? sToken = prefs.getString('sToken');
//       String? sEmpCode = prefs.getString('sEmpCode');
//       int currentYear = DateTime.now().year;
//
//
//       var baseURL = BaseRepo().baseurl;
//       var endPoint = "hrmsLeaveApplication/hrmsLeaveApplication";
//       var hrmsLeaveApplicationApi = "$baseURL$endPoint";
//       print('------------17---hrmsLeaveApplicationApi---$hrmsLeaveApplicationApi');
//
//       showLoader();
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request('POST', Uri.parse('$hrmsLeaveApplicationApi'));
//
//       request.body = json.encode({
//         "sEmpCode": "",
//         "sLvType": "",
//         "dFromDate": "",
//         "dToDate": "",
//         "sLeaveReason": "",
//         "sContactableAddress": "",
//         "sLeaveAppBy": "",
//         "sFullHalfDay": "",
//         "iLeaveYear": "",
//       });
//
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       var map;
//       var data = await response.stream.bytesToString();
//       map = json.decode(data);
//       print('----------20---login RESPONSE----$map');
//       if (response.statusCode == 200) {
//         hideLoader();
//         print('----------22-----$map');
//         return map;
//       } else {
//         print('----------29---LOGINaPI RESPONSE----$map');
//         hideLoader();
//         print(response.reasonPhrase);
//         return map;
//       }
//     } catch (e) {
//       hideLoader();
//       debugPrint("exception: $e");
//       throw e;
//     }
//   }
// }


