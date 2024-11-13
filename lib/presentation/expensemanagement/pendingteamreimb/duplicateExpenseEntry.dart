import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/expensemanagement/pendingteamreimb/pendingteamreimb.dart';
import '../../../app/generalFunction.dart';
import '../../../data/DuplicateEtriesForCrossCheckRepo.dart';
import '../../../data/district_repo.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../../data/shopTypeRepo.dart';
import '../../../domain/GetDuplicateEtriesForCrossCheckModel.dart';
import '../../../domain/GetPendingForApprovalReimModel.dart';
import '../../../domain/GetPendingForApprovalReimRepo.dart';
import '../../dashboard/dashboard.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';
import '../reimbursementStatus/consumableItem.dart';
import '../reimbursementStatus/reimbursementlog.dart';

class DuplicatExpensEntry extends StatefulWidget {

   var sTranCode;
  DuplicatExpensEntry(this.sTranCode, {super.key});

  @override
  State<DuplicatExpensEntry> createState() => _DuplicagteExpenseEntryState();

}

class _DuplicagteExpenseEntryState extends State<DuplicatExpensEntry> {

  List<Map<String, dynamic>>? pendingSchedulepointList;
  double? lat;
  double? long;
  GeneralFunction generalfunction = GeneralFunction();
  DateTime? _date;

  List stateList = [];
  List distList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  // Distic List

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  // FocusNode descriptionfocus = FocusNode();
  String? todayDate;
  List? data;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final sectorFocus = GlobalKey();
  File? _imageFile;
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  String? firstOfMonthDay;
  String? lastDayOfCurrentMonth;
  var sTranCode;
  var duplicate;


