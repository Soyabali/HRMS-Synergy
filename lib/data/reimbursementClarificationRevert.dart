import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmsPostReimbursementRevertRepo {
  // this is a loginApi call functin

  Future hrmsPostReimbursementRevert(

      BuildContext context,
      int sTranCode,
      String? sEmpCode,
      selectedSectorId,
      selectedShopId,
      dExpDate,
      String amount,
      String expenseDetails,
      uplodedImage,
      String? sContactNo,
      result,
      String remarks, uplodedImage2, uplodedImage3, uplodedImage4, String? consumableList) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');
      print('----sToken--18---$sToken');
      print('----sTranCode--15---$sTranCode');
      print('----sEmpCode--15---$sEmpCode');
      print('----selectedSectorId--15---$selectedSectorId');
      print('----selectedShopId--15---$selectedShopId');
      print('----dExpDate--15---$dExpDate');
      print('----amount--15---$amount');
      print('----expenseDetails--15---$expenseDetails');
      print('----uplodedImage--15---$uplodedImage');
      print('----sContactNo--15---$sContactNo');
      print('----sRemarks--15---${remarks}');
      print('----result--15---$result');
      print('----uplodedImage2--15---$uplodedImage2');
      print('----uplodedImage3--41---$uplodedImage3');
      print('----uplodedImage4--41---$uplodedImage4');
      print('----consumableList--43---$consumableList');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsPostReimbursement/hrmsPostReimbursement";
      var hrmsPostReimbursementApi = "$baseURL$endPoint";
      print(
          '------------17---hrmsPostReimbursementApi---$hrmsPostReimbursementApi');

      showLoader();
      var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
      var request =
      http.Request('POST', Uri.parse('$hrmsPostReimbursementApi'));

      request.body = json.encode({
        "sTranCode": sTranCode,
        "sEmpCode": sEmpCode,
        "sProjectCode": selectedSectorId,
        "sExpHeadCode": selectedShopId,
        "dExpDate": dExpDate,
        "fAmount": amount,
        "sExpDetails": expenseDetails,
        "sExpBillPhoto": uplodedImage,
        "sEntryBy": sContactNo,
        "sRemarks": remarks,
        "sResult": result,
        "uplodedImage2": uplodedImage2,
        "uplodedImage3": uplodedImage3,
        "uplodedImage4": uplodedImage4,
        "sItemArray":consumableList
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---login RESPONSE----$map');
      if (response.statusCode == 200) {
        hideLoader();
        print('----------71-----$map');
        return map;
      } else {
        print('----------74--hrmsPostReimbursement----$map');
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }
}
