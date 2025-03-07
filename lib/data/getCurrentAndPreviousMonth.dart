// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:tut_application/model/state_list_model.dart';
//
// class StateRepo {
//   final baseUrl = "http://49.50.79.121:8080/jci-api/api/allState";
//   // var headers = {'API-Token': 'token'};
//
//   //Fetch Country Data
//   // Future<CountryDataModel?>
//  Future<StateList?> getStateList() async {
//     var client = http.Client();
//     final url = baseUrl;
//
//     try {
//       var response = await client.get(Uri.parse(url));
//       var jsonStr = jsonDecode(response.body);
//
//       debugPrint(response.body);
//       if (response.statusCode == 200) {
//         var json = response.body;
//         Map<String, dynamic> mapData = jsonDecode(json);
//         print("State List: ${StateList.fromJson(mapData)}");
//         return StateList.fromJson(mapData);
//       }
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import 'baseurl.dart';

class GetCurrentAndpreviousMonthRepo
{
  GeneralFunction generalFunction = GeneralFunction();
  List<dynamic>  distList = [];
  Future<List> getCurrentAndPreviousMonth(BuildContext context) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('-----22---$sToken');


    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetCurrentAndPreviousMonth/GetCurrentAndPreviousMonth";
    var projectList = "$baseURL$endPoint";
    print('------------17---loginApi---$projectList');

    //showLoader();

    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('$projectList'));
      // request.body = json.encode({
      //   "iUserId": "$iUserId"
      // });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200)
      {
        var data = await response.stream.bytesToString();
        //print('--74---xxx---${jsonDecode(data)}');
        // Map<String, dynamic> parsedJson = jsonDecode(data);
        //distList = parsedJson['Data'];
        // distList = jsonDecode(data);
        List<dynamic> distList = jsonDecode(data);
        return distList;
      }
      else if(response.statusCode==401){
        generalFunction.logout(context);
        //SharedPreferences prefs = await SharedPreferences.getInstance();
       // prefs.clear();
       // generalFunction.goNext(context);
        // loginScreen
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginScreen()),
        //       (route) => false, // Pop all routes until this page
        // );
      }
      {
        return distList;
      }
    } catch (e)
    {
      throw (e);
    }
  }
}
