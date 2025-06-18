import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/data/loader_helper.dart';
import '../app/generalFunction.dart';
import '../domain/GetConsumablesReimbItem_Model.dart';
import 'baseurl.dart';


class ConsumableItemRepo {

  var consumableItemList = [];
  GeneralFunction generalFunction = GeneralFunction();

  Future<List<GetConsumableSreimbitemModel>>  consumableList(BuildContext context, String stranCode) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');
    print('--17 --contactNo--$contactNo');
    print('------22----StranCode-----$stranCode');
    showLoader();
    //  String defaultFromDate = "01/Sep/2024";
    //String defaultToDate = "30/Sep/2024";
    // String fromDate = firstOfMonthDay ?? defaultFromDate;
    //String toDate = lastDayOfCurrentMonth ?? defaultToDate;

    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetConsumablesReimbItem/GetConsumablesReimbItem";
    var consumableitemApi = "$baseURL$endPoint";

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$consumableitemApi'));
      request.body = json.encode({
        "sTranCode": stranCode,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if(response.statusCode==401){
        // logout
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
        return jsonResponse.map((data) => GetConsumableSreimbitemModel.fromJson(data)).toList();

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
