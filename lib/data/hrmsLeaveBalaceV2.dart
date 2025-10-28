import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../domain/leavebalance.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class Hrmsleavebalacev2Repo {

  GeneralFunction generalFunction = GeneralFunction();

  var hrmsleavebalacev2List = [];

  Future<List<LeaveData>> getHrmsleavebalacev2(BuildContext context) async {
    // get a currentYear and CurrentMonth

    DateTime now = DateTime.now();
    var currentMonth = DateFormat('dd/MMM/yyyy').format(now);
    var currentYear = DateFormat('yyyy').format(now);

    print('---25--currentMonth--$currentMonth');
    print('---26--currentYear--$currentYear');

    showLoader();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');
    print('---21--token--$sToken');
    print('---22--sEmpCode--$sEmpCode');

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsLeaveBalanceV2/hrmsLeaveBalanceV2";
    var hrmsLeaveBalanceApi = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json',
      };
      var request = http.Request('POST', Uri.parse('$hrmsLeaveBalanceApi'));
      request.body = json.encode({
        "dYTDMonth": currentMonth,
        "iLeaveYear": currentYear,
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
        print('---46--$jsonResponse');
        // Return the list of LeaveData
        return jsonResponse.map((data) => LeaveData.fromJson(data)).toList();
      } else if (response.statusCode == 401) {
        hideLoader();
        generalFunction.logout(context);
        throw Exception('Unauthorized access');
      } else {
        hideLoader();
        throw Exception('Failed to load leave data');
      }
    } catch (e) {
      hideLoader();
      throw Exception('An error occurred: $e');
    } finally {
      // Ensure the loader is hidden in case of an unhandled error
      hideLoader();
    }
  }
}
