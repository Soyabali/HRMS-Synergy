

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmsreimbursementLogRepo {
  List<dynamic>  hrmsleavebalacev2List = [];
  GeneralFunction generalFunction = GeneralFunction();
  Future<List> hrmsReimbursementLog(BuildContext context, String sTranCode) async
  {

   // print('---date----13---$dDate');
    //showLoader();
    int currentYear = DateTime.now().year;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsReimbursementLog/hrmsReimbursementLog";
    var hrmsReimbursementLogApi = "$baseURL$endPoint";
    print('------------17---hrmsReimbursementLogApi---$hrmsReimbursementLogApi');

    showLoader();

    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsReimbursementLogApi'));
      request.body = json.encode({
        "sTranCode":sTranCode
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if(response.statusCode==401){
        // todo apply logout code
        generalFunction.logout(context);
      }
      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        //print('--74---xxx---${jsonDecode(data)}');
        // Map<String, dynamic> parsedJson = jsonDecode(data);
        //distList = parsedJson['Data'];
        // distList = jsonDecode(data);
        List<dynamic> hrmsleavebalacev2List = jsonDecode(data);
        return hrmsleavebalacev2List;
      } else
      {
        hideLoader();
        return hrmsleavebalacev2List;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }

  // Future<List<Map<String, dynamic>>?> hrmsReimbursementLog(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? sToken = prefs.getString('sToken');
  //
  //   try {
  //     var baseURL = BaseRepo().baseurl;
  //     var endPoint = "hrmsReimbursementLog/hrmsReimbursementLog";
  //     var bindsectorApi = "$baseURL$endPoint";
  //
  //     showLoader();
  //     var headers = {
  //       'token': '$sToken',
  //       'Content-Type': 'application/json'
  //     };
  //     var request = http.Request('POST', Uri.parse('$bindsectorApi'));
  //     request.body = json.encode({
  //       "sTranCode": "27456559",
  //
  //     });
  //     request.headers.addAll(headers);
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       hideLoader();
  //       var data = await response.stream.bytesToString();
  //       // Parse the response as a List<dynamic>
  //       List<dynamic> parsedJson = jsonDecode(data);
  //       // Convert the List<dynamic> to List<Map<String, dynamic>>
  //       List<Map<String, dynamic>> pendingSchedulepointList = List<Map<String, dynamic>>.from(parsedJson);
  //       print("Dist list----48: $pendingSchedulepointList");
  //       return pendingSchedulepointList;
  //     } else if(response.statusCode==401) {
  //       // Handle unauthorized error
  //     }
  //
  //   } catch (e) {
  //     hideLoader();
  //     debugPrint("Exception: $e");
  //     throw e;
  //   }
  //   return null;
  // }
}
