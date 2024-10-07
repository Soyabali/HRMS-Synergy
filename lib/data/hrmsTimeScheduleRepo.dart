import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class HrmsTimeScheduleRepo
{
  List<dynamic>  distList = [];
  Future<List> timeScheduleList(BuildContext context) async
  {
    showLoader();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');

    print('-----19---$sToken');

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmstimeschedule/hrmstimeschedule";
    var hrmsTimeScheduleList = "$baseURL$endPoint";
    print('------------17---hrmsTimeScheduleList---$hrmsTimeScheduleList');

    //showLoader();

    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsTimeScheduleList'));
      request.body = json.encode({
        // "dMonth": '31/Aug/2024',
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
