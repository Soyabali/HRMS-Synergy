import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/app/generalFunction.dart';
import 'package:untitled/data/loader_helper.dart';
import '../domain/hrmsreimbursementstatusV3Model.dart';
import '../domain/policy_model.dart';
import 'baseurl.dart';

class HrmsPolicyDocRepo {

   GeneralFunction generalFunction = GeneralFunction();
   Future<List<PolicyDocModel>> policyDocList(BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      showLoader();

      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsCompanyPolicy/hrmsCompanyPolicy";
      var companyPolicy = "$baseURL$endPoint";

      try {
         var headers = {
            'token': sToken ?? '',
            'Content-Type': 'application/json',
         };

         var request = http.Request('GET', Uri.parse(companyPolicy));
         request.headers.addAll(headers);

         http.StreamedResponse response = await request.send();

         if (response.statusCode == 200) {
            hideLoader();
            // Convert the response stream to a string
            String responseBody = await response.stream.bytesToString();
            // Decode the response body
            List jsonResponse = jsonDecode(responseBody);
            print('---54--$jsonResponse');
            // Return the list of PolicyDocModel
            return jsonResponse.map((data) => PolicyDocModel.fromJson(data)).toList();
         } else if (response.statusCode == 401) {
            hideLoader();
            generalFunction.logout(context);
            throw Exception('Unauthorized access');
         } else {
            hideLoader();
            throw Exception('Failed to load policy documents');
         }
      } catch (e) {
         hideLoader();
         throw Exception('An error occurred: $e');
      } finally {
         // Ensure loader is hidden in all cases
         hideLoader();
      }
   }

// Future<List<PolicyDocModel>> policyDocList(BuildContext context  ) async{
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? sToken = prefs.getString('sToken');
  //   showLoader();
  //
  //   var baseURL = BaseRepo().baseurl;
  //   var endPoint = "hrmsCompanyPolicy/hrmsCompanyPolicy";
  //   var companyPolicy = "$baseURL$endPoint";
  //
  //   try {
  //     var headers = {
  //       'token': '$sToken',
  //       'Content-Type': 'application/json'
  //     };
  //
  //     var request = http.Request('GET', Uri.parse('$companyPolicy'));
  //
  //     request.headers.addAll(headers);
  //     http.StreamedResponse response = await request.send();
  //     if (response.statusCode == 200) {
  //       hideLoader();
  //       // Convert the response stream to a string
  //       String responseBody = await response.stream.bytesToString();
  //       // Decode the response body
  //       List jsonResponse = jsonDecode(responseBody);
  //       print('---54--$jsonResponse');
  //       // Return the list of LeaveData
  //       return jsonResponse.map((data) => PolicyDocModel.fromJson(data))
  //           .toList();
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
