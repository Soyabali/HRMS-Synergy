import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/app/generalFunction.dart';
import 'package:untitled/data/loader_helper.dart';
import '../domain/actionOnLeaveModel.dart';
import 'baseurl.dart';

class HrmsLeavePendingForApprovailRepo {
   GeneralFunction generalFunction = GeneralFunction();
  var hrmsLeavePendingForApprovailList = [];

  Future<List<HrmsLeavePendingForApprovalModel>>  hrmsLevePendingForApprovalList(BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth, sStatusValue) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');
    print('--15 --firstOfMonthDay--$firstOfMonthDay');
    print('--16 --lastDayOfCurrentMonth--$lastDayOfCurrentMonth');
    print('--17 --contactNo--$contactNo');
    print('-----21---sStatusValue---$sStatusValue');
    showLoader();
    //  String defaultFromDate = "01/Sep/2024";
    //String defaultToDate = "30/Sep/2024";
    // String fromDate = firstOfMonthDay ?? defaultFromDate;
    //String toDate = lastDayOfCurrentMonth ?? defaultToDate;

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsleavependingforapproval/hrmsleavependingforapproval";
    var hrmsLeavePendingForApprovalApi = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsLeavePendingForApprovalApi'));
      request.body = json.encode({
        "sContactNo":contactNo,
        "sStatus":sStatusValue,
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
        print('---54--$jsonResponse');
        // Return the list of LeaveData
        return jsonResponse.map((data) => HrmsLeavePendingForApprovalModel.fromJson(data)).toList();

      }
      else if(response.statusCode==401){
        generalFunction.logout(context);
        throw Exception('Unauthorized access');
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
