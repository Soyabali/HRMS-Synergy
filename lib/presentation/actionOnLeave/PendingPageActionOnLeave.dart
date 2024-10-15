import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/generalFunction.dart';
import '../../data/hrmsleavependingforapprovail.dart';
import '../../data/updateLeaveStatusRepo.dart';
import '../../domain/actionOnLeaveModel.dart';
import '../resources/app_text_style.dart';

class PendingPageActionOnLeave extends StatefulWidget {
  String? formDate, toDate;

  PendingPageActionOnLeave(
      {super.key, required this.formDate, required this.toDate});

  @override
  State<PendingPageActionOnLeave> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPageActionOnLeave> {
  var result, msg;
  late Future<List<HrmsLeavePendingForApprovalModel>>
      hrmsLeavePendingForApproval;
  GeneralFunction generalFunction = GeneralFunction();
  late var leavePending;

  @override
  void initState() {
    // TODO: implement initState
    print('----------28-----Pending');
    print("${widget.formDate}");
    print("${widget.toDate}");
    hrmsLeavePendingForApproval = HrmsLeavePendingForApprovailRepo()
        .hrmsLevePendingForApprovalList(
            context, "${widget.formDate}", "${widget.toDate}", "P");
    print('-----37---$hrmsLeavePendingForApproval');
    super.initState();
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
                      //  final randomColor = colorList[index % colorList.length];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
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
                                              Text(
                                                  'Applied by : ${leavePending.sEmpName}',
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
                                                  Text(
                                                      'From : ${leavePending.dFromDate}',
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
                                                  Text(
                                                      'TO : ${leavePending.dToDate}',
                                                      style: AppTextStyle
                                                          .font12OpenSansRegularBlackTextStyle),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
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
                                              var iTranId =
                                                  "${leavePending.iTranId}";
                                              print('---288--$iTranId');

                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return _takeActionDialog(
                                                      context, iTranId);
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            )));
  }

  // take action dialog
  // take a action Dialog
  Widget _takeActionDialog(BuildContext context, String iTranId) {
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
                  'Update Leave Status',
                  style: AppTextStyle.font16OpenSansRegularBlack45TextStyle,
                ),
                SizedBox(height: 10),
                // TextFormField for entering data
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: TextFormField(
                    controller: _takeAction,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        filled: true,
                        // Enable background color
                        fillColor: Color(0xFFf2f3f5),
                        // Set your desired background color here
                        hintText: 'Enter Remarks',
                        // Set your hint text here
                        hintStyle:
                            AppTextStyle.font14OpenSansRegularBlack45TextStyle),
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
                // Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        var sRemarks = _takeAction.text;
                        var action = "R";

                        if (sRemarks != null && sRemarks != '') {

                          var updateLeaveStatus = await UpdateLeaveStatusRepo()
                              .updateLeaeStatus(context, iTranId, action, sRemarks);

                          setState(() {
                            result = "${updateLeaveStatus[0]['Result']}";
                            msg = "${updateLeaveStatus[0]['Msg']}";
                          });
                          print('--Result---416--$result');
                          print('--Result---417--$msg');
                          // inter condition
                          if(result=="1"){
                            Navigator.of(context).pop();
                            // call api again
                            hrmsLeavePendingForApproval = HrmsLeavePendingForApprovailRepo()
                                .hrmsLevePendingForApprovalList(
                                context, "${widget.formDate}", "${widget.toDate}", "P");

                            showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) {
                                return _buildDialogSucces2(
                                    context, msg);
                              },
                            );
                          }else{
                            print("----427--result--0-");
                          }

                        } else {
                          print('---Api not call ----');
                          generalFunction.displayToast("Enter remarks");
                        }
                      },


                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 8),
                        // Adjust vertical padding to reduce height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15), // Rounded corners for the button
                        ),
                        backgroundColor:
                            Color(0xFF0098a6), // Button background color
                      ),
                      child: Text(
                        'Rejected',
                        style: AppTextStyle.font12OpenSansRegularWhiteTextStyle,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var sRemarks = _takeAction.text;
                        var action = "S";

                        if (sRemarks != null && sRemarks != '') {

                          var updateLeaveStatus = await UpdateLeaveStatusRepo()
                              .updateLeaeStatus(context, iTranId, action, sRemarks);

                          setState(() {
                            result = "${updateLeaveStatus[0]['Result']}";
                            msg = "${updateLeaveStatus[0]['Msg']}";
                          });
                          print('--Result---475--$result');
                          print('--Result---476--$msg');
                          // inter condition
                          if(result=="1"){
                            Navigator.of(context).pop();
                            // api call
                            hrmsLeavePendingForApproval = HrmsLeavePendingForApprovailRepo()
                                .hrmsLevePendingForApprovalList(
                                context, "${widget.formDate}", "${widget.toDate}", "P");
                            // show Dialog
                            showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) {
                                return _buildDialogSucces2(
                                    context, msg);
                              },
                            );
                          }else{
                            print("----427--result--0-");
                          }

                        } else {
                          print('---Api not call ----');
                          generalFunction.displayToast("Enter remarks");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 8),
                        // Adjust vertical padding to reduce height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15), // Rounded corners for the button
                        ),
                        backgroundColor:
                            Color(0xFF0098a6), // Button background color
                      ),
                      child: Text(
                        'Approved',
                        style: AppTextStyle.font12OpenSansRegularWhiteTextStyle,
                      ),
                    ),
                  ],
                ),
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
                        //  hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
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
}
