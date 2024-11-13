import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/data/loader_helper.dart';
import '../data/baseurl.dart';
import '../domain/GetDuplicateEtriesForCrossCheckModel.dart';


class DuplicateEntriesforcrossCheckRepo {

  var duplicateEnteryforcrossCheckList = [];
  var sTranCode;
  Future<List<DuplicateEntriesForCrossCheck>>  duplicateEntryCrossCheck(BuildContext context, sTranCode) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    showLoader();
    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetDuplicateEtriesForCrossCheck/GetDuplicateEtriesForCrossCheck";
    var duplicateEntryForCrossCheckApi = "$baseURL$endPoint";
      print('--------sTranCode--23-$sTranCode');
    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$duplicateEntryForCrossCheckApi'));
      request.body = json.encode({
        "sTranCode": sTranCode,
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
        return jsonResponse.map((data) => DuplicateEntriesForCrossCheck.fromJson(data)).toList();

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
