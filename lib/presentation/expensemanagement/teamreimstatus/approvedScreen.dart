import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/generalFunction.dart';
import '../../../data/approvedTeamReimbursementRepo.dart';
import '../../../domain/ApprovedTeamReimbursementModel.dart';
import '../../resources/app_text_style.dart';
import '../pendingteamreimb/duplicateExpenseEntry.dart';
import '../reimbursementStatus/reimbursementlog.dart';

class ApprovedScreen extends StatefulWidget {

  String? formDate, toDate;
  var empCode;

  ApprovedScreen({super.key, required this.formDate, required this.toDate});

  @override
  State<ApprovedScreen> createState() => _PendingPageState();
}

class _PendingPageState extends State<ApprovedScreen> {
  var result, msg;
  late Future<List<ApprovedTeamReimbursementModel>> hrmsLeaveStatus;
  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    // TODO: implement initState
    print('----------28-----Pending');
    print("------30----fromDate---${widget.formDate}");
    print("------31----toDate---${widget.toDate}");
    print("------31----empCode---${widget.empCode}");
    print("------32----A---");

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<List<ApprovedTeamReimbursementModel>>(
                future: hrmsLeaveStatus,
                builder: (context, snapshot) {
                  // Check if the snapshot has data and is not null
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for data
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Handle error scenario
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Handle the case where the data is empty or null
                    return Center(child: Text('No Data'));
                  }
                  final polocyDocList =
                      snapshot.data!; // Access the resolved data

                  return ListView.builder(
                      itemCount: polocyDocList.length,
                      itemBuilder: (context, index) {
                        final empinfo = polocyDocList[index];
                        //final randomColor = colorList[index % colorList.length];

                        return Card(
                          elevation: 1,
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                              color: Color(0xFF255899),
                                              width:
                                                  0.5, // Outline border width
                                            ),
                                            color: Colors.white,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Conveyance',
                                                style: AppTextStyle
                                                    .font12OpenSansRegularBlackTextStyle,
                                                maxLines: 2,
                                                // Limits the text to 2 lines
                                                overflow: TextOverflow
                                                    .ellipsis, // Truncates with an ellipsis if too long
                                              ),
                                              SizedBox(height: 4),
                                              // Add spacing between texts if needed
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Text(
                                                  "Project Name : ${empinfo.sProjectName}",
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
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Container(
                                        height: 0.5,
                                        color: Color(0xff3f617d),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 10.0,
                                          width: 10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            // Change this to your preferred color
                                            borderRadius:
                                                BorderRadius.circular(5.0),
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
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(empinfo.sEmpName,
                                          //item['dExpDate'] ??'',
                                          style: AppTextStyle
                                              .font12OpenSansRegularBlack45TextStyle),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 10.0,
                                          width: 10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            // Change this to your preferred color
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text('Bill Date',
                                            style: AppTextStyle
                                                .font12OpenSansRegularBlackTextStyle)
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(empinfo.dExpDate,
                                          // item['dEntryAt'] ?? '',
                                          style: AppTextStyle
                                              .font12OpenSansRegularBlack45TextStyle),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 10.0,
                                          width: 10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            // Change this to your preferred color
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text('Enter At',
                                            style: AppTextStyle
                                                .font12OpenSansRegularBlackTextStyle)
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(empinfo.dEntryAt,
                                          // item['sExpDetails'] ?? '',
                                          style: AppTextStyle
                                              .font12OpenSansRegularBlack45TextStyle),
                                    ),
                                    // cross Check
                                    SizedBox(height: 10),
                                    //
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 10.0,
                                          width: 10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            // Change this to your preferred color
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text('Manager Action At',
                                            style: AppTextStyle
                                                .font12OpenSansRegularBlackTextStyle)
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(empinfo.dActionEntryAt,
                                          // item['sExpDetails'] ?? '',
                                          style: AppTextStyle
                                              .font12OpenSansRegularBlack45TextStyle),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 10.0,
                                          width: 10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            // Change this to your preferred color
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text('Expense Details',
                                            style: AppTextStyle
                                                .font12OpenSansRegularBlackTextStyle)
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(empinfo.sExpDetails,
                                          // item['sExpDetails'] ?? '',
                                          style: AppTextStyle
                                              .font12OpenSansRegularBlack45TextStyle),
                                    ),
                                    SizedBox(height: 10),

                                    // bottom
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.speaker_notes,
                                              size: 20, color: Colors.black),
                                          SizedBox(width: 10),
                                          Text('Status',
                                              style: AppTextStyle
                                                  .font12OpenSansRegularBlackTextStyle),
                                          SizedBox(width: 5),
                                          const Text(
                                            ':',
                                            style: TextStyle(
                                              color: Color(0xFF0098a6),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              empinfo.sStatusName,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF0098a6),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '₹ ${empinfo.fAmount}',
                                                // item['fAmount'] ?? '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                ),
                                                maxLines: 1,
                                                // Allows up to 2 lines for the text
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // Space between the two columns
                                        children: [
                                          // First Column
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF0098a6),
                                                    // Change this to your preferred color
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(
                                                          '-----832---View Image---');
                                                      List<String> images = [
                                                        empinfo.sExpBillPhoto,
                                                        empinfo.sExpBillPhoto2,
                                                        empinfo.sExpBillPhoto3,
                                                        empinfo.sExpBillPhoto4,
                                                      ]
                                                          .where((image) =>
                                                              image != null &&
                                                              image.isNotEmpty)
                                                          .toList(); // Filter out null/empty images
                                                      var dExpDate =
                                                          empinfo.dExpDate;
                                                      var billDate =
                                                          'Bill Date : $dExpDate';
                                                      openFullScreenDialog(
                                                          context,
                                                          images,
                                                          billDate);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('View Image',
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularWhiteTextStyle),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.white,
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
                                          // if(leaveData.iStatus=="0")
                                          // remove

                                          SizedBox(width: 2),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF6a94e3),
                                                      // Change this to your preferred color
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        //var projact =  item['sProjectName'] ??'';
                                                        var sTranCode =
                                                            empinfo.sTranCode;
                                                        var project = empinfo
                                                            .sProjectName;
                                                        print(
                                                            "----1257----$sTranCode");
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ReimbursementLogPage(
                                                                      project,
                                                                      sTranCode)),
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text('Log',
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularWhiteTextStyle),
                                                          SizedBox(width: 10),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: Colors.white,
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
                        );

                      });
                }))

    );
  }
}
