import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../app/generalFunction.dart';
import '../../data/hrmsleavependingforapprovail.dart';
import '../../domain/actionOnLeaveModel.dart';
import '../resources/app_text_style.dart';


class SanctionedPageActionOnLeave extends StatefulWidget {
  String? formDate, toDate;

  SanctionedPageActionOnLeave(
      {super.key, required this.formDate, required this.toDate});

  @override
  State<SanctionedPageActionOnLeave> createState() => _SanctionedPageState();
}

class _SanctionedPageState extends State<SanctionedPageActionOnLeave> {
  String? formDate, toDate;
  var result, msg;
  late var leavePending;

  late Future<List<HrmsLeavePendingForApprovalModel>>
      hrmsLeavePendingForApproval;
  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    // TODO: implement initState

    hrmsLeavePendingForApproval = HrmsLeavePendingForApprovailRepo()
        .hrmsLevePendingForApprovalList(
            context, "${widget.formDate}", "${widget.toDate}", "S");
    print('-----42---$hrmsLeavePendingForApproval');
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
                  final actionOnLeavePending =
                      snapshot.data!; // Access the resolved data

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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.punch_clock_sharp,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                    'Sanctioned At : ${leavePending.dAppRejDate}',
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
                                                const Icon(
                                                  Icons.notes_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 5),
                                                Text('Reason : ${leavePending.sLeaveReason}',
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlackTextStyle),
                                              ],
                                            ),
                                          ],
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

    // body:  Container(
    //     height: MediaQuery.of(context).size.height,
    //     child: FutureBuilder<List<HrmsLeaveStatusModel>>(
    //         future: hrmsLeaveStatus,
    //         builder: (context, snapshot) {
    //           // Check if the snapshot has data and is not null
    //           if (snapshot.connectionState == ConnectionState.waiting) {
    //             // Show a loading indicator while waiting for data
    //             return Center(child: CircularProgressIndicator());
    //           } else if (snapshot.hasError) {
    //             // Handle error scenario
    //             return Center(child: Text('Error: ${snapshot.error}'));
    //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //             // Handle the case where the data is empty or null
    //             return Center(child: Text('No Data'));
    //           }
    //
    //           // Once data is available, build the ListView
    //           final polocyDocList = snapshot.data!; // Access the resolved data
    //
    //           return ListView.builder(
    //               itemCount: polocyDocList.length,
    //               itemBuilder: (context, index) {
    //                 final policyDocData = polocyDocList[index];
    //                 //final randomColor = colorList[index % colorList.length];
    //                 return Padding(
    //                   padding:
    //                   const EdgeInsets.only(left: 5, right: 5, top: 5),
    //                   child: Column(
    //                     children: [
    //                       Container(
    //                         decoration: BoxDecoration(
    //                           color: Colors
    //                               .white, // Background color of the container
    //                           borderRadius: BorderRadius.circular(
    //                               2.0), // Rounded corners
    //                           border: Border.all(
    //                             color: Colors.grey, // Border color
    //                             width: 1.0, // Border width
    //                           ),
    //                         ),
    //                         child: Container(
    //                           color: Colors.white,
    //                           margin: EdgeInsets.only(
    //                               left: 5, right: 5, top: 5),
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             crossAxisAlignment:
    //                             CrossAxisAlignment.start,
    //                             children: [
    //                               Container(
    //                                 height: 40,
    //                                 // todo container apple left color border with 2 width
    //                                 decoration: const BoxDecoration(
    //                                   border: Border(
    //                                     left: BorderSide(
    //                                       color: Colors
    //                                           .blue, // Color of the left border
    //                                       width:
    //                                       2.0, // Width of the left border
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 child: Row(
    //                                   mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                                   children: [
    //                                     /// todo take a two TextVIEW
    //                                     Padding(
    //                                       padding: const EdgeInsets.only(
    //                                           left: 5),
    //                                       child: Text(
    //                                         "${policyDocData.sLvDesc}",
    //                                         style: AppTextStyle
    //                                             .font12OpenSansRegularBlackTextStyle,
    //                                       ),
    //                                     ),
    //                                     Text(
    //                                         "Applied At: ${policyDocData.dApplyDate}",
    //                                         style: AppTextStyle
    //                                             .font12OpenSansRegularBlackTextStyle),
    //                                   ],
    //                                 ),
    //                               ),
    //                               SizedBox(height: 5),
    //                               Row(
    //                                 mainAxisAlignment:
    //                                 MainAxisAlignment.start,
    //                                 children: [
    //                                   Row(
    //                                     mainAxisAlignment:
    //                                     MainAxisAlignment.start,
    //                                     children: [
    //                                       Icon(
    //                                         Icons.notes_outlined,
    //                                         size: 18,
    //                                       ),
    //                                       SizedBox(width: 5),
    //                                       Text('Leave Reason',
    //                                           style: AppTextStyle
    //                                               .font12OpenSansRegularBlackTextStyle),
    //                                     ],
    //                                   ),
    //                                 ],
    //                               ),
    //                               SizedBox(height: 5),
    //                               Padding(
    //                                 padding:
    //                                 const EdgeInsets.only(left: 22),
    //                                 child: Text(
    //                                     "${policyDocData.sLeaveReason}",
    //                                     style: AppTextStyle
    //                                         .font12OpenSansRegularBlackTextStyle),
    //                               ),
    //                               SizedBox(height: 5),
    //                               Row(
    //                                 mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                                 children: [
    //                                   Column(
    //                                     children: [
    //                                       Row(
    //                                         mainAxisAlignment:
    //                                         MainAxisAlignment.start,
    //                                         children: [
    //                                           Icon(Icons.calendar_month,
    //                                               size: 18,
    //                                               color: Colors.cyan),
    //                                           SizedBox(width: 4),
    //                                           Text('From : ${policyDocData.dFromDate}',
    //                                               style: AppTextStyle
    //                                                   .font12OpenSansRegularBlackTextStyle),
    //                                         ],
    //                                       )
    //                                     ],
    //                                   ),
    //                                   Column(
    //                                     children: [
    //                                       Row(
    //                                         mainAxisAlignment:
    //                                         MainAxisAlignment.start,
    //                                         children: [
    //                                           Icon(Icons.calendar_month,
    //                                               size: 18,
    //                                               color: Colors.cyan),
    //                                           SizedBox(width: 4),
    //                                           Text('TO : ${policyDocData.dToDate}',
    //                                               style: AppTextStyle
    //                                                   .font12OpenSansRegularBlackTextStyle),
    //                                         ],
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ],
    //                               ),
    //                               SizedBox(height: 5),
    //                               Align(
    //                                 alignment: Alignment.centerRight,
    //                                 child: DottedBorder(
    //                                   color: Colors
    //                                       .grey, // Color of the dotted line
    //                                   strokeWidth:
    //                                   1.0, // Width of the dotted line
    //                                   dashPattern: const [
    //                                     4,
    //                                     2
    //                                   ], // Dash pattern for the dotted line
    //                                   borderType: BorderType.RRect,
    //                                   radius: const Radius.circular(
    //                                       5.0), // Rounded corners
    //                                   child: Padding(
    //                                     padding: const EdgeInsets.all(
    //                                         2.0), // Padding inside the dotted border
    //                                     child: Row(
    //                                       mainAxisSize: MainAxisSize
    //                                           .min, // Ensures the Row takes minimum width
    //                                       children: [
    //                                         Text(
    //                                           'Leave Applied For',
    //                                           style: AppTextStyle
    //                                               .font12OpenSansRegularBlack45TextStyle,
    //                                         ),
    //                                         const SizedBox(
    //                                             width:
    //                                             2.0), // Space between 'Leave Applied For' and ':'
    //                                         Text(
    //                                           ' : ',
    //                                           style: AppTextStyle
    //                                               .font12OpenSansRegularBlack45TextStyle,
    //                                         ),
    //                                         const SizedBox(
    //                                             width:
    //                                             2.0), // Space between ':' and '1 Days'
    //                                         Text(
    //                                           "${policyDocData.iDays} Day",
    //                                           style: AppTextStyle
    //                                               .font12OpenSansRegularBlackTextStyle,
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                               SizedBox(height: 5),
    //                               Column(
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 crossAxisAlignment: CrossAxisAlignment.start,
    //                                 children: [
    //                                   // Conditionally show the Row if dAppRejDate is not null
    //                                   Visibility(
    //                                     visible: policyDocData.dAppRejDate != null && policyDocData.dAppRejDate.isNotEmpty, // Check if dAppRejDate is not null or empty
    //                                     child: Row(
    //                                       mainAxisAlignment: MainAxisAlignment.start,
    //                                       children: [
    //                                         Row(
    //                                           mainAxisAlignment: MainAxisAlignment.start,
    //                                           children: [
    //                                             const Icon(
    //                                               Icons.notes_outlined,
    //                                               size: 18,
    //                                             ),
    //                                             SizedBox(width: 5),
    //                                             Text(
    //                                               'Sanctioned At : ${policyDocData.dAppRejDate}',
    //                                               style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                   SizedBox(height: 5),
    //                                   // Conditionally show the Padding widget if sAppRejReason is not null
    //                                   Visibility(
    //                                     visible: policyDocData.sAppRejReason != null && policyDocData.sAppRejReason.isNotEmpty, // Check if sAppRejReason is not null or empty
    //                                     child: Padding(
    //                                       padding: const EdgeInsets.only(left: 22),
    //                                       child: Text(
    //                                         'Reason : ${policyDocData.sAppRejReason}',
    //                                         style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                               SizedBox(height: 5),
    //                               Container(
    //                                 height: 35, // Set the height for the button
    //                                 width: MediaQuery.of(context).size.width - 30,
    //                                 child: ElevatedButton(
    //                                   onPressed: () async {
    //                                     var iTranId = "${policyDocData.iTranId}";
    //
    //                                     showDialog(
    //                                       context: context,
    //                                       builder: (BuildContext context) {
    //                                         return _takeActionDialog(context,iTranId);
    //                                       },
    //                                     );
    //                                   },
    //                                   style: ElevatedButton.styleFrom(
    //                                     backgroundColor: const Color(0xFFe8878e), // Button color
    //                                     padding: const EdgeInsets.symmetric(
    //                                       horizontal: 24, // Horizontal padding
    //                                       vertical: 0,    // Adjust vertical padding to 0 for a smaller height
    //                                     ),
    //                                     shape: RoundedRectangleBorder(
    //                                       borderRadius: BorderRadius.circular(2),
    //                                     ),
    //                                   ),
    //                                   child: Text(
    //                                     'Cancel Leave Request',
    //                                     style: AppTextStyle.font12OpenSansRegularWhiteTextStyle, // Make sure this text style is not too large
    //                                   ),
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 );
    //               });
    //         })));
  }
}
