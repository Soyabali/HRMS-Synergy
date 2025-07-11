import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../app/generalFunction.dart';
import '../../data/hrmsleavependingforapprovail.dart';
import '../../data/leaveUpdateRepo.dart';
import '../../domain/actionOnLeaveModel.dart';
import '../resources/app_text_style.dart';

class RejectedActionOnLeave extends StatefulWidget {

  String? formDate, toDate;

  RejectedActionOnLeave(
      {super.key, required this.formDate, required this.toDate});

  @override
  State<RejectedActionOnLeave> createState() => _RejectedPageState();
}

class _RejectedPageState extends State<RejectedActionOnLeave> {
  var result, msg;
  String? formDate, toDate;
  late var leavePending;

  late Future<List<HrmsLeavePendingForApprovalModel>>
      hrmsLeavePendingForApproval;
  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    // TODO: implement initState
    print('----------28-----Rejectd----');
    print("------40---R--- :   ${widget.formDate}");
    print("----41--R-- :   ${widget.toDate}");
    print("-------38---Rejected-----");

    hrmsLeavePendingForApproval = HrmsLeavePendingForApprovailRepo()
        .hrmsLevePendingForApprovalList(
            context, "${widget.formDate}", "${widget.toDate}", "R");
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
                                          alignment: Alignment.centerRight,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          // Aligns both widgets vertically centered
                                          children: [
                                            Expanded(
                                              // To make DottedBorder take up most of the available width
                                              child: DottedBorder(
                                                color: Colors.grey,
                                                // Color of the dotted line
                                                strokeWidth: 1.0,
                                                // Width of the dotted line
                                                dashPattern: const [4, 2],
                                                // Dash pattern for the dotted line
                                                borderType: BorderType.RRect,
                                                radius:
                                                    const Radius.circular(5.0),
                                                // Rounded corners
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  // Padding inside the dotted border
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    // Ensures Row takes full width
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    // Space between text and ':'
                                                    children: [
                                                      Text(
                                                        'Leave Applied For',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlack45TextStyle,
                                                      ),
                                                      const SizedBox(width: 2.0),
                                                      // Space between text and colon
                                                      Text(
                                                        ' : ',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlack45TextStyle,
                                                      ),
                                                      const SizedBox(width: 2.0),
                                                      // Space between colon and days
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
                                            const SizedBox(width: 10.0),
                                            // Spacing between DottedBorder and button
                                            ElevatedButton(
                                              onPressed: () {
                                                /// todo take a ction functionality

                                                // _takeActionDialog(context,"");
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return _takeActionDialog(context,"");
                                                  },
                                                );

                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF0098a6),
                                                // Green background
                                                foregroundColor: Colors.white,
                                                // White label text
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4), // No rounded corners
                                                ),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 16,
                                                    vertical:
                                                        12), // Adjust button padding
                                              ),
                                              child: Text(
                                                "Take Action",
                                                style: AppTextStyle
                                                    .font12OpenSansRegularWhiteTextStyle, // Adjust label text size
                                              ),
                                            )
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
                                                  Icons.punch_clock_sharp,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                    'Rejected At : ${leavePending.dAppRejDate}',
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
                                            Icon(
                                              Icons.notes_outlined,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              // Prevents text from overflowing
                                              child: Text(
                                                'Reason : ${leavePending.sLeaveReason}',
                                                style: AppTextStyle
                                                    .font12OpenSansRegularBlackTextStyle,
                                                overflow: TextOverflow
                                                    .visible, // Ensures text is visible and wraps
                                              ),
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
  }

  Widget _takeActionDialog(BuildContext context, String iTranId) {

    TextEditingController _queryTitleEditText = TextEditingController();

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
            // Adjusted height to accommodate the TextFormField and Submit button
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
             // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextFormField for entering data
                // SizedBox(height: 5),
                Text("Update Leave Status",
                    style: AppTextStyle.font12OpenSansRegularBlack45TextStyle),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: TextFormField(
                    controller: _queryTitleEditText,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      filled: true,
                      // Enable background color
                      fillColor: Color(0xFFf2f3f5),
                      // Set your desired background color here
                      hintText: 'Enter Remarks',
                      // Add your hint text here
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                SizedBox(height: 15),
                // Submit button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            var queryTitle = _queryTitleEditText.text.trim();
                            if(queryTitle != null && queryTitle != ''){
                              // call Api
                                        var postQuery = await LeaveUpdateRepo().leaveUpdate(context, queryTitle, iTranId);
                                        print('--495-----$postQuery');
                                        //
                                        setState(() {
                                          result = "${postQuery[0]['Result']}";
                                          msg = "${postQuery[0]['Msg']}";
                                        });
                            }else{
                              if(queryTitle == null || queryTitle == ''){
                                generalFunction.displayToast('Enter Remarks');
                              }else{


                              }
                            }

                            // Add your logic here
                            //         var queryTitle = _queryTitleEditText.text.trim();
                            //
                            //         // Check if the input is not empty
                            //         if (queryTitle != null && queryTitle != '') {
                            //           print('---Call Api-----');
                            //
                            //           var postQuery = await LeaveCancellationRepo()
                            //               .leaveCancellation(context, queryTitle, iTranId);
                            //           print('--326--$postQuery');
                            //
                            //           setState(() {
                            //             result = "${postQuery[0]['Result']}";
                            //             msg = "${postQuery[0]['Msg']}";
                            //           });
                            //         } else {
                            //           if (queryTitle == null || queryTitle == '') {
                            //             generalFunction.displayToast('Enter reason');
                            //           } else {
                            //             // generalFunction.displayToast('Enter Query');
                            //           }


                          },
                          child: Text('Rejected',style: AppTextStyle.font14OpenSansRegularWhiteTextStyle),
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 2),
                            backgroundColor: Color(0xFF0098a6), // Background color
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Add some space between the buttons
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            var queryTitle = _queryTitleEditText.text.trim();
                            if(queryTitle != null && queryTitle != ''){
                              // call Api
                              var postQuery = await LeaveUpdateRepo().leaveUpdate(context, queryTitle, iTranId);
                              print('--550-----$postQuery');

                              setState(() {
                                result = "${postQuery[0]['Result']}";
                                msg = "${postQuery[0]['Msg']}";
                              });
                            }else{
                              if(queryTitle == null || queryTitle == ''){
                                generalFunction.displayToast('Enter Remarks');
                              }else{
                                generalFunction.displayToast(msg);
                              }

                            }

                            // Add your logic here
                            //         var queryTitle = _queryTitleEditText.text.trim();
                            //
                            //         // Check if the input is not empty
                            //         if (queryTitle != null && queryTitle != '') {
                            //           print('---Call Api-----');
                            //
                            //           var postQuery = await LeaveCancellationRepo()
                            //               .leaveCancellation(context, queryTitle, iTranId);
                            //           print('--326--$postQuery');
                            //
                            //           setState(() {
                            //             result = "${postQuery[0]['Result']}";
                            //             msg = "${postQuery[0]['Msg']}";
                            //           });
                            //         } else {
                            //           if (queryTitle == null || queryTitle == '') {
                            //             generalFunction.displayToast('Enter reason');
                            //           } else {
                            //             // generalFunction.displayToast('Enter Query');
                            //           }


                          },
                          child: Text('Approved',style: AppTextStyle.font14OpenSansRegularWhiteTextStyle),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            backgroundColor: Color(0xFF0098a6), // Background color
                          ),
                        ),
                      ),
                    ),
                  ],
                )

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     InkWell(
                //       onTap: () async {
                //         var queryTitle = _queryTitleEditText.text.trim();
                //
                //         // Check if the input is not empty
                //         if (queryTitle != null && queryTitle != '') {
                //           print('---Call Api-----');
                //
                //           var postQuery = await LeaveCancellationRepo()
                //               .leaveCancellation(context, queryTitle, iTranId);
                //           print('--326--$postQuery');
                //
                //           setState(() {
                //             result = "${postQuery[0]['Result']}";
                //             msg = "${postQuery[0]['Msg']}";
                //           });
                //         } else {
                //           if (queryTitle == null || queryTitle == '') {
                //             generalFunction.displayToast('Enter reason');
                //           } else {
                //             // generalFunction.displayToast('Enter Query');
                //           }
                //           print('---Api not Call -----');
                //         }
                //         if (result == "1") {
                //           Navigator.of(context).pop();
                //
                //           /// calla api again
                //           //  hrmsLeaveStatus = HrmsLeaveStatusRepo().hrmsLeveStatusList(context, "${widget.formDate}", "${widget.toDate}","P");
                //
                //           showDialog(
                //             context: context,
                //             builder: (BuildContext context) {
                //               return _buildDialogSucces2(
                //                   context, msg); // A new dialog for showing success
                //             },
                //           );
                //         } else {
                //           generalFunction.displayToast(msg);
                //         }
                //       },
                //       child: Container(
                //         //width: double.infinity,
                //         // Make container fill the width of its parent
                //         height: AppSize.s45,
                //         padding: EdgeInsets.all(AppPadding.p5),
                //         decoration: BoxDecoration(
                //           color: AppColors.loginbutton,
                //           // Background color using HEX value
                //           borderRadius: BorderRadius.circular(
                //               AppMargin.m10), // Rounded corners
                //         ),
                //         //  #00b3c7
                //         child: Center(
                //           child: Text(
                //             "Submit",
                //             style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                //           ),
                //         ),
                //       ),
                //     ),
                //     InkWell(
                //       onTap: () async {
                //         var queryTitle = _queryTitleEditText.text.trim();
                //
                //         // Check if the input is not empty
                //         if (queryTitle != null && queryTitle != '') {
                //           print('---Call Api-----');
                //
                //           var postQuery = await LeaveCancellationRepo()
                //               .leaveCancellation(context, queryTitle, iTranId);
                //           print('--326--$postQuery');
                //
                //           setState(() {
                //             result = "${postQuery[0]['Result']}";
                //             msg = "${postQuery[0]['Msg']}";
                //           });
                //         } else {
                //           if (queryTitle == null || queryTitle == '') {
                //             generalFunction.displayToast('Enter reason');
                //           } else {
                //             // generalFunction.displayToast('Enter Query');
                //           }
                //           print('---Api not Call -----');
                //         }
                //         if (result == "1") {
                //           Navigator.of(context).pop();
                //
                //           /// calla api again
                //           //  hrmsLeaveStatus = HrmsLeaveStatusRepo().hrmsLeveStatusList(context, "${widget.formDate}", "${widget.toDate}","P");
                //
                //           showDialog(
                //             context: context,
                //             builder: (BuildContext context) {
                //               return _buildDialogSucces2(
                //                   context, msg); // A new dialog for showing success
                //             },
                //           );
                //         } else {
                //           generalFunction.displayToast(msg);
                //         }
                //       },
                //       child: Container(
                //         //width: double.infinity,
                //         // Make container fill the width of its parent
                //         height: AppSize.s45,
                //         padding: EdgeInsets.all(AppPadding.p5),
                //         decoration: BoxDecoration(
                //           color: AppColors.loginbutton,
                //           // Background color using HEX value
                //           borderRadius: BorderRadius.circular(
                //               AppMargin.m10), // Rounded corners
                //         ),
                //         //  #00b3c7
                //         child: Center(
                //           child: Text(
                //             "Submit",
                //             style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // InkWell(
                //   onTap: () async {
                //     var queryTitle = _queryTitleEditText.text.trim();
                //
                //     // Check if the input is not empty
                //     if (queryTitle != null && queryTitle != '') {
                //       print('---Call Api-----');
                //
                //       var postQuery = await LeaveCancellationRepo()
                //           .leaveCancellation(context, queryTitle, iTranId);
                //       print('--326--$postQuery');
                //
                //       setState(() {
                //         result = "${postQuery[0]['Result']}";
                //         msg = "${postQuery[0]['Msg']}";
                //       });
                //     } else {
                //       if (queryTitle == null || queryTitle == '') {
                //         generalFunction.displayToast('Enter reason');
                //       } else {
                //         // generalFunction.displayToast('Enter Query');
                //       }
                //       print('---Api not Call -----');
                //     }
                //     if (result == "1") {
                //       Navigator.of(context).pop();
                //
                //       /// calla api again
                //       //  hrmsLeaveStatus = HrmsLeaveStatusRepo().hrmsLeveStatusList(context, "${widget.formDate}", "${widget.toDate}","P");
                //
                //       showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return _buildDialogSucces2(
                //               context, msg); // A new dialog for showing success
                //         },
                //       );
                //     } else {
                //       generalFunction.displayToast(msg);
                //     }
                //   },
                //   child: Container(
                //     //width: double.infinity,
                //     // Make container fill the width of its parent
                //     height: AppSize.s45,
                //     padding: EdgeInsets.all(AppPadding.p5),
                //     decoration: BoxDecoration(
                //       color: AppColors.loginbutton,
                //       // Background color using HEX value
                //       borderRadius: BorderRadius.circular(
                //           AppMargin.m10), // Rounded corners
                //     ),
                //     //  #00b3c7
                //     child: Center(
                //       child: Text(
                //         "Submit",
                //         style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                //       ),
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
}
