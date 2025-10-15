import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/app/generalFunction.dart';
import 'package:untitled/data/loader_helper.dart';
import 'package:untitled/domain/tripDetailModel.dart';
import 'baseurl.dart';


class HrmstripdetailRepo {

  var hrmsleavebalacev2List = [];
 // GeneralFunction  throw Exception('Unauthorized access');
  GeneralFunction generalFunction = new GeneralFunction();

  Future<List<TripDetailModel>>  hrmsTripDetail(BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');
    print('----21--$firstOfMonthDay');
    print('----22--$lastDayOfCurrentMonth');
    print('----23--$contactNo');

    showLoader();

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsapistripdetails/hrmsapistripdetails";
    var hrmsTripDetal = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsTripDetal'));
      request.body = json.encode({
        "sContactNo": contactNo,
        "dFromDate": firstOfMonthDay,
        "dToDate": lastDayOfCurrentMonth,
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if(response.statusCode == 200) {
        hideLoader();

        // Convert the response stream to a string
        String responseBody = await response.stream.bytesToString();
        // Decode the response body
        List jsonResponse = jsonDecode(responseBody);
        print('---54--$jsonResponse');
        // Return the list of LeaveData
        return jsonResponse.map((data) => TripDetailModel.fromJson(data)).toList();

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
