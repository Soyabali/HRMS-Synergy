import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/data/loader_helper.dart';
import '../app/generalFunction.dart';
import '../domain/ApprovedTeamReimbursementModel.dart';
import 'baseurl.dart';

class ApprovedTeamReimbursementRepo {

  var approvedteamReimList = [];

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<ApprovedTeamReimbursementModel>>  approvedTeamReimbursementList(BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth, sStatusValue, empCode) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');
    print('--15 --firstOfMonthDay--$firstOfMonthDay');
    print('--16 --lastDayOfCurrentMonth--$lastDayOfCurrentMonth');
    print('--17 --contactNo--$contactNo');
    print('-----22---sStatusValue---$sStatusValue');
    print("-------24- empCode-----$empCode");
    showLoader();
    //  String defaultFromDate = "01/Sep/2024";
    //String defaultToDate = "30/Sep/2024";
    // String fromDate = firstOfMonthDay ?? defaultFromDate;
    //String toDate = lastDayOfCurrentMonth ?? defaultToDate;

    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetApprovedTeamReimbursement/GetApprovedTeamReimbursement";
    var approvedRemApi = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$approvedRemApi'));
      request.body = json.encode({

        // "dFromDate": "01/Nov/2024",
        // "dToDate": "30/Nov/2024",
        // "sUserId" : "9810754385",
        // "iStatus" : "9",
        // "sEmpCode" : "7814104309",

        "dFromDate": firstOfMonthDay,
        "dToDate": lastDayOfCurrentMonth,
        "sUserId" : contactNo,
        "iStatus" : sStatusValue,
        "sEmpCode" : empCode,

      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if(response.statusCode==401){
        hideLoader();
        generalFunction.logout(context);
        throw Exception('Unauthorized access');
      }
      if (response.statusCode == 200) {
        hideLoader();

        // Convert the response stream to a string
        String responseBody = await response.stream.bytesToString();
        // Decode the response body
        List jsonResponse = jsonDecode(responseBody);
        print('---54--$jsonResponse');
        // Return the list of LeaveData
        return jsonResponse.map((data) => ApprovedTeamReimbursementModel.fromJson(data)).toList();

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
