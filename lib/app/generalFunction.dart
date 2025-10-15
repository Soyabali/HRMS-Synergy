import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/dashboard/dashboard.dart';
import 'package:untitled/presentation/shortLeave/shortLeave.dart';
import 'package:url_launcher/url_launcher.dart';
import '../presentation/actionOnLeave/actionOnLeave.dart';
import '../presentation/allLeaveStatus/allLeaveStatus.dart';
import '../presentation/changePassword/changepassword.dart';
import '../presentation/employeeList/employeelist.dart';
import '../presentation/expensemanagement/pendingteamreimb/duplicateExpenseEntry.dart';
import '../presentation/leaveCancellationRequest/leaveCancellationRequest.dart';
import '../presentation/login/loginScreen.dart';
import '../presentation/myLeaveStatus/myLeaveStatus.dart';
import '../presentation/resources/app_text_style.dart';
import '../presentation/tripList/tripList.dart';
import '../presentation/tripdetails/tripdetail.dart';


String? sFirstName;
String? sCompEmailId;
String? iIsEligibleShLv;
String? sEmpImage;

class GeneralFunction {

  getLocalValueFromALocalDataBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('iIsEligibleShLv');
  }
  getEImageLocalValueFromALocalDataBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sEmpImage');
  }
  Future<void> someFunction() async {
    iIsEligibleShLv = await getLocalValueFromALocalDataBase();
    sEmpImage = await getEImageLocalValueFromALocalDataBase();
    print("-------43------$iIsEligibleShLv"); // This will print the actual value
    print("-------44------$sEmpImage");
  }
  // Open ImageFullScreenDialog
  void showFullScreenImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // tap outside to close
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero, // full screen
          child: Stack(
            children: [
              // Internet image
              InteractiveViewer( // for zoom, drag, etc.
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// A function that returns a circular widget to display an image from the internet.
  Widget internetImage(String imageUrl, {double size = 80.0, BoxFit fit = BoxFit.cover}) {
    return ClipOval(
      child: GestureDetector(
        onTap: (){
          var image = imageUrl;
          print("-----48-----------$image");

          // to Open imageOn a full Screen

        },
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: fit,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child; // Image is fully loaded, so display it
            } else {
              // Show a CircularProgressIndicator while the image is loading
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            // Show an error icon if the image fails to load
            return Container(
              height: 50, // Set the height of the container
              width: 50,  // Set the width of the container
              decoration: BoxDecoration(
                color: Colors.grey.shade400, // Background color
                borderRadius: BorderRadius.circular(50), // Make the corners rounded
              ),
              child: ClipOval( // Clip the child to a circle
              ),
            );
            // return Icon(Icons.error, color: Colors.red, size: size / 2);
          },
        ),
      ),
    );
  }


  void logout(BuildContext context)async {
       /// TODO LOGOUT CODE
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // get a stored value
     sFirstName = prefs.getString('sFirstName');
     sCompEmailId = prefs.getString('sCompEmailId');
    iIsEligibleShLv = prefs.getString('iIsEligibleShLv');
    print('-----37----XXX--$iIsEligibleShLv');
    print("----firstName :----$sFirstName");

    prefs.remove("sEmpCode");
    prefs.remove("sCompEmpCode");
    prefs.remove("sFirstName");
    prefs.remove("sLastName");

    prefs.remove("sLastName");
    //prefs.remove("sContactNo");
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
    prefs.remove("setPin");
   // prefs.clear();
    goNext(context);
  }
  // dialogBOX
  // void displayToast(String msg) {
  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.black45,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

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
  //  takeActionDialog
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
                  internetImage(
                    '$sEmpImage',
                    fit: BoxFit.cover,
                  ),
                  // Container(
                  //   width: 80,
                  //   height: 80,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[300], // Light gray color
                  //     borderRadius: BorderRadius.circular(40), // Border radius of 40
                  //   ),
                  //   /// todo apply a funcation to set a internet images
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(14.0),
                  //     child: Container(
                  //       child:   Image.asset('assets/images/post_complaint.png',
                  //         fit: BoxFit.cover,
                  //        ),
                  //     ),
                  //   ),
                  // ),
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
                    child: drawerItem('assets/images/allleavestatus.jpeg', "All Leave Status")),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Myleavestatus()),
                    );
                  },
                    child: drawerItem('assets/images/myLeaveStatus.jpeg', "My Leave Status")),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Actiononleave()),
                    );
                  },
                    child: drawerItem('assets/images/actionOnLeave.jpeg', "Action On Leave")),
                // short leave
                shortLeaveWidget(context),
                // InkWell(
                //   onTap: (){
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => ShortLeave()),
                //     );
                //   },
                //     child: drawerItem('assets/images/post_complaint.png', "Short Leave")),

                InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeaveCancellationRequest()),
                      );
                    },
                    child: drawerItem('assets/images/leaveCancellation.jpeg', "Leave Cancellation Request")),
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
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmployeeList()),
                    );
                  },
                    child: drawerItem('assets/images/employlist.jpeg', "Employee List")),
                  // ChangePassword
                InkWell(
                    onTap: (){
                      // open Password screen
                      print('---Password-----');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePassword(name: null,)),
                      );
                    },
                    child: drawerItem('assets/images/changePasswrod.PNG', "Change Password")),
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
  Widget shortLeaveWidget(BuildContext context) {
    someFunction();
    if (iIsEligibleShLv == "1") {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShortLeave()),
          );
        },
        child: drawerItem('assets/images/shortleave.jpeg', "Short Leave"),
      );
    } else {
      return SizedBox.shrink(); // Return an empty widget if abc is not 1
    }
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

  // void displayToastlogout(){
  //   Fluttertoast.showToast(
  //       msg: "Someone else has been login with your number.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  // }

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
  // build dialogSucess
  Widget buildDialogCall(BuildContext context, String sEmpName, String sContactNo) {
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
            height: 170,
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Space for the image
                Row(
                  children: [
                    Icon(
                      Icons.phone, // Exclamation icon
                      color: Colors.red, // Color of the icon
                      size: 22, // Size of the icon
                    ),
                    SizedBox(width: 8), // Spacing between the icon and text
                    Text(
                      'Phone Call',
                      style: TextStyle(
                        fontSize: 16, // Adjust font size
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.black, // Text color
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded( // Wrap the text in Expanded to allow it to take available space and wrap
                 child: Text.rich(
                   TextSpan(
                     text: 'Do you want to call ', // Regular text
                     style: TextStyle(
                         fontSize: 12,
                         color: Colors.grey[600]), // Default text style
                     children: <TextSpan>[
                       TextSpan(
                         text: '$sEmpName', // Highlighted text
                         style: TextStyle(
                           fontWeight: FontWeight.bold, // Bold only for the name
                           color: Color(0xff3f617d), // Optional: Change color for the name
                         ),
                       ),
                       TextSpan(
                         text: '?', // Regular text after the name
                       ),
                     ],
                   ),
                 ),
                  // child: Text(
                  //   "Do you want to call Ashish Babu",
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.grey[600],
                  //   ),
                  //   textAlign: TextAlign.left, // Align the text to the left
                  //   softWrap: true, // Allow text to wrap
                  //   maxLines: 2, // Set the maximum number of lines the text can take
                  //   overflow: TextOverflow.ellipsis, // Add ellipsis if the text exceeds the available space
                  // ),
                ),
                SizedBox(height: 20),
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
                            'No',
                            style: GoogleFonts.openSans(
                              color: Colors.red, // Text color for "Yes"
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
                           // getLocation();
                           // Navigator.of(context).pop();
                            _makePhoneCall("${sContactNo}");

                            print("----Phone call----");
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
                              color: Colors.green, // Text color for "No"
                              fontSize: 12, // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
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
    );
  }

  // phoneCall method
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

}