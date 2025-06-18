import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../app/generalFunction.dart';
import '../../data/hrmsleavependingforapprovail.dart';
import '../../domain/actionOnLeaveModel.dart';
import '../resources/app_text_style.dart';

class AllActionOnLeave extends StatefulWidget {

  String? formDate, toDate;
  var result, msg;

  AllActionOnLeave({super.key, required this.formDate, required this.toDate});

  @override
  State<AllActionOnLeave> createState() => _AllPageState();
}

class _AllPageState extends State<AllActionOnLeave> {

  String? formDate, toDate;
  var result, msg;
  late var leavePending;

  late Future<List<HrmsLeavePendingForApprovalModel>>hrmsLeavePendingForApproval;
  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    // TODO: implement initState
    print('----------35-----All----');
    print('----------35-----A-----fromdate-${widget.formDate}');
    print('----------35-----A----toDate---${widget.toDate}');

    hrmsLeavePendingForApproval = HrmsLeavePendingForApprovailRepo()
        .hrmsLevePendingForApprovalList(
            context, "${widget.formDate}", "${widget.toDate}", "A");
    print('-----48---$hrmsLeavePendingForApproval');
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<List<HrmsLeavePendingForApprovalModel>>(
                future: hrmsLeavePendingForApproval,
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
                  // Once data is available, build the ListView
                  final actionOnLeavePending = snapshot.data!; // Access the resolved data

                  return ListView.builder(
                      itemCount: actionOnLeavePending.length,
                      itemBuilder: (context, index) {
                        leavePending = actionOnLeavePending[index];

                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 5,bottom: 5),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // Background color of the container
                                    borderRadius: BorderRadius.circular(2.0),
                                    // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 1.0, // Border width
                                    ),
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40,
                                          // todo container apple left color border with 2 width
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: Colors.blue,
                                                // Color of the left border
                                                width:
                                                    2.0, // Width of the left border
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              /// todo take a two TextVIEW
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  "${leavePending.sLvDesc}",
                                                  style: AppTextStyle
                                                      .font12OpenSansRegularBlackTextStyle,
                                                ),
                                              ),
                                              Text(
                                                  "Applied At: ${leavePending.dApplyDate}",
                                                  style: AppTextStyle
                                                      .font12OpenSansRegularBlackTextStyle),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.account_box,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 5),
                                                Text('Applied by : ${leavePending.sEmpName}',
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlackTextStyle),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.notes_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 5),
                                                Text('Leave Reason',
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlackTextStyle),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 22),
                                          child: Text(
                                              "${leavePending.sLeaveReason}",
                                              style: AppTextStyle
                                                  .font12OpenSansRegularBlackTextStyle),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.calendar_month,
                                                        size: 18,
                                                        color: Colors.cyan),
                                                    SizedBox(width: 4),
                                                    Text('From : ${leavePending.dFromDate}',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.calendar_month,
                                                        size: 18,
                                                        color: Colors.cyan),
                                                    SizedBox(width: 4),
                                                    Text('TO : ${leavePending.dToDate}',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Align(
                                          // alignment: Alignment.centerRight,
                                          child: DottedBorder(
                                            color: Colors.grey,
                                            // Color of the dotted line
                                            strokeWidth: 1.0,
                                            // Width of the dotted line
                                            dashPattern: const [4, 2],
                                            // Dash pattern for the dotted line
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(5.0),
                                            // Rounded corners
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              // Padding inside the dotted border
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                // Ensures the Row takes minimum width
                                                children: [
                                                  Text(
                                                    'Leave Applied For',
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlack45TextStyle,
                                                  ),
                                                  const SizedBox(width: 2.0),
                                                  // Space between 'Leave Applied For' and ':'
                                                  Text(
                                                    ' : ',
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlack45TextStyle,
                                                  ),
                                                  const SizedBox(width: 2.0),
                                                  // Space between ':' and '1 Days'
                                                  Text(
                                                    "${leavePending.iDays} Day",
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlackTextStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                })));
  }
}