  // multifilepath
  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }




  @override
  void initState() {
    // TODO: implement initState
    sTranCode = '${widget.sTranCode}';
    duplicateEntryCrossCheck(sTranCode);
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

  late Future<List<DuplicateEntriesForCrossCheck>> getPendingApprovalReim;
  List<DuplicateEntriesForCrossCheck> _allData = []; // Holds original data
  List<DuplicateEntriesForCrossCheck> _filteredData = [];


  duplicateEntryCrossCheck(String sTranCode) async {

    getPendingApprovalReim = DuplicateEntriesforcrossCheckRepo()
        .duplicateEntryCrossCheck(context,sTranCode);

    getPendingApprovalReim.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
  }

  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData; // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sProjectName
              .toLowerCase()
              .contains(query.toLowerCase()) || // Filter by project name
              item.sExpHeadName.toLowerCase().contains(query.toLowerCase()) ||
              item.sEmpName.toLowerCase().contains(query.toLowerCase());
          // Filter by employee name
        }).toList();
      }
    });
  }

  // currentDate

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // statusBarColore
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color  // 2a697b
            statusBarColor: Color(0xFF2a697b),
            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.dark,
            // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          // backgroundColor: Colors.blu
          backgroundColor: Color(0xFF0098a6),
          leading: InkWell(
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PendingTeamReimbPage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Duplicate Expense Entry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
          ), // Removes shadow under the AppBar
        ),

        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Expanded(
                  child: Container(
                      child: FutureBuilder<List<DuplicateEntriesForCrossCheck>>(
                          future: getPendingApprovalReim,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text('No data available'));
                            } else {
                              return ListView.builder(
                                  itemCount: snapshot.data!.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final leaveData = _filteredData[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Card(
                                        elevation: 1,
                                        color: Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius
                                                .circular(5.0),
                                            border: Border.all(
                                              color: Colors.grey,
                                              // Outline border color
                                              width: 0.2, // Outline border width
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 8),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 30.0,
                                                        height: 30.0,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(
                                                              15.0),
                                                          border: Border
                                                              .all(
                                                            color: Color(
                                                                0xFF255899),
                                                            width: 0.5, // Outline border width
                                                          ),
                                                          color: Colors
                                                              .white,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${1 + index}",
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularBlackTextStyle,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      // Wrap the column in Flexible to prevent overflow
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: <
                                                              Widget>[
                                                            Text(
                                                              leaveData
                                                                  .sExpHeadName,
                                                              //leaveData.sExpHeadName,
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlackTextStyle,
                                                              maxLines: 2,
                                                              // Limits the text to 2 lines
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Truncates with an ellipsis if too long
                                                            ),
                                                            SizedBox(
                                                                height: 4),
                                                            // Add spacing between texts if needed
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                              child: Text(
                                                                // leaveData.sProjectName,
                                                                "Project Name : ${leaveData
                                                                    .sProjectName}",
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle,
                                                                maxLines: 2,
                                                                // Limits the text to 2 lines
                                                                overflow: TextOverflow
                                                                    .ellipsis, // Truncates with an ellipsis if too long
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 10),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 15,
                                                        right: 15),
                                                    child: Container(
                                                      height: 0.5,
                                                      color: Color(
                                                          0xff3f617d),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 10.0,
                                                        width: 10.0,
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .black,
                                                          // Change this to your preferred color
                                                          borderRadius: BorderRadius
                                                              .circular(
                                                              5.0),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      //  '‣ Sector',
                                                      Text('Employee Name',
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle)
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets
                                                        .only(
                                                        left: 15),
                                                    child: Text(
                                                        leaveData.sEmpName,
                                                        //item['dExpDate'] ??'',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlack45TextStyle),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 10.0,
                                                        width: 10.0,
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .black,
                                                          // Change this to your preferred color
                                                          borderRadius: BorderRadius
                                                              .circular(
                                                              5.0),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text('Bill Date',
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle)
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Text(
                                                        leaveData.dExpDate,
                                                        // item['dEntryAt'] ?? '',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlack45TextStyle),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 10.0,
                                                        width: 10.0,
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .black,
                                                          // Change this to your preferred color
                                                          borderRadius: BorderRadius
                                                              .circular(
                                                              5.0),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text('Enter At',
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle)
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets
                                                        .only(
                                                        left: 15),
                                                    child: Text(
                                                        leaveData.dEntryAt,
                                                        // item['sExpDetails'] ?? '',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlack45TextStyle),
                                                  ),
                                                  SizedBox(height: 10),
                                                  // cross Check
                                                  //
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 10.0,
                                                        width: 10.0,
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .black,
                                                          // Change this to your preferred color
                                                          borderRadius: BorderRadius
                                                              .circular(
                                                              5.0),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                          'Expense Details',
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle)
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets
                                                        .only(
                                                        left: 15),
                                                    child: Text(
                                                        leaveData
                                                            .sExpDetails,
                                                        // item['sExpDetails'] ?? '',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlack45TextStyle),
                                                  ),
                                                  SizedBox(height: 10),
                                                  // bottom
                                                  Container(
                                                    height: 1,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width - 40,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(left: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Icon(Icons
                                                            .speaker_notes,
                                                            size: 20,
                                                            color: Colors
                                                                .black),
                                                        SizedBox(width: 10),
                                                        Text('Status',
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlackTextStyle),
                                                        SizedBox(width: 5),
                                                        const Text(
                                                          ':',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF0098a6),
                                                            fontSize: 14,
                                                            fontWeight: FontWeight
                                                                .normal,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                          child: Text(
                                                            leaveData
                                                                .sStatus,
                                                            // item['sStatusName'] ?? '',
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlackTextStyle,
                                                            maxLines: 2,
                                                            // Allows up to 2 lines for the text
                                                            overflow: TextOverflow
                                                                .ellipsis, // Adds an ellipsis if the text overflows
                                                          ),
                                                        ),
                                                        // Spacer(),
                                                        Container(
                                                          height: 30,
                                                          padding:
                                                          EdgeInsets
                                                              .symmetric(
                                                              horizontal: 16.0),
                                                          decoration: BoxDecoration(
                                                            color: Color(
                                                                0xFF0098a6),
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                15),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '₹ ${leaveData
                                                                  .fAmount}',
                                                              // item['fAmount'] ?? '',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0,
                                                              ),
                                                              maxLines: 1,
                                                              // Allows up to 2 lines for the text
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(bottom: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      // Space between the two columns
                                                      children: [
                                                        // First Column
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xFF0098a6),
                                                                  // Change this to your preferred color
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10),
                                                                ),
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    List<String> images = [
                                                                      leaveData.sExpBillPhoto,
                                                                      leaveData.sExpBillPhoto2,
                                                                      leaveData.sExpBillPhoto3,
                                                                      leaveData.sExpBillPhoto4,
                                                                    ].where((image) => image != null && image.isNotEmpty).toList(); // Filter out null/empty images

                                                                    var dExpDate = leaveData.dExpDate;
                                                                    var billDate = 'Bill Date : $dExpDate';
                                                                    openFullScreenDialog(context, images, billDate);
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                    children: [
                                                                      Text(
                                                                          'View Image',
                                                                          style: AppTextStyle
                                                                              .font14OpenSansRegularWhiteTextStyle),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        color: Colors
                                                                            .white,
                                                                        size: 16,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 2),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {

                                                                  print('--sTranCode---$sTranCode');
                                                                  var project = leaveData.sProjectName;
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => ReimbursementLogPage(project,sTranCode)),
                                                                  );

                                                                },
                                                                child: Container(
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xFF6a94e3),
                                                                    // Change this to your preferred color
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        10),
                                                                  ),
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      var project = leaveData.sProjectName;
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => ReimbursementLogPage(project,sTranCode)),
                                                                      );
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Text(
                                                                            'Log',
                                                                            style: AppTextStyle
                                                                                .font14OpenSansRegularWhiteTextStyle),
                                                                        SizedBox(
                                                                            width: 10),
                                                                        Icon(
                                                                          Icons
                                                                              .arrow_forward_ios,
                                                                          color: Colors
                                                                              .white,
                                                                          size: 18,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              );
                            }
                          }
                          )
                      )

              )

            ]
        ));
  }
}

