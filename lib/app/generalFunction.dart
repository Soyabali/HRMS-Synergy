import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/dashboard/dashboard.dart';
import 'package:untitled/presentation/shortLeave/shortLeave.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presentation/actionOnLeave/actionOnLeave.dart';
import '../presentation/allLeaveStatus/allLeaveStatus.dart';
import '../presentation/leaveCancellationRequest/leaveCancellationRequest.dart';
import '../presentation/login/loginScreen.dart';
import '../presentation/myLeaveStatus/myLeaveStatus.dart';
import '../presentation/resources/app_text_style.dart';
import '../presentation/resources/assets_manager.dart';
import '../presentation/resources/values_manager.dart';
import '../presentation/tripList/tripList.dart';
import '../presentation/tripdetails/tripdetail.dart';

String? sFirstName;
String? sCompEmailId;

class GeneralFunction {
  TextEditingController _takeActionController = TextEditingController();
  void logout(BuildContext context)async {
       /// TODO LOGOUT CODE
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // get a stored value
     sFirstName = prefs.getString('sFirstName');
     sCompEmailId = prefs.getString('sCompEmailId');

    prefs.remove("sEmpCode");
    prefs.remove("sCompEmpCode");
    prefs.remove("sFirstName");
    prefs.remove("sLastName");

    prefs.remove("sLastName");
    prefs.remove("sContactNo");
    prefs.remove("dDOJ");
    prefs.remove("dDOB");

    prefs.remove("sEmergencyContactPerson");
    prefs.remove("sEmergencyContactNo");
    prefs.remove("sEmergencyContactRelation");
    prefs.remove("sBloodGroup");

    prefs.remove("sCategory");
    prefs.remove("sDsgCode");
    prefs.remove("sDsgName");
    prefs.remove("sDeptCode");

    prefs.remove("sDeptName");
    prefs.remove("sLocCode");
    prefs.remove("sLocName");
    prefs.remove("sLocation");

    prefs.remove("sBankName");
    prefs.remove("sBankAcNo");
    prefs.remove("sISFCode");
    prefs.remove("Entitlement");

    prefs.remove("Availed");
    prefs.remove("Balance");
    prefs.remove("sToken");
    prefs.remove("sEmpImage");

    prefs.remove("sCompEmailId");
    prefs.remove("sMngrName");
    prefs.remove("sMngrDesgName");
    prefs.remove("Development");

    prefs.remove("sMngrContactNo");
    prefs.remove("iIsEligibleShLv");

    goNext(context);
  }
  // dialogBOX
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  //  takeActionDialog

