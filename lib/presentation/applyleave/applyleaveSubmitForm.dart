import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/hrmsleaveapplication.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';
import 'applyLeave.dart';

class ApplyLeaveSubmitFormHome extends StatefulWidget {
  final sLvDesc, sFirstName, sLvTypeCode,sLastName;
  const ApplyLeaveSubmitFormHome(
      this.sLvDesc, this.sFirstName, this.sLvTypeCode,this.sLastName,
      {super.key});

  @override
  State<ApplyLeaveSubmitFormHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ApplyLeaveSubmitFormHome> {

  String _selectedValue = "Full Day";
  String _selectedValue2 = "Full";

  List stateList = [];
  List<dynamic> distList = [];
  List<dynamic> expenseList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;
  String? formattedDate;

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _reasonController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  FocusNode _reasonfocus = FocusNode();
  FocusNode _addressfocus = FocusNode();
  // FocusNode descriptionfocus = FocusNode();
  String? todayDate;

  List? data;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final sectorFocus = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  double? lat, long;

  var dExpDate;
  String? formDate;
  String? toDate;
  String? tempDate;
  String? sFirstName;
  int totalDays = 0;
  String displayText = "";
  var hrmsPopWarning;
  var fullName;

  // Uplode Id Proof with gallary

  // multifilepath
  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // dialogBox
  Widget _buildDialogSucces2(BuildContext context,String msg) {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Applyleave()),
                        );
                        //Navigator.of(context).pop();

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the background color to white
                        foregroundColor: Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     getLocation();
                    //     Navigator.of(context).pop();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white, // Set the background color to white
                    //     foregroundColor: Colors.black, // Set the text color to black
                    //   ),
                    //   child: Text('OK',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    // )
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
  // dialogBox if response is failed
  Widget _buildDialogFailed(BuildContext context,String msg) {
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
                    'Information',
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
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the background color to white
                        foregroundColor: Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     getLocation();
                    //     Navigator.of(context).pop();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white, // Set the background color to white
                    //     foregroundColor: Colors.black, // Set the text color to black
                    //   ),
                    //   child: Text('OK',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    // )
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
                  'assets/images/information.jpeg', // Replace with your asset image path
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

  @override
  void initState() {
    // TODO: implement initState
    getACurrentDate();
    DateTime currentDate = DateTime.now();
    formDate = DateFormat('dd/MMM/yyyy').format(currentDate);
    toDate = DateFormat('dd/MMM/yyyy').format(currentDate);
    calculateTotalDays();
     fullName = '${widget.sFirstName} ${''}${widget.sLastName}';
    print('-------278----$fullName');
    super.initState();
    _reasonfocus = FocusNode();
    _addressfocus = FocusNode();
  }
  // clculateTotalDays

  void calculateTotalDays() {
    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    DateTime? fromDate2 = dateFormat.parse(formDate!);
    DateTime? toDate2 = dateFormat.parse(toDate!);

    setState(() {
      totalDays = toDate2.difference(fromDate2).inDays +
          1; // Adding 1 to include both start and end dates
    });
    setState(() {
      if (totalDays <= 1) {
        displayText = _selectedValue; // Set your specific value
      } else {
        displayText = totalDays.toString() + ' Days'; // Display total days
      }
    });
    print('Total days:----114---: $displayText');
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _reasonfocus.dispose();
    _addressfocus.dispose();
    _reasonController.dispose();
    _addressController.dispose();
    FocusScope.of(context).unfocus();
  }

  getACurrentDate() {
    DateTime now = DateTime.now();
    formDate = DateFormat('dd/MMM/yyyy').format(now);
    //
    DateTime now2 = DateTime.now();
    toDate = DateFormat('dd/MMM/yyyy').format(now2);
  }

  // to Date SelectedLogic
  void toDateSelectLogic() {
    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    DateTime? fromDate2 = dateFormat.parse(formDate!);
    DateTime? toDate2 = dateFormat.parse(toDate!);

    if (toDate2.isBefore(fromDate2)) {
      setState(() {
        toDate = tempDate;
      });
      displayToast("To Date can not be less than From Date");
    }
  }

  void fromDateSelectLogic() {
    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    DateTime? fromDate2 = dateFormat.parse(formDate!);
    DateTime? toDate2 = dateFormat.parse(toDate!);

    if (fromDate2.isAfter(toDate2)) {
      setState(() {
        formDate = tempDate;
      });
      calculateTotalDays();
      displayToast("From date can not be greater than To Date");
    }
  }

  //
  void compareDates(String fromDate, String toDate) {
    String fromDateString = "29/Aug/2024";
    String toDateString = "30/Aug/2024";

    // Define the date format
    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    // Parse the date strings to DateTime objects
    DateTime? fromDate = dateFormat.parse(fromDateString);
    DateTime? toDate = dateFormat.parse(toDateString);

    // Compare the dates
    if (toDate.isAfter(fromDate)) {
      print('toDate is greater than fromDate');
      // Perform your action here
    } else if (toDate.isBefore(fromDate)) {
      print('toDate is less than fromDate');
    } else {
      print('toDate is the same as fromDate');
    }
  }

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

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
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        backgroundColor: Color(0xFF0098a6),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const Applyleave()),
            // );
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
            'Leave Application',
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

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: SizedBox(
                height: 150, // Height of the container
                width: MediaQuery.of(context).size.width,
                //width: 200, // Width of the container
                child: Image.asset(
                  'assets/images/leave.jpeg',
                  // Replace 'image_name.png' with your asset image path
                  fit: BoxFit.cover, // Adjust the image fit to cover the container
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.5), // Color of the shadow
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Offset of the shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center, // Center all widgets vertically
                              children: <Widget>[
                                // First widget: Image or Icon
                                Container(
                                  height: 24,
                                  width: 24,
                                  margin: const EdgeInsets.only(left: 0, right: 5, top: 10), // Consistent top margin
                                  child: Image.asset('assets/images/triplist_1.jpeg'),
                                ),

                                // Second widget: Text (fullName)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10), // Add top margin for consistent spacing
                                  child: Text(
                                    fullName ?? 'No Name',
                                    style: const TextStyle(
                                      color: Color(0xFF0097A7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                // Spacer to push the third widget to the right
                                Spacer(),

                                // Third widget: Container with text inside
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    height: 24.0, // Set the height of the container
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0), // Optional: horizontal padding
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200], // Background color
                                      borderRadius: BorderRadius.circular(9.0), // Rounded corners
                                    ),
                                    child: Center( // Center the text inside the container
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0), // Left and right padding inside the container
                                        child: Text(
                                          '${widget.sLvDesc}',
                                          style: AppTextStyle.font10OpenSansRegularBlackTextStyle,
                                          textAlign: TextAlign.center, // Center the text horizontally
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align row children horizontally
                                crossAxisAlignment: CrossAxisAlignment.center, // Align row children vertically to the center
                                children: [
                                  // First Column takes 1/3 of the width
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 30,
                                      color: Colors.white, // Background color for the first container
                                      alignment: Alignment.centerLeft, // Align the text to the left
                                      child: Text(
                                        'From Date :',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8), // Optional spacing between columns
                                  // Second Column takes the remaining 2/3 of the width
                                  Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                          setState(() {
                                            tempDate = formDate; // Save the current formDate before updating
                                            formDate = formattedDate;
                                            calculateTotalDays();
                                          });
                                          fromDateSelectLogic();
                                        }


                                      },
                                      child: Container(
                                        height: 30,
                                        color: Colors.grey[100], // Background color for the second container
                                        padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding inside the date container
                                        alignment: Alignment.center, // Align the row to the center
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start, // Center the icon and text horizontally
                                          crossAxisAlignment: CrossAxisAlignment.center, // Center the icon and text vertically
                                          children: [
                                            // First widget: Icon
                                            const Icon(
                                              Icons.calendar_month,
                                              color: Color(0xFF0098a6),
                                              size: 16, // Icon size
                                            ),
                                            SizedBox(width: 8), // Spacing between Icon and Text
                                            // Second widget: Text widget
                                            Text(
                                              '$formDate',
                                              style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align row children horizontally
                                crossAxisAlignment: CrossAxisAlignment.center, // Align row children vertically to the center
                                children: [
                                  // First Column takes 1/3 of the width
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 30,
                                      color: Colors.white, // Background color for the first container
                                      alignment: Alignment.centerLeft, // Align the text to the left
                                      child: Text(
                                        'To Date :',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8), // Optional spacing between columns
                                  // Second Column takes the remaining 2/3 of the width
                                  Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () async {
                                                    DateTime? pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    );
                                                    if (pickedDate != null) {
                                                      String formattedDate =
                                                      DateFormat('dd/MMM/yyyy')
                                                          .format(pickedDate);
                                                      setState(() {
                                                        tempDate =
                                                            toDate; // Save the current toDate before updating
                                                        toDate = formattedDate;
                                                        calculateTotalDays();
                                                      });
                                                      toDateSelectLogic();
                                                    }
                                        // DateTime? pickedDate = await showDatePicker(
                                        //   context: context,
                                        //   initialDate: DateTime.now(),
                                        //   firstDate: DateTime(2000),
                                        //   lastDate: DateTime(2100),
                                        // );
                                        // if (pickedDate != null) {
                                        //   String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                        //   setState(() {
                                        //     toDate = formDate; // Save the current formDate before updating
                                        //     toDate = formattedDate;
                                        //     calculateTotalDays();
                                        //   });
                                        //   fromDateSelectLogic();
                                        // }
                                      },
                                      child: Container(
                                        height: 30,
                                        color: Colors.grey[100], // Background color for the second container
                                        padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding inside the date container
                                        alignment: Alignment.center, // Align the row to the center
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start, // Center the icon and text horizontally
                                          crossAxisAlignment: CrossAxisAlignment.center, // Center the icon and text vertically
                                          children: [
                                            // First widget: Icon
                                            const Icon(
                                              Icons.calendar_month,
                                              color: Color(0xFF0098a6),
                                              size: 16, // Icon size
                                            ),
                                            SizedBox(width: 8), // Spacing between Icon and Text
                                            // Second widget: Text widget
                                            Text(
                                              '$toDate',
                                              style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align row children horizontally
                                crossAxisAlignment: CrossAxisAlignment.center, // Align row children vertically at the center
                                children: [
                                  // First Column takes 1/3 of the width
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 35,
                                      color: Colors.white, // Background color for the first container
                                      alignment: Alignment.centerLeft, // Align text to the left
                                      child: Text(
                                        'Reason :',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8), // Optional spacing between columns
                                  // Second Column takes the remaining 2/3 of the width
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 35, // Ensure consistent height for the container
                                      color: Colors.grey[100], // Background color for the second container
                                      child: Center(
                                        child: TextFormField(
                                          focusNode: _reasonfocus,
                                          controller: _reasonController,
                                          textInputAction: TextInputAction.next,
                                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Adjust padding
                                            hintText: 'Enter leave reason', // Add your hint text here
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12, // Adjust the font size as needed
                                            ),
                                            border: OutlineInputBorder(),
                                            filled: true, // Enable background color
                                            fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                          ),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          maxLines: 1, // Keeps the TextFormField to a single line
                                          showCursor: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align row children horizontally
                                crossAxisAlignment: CrossAxisAlignment.center, // Align row children vertically at the center
                                children: [
                                  // First Column takes 1/3 of the width
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 35,
                                      color: Colors.white, // Background color for the first container
                                      alignment: Alignment.centerLeft, // Align text to the left
                                      child: Text(
                                        'Address :',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8), // Optional spacing between columns
                                  // Second Column takes the remaining 2/3 of the width
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 35, // Ensure consistent height for the container
                                      color: Colors.grey[100], // Background color for the second container
                                      child: Center(
                                        child: TextFormField(
                                          focusNode: _addressfocus,
                                          controller: _addressController,
                                          textInputAction: TextInputAction.next,
                                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Adjust padding
                                            hintText: 'Enter Contactable address', // Add your hint text here
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12, // Adjust the font size as needed
                                            ),
                                            border: OutlineInputBorder(),
                                            filled: true, // Enable background color
                                            fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                          ),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          maxLines: 1, // Keeps the TextFormField to a single line
                                          showCursor: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Visibility(
                              visible: totalDays <= 1,
                              replacement: SizedBox.shrink(),
                              child: Container(
                                height: 88,
                              // color: Colors.white,
                                color: Colors.grey[100], // Light gray color
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10,left: 20),
                                      child: Text('Applied For :',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlackTextStyle),
                                    ),
                                    SizedBox(height: 0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Radio<String>(
                                              value: "Full Day",
                                              groupValue: _selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedValue = value!;
                                                });
                                                if (_selectedValue != null) {
                                                  print(
                                                      "Selected Radio Value: $_selectedValue");
                                                  // You can also set this value to a Text widget
                                                  displayText = _selectedValue;
                                                }
                                              },
                                            ),
                                            SizedBox(width: 3), // Adjust the width to reduce the gap
                                            Text(
                                              "Full Day",
                                              style: AppTextStyle
                                                  .font10OpenSansRegularBlack45TextStyle, // Reduce font size
                                              overflow: TextOverflow
                                                  .ellipsis, // Handle overflow
                                              softWrap: false,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Radio<String>(
                                              value: "First Half",
                                              groupValue: _selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedValue = value!;
                                                });
                                                if (_selectedValue != null) {
                                                  print(
                                                      "Selected Radio Value: $_selectedValue");
                                                  // You can also set this value to a Text widget
                                                  displayText = _selectedValue;
                                                }
                                              },
                                            ),
                                            SizedBox(width: 3), // Adjust the width to reduce the gap
                                            Text(
                                              "First Half",
                                              style: AppTextStyle
                                                  .font10OpenSansRegularBlack45TextStyle, // Reduce font size
                                              overflow: TextOverflow
                                                  .ellipsis, // Handle overflow
                                              softWrap: false,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Radio<String>(
                                              value: "Second Half",
                                              groupValue: _selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedValue = value!;
                                                });
                                                if (_selectedValue != null) {
                                                  print("Selected Radio Value: $_selectedValue");
                                                  // You can also set this value to a Text widget
                                                  displayText = _selectedValue;
                                                }
                                              },
                                            ),
                                            SizedBox(width: 3), // Adjust the width to reduce the gap
                                            Text(
                                              "Second Half",
                                              style: AppTextStyle
                                                  .font10OpenSansRegularBlack45TextStyle, // Reduce font size
                                              overflow: TextOverflow
                                                  .ellipsis, // Handle overflow
                                              softWrap: false,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'You are going to apply for a leave of ', // Regular text
                                      style: AppTextStyle.font12OpenSansRegularBlackTextStyle, // Apply your existing text style here
                                    ),
                                    TextSpan(
                                      text: displayText, // Text you want in red
                                      style: AppTextStyle.font12OpenSansRegularBlackTextStyle.copyWith(
                                        color: Colors.red, // Set the displayText color to red
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // child: Text(
                              //     'You are going to apply for a leave of $displayText',
                              //     style: AppTextStyle
                              //         .font14OpenSansRegularBlack45TextStyle),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () async {
                                var reason = _reasonController.text.trim();
                                var address = _addressController.text.trim();

                                // Ensure form validation and non-empty fields
                                if (_formKey.currentState!.validate() && reason.isNotEmpty && address.isNotEmpty) {
                                  try {
                                    /// Call the API
                                    hrmsPopWarning = await HrmsLeaveApplicationRepo().hrmsleave(
                                      context,
                                      formDate,
                                      toDate,
                                      reason,
                                      address,
                                      _selectedValue,
                                      '${widget.sFirstName}',
                                      '${widget.sLvDesc}',
                                      '${widget.sLvTypeCode}',
                                    );

                                    if (hrmsPopWarning.isNotEmpty) {
                                      result = "${hrmsPopWarning[0]['Result']}";
                                      msg = "${hrmsPopWarning[0]['Msg']}";

                                      // Check if API result is successful
                                      if (result == '1') {
                                        print('-----result--811---$result');
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                              return _buildDialogSucces2(context,msg);
                                            },
                                            );
                                      //  _showSuccessDialog(context, msg);
                                      } else {
                                        print('-----result--814---$result');
                                        // _buildDialogFailed
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                              return _buildDialogFailed(context,msg);
                                            },
                                            );
                                        //_showErrorDialog(context, msg);
                                      }
                                    } else {
                                      displayToast('Unexpected API response');
                                    }
                                  } catch (e) {
                                    displayToast('Error during API call: ${e.toString()}');
                                  }
                                } else {
                                  // Validation failure
                                  if (reason.isEmpty) {
                                    displayToast('Please enter Reason');
                                  } else if (address.isEmpty) {
                                    displayToast('Please enter Address');
                                  }
                                }
                              },

                              child: Container(
                                width: double.infinity,
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
                                    "Apply",
                                    style: AppTextStyle
                                        .font14OpenSansRegularWhiteTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // dialogbox
  Widget _buildDialog(BuildContext context, String msg) {
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
            height: 205,
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
                  'Information',
                  style: AppTextStyle.font16OpenSansRegularBlackTextStyle,
                ),
                SizedBox(height: 10),
                Text(
                  msg,
                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white, // Set the background color to white
                    foregroundColor:
                        Colors.black, // Set the text color to black
                  ),
                  child: Text('OK',
                      style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                )
              ],
            ),
          ),
          Positioned(
            top: -40, // Position the image at the top center
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueAccent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/dialogimg.jpeg', // Replace with your asset image path
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
