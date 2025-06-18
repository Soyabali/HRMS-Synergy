import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class ConsuamableItemRepo_2
{
  List<dynamic>  consuambleItemList = [];
  Future<List> consuambleItem(BuildContext context, stranCode) async
  {
    showLoader();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetConsumablesReimbItem/GetConsumablesReimbItem";
    var consumableListItem = "$baseURL$endPoint";
    print('------------17---constumableItemApi---$consumableListItem');

    //showLoader();

    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$consumableListItem'));
      request.body = json.encode({
        // "dMonth": '31/Aug/2024',
        "sTranCode": stranCode,

      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        //print('--74---xxx---${jsonDecode(data)}');
        // Map<String, dynamic> parsedJson = jsonDecode(data);
        //distList = parsedJson['Data'];
        // distList = jsonDecode(data);
        List<dynamic> consuambleItemList = jsonDecode(data);
        return consuambleItemList;
      } else
      {
        hideLoader();
        return consuambleItemList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
