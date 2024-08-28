import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presentation/login/loginScreen.dart';
import '../presentation/resources/assets_manager.dart';
import '../presentation/resources/values_manager.dart';

String? sFirstName;
String? sCompEmailId;

class GeneralFunction {
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

  goNext(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // Pop all routes until this page
    );
  }

  // tost
  void displayToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
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
              // image: DecorationImage(
              //   image: AssetImage('assets/images/splash_logo.png'), // Replace with your asset image path
              //   fit: BoxFit.fill,
              // ),
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
                drawerItem('assets/images/tripdetails.jpeg', "Trip Details"),
                drawerItem('assets/images/triplistfirst.jpeg', "Trip List"),
                InkWell(
                    onTap: (){
                      print('---Logout---');
                      logout(context);
                    },
                    child: drawerItem('assets/images/logout.jpeg', "Logout")),
                // drawerItem('assets/images/tripdetails.jpeg', "Trip List"),
                // drawerItem('assets/images/post_complaint.png', "Today's Attendance"),
                // drawerItem('assets/images/post_complaint.png', "All Leave Status"),
                // drawerItem('assets/images/post_complaint.png', "My Leave Status"),
                // drawerItem('assets/images/post_complaint.png', "Action On Leave"),
                // drawerItem('assets/images/post_complaint.png', "Employee List"),
                // drawerItem('assets/images/post_complaint.png', "Family Details (Dependents)"),
                // drawerItem('assets/images/post_complaint.png', "Employees Nomination Details"),
                // drawerItem('assets/images/post_complaint.png', "Emergency Contact List"),
                // drawerItem('assets/images/post_complaint.png', "Thought Of The Day"),
                // drawerItem('assets/images/post_complaint.png', "Change Password"),
                // InkWell(
                //      onTap: (){
                //        print('---Logout---');
                //        logout(context);
                //      },
                //     child: drawerItem('assets/images/logout.jpeg', "Logout")),
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
                  fontWeight: FontWeight.bold,
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

}