// OpenDialogo
void openFullScreenDialog(
    BuildContext context, List<String> imageUrls, String billDate) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Makes the dialog full screen
        insetPadding: EdgeInsets.all(0),
        child: Stack(
          children: [
            // Fullscreen PageView for multiple images
            Positioned.fill(
              child: PageView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover, // Adjust the image to fill the dialog
                  );
                },
              ),
            ),

            // White container with Bill Date at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      billDate,
                      style: AppTextStyle.font16OpenSansRegularBlackTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            // Close button in the bottom-right corner
            Positioned(
              right: 16,
              bottom: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                  padding: EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// take action Dialog
Widget _takeActionDialog(BuildContext context) {
  TextEditingController _takeAction =
  TextEditingController(); // Text controller for the TextFormField

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 220,
          // Adjusted height to accommodate the TextFormField and Submit button
          padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Remove Reimbursement',
                style: AppTextStyle.font16OpenSansRegularRedTextStyle,
              ),
              SizedBox(height: 10),
              // TextFormField for entering data
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: TextFormField(
                  controller: _takeAction,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    filled: true, // Enable background color
                    fillColor: Color(
                        0xFFf2f3f5), // Set your desired background color here
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter a value';
                  //   }
                  //   final intValue = int.tryParse(value);
                  //   if (intValue == null || intValue <= 0) {
                  //     return 'Enter an amount greater than 0';
                  //   }
                  //   return null;
                  // },
                ),
              ),
              SizedBox(height: 15),
              // Submit button
              InkWell(
                onTap: () async {
                  var takeAction = _takeAction.text.trim();
                  print('-----1102--$takeAction');
                  // print(sTranCode);

                  // Check if the input is not empty
                  if (takeAction != null && takeAction != '') {
                    print('---Call Api-----');

                    // Make API call here
                    // var loginMap = await Reimbursementstatustakeaction()
                    //     .reimbursementTakeAction(context, sTranCode);
                    // print('---418----$loginMap');

                    // setState(() {
                    //   result = "${loginMap[0]['Result']}";
                    //   msg = "${loginMap[0]['Msg']}";
                    // });

                    // print('---1114----$result');
                    // print('---1115----$msg');

                    // Check the result of the API call
                    //   if (result == "1") {
                    //     // Close the current dialog and show a success dialog
                    //     Navigator.of(context).pop();
                    //
                    //     // Show the success dialog
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return _buildDialogSucces2(context, msg); // A new dialog for showing success
                    //       },
                    //     );
                    //     print('-----1123---');
                    //   } else if (result == "0") {
                    //     // Keep the dialog open and show an error message (if needed)
                    //     // You can display an error message in the same dialog without dismissing it
                    //     displayToast(msg);  // Optionally, show a toast message to indicate failure
                    //
                    //     // Optionally clear the input field if needed
                    //     // _takeAction.clear();  // Do not clear to allow retrying
                    //   }
                    // } else {
                    //   // Handle the case where no input is provided
                    //   displayToast("Enter remarks");
                    // }
                  }
                },
                child: Container(
                  //width: double.infinity,
                  // Make container fill the width of its parent
                  height: AppSize.s45,
                  padding: EdgeInsets.all(AppPadding.p5),
                  decoration: BoxDecoration(
                    color: AppColors.loginbutton,
                    // Background color using HEX value
                    borderRadius:
                    BorderRadius.circular(AppMargin.m10), // Rounded corners
                  ),
                  //  #00b3c7
                  child: Center(
                    child: Text(
                      "Submit",
                      style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     String enteredText = _textController.text;
              //     if (enteredText.isNotEmpty) {
              //       print('Submitted: $enteredText');
              //     }
              //     // Perform any action you need on submit
              //    // Navigator.of(context).pop(); // Close the dialog
              //   },
              //   style: ElevatedButton.styleFrom(
              //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Adjust button size
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15), // Rounded corners for button
              //     ),
              //     backgroundColor: Colors.blue, // Button background color
              //   ),
              //   child: Text(
              //     'Submit',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 14,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Positioned(
          top: -30, // Position the image at the top center
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: ClipOval(
              child: Image.asset(
                'assets/images/addreimbursement.jpeg',
                // Replace with your asset image path
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// sucessDialog
Widget _buildDialogSucces2(BuildContext context, String msg) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 190,
          padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 0), // Space for the image
              Text('Success',
                  style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
              SizedBox(height: 10),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // call api again
                      // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const ExpenseManagement()),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // Set the background color to white
                      foregroundColor:
                      Colors.black, // Set the text color to black
                    ),
                    child: Text('Ok',
                        style:
                        AppTextStyle.font16OpenSansRegularBlackTextStyle),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: -30, // Position the image at the top center
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: ClipOval(
              child: Image.asset(
                'assets/images/sussess.jpeg',
                // Replace with your asset image path
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
