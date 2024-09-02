import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/data/loader_helper.dart';
import 'baseurl.dart';


class Hrmsreimbursementstatusv3Repo {

  Future<List<Map<String, dynamic>>?> hrmsReimbursementStatusList(BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');
    print('--15 --firstOfMonthDay--$firstOfMonthDay');
    print('--16 --lastDayOfCurrentMonth--$lastDayOfCurrentMonth');
    print('--17 --contactNo--$contactNo');

    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsreimbursementstatusV3/hrmsreimbursementstatusV3";
      var bindsectorApi = "$baseURL$endPoint";

      showLoader();
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$bindsectorApi'));
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
        var data = await response.stream.bytesToString();
        // Parse the response as a List<dynamic>
        List<dynamic> parsedJson = jsonDecode(data);
        // Convert the List<dynamic> to List<Map<String, dynamic>>
        List<Map<String, dynamic>> pendingSchedulepointList = List<Map<String, dynamic>>.from(parsedJson);

        print("Dist list----48: $pendingSchedulepointList");
        return pendingSchedulepointList;
      } else if(response.statusCode==401) {
        // Handle unauthorized error
      }

    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
      throw e;
    }
    return null;
  }
}