  _takeActionDialog(BuildContext context) {
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
                Text(
                    'Remove Reimbursement',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 0),
                  child: Container(
                    height: 42,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: TextFormField(
                        controller: _takeActionController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          filled: true, // Enable background color
                          fillColor: Color(0xFFf2f3f5),// Set your desired background color here
                        ),
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        // validator: (value) {
                        //   if (value !=null && value =="0") {
                        //     return 'Enter an amount greater than 0';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                  ),
                ),
                // Text(
                //   msg,
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey[600],
                //   ),
                //   maxLines: 2,
                //   textAlign: TextAlign.center,
                // ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the background color to white
                        foregroundColor: Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
                  'assets/images/sussess.jpeg', // Replace with your asset image path
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

  // logout dialogbBOX
  // void _showlogoutDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15.0),
  //           ),
  //           title: const Column(
  //             children: [
  //               Icon(
  //                 Icons.logout,
  //                 color: Colors.red,
  //                 size: 50.0,
  //               ),
  //               SizedBox(height: 10.0),
  //               Text(
  //                 'Logout',
  //                 style: TextStyle(
  //                   fontSize: 22.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           content: const Text(
  //             "Do you want to log out?",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 16.0,
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Dismiss the dialog
  //               },
  //               child: Text(
  //                 'No',
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 logout(context);
  //                 Navigator.of(context).pop(); // Dismiss the dialog after action
  //                 // You can call a function or perform any action you need here
  //               },
  //               child: Text(
  //                 'Yes',
  //                 style: TextStyle(color: Colors.green),
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //   );
  // }
  Widget _logoutDialog(BuildContext context) {
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
            height: 160,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Logout',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                Text(
                  "Do you want to Logout ?",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Container(
                  height: 35, // Reduced height to 35
                  padding: EdgeInsets.symmetric(horizontal: 5), // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    border: Border.all(color: Colors.grey), // Border color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            logout(context);
                            //generalFunction.logout(context);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove default padding
                            minimumSize: Size(0, 0), // Remove minimum size constraints
                            backgroundColor: Colors.white, // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              color: Colors.green, // Text color for "Yes"
                              fontSize: 12, // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey, // Divider color
                        width: 20, // Space between buttons
                        thickness: 1, // Thickness of the divider
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove default padding
                            minimumSize: Size(0, 0), // Remove minimum size constraints
                            backgroundColor: Colors.white, // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              color: Colors.red, // Text color for "No"
                              fontSize: 12, // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                // Container(
                //     height: 50,
                //     padding: EdgeInsets.all(5), // Adjust padding as needed
                //     decoration: BoxDecoration(
                //       color: Colors.white, // Container background color
                //       borderRadius: BorderRadius.circular(15), // Rounded corners
                //       border: Border.all(color: Colors.grey), // Border color
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Expanded(
                //           child: TextButton(
                //             onPressed: () {
                //               generalFunction.logout(context);
                //               Navigator.of(context).pop();
                //             },
                //             style: TextButton.styleFrom(
                //               backgroundColor: Colors.white, // Button background
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15), // Button border radius
                //               ),
                //             ),
                //             child: Text(
                //               'Yes',
                //               style: GoogleFonts.openSans(
                //                 color: Colors.red, // Text color for "Yes"
                //                 fontSize: 10,
                //                 fontWeight: FontWeight.w400,
                //               ),
                //             ),
                //           ),
                //         ),
                //         VerticalDivider(
                //           color: Colors.grey, // Divider color
                //           width: 20, // Space between buttons
                //           thickness: 1, // Thickness of the divider
                //         ),
                //         Expanded(
                //           child: TextButton(
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //             style: TextButton.styleFrom(
                //               backgroundColor: Colors.white, // Button background
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15), // Button border radius
                //               ),
                //             ),
                //             child: Text(
                //               'No',
                //               style: GoogleFonts.openSans(
                //                 color: Colors.black, // Text color for "No"
                //                 fontSize: 10,
                //                 fontWeight: FontWeight.w400,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),


                // Padding(
                //   padding: const EdgeInsets.only(left: 40, right: 40),
                //   child: Container(
                //     height: 35,
                //     padding: EdgeInsets.all(5), // Adjust padding as needed
                //     decoration: BoxDecoration(
                //       color: Colors.white, // Container background color
                //       borderRadius: BorderRadius.circular(15), // Rounded corners
                //       border: Border.all(color: Colors.grey), // Border color
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         Expanded(
                //           child: TextButton(
                //             onPressed: () {
                //               //Navigator.of(context).pop();
                //               generalFunction.logout(context);
                //               Navigator.of(context).pop();
                //             },
                //             style: TextButton.styleFrom(
                //               backgroundColor: Colors.white,
                //               foregroundColor: Colors.black,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15), // Button border radius
                //               ),
                //             ),
                //             child: Text(
                //               'Yes',
                //               style: GoogleFonts.openSans(
                //                   color: AppColors.red, fontSize: 16, fontWeight: FontWeight.w400),
                //             ),
                //           ),
                //         ),
                //         VerticalDivider(
                //           color: Colors.grey, // Divider color
                //           width: 20, // Space between buttons
                //           thickness: 1, // Thickness of the divider
                //         ),
                //         Expanded(
                //           child: TextButton(
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //             style: TextButton.styleFrom(
                //               backgroundColor: Colors.white,
                //               foregroundColor: Colors.black,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15), // Button border radius
                //               ),
                //             ),
                //             child: Text(
                //               'No',
                //               style: GoogleFonts.openSans(
                //                   color: AppColors.green, fontSize: 16, fontWeight: FontWeight.w400),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // )

                // Padding(
                //   padding: const EdgeInsets.only(left: 40,right: 40),
                //   child: Container(
                //     height: 35,
                //     padding: EdgeInsets.all(5), // Adjust padding as needed
                //     decoration: BoxDecoration(
                //       color: Colors.white, // Container background color
                //       borderRadius: BorderRadius.circular(15), // Rounded corners
                //       border: Border.all(color: Colors.grey), // Border color
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         Expanded(
                //           child: ElevatedButton(
                //             onPressed: () {
                //               //Navigator.of(context).pop();
                //               generalFunction.logout(context);
                //               Navigator.of(context).pop();
                //
                //             },
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.white,
                //               foregroundColor: Colors.black,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15), // Button border radius
                //               ),
                //             ),
                //             child: Text(
                //               'Yes',
                //               style: GoogleFonts.openSans(
                //                   color: AppColors.red, fontSize: 16, fontWeight: FontWeight.w400)
                //             ),
                //           ),
                //         ),
                //         VerticalDivider(
                //           color: Colors.grey, // Divider color
                //           width: 20, // Space between buttons
                //           thickness: 1, // Thickness of the divider
                //         ),
                //         Expanded(
                //           child: ElevatedButton(
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.white,
                //               foregroundColor: Colors.black,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15), // Button border radius
                //               ),
                //             ),
                //             child: Text(
                //               'No',
                //                 style: GoogleFonts.openSans(
                //                     color: AppColors.green, fontSize: 16, fontWeight: FontWeight.w400)
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // )

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.white, // Set the background color to white
                //         foregroundColor: Colors.black, // Set the text color to black
                //       ),
                //       child: Text('Yes',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                //     ),
                //     ElevatedButton(
                //       onPressed: () {
                //         getLocation();
                //         Navigator.of(context).pop();
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.white, // Set the background color to white
                //         foregroundColor: Colors.black, // Set the text color to black
                //       ),
                //       child: Text('No',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                //     )
                //   ],
                // )
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
                  'assets/images/logoutnew.jpeg', // Replace with your asset image path
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
  goNext(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // Pop all routes until this page
    );
  }
  // drawerFunction

  drawerFunction(BuildContext context, String sName, String email) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove any default padding
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0098a6),

            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Light gray color
                      borderRadius: BorderRadius.circular(40), // Border radius of 40
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Container(
                        child:   Image.asset('assets/images/post_complaint.png',
                          fit: BoxFit.cover,
                         ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    sName,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap:(){
                  // AllLeaveStatus
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllLeaveStatus()),
                    );
                  },
                    child: drawerItem('assets/images/tripdetails.jpeg', "All Leave Status")),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Myleavestatus()),
                    );
                  },
                    child: drawerItem('assets/images/triplistfirst.jpeg', "My Leave Status")),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Actiononleave()),
                    );
                  },
                    child: drawerItem('assets/images/tripdetails.jpeg', "Action On Leave")),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShortLeave()),
                    );
                  },
                    child: drawerItem('assets/images/post_complaint.png', "Short Leave")),
                InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeaveCancellationRequest()),
                      );
                    },
                    child: drawerItem('assets/images/post_complaint.png', "Leave Cancellation Request")),
                InkWell(
                  onTap: (){
                    // TripDetails
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TripDetail()),
                    );
                  },
                    child: drawerItem('assets/images/tripdetails.jpeg', "Trip Details")),
                InkWell(
                  onTap: (){
                    // StripList
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TripList()),
                    );
                  },
                    child: drawerItem('assets/images/triplistfirst.jpeg', "Trip List")),
                drawerItem('assets/images/post_complaint.png', "Employee List"),
                // drawerItem('assets/images/post_complaint.png', "Family Details (Dependents)"),
                // drawerItem('assets/images/post_complaint.png', "Employees Nomination Details"),
                // drawerItem('assets/images/post_complaint.png', "Emergency Contact List"),
                // drawerItem('assets/images/post_complaint.png', "Thought Of The Day"),
                // drawerItem('assets/images/post_complaint.png', "Change Password"),
                InkWell(
                     onTap: (){
                       showDialog(
                         context: context,
                         builder: (BuildContext context) {
                           return _logoutDialog(context);
                         },
                       );
                     },
                    child: drawerItem('assets/images/logout.jpeg', "Logout")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItem(String imagePath, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain, // or BoxFit.cover depending on the desired effect
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xff3f617d),
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 0.5,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // drawerFunction(BuildContext context, String sName, String sContactNo) {
  //   return Drawer(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         DrawerHeader(
  //           decoration: const BoxDecoration(
  //             image: DecorationImage(image: AssetImage('assets/images/splash_logo.png'), // Replace with your asset image path
  //               fit: BoxFit.fill,
  //             ),
  //             // image: DecorationImage(image: AssetImage('assets/images/citysimpe.png'), // Replace with your asset image path
  //             //   fit: BoxFit.cover,
  //             // ),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 sName,
  //                 style: const TextStyle(
  //                   fontFamily: 'Montserrat',
  //                   color: Colors.black,
  //                   fontSize: 16.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: <Widget>[
  //                   const Icon(
  //                     Icons.call,
  //                     size: 18,
  //                     color: Colors.black,
  //                   ),
  //                   SizedBox(width: 5),
  //                   Text(
  //                     sContactNo,
  //                     style: const TextStyle(
  //                       fontFamily: 'Montserrat',
  //                       color: Colors.black,
  //                       fontSize: 16.0,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: <Widget>[
  //                       Image.asset(
  //                         'assets/images/post_complaint.png',
  //                         width: 35,
  //                         height: 35,
  //                       ),
  //                       const SizedBox(width: 10),
  //                       const Text(
  //                         "Today's Attendance",
  //                         style: TextStyle(
  //                           fontFamily: 'Montserrat',
  //                           color: Color(0xff3f617d),
  //                           fontSize: 16.0,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //
  //
  //                     ],
  //                   ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                 color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "All Leave Status",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "My Leave Status",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Action On Leave",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Leave Cancellation Request",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Trip Details",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Trip List",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Employee List",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Family Details (Dependents)",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Employees Nomination Details",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Image.asset(
  //                       'assets/images/post_complaint.png',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     const Text(
  //                       "Employees Nomination Details",
  //                       style: TextStyle(
  //                         fontFamily: 'Montserrat',
  //                         color: Color(0xff3f617d),
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 Container(height: 0.5,
  //                   color: Colors.grey,
  //                 )
  //
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ShowBottomSheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              print('---------');
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff3f617d),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Do you want to logout?",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff3f617d),
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () async {
                              // create an instance of General function
                              logout(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF255899),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust as needed
                              ), // Text color
                            ),
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 30,
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust as needed
                              ), // Text color
                            ),
                            child: const Text(
                              'No',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }

  void displayToastlogout(){
    Fluttertoast.showToast(
        msg: "Someone else has been login with your number.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

   Future<void> launchGoogleMaps(double laititude,double longitude) async {
     double destinationLatitude= laititude;
     double destinationLongitude = longitude;
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {
          'q': '$destinationLatitude, $destinationLongitude'
        });
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }
  // successDialog
  Widget successDialog(BuildContext context,String msg) {
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
                Text(
                    'Success',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
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
                       // Navigator.of(context).pop();
                        // call api again
                        // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DashBoard()),
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the background color to white
                        foregroundColor: Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
                  'assets/images/sussess.jpeg', // Replace with your asset image path
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