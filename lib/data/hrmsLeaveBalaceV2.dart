import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/hrmsLeavebalanceV2.dart';
import 'baseurl.dart';
import 'loader_helper.dart';


class Hrmsleavebalacev2Repo {

  List<dynamic> hrmsleavebalacev2List = [];

  Future<List<Hrmsleavebalancev2Model>?> getHrmsleavebalacev2(String dDate) async {
    print('---date----13---$dDate');

    int currentYear = DateTime.now().year;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sEmpCode = prefs.getString('sEmpCode');

    print('------------20---sEmpCode---$sEmpCode');
    print('------------20---date---$dDate');
    print('------------20---currentYear---$currentYear');

    var baseURL = BaseRepo().baseurl;
    var endPoint = "hrmsLeaveBalanceV2/hrmsLeaveBalanceV2";
    var hrmsLeaveBalanceApi = "$baseURL$endPoint";
    print('------------17---hrmsLeaveBalanceApi---$hrmsLeaveBalanceApi');

    showLoader();

    try {
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsLeaveBalanceApi'));
      request.body = json.encode({
        "dYTDMonth": dDate,
        "iLeaveYear": currentYear,
        "sEmpCode": sEmpCode
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();

        List<dynamic> dataList = jsonDecode(data);
        if (dataList != null) {
          List<Hrmsleavebalancev2Model> hrmsLeaveBalanceV2 = dataList.map((json) => Hrmsleavebalancev2Model.fromJson(json)).toList();

          // Print each model in a readable format
          for (var leaveBalance in hrmsLeaveBalanceV2) {
            print(leaveBalance.toString());
          }

          return hrmsLeaveBalanceV2;
        }
      } else {
        hideLoader();
        return null;
      }
    } catch (e) {
      hideLoader();
      throw (e);
    }
  }
}


// class Hrmsleavebalacev2Repo
// {
//   List<dynamic>  hrmsleavebalacev2List = [];
//
//   Future<List<Hrmsleavebalancev2Model>?> getHrmsleavebalacev2(String dDate) async
//   {
//
//     print('---date----13---$dDate');
//     //showLoader();
//     int currentYear = DateTime.now().year;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//     String? sEmpCode = prefs.getString('sEmpCode');
//
//     print('------------20---sEmpCode---$sEmpCode');
//     print('------------20---date---$dDate');
//     print('------------20---currentYear---$currentYear');
//
//     var baseURL = BaseRepo().baseurl;
//     var endPoint = "hrmsLeaveBalanceV2/hrmsLeaveBalanceV2";
//     var hrmsLeaveBalanceApi = "$baseURL$endPoint";
//     print('------------17---hrmsLeaveBalanceApi---$hrmsLeaveBalanceApi');
//
//     showLoader();
//
//     try
//     {
//       var headers = {
//         'token': '$sToken',
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request('POST', Uri.parse('$hrmsLeaveBalanceApi'));
//       request.body = json.encode({
//         "dYTDMonth": dDate,
//         "iLeaveYear":currentYear,
//         "sEmpCode":sEmpCode
//       });
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200)
//       {
//         hideLoader();
//         var data = await response.stream.bytesToString();
//         //print('--74---xxx---${jsonDecode(data)}');
//         // Map<String, dynamic> parsedJson = jsonDecode(data);
//         //distList = parsedJson['Data'];
//         // distList = jsonDecode(data);
//         List<dynamic> dataList = jsonDecode(data);
//         if(dataList!=null){
//           List<Hrmsleavebalancev2Model> hrmsLeaveBalanceV2 = dataList.map((json) => Hrmsleavebalancev2Model.fromJson(json)).toList();
//           print('-----59----$hrmsLeaveBalanceV2');
//           return hrmsLeaveBalanceV2;
//         }
//       } else
//       {
//         hideLoader();
//         return null;
//       }
//     } catch (e)
//     {
//       hideLoader();
//       throw (e);
//     }
//   }
// }
 /// todo here you should remove if above code has a problem

// class Hrmsleavebalacev2Repo
// {
//   List<dynamic>  hrmsleavebalacev2List = [];
//   Future<List> getHrmsleavebalacev2(String dDate) async
//   {
//
//     print('---date----13---$dDate');
//     //showLoader();
//     int currentYear = DateTime.now().year;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//     String? sEmpCode = prefs.getString('sEmpCode');
//
//     print('------------20---sEmpCode---$sEmpCode');
//     print('------------20---date---$dDate');
//     print('------------20---currentYear---$currentYear');
//
//     var baseURL = BaseRepo().baseurl;
//     var endPoint = "hrmsLeaveBalanceV2/hrmsLeaveBalanceV2";
//     var hrmsLeaveBalanceApi = "$baseURL$endPoint";
//     print('------------17---hrmsLeaveBalanceApi---$hrmsLeaveBalanceApi');
//
//     showLoader();
//
//     try
//     {
//       var headers = {
//         'token': '$sToken',
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request('POST', Uri.parse('$hrmsLeaveBalanceApi'));
//       request.body = json.encode({
//         "dYTDMonth": dDate,
//         "iLeaveYear":currentYear,
//         "sEmpCode":sEmpCode
//       });
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200)
//       {
//         hideLoader();
//         var data = await response.stream.bytesToString();
//         //print('--74---xxx---${jsonDecode(data)}');
//         // Map<String, dynamic> parsedJson = jsonDecode(data);
//         //distList = parsedJson['Data'];
//         // distList = jsonDecode(data);
//         List<dynamic> hrmsleavebalacev2List = jsonDecode(data);
//         return hrmsleavebalacev2List;
//       } else
//       {
//         hideLoader();
//         return hrmsleavebalacev2List;
//       }
//     } catch (e)
//     {
//       hideLoader();
//       throw (e);
//     }
//   }
// }
