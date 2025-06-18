import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/app/generalFunction.dart';
import 'package:untitled/data/loader_helper.dart';
import '../data/baseurl.dart';
import 'GetPendingForApprovalReimModel.dart';


class GetPendingforApprovalReimRepo {

  var getPendingForApprovalList = [];
  GeneralFunction generalFunction = GeneralFunction();

  Future<List<GetPendingForApprovalReimmodel>> getPendingApprovalReim(
      BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');

    print('--15 --firstOfMonthDay--$firstOfMonthDay');
    print('--16 --lastDayOfCurrentMonth--$lastDayOfCurrentMonth');
    print('--17 --contactNo--$contactNo');

    showLoader();

    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetPendingForApprovalReim/GetPendingForApprovalReim";
    var hrmsreimbursementstatusV3 = "$baseURL$endPoint";

    try {
      var headers = {
        'token': sToken ?? '',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(hrmsreimbursementstatusV3));
      request.body = json.encode({
        "sUserId": contactNo,
        "dFromDate": firstOfMonthDay,
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
        print('---54---->>>--$jsonResponse');
        // Return the list of GetPendingForApprovalReimmodel
        return jsonResponse
            .map((data) => GetPendingForApprovalReimmodel.fromJson(data))
            .toList();
      } else if (response.statusCode == 401) {
        hideLoader();
        generalFunction.logout(context);
        throw Exception('Unauthorized access');
      } else {
        hideLoader();
        throw Exception('Failed to load pending approvals');
      }
    } catch (e) {
      hideLoader();
      throw Exception('An error occurred: $e');
    } finally {
      hideLoader(); // Ensure the loader is hidden in all cases
    }
  }

// Future<List<GetPendingForApprovalReimmodel>>  getPendingApprovalReim(BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth) async{
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? sToken = prefs.getString('sToken');
  //   String? contactNo = prefs.getString('sContactNo');
  //   print('--15 --firstOfMonthDay--$firstOfMonthDay');
  //   print('--16 --lastDayOfCurrentMonth--$lastDayOfCurrentMonth');
  //   print('--17 --contactNo--$contactNo');
  //   showLoader();
  //   var baseURL = BaseRepo().baseurl;
  //   var endPoint = "GetPendingForApprovalReim/GetPendingForApprovalReim";
  //   var hrmsreimbursementstatusV3 = "$baseURL$endPoint";
  //
  //   try {
  //     var headers = {
  //       'token': '$sToken',
  //       'Content-Type': 'application/json'
  //     };
  //     var request = http.Request('POST', Uri.parse('$hrmsreimbursementstatusV3'));
  //     request.body = json.encode({
  //       "sUserId": contactNo,
  //       "dFromDate": firstOfMonthDay,
  //       "dToDate": lastDayOfCurrentMonth,
  //     });
  //     request.headers.addAll(headers);
  //     http.StreamedResponse response = await request.send();
  //     if (response.statusCode == 200) {
  //       hideLoader();
  //
  //       // Convert the response stream to a string
  //       String responseBody = await response.stream.bytesToString();
  //       // Decode the response body
  //       List jsonResponse = jsonDecode(responseBody);
  //       print('---54--$jsonResponse');
  //       // Return the list of LeaveData
  //       return jsonResponse.map((data) => GetPendingForApprovalReimmodel.fromJson(data)).toList();
  //
  //     }
  //     else if(response.statusCode==401){
  //       generalFunction.logout(context);
  //     }
  //     else {
  //       hideLoader();
  //       throw Exception('Failed to load leave data');
  //     }
  //   } catch (e) {
  //     hideLoader();
  //     throw (e);
  //   }
  // }
}
