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
    showLoader();
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
        hideLoader();
        var data = await response.stream.bytesToString();
        //print('--74---xxx---${jsonDecode(data)}');
        // Map<String, dynamic> parsedJson = jsonDecode(data);
        //distList = parsedJson['Data'];
        // distList = jsonDecode(data);
        List<dynamic> distList = jsonDecode(data);
        return distList;
      } else
      {
        hideLoader();
        return distList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
