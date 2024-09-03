import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class Hrmsleavebalacev2Repo
{
  List<dynamic>  hrmsleavebalacev2List = [];
  Future<List> getHrmsleavebalacev2(String dDate) async
  {

    print('---date----13---$dDate');
    //showLoader();
    int currentYear = DateTime.now().year;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');

    print('------------20---sEmpCode---$sEmpCode');

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsLeaveBalanceV2/hrmsLeaveBalanceV2";
    var hrmsLeaveBalanceApi = "$baseURL$endPoint";
    print('------------17---hrmsLeaveBalanceApi---$hrmsLeaveBalanceApi');

    showLoader();

    try
    {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsLeaveBalanceApi'));
      request.body = json.encode({
        "dYTDMonth": dDate,
        "iLeaveYear":currentYear,
        "sEmpCode":sEmpCode
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
        List<dynamic> hrmsleavebalacev2List = jsonDecode(data);
        return hrmsleavebalacev2List;
      } else
      {
        hideLoader();
        return hrmsleavebalacev2List;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
