import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/data/loader_helper.dart';
import '../domain/pinSlipModel.dart';
import 'baseurl.dart';


class PinSlipRepo {

  var hrmsleavebalacev2List = [];

  Future<List<PinSlipModel>>  pinslip(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');

    print('--17 --sEmpCode--$sEmpCode');
    showLoader();
    //  String defaultFromDate = "01/Sep/2024";
    //String defaultToDate = "30/Sep/2024";
    // String fromDate = firstOfMonthDay ?? defaultFromDate;
    //String toDate = lastDayOfCurrentMonth ?? defaultToDate;

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsmonthlist/hrmsmonthlist";
    var hrmsStafList = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsStafList'));
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
        return jsonResponse.map((data) => PinSlipModel.fromJson(data)).toList();

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