import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class GetYtdMonthRepo
{
  List<dynamic>  ytdMonthList = [];
  Future<List> getYtdMonth() async
  {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('-----22---$sToken');


    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetYTDMonth/GetYTDMonth";
    var tdMonthApi = "$baseURL$endPoint";
    print('------------17---tdMonthApi---$tdMonthApi');

    showLoader();

    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('$tdMonthApi'));
      // request.body = json.encode({
      //   "iUserId": "$iUserId"
      // });
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
         ytdMonthList = jsonDecode(data);
        return ytdMonthList;
      } else
      {
        hideLoader();
        return ytdMonthList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
