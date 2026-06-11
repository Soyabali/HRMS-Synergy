import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/app/generalFunction.dart';
import 'package:untitled/data/loader_helper.dart';
import '../domain/leaveStatusModel.dart';
import 'baseurl.dart';

class HrmsLeaveStatusRepo {
   GeneralFunction generalFunction = GeneralFunction();
  var hrmsleavebalacev2List = [];

   Future<List<HrmsLeaveStatusModel>> hrmsLeveStatusList(
       BuildContext context,
       String firstOfMonthDay,
       String lastDayOfCurrentMonth,
       String sStatusValue) async {

     SharedPreferences prefs = await SharedPreferences.getInstance();

     String? sToken = prefs.getString('sToken');
     String? contactNo = prefs.getString('sContactNo');

     showLoader();

     try {

       var headers = {
         'token': sToken ?? '',
         'Content-Type': 'application/json',
       };

       var request = http.Request(
         'POST',
         Uri.parse(
           '${BaseRepo().baseurl}hrmsLeaveStatus/hrmsLeaveStatus',
         ),
       );

       request.body = jsonEncode({
         "sContactNo":contactNo,
         "sStatus": sStatusValue,
         "dFromDate": firstOfMonthDay,
         "dToDate": lastDayOfCurrentMonth,
       });

       request.headers.addAll(headers);

       print("REQUEST BODY => ${request.body}");

       final response = await request.send();

       final responseBody =
       await response.stream.bytesToString();

       print("STATUS CODE => ${response.statusCode}");
       print("RESPONSE => $responseBody");

       if (response.statusCode == 200) {

         final decoded = jsonDecode(responseBody);

         if (decoded is List) {
           return decoded
               .map<HrmsLeaveStatusModel>(
                 (e) => HrmsLeaveStatusModel.fromJson(e),
           )
               .toList();
         }

         return [];
       }

       if (response.statusCode == 401) {
         generalFunction.logout(context);
         return [];
       }

       return [];

     } catch (e) {
       print("API ERROR => $e");
       return [];
     } finally {
       hideLoader();
     }
   }

  // Future<List<HrmsLeaveStatusModel>> hrmsLeveStatusList(
  //      BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth, sStatusValue) async {
  //    SharedPreferences prefs = await SharedPreferences.getInstance();
  //    String? sToken = prefs.getString('sToken');
  //    String? contactNo = prefs.getString('sContactNo');
  //    print('--15 --firstOfMonthDay--$firstOfMonthDay');
  //    print('--16 --lastDayOfCurrentMonth--$lastDayOfCurrentMonth');
  //    print('--17 --contactNo--$contactNo');
  //    print('-----21---sStatusValue---$sStatusValue');
  //    print("------23-----token--$sToken");
  //    showLoader();
  //
  //    var baseURL = BaseRepo().baseurl;
  //    var endPoint = "hrmsLeaveStatus/hrmsLeaveStatus";
  //    var hrmsLeaveStatus = "$baseURL$endPoint";
  //
  //    try {
  //      var headers = {
  //        'token': sToken ?? '',
  //        'Content-Type': 'application/json',
  //      };
  //      var request = http.Request('POST', Uri.parse(hrmsLeaveStatus));
  //      request.body = json.encode({
  //        "sContactNo": "7417499589",
  //        "sStatus": "P",
  //        "dFromDate": "01/Jun/2026",
  //        "dToDate": "31/Jul/2026",
  //        // "sContactNo": contactNo,
  //        // "sStatus": sStatusValue,
  //        // "dFromDate": firstOfMonthDay,
  //        // "dToDate": lastDayOfCurrentMonth,
  //      });
  //      request.headers.addAll(headers);
  //      http.StreamedResponse response = await request.send();
  //
  //      if (response.statusCode == 200) {
  //        // Convert the response stream to a string
  //        String responseBody = await response.stream.bytesToString();
  //        // Decode the response body
  //        List jsonResponse = jsonDecode(responseBody);
  //        print('---54--$jsonResponse');
  //        // Return the list of HrmsLeaveStatusModel objects
  //        return jsonResponse.map((data) => HrmsLeaveStatusModel.fromJson(data)).toList();
  //      } else if (response.statusCode == 401) {
  //        generalFunction.logout(context);
  //        throw Exception('Unauthorized access');
  //      } else {
  //        throw Exception('Failed to load leave data, status code: ${response.statusCode}');
  //      }
  //    } catch (e) {
  //      hideLoader();
  //      rethrow; // Propagate the error to be handled by the caller
  //    } finally {
  //      hideLoader(); // Ensure loader is hidden even if an error occurs
  //    }
  //  }
}
