import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:untitled/presentation/expensemanagement/pendingteamreimb/pendingteamreimb.dart';
import '../../../app/generalFunction.dart';
import '../../../data/DuplicateEtriesForCrossCheckRepo.dart';
import '../../../domain/GetDuplicateEtriesForCrossCheckModel.dart';
import '../../resources/app_text_style.dart';
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
      msg,
      duration: Duration(seconds: 1),
      position: Fluttertoast.ToastPosition.center,
      backgroundColor: Colors.black45,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }
  // void displayToast(String msg) {
  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }




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
                                  itemCount: snapshot.data!.length,
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
                  return Padding(
                    padding: const EdgeInsets.all(16.0), // Add padding on all sides
                    child: Center(
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.contain, // Ensures the image fits within the available space
                      ),
                    ),
                  );
                },
              ),
            ),

            // Positioned.fill(
            //   child: PageView.builder(
            //     itemCount: imageUrls.length,
            //     itemBuilder: (context, index) {
            //       return Image.network(
            //         imageUrls[index],
            //         fit: BoxFit.contain, // Adjust the image to fill the dialog
            //       );
            //     },
            //   ),
            // ),

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