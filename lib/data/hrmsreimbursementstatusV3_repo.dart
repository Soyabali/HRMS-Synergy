import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/data/loader_helper.dart';
import '../domain/hrmsreimbursementstatusV3Model.dart';
import 'baseurl.dart';


class Hrmsreimbursementstatusv3Repo {

  var hrmsleavebalacev2List = [];

  Future<List<Hrmsreimbursementstatusv3model>>  hrmsReimbursementStatusList(BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth) async{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      String? contactNo = prefs.getString('sContactNo');
      print('--15 --firstOfMonthDay--$firstOfMonthDay');
      print('--16 --lastDayOfCurrentMonth--$lastDayOfCurrentMonth');
      print('--17 --contactNo--$contactNo');
      showLoader();
    //  String defaultFromDate = "01/Sep/2024";
      //String defaultToDate = "30/Sep/2024";
     // String fromDate = firstOfMonthDay ?? defaultFromDate;
      //String toDate = lastDayOfCurrentMonth ?? defaultToDate;

          var baseURL = BaseRepo().baseurl;
          var endPoint = "hrmsreimbursementstatusV3/hrmsreimbursementstatusV3";
           var hrmsreimbursementstatusV3 = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsreimbursementstatusV3'));
      request.body = json.encode({
              "sType": "A",
              "dFromDate": firstOfMonthDay,
              "sUserId": contactNo,
              "iPage": "1",
              "iPageSize": "10",
              "dToDate": lastDayOfCurrentMonth,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        hideLoader();

        // Convert the response stream to a string
        String responseBody = await response.stream.bytesToString();
        // Decode the response body
        List jsonResponse = jsonDecode(responseBody);
        print('---54--$jsonResponse');
        // Return the list of LeaveData
        return jsonResponse.map((data) => Hrmsreimbursementstatusv3model.fromJson(data)).toList();

      } else {
        hideLoader();
        throw Exception('Failed to load leave data');
      }
    } catch (e) {
      hideLoader();
      throw (e);
    }
  }
}
