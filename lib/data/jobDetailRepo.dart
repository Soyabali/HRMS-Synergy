import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/app/generalFunction.dart';
import 'package:untitled/data/loader_helper.dart';
import 'package:untitled/domain/educationModel.dart';
import 'package:untitled/domain/jobDetailModel.dart';
import '../domain/holidaylist_model.dart';
import '../domain/queryResponseModel.dart';
import 'baseurl.dart';


class JobDetailRepo {
   GeneralFunction generalFunction = GeneralFunction();
  Future<List<JobDetailmodel>>  jobDetailList(BuildContext context) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');

    showLoader();
    //  String defaultFromDate = "01/Sep/2024";
    //String defaultToDate = "30/Sep/2024";
    // String fromDate = firstOfMonthDay ?? defaultFromDate;
    //String toDate = lastDayOfCurrentMonth ?? defaultToDate;

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsJobDetails/hrmsJobDetails";
    var jobdetailList = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$jobdetailList'));

      request.body = json.encode({
        "sEmpCode": sEmpCode,
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
        return jsonResponse.map((data) => JobDetailmodel.fromJson(data)).toList();

      }
      else if(response.statusCode==401){
        generalFunction.logout(context);
        throw Exception("Unauthorized access");
      }
      else {
        hideLoader();
        throw Exception('Failed to load leave data');
      }
    } catch (e) {
      hideLoader();
      throw (e);
    }
  }
}
