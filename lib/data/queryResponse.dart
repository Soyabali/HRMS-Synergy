import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/app/generalFunction.dart';
import 'package:untitled/data/loader_helper.dart';
import '../domain/holidaylist_model.dart';
import '../domain/queryResponseModel.dart';
import 'baseurl.dart';


class QueryResponseRepo {
  GeneralFunction generalFunction = GeneralFunction();
  Future<List<QueryResponsemodel>> quryList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sContactNo = prefs.getString('sContactNo');
    showLoader();

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsqueryresponse/hrmsqueryresponse";
    var queryList = "$baseURL$endPoint";

    try {
      var headers = {
        'token': sToken ?? '',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(queryList));

      request.body = json.encode({
        "sContactNo": sContactNo,
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
        // Return the list of QueryResponsemodel
        return jsonResponse.map((data) => QueryResponsemodel.fromJson(data)).toList();
      } else if (response.statusCode == 401) {
        hideLoader();
        generalFunction.logout(context);
        throw Exception('Unauthorized access');
      } else {
        hideLoader();
        throw Exception('Failed to load query response data');
      }
    } catch (e) {
      hideLoader();
      throw Exception('An error occurred: $e');
    } finally {
      hideLoader(); // Ensure loader is hidden in all scenarios
    }
  }
}
