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
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';

class BindreimuomRepo
{
  List<dynamic>  bindreimouList = [];
  Future<List> bindReimouList() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');

    print('-----22---$sToken');
    print('-----50---$contactNo');


    var baseURL = BaseRepo().baseurl;
    var endPoint = "BindReimUoM/BindReimUoM";
    var bindReimUoList = "$baseURL$endPoint";
    print('------------17---BindReimUoMApi---$bindReimUoList');
    //showLoader();
    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('Get', Uri.parse('$bindReimUoList'));
      // request.body = json.encode({
      //   "sContactNo": "$contactNo"
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
        bindreimouList = jsonDecode(data);
        print('-----81----$bindReimUoList');
        return bindreimouList;
      } else
      {
        return bindreimouList;
      }
    } catch (e)
    {
      throw (e);
    }
  }
}