import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/presentation/policydoc/policyDocPdf.dart';
import '../../app/generalFunction.dart';
import '../../data/companyPolicy_repo.dart';
import '../../data/policyDocAcceptRepo.dart';
import '../../data/policyDocRejectRepo.dart';
import '../../domain/policy_model.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';

class PolicyDoc extends StatelessWidget {
  const PolicyDoc({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PolicydocScreen(),
    );
  }
}

class PolicydocScreen extends StatefulWidget {
  const PolicydocScreen({super.key});

  @override
  State<PolicydocScreen> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<PolicydocScreen> {
  late Future<List<PolicyDocModel>> polocyDocList;
  var result, msg;
  GeneralFunction generalFunction = GeneralFunction();

  final List<Color> colorList = [
    Color(0xFF4DB6AC),
    Color(0xFFE1A245),
    Color(0xFFC888D3),
    Color(0xFFE88989),
    Color(0xFFA6A869),
    Color(0xFF379BF3),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polocyDocList = HrmsPolicyDocRepo().policyDocList(context);
    print('----40--$polocyDocList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar
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
              MaterialPageRoute(builder: (context) => const DashBoard()),
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
            'Policy Doc',
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
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 110,
            child: FutureBuilder<List<PolicyDocModel>>(
                future: polocyDocList,
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
                    return Center(child: Text('No notifications found'));
                  }
                  // Once data is available, build the ListView
                  final polocyDocList = snapshot.data!; // Access the resolved data

                  return ListView.builder(
                      itemCount: polocyDocList.length,
                      itemBuilder: (context, index) {
                        final policyDocData = polocyDocList[index];
                        final randomColor = colorList[index % colorList.length];

                        return Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Card(
                                  elevation: 5, // Elevation for shadow effect
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      // Rounded corners
                                      side: BorderSide(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 5),
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                // First Column: Takes 80% of the width
                                                Expanded(
                                                  flex: 8, // 80% of width
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: randomColor,
                                                              // Red color
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5), // Radius of 5
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            policyDocData
                                                                .dUploadDate,
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlackTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      // Spacing between the two texts
                                                      Text(
                                                        policyDocData
                                                            .sPolictyTitle,
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Expanded(
                                                  flex: 2, // 20% of width
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Transform.rotate(
                                                      angle: 45 * (3.1415927 / 180),
                                                      // Rotate by 90 degrees (convert degrees to radians)
                                                      child: GestureDetector(
                                                        child: IconButton(
                                                          icon: Icon(Icons.attach_file),
                                                          onPressed: () {
                                                            var pdfFile = policyDocData.sPolicyFile;
                                                            print(
                                                                '---Downlode pdf ---195------$pdfFile');
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      PolicydocPdfScreen(
                                                                          pdfFile:
                                                                              pdfFile)),
                                                            );
                                                            // Handle onPressed for icon here
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              policyDocData.sPolictyDescription,
                                              style: AppTextStyle
                                                  .font10OpenSansRegularBlackTextStyle,
                                            ),
                                            SizedBox(height: 5),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.end,
                                            //   // Aligns Row to the right
                                            //   children: [
                                            //     // Accept text with iOS forward icon
                                            //     GestureDetector(
                                            //       onTap: () async {
                                            //         print('---ACCEPT---');
                                            //         // call api
                                            //         var sPolicyCode = policyDocData.sPolicyCode;
                                            //         print('---sPolicyCode---$sPolicyCode');
                                            //         var projectDocAccept = await PolicydocAcceptRepo().policydocAccept(context,sPolicyCode);
                                            //         print('---232---$projectDocAccept');
                                            //         setState(() {
                                            //           msg = "${projectDocAccept[0]['Msg']}";
                                            //         });
                                            //         if(msg!=null && msg!=''){
                                            //           showDialog(
                                            //             context: context,
                                            //             builder: (BuildContext context) {
                                            //               return _buildDialogSucces2(context, msg); // A new dialog for showing success
                                            //             },
                                            //           );
                                            //         }else{
                                            //           generalFunction.displayToast("Not Response");
                                            //         }
                                            //
                                            //
                                            //       },
                                            //       child: Row(
                                            //         children: [
                                            //           Text('ACCEPT', style: AppTextStyle
                                            //               .font12OpenSansRegularGreenTextStyle,
                                            //           ),
                                            //           SizedBox(width: 8),
                                            //           // Space between text and icon
                                            //           Icon(Icons.arrow_forward_ios, size: 12),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //     SizedBox(width: 20),
                                            //     // Space between "Accept" and "Reject"
                                            //
                                            //     // Reject text with iOS forward icon
                                            //     GestureDetector(
                                            //       onTap: (){
                                            //         print('---REJECT---');
                                            //         //_takeActionDialog(context);
                                            //         var sPolicyCode = policyDocData.sPolicyCode;
                                            //         print('---PoliceCode---$sPolicyCode');
                                            //
                                            //         showDialog(
                                            //           context: context,
                                            //           builder: (BuildContext context) {
                                            //             return _takeActionDialog(context,sPolicyCode);
                                            //           },
                                            //         );
                                            //       },
                                            //       child: Row(
                                            //         children: [
                                            //           Text('REJECT', style: AppTextStyle
                                            //               .font12OpenSansRegularRedTextStyle),
                                            //           SizedBox(width: 8),
                                            //           // Space between text and icon
                                            //           Icon(Icons.arrow_forward_ios, size: 12),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            // SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  // Open DIALOG
  // take a action Dialog
  Widget _takeActionDialog(BuildContext context, String sPolicyCode) {
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
                  'Update Policy View Status',
                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                ),
                SizedBox(height: 10),
                // TextFormField for entering data

                Padding(
                  padding: const EdgeInsets.only(left: 0),
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
                      hintText: 'Enter Reason',
                      // Add hint text here
                      hintStyle:
                          AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                SizedBox(height: 15),

                // Submit button
                InkWell(
                  onTap: () async {
                    var remark = _takeAction.text.trim();
                    print('-----1102--$remark');
                    //  sPolicyCode
                    print('-----350----$sPolicyCode');
                    // print(sTranCode);
                    // Check if the input is not empty
                    if (remark != null && remark != '') {
                      print('---Call Api-----');

                      // Make API call here
                      var projectdocReject = await PolicydocrejectRepo()
                          .policydocReject(context, remark, sPolicyCode);

                      print('---360----$projectdocReject');
                      //
                      setState(() {
                        // result = "${projectdocReject[0]['Result']}";
                        msg = "${projectdocReject[0]['Msg']}";
                      });

                      print('---1114----$result');
                      print('---1115----$msg');

                      // Check the result of the API call
                      if (msg != null && msg != '') {
                        // Close the current dialog and show a success dialog
                        Navigator.of(context).pop();

                        // Show the success dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildDialogSucces2(context,
                                msg); // A new dialog for showing success
                          },
                        );
                        print('-----1123---');
                      } else if (msg == '') {
                        generalFunction.displayToast("No Response");
                        // Keep the dialog open and show an error message (if needed)
                        // You can display an error message in the same dialog without dismissing it
                        //generalFunction.displayToast(msg);  // Optionally, show a toast message to indicate failure

                        // Optionally clear the input field if needed
                        // _takeAction.clear();  // Do not clear to allow retrying
                      }
                    } else {
                      // Handle the case where no input is provided
                      generalFunction.displayToast("Enter remarks");
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
                      borderRadius: BorderRadius.circular(
                          AppMargin.m10), // Rounded corners
                    ),
                    //  #00b3c7
                    child: Center(
                      child: Text(
                        "Rejected",
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
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/policydocrecect.jpeg',
                  // Replace with your asset image path
                  fit: BoxFit.fill,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: -30, // Position the image at the top center
          //   child: CircleAvatar(
          //     radius: 25,
          //     backgroundColor: Colors.white,
          //     child: ClipOval(
          //       child: Image.asset(
          //         'assets/images/policydocrecect.jpeg', // Replace with your asset image path
          //         fit: BoxFit.fill,
          //         width: 35,
          //         height: 35,
          //       ),
          //     ),
          //   ),
          // ),
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
                Text('Information',
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
                        /// todo here you uncomment of the api link
                        ///
                        //  hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const ExpenseManagement()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Set the background color to white
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
                'assets/images/dialogimg.jpeg',
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              )
                  // child: Image.asset('assets/images/sussess.jpeg', // Replace with your asset image path
                  //   fit: BoxFit.cover,
                  //   width: 60,
                  //   height: 60,
                  // ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
