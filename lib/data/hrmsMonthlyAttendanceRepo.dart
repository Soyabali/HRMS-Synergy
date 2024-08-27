import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/hrmsMonthlyAttendanceModel.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class HrmsmonthlyattendanceRepo
{
  List<dynamic>  distList = [];
  Future<List> monthlyAttendanceList(BuildContext context, String dDate) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');

    print('-----19---$sToken');
    print('-----20--Datee----$dDate');


    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsMonthlyAttendance/hrmsMonthlyAttendance";
    var projectList = "$baseURL$endPoint";
    print('------------17---loginApi---$projectList');

    //showLoader();

    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$projectList'));
      request.body = json.encode({
         // "dMonth": '31/Aug/2024',
          "dMonth": dDate.toString(),
          "sEmpCode": sEmpCode,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        var data = await response.stream.bytesToString();
        //print('--74---xxx---${jsonDecode(data)}');
        // Map<String, dynamic> parsedJson = jsonDecode(data);
        //distList = parsedJson['Data'];
        // distList = jsonDecode(data);
        List<dynamic> distList = jsonDecode(data);
        return distList;
      } else
      {
        return distList;
      }
    } catch (e)
    {
      throw (e);
    }
  }
}


// class HrmsmonthlyattendanceRepo
// {
//   //List<dynamic>  monthlyAttendancehList = [];
//
//   Future<List<HrmsmonthlyattendanceModel>?>  monthlyAttendanceList(BuildContext context) async
//   {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//
//     print('-----22---$sToken');
//
//
//     var baseURL = BaseRepo().baseurl;
//     var endPoint = "hrmsMonthlyAttendance/hrmsMonthlyAttendance";
//     var monthlyAttendanceList = "$baseURL$endPoint";
//     print('------------17---getCurrentPreviousMonth---$monthlyAttendanceList');
//
//     showLoader();
//
//     try
//     {
//       var headers = {
//         'token': '$sToken',
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request('POST', Uri.parse('$monthlyAttendanceList'));
//       request.body = json.encode({
//           "dMonth": '31/Aug/2024',
//           "sEmpCode": '7286130446',
//       });
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200)
//       {
//
//         var data = await response.stream.bytesToString();
//         hideLoader();
//         //print('--74---xxx---${jsonDecode(data)}');
//         // Map<String, dynamic> parsedJson = jsonDecode(data);
//         //distList = parsedJson['Data'];
//         // distList = jsonDecode(data);
//         List<dynamic> getCurrentAndPreviousMonthList = jsonDecode(data);
//
//         if (getCurrentAndPreviousMonthList != null) {
//           // response convert into the model
//           List<HrmsmonthlyattendanceModel> temples = getCurrentAndPreviousMonthList.map((json) => HrmsmonthlyattendanceModel.fromJson(json)).toList();
//           print('-----57----$temples');
//           return temples;
//         } else {
//           hideLoader();
//           return null;
//         }
//
//       } else
//       {
//         hideLoader();
//         return null;
//       }
//     } catch (e)
//     {
//       throw (e);
//     }
//   }
// }

