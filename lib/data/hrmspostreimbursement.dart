import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseurl.dart';
import 'loader_helper.dart';

class HrmsPostReimbursementRepo {
  // this is a loginApi call functin

  Future hrmsPostReimbursement(
      BuildContext context,
      sTranCode,
      String? sEmpCode,
      selectedSectorId,
      selectedShopId,
      dExpDate,
      String amount,
      String expenseDetails,
      uplodedImage,
      String? sContactNo,
      result,
      String remarks, uplodedImage2, uplodedImage3, uplodedImage4, String? consumableList, consumableItemString,
      ) async {
    try {
      //uplodedImage2, uplodedImage3, uplodedImage4
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sToken = prefs.getString('sToken');

      print('----sToken--18---$sToken');
      print('----sTranCode--31---$sTranCode');
      print('----sEmpCode--32---$sEmpCode');
      print('----selectedSectorId--33---$selectedSectorId');
      print('----selectedShopId--34---$selectedShopId');
      print('----dExpDate--35---$dExpDate');
      print('----amount--36---$amount');
      print('----expenseDetails--37---$expenseDetails');
      print('----uplodedImage--38---$uplodedImage');
      print('----sContactNo--39---$sContactNo');
      print('----sRemarks--40---${remarks}');
      print('----result--41---$result');
      print('----uplode image 2--42---$uplodedImage2');
      print('----uplode image 3--43---$uplodedImage3');
      print('----uplode image 4--44---$uplodedImage4');
      print('----ConsumaleList --45---$consumableList');
      print('----consumableItemString --45---$consumableItemString');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "hrmsPostReimbursementNew/hrmsPostReimbursementNew";
      var hrmsPostReimbursementApi = "$baseURL$endPoint";
      print('------------17---hrmsPostReimbursementApi---$hrmsPostReimbursementApi');

      showLoader();
      var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$hrmsPostReimbursementApi'));

      request.body = json.encode({
        "fAmount": amount ?? "",
        "sExpDetails": expenseDetails ?? "",
        "sExpBillPhoto2":uplodedImage2 ?? "",
        "sExpBillPhoto3":uplodedImage3 ?? "",
        "sExpBillPhoto4":uplodedImage4 ?? "",
        "sRemarks": remarks ?? "",
        "sResult": result ?? "",
        "sTranCode": "$sTranCode" ?? "",
        "dExpDate": dExpDate ?? "",
        "sEntryBy": sContactNo ?? "",
        "sExpBillPhoto": uplodedImage ?? "",
        "sExpHeadCode": selectedShopId ?? "",
        "sProjectCode": selectedSectorId ?? "",
        "sEmpCode": sEmpCode ?? "",
        "sItemArray": consumableList ?? consumableItemString,
        //"sItemArray": consumableList ?? '[{"":""}]',
        //"sItemArray": (consumableList == null || consumableList.isEmpty) ? [] : consumableList,

        // "sItemArray":consumableList ?? "",
       // "sItemArray":'[{"SrNo":"1","sItemName":"Pencil Box","sUoM":"Box","fQty":"4","fAmount":"400"},{"SrNo":"2","sItemName":"Laptop Bag","sUoM":"Bags","fQty":"2","fAmount":"4400"}]',


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
