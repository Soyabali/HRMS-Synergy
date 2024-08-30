import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/hrmsleaveapplication.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';
import 'applyLeave.dart';
import 'package:intl/intl.dart';



class ApplyLeaveSubmitFormHome extends StatefulWidget {

  final sLvDesc,sFirstName,sLvTypeCode;
  const ApplyLeaveSubmitFormHome(this.sLvDesc, this.sFirstName, this.sLvTypeCode, {super.key});

  @override
  State<ApplyLeaveSubmitFormHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ApplyLeaveSubmitFormHome> {

  String _selectedValue = "Full Day";

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

  // focus
  // FocusNode locationfocus = FocusNode();
  FocusNode _reasonfocus = FocusNode();
  FocusNode _addressfocus = FocusNode();

  // FocusNode descriptionfocus = FocusNode();
  String? todayDate;

  List? data;
  var _dropDownValue;
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
  String? sFirstName;
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

  @override
  void initState() {
    // TODO: implement initState
    getACurrentDate();
    super.initState();
     _reasonfocus = FocusNode();
    _addressfocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     _reasonfocus.dispose();
    _addressfocus.dispose();
    _reasonController.dispose();
    _addressController.dispose();
  }

  getACurrentDate(){
    DateTime now = DateTime.now();
    formDate = DateFormat('dd/MMM/yyyy').format(now);
    //
    DateTime now2 = DateTime.now();
    toDate = DateFormat('dd/MMM/yyyy').format(now2);
  }

    toDateSelectLogic(){
      DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
      // Parse the date strings to DateTime objects
      DateTime? fromDate2 = dateFormat.parse(formDate!);
      DateTime? toDate2 = dateFormat.parse(toDate!);
      if (toDate2.isAfter(fromDate2)) {
        print('toDate is greater than fromDate');
        // Perform your action here
      } else if (toDate2.isBefore(fromDate2)) {
        /// TODO GIVE A NOTIFICATION
        print('toDate is less than fromDate');
        /// TODO HERE YOU SHOULD TAKE A CUTTERN DATE AGAIN
        DateTime currentDate = DateTime.now();
        String formattedDate = DateFormat('dd/MMM/yyyy').format(currentDate);
        setState(() {
          toDate = formattedDate;
        });
        displayToast("ToDate can not be less than FromDate");

      } else {
        print('toDate can not be less than fromDate');
      }
    }
    fromDateSelectLogic(){
    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    // Parse the date strings to DateTime objects
    DateTime? fromDate2 = dateFormat.parse(formDate!);
    DateTime? toDate2 = dateFormat.parse(toDate!);
    if (fromDate2.isAfter(toDate2)) {
      print('FromDate is greater than to Date');

      DateTime currentDate = DateTime.now();
      String formattedDate = DateFormat('dd/MMM/yyyy').format(currentDate);
      setState(() {
        formDate = formattedDate;
      });

      displayToast("FromDate can not be greater than Todate");
      // Perform your action here
    } else if (fromDate2.isBefore(toDate2)) {
      /// TODO GIVE A NOTIFICATION
      print('fromDate is less than toDate');
      /// TODO HERE YOU SHOULD TAKE A CUTTERN DATE AGAIN

    } else {
      print('FromDate can not be less than toDate');
    }
  }

  //
  void compareDates(String fromDate,String toDate) {
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
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Applyleave()),
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
                width: 200, // Width of the container
                child: Opacity(
                  opacity: 0.9,
                  //step3.jpg
                  child: Image.asset(
                    'assets/images/addreimbursement.jpeg',
                    // Replace 'image_name.png' with your asset image path
                    fit: BoxFit
                        .cover, // Adjust the image fit to cover the container
                  ),
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
                          children: <Widget>[
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // 'assets/images/favicon.png',
                                Container(
                                    margin: const EdgeInsets.only(left: 0, right: 10, top: 10),
                                    child: const Icon(
                                      Icons.person,
                                      size: 24,
                                      color: Color(0xFF0098a6),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('${widget.sFirstName}',
                                      style: AppTextStyle
                                          .font16OpenSansRegularBlack45TextStyle),
                                ),
                                Spacer(),
                                Text('${widget.sLvDesc}',
                                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle)
                              ],
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                // Check if a date was picked
                                if (pickedDate != null) {
                                  // Format the picked date
                                  String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                  // Update the state with the picked date
                                  setState(() {
                                    formDate = formattedDate;
                                  });
                                  print('-----262---$formDate');
                                  fromDateSelectLogic();
                                  // Display the selected date as a toast
                                  //displayToast(dExpDate.toString());
                                } else {
                                  // Handle case where no date was selected
                                  //displayToast("No date selected");
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between widgets
                                children: [
                                  // First widget: Text widget
                                  Text('From Date :',
                                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                  // Second widget: Container with light gray background
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding inside the Container
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD3D3D3), // Light gray background color
                                      borderRadius: BorderRadius.circular(8), // Rounded corners
                                    ),
                                    child: Row(
                                      children: [
                                        // First widget inside the Container: Icon
                                        const Icon(
                                          Icons.calendar_month, // Example icon
                                          color: Color(0xFF0098a6), // Icon color
                                        ),
                                        SizedBox(width: 8), // Spacing between Icon and Text
                                        // Second widget inside the Container: Text widget
                                        Text('$formDate', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: ()async{
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                // Check if a date was picked
                                if (pickedDate != null) {
                                  // Format the picked date
                                  String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);

                                  setState(() {
                                    toDate = formattedDate;
                                  });
                                  print('---316----$toDate');
                                  /// TODO HERE YOU SHOULD COMPARE DATE AND APPLY LOGIC
                                  toDateSelectLogic();

                                } else {
                                  // Handle case where no date was selected
                                  //displayToast("No date selected");
                                }
                                // compare the date

                                },

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between widgets
                                children: [
                                  // First widget: Text widget
                                  Text(
                                    'To Date :',
                                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle
                                  ),
                                  // Second widget: Container with light gray background
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding inside the Container
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD3D3D3), // Light gray background color
                                      borderRadius: BorderRadius.circular(8), // Rounded corners
                                    ),
                                    child: Row(
                                      children: [
                                        // First widget inside the Container: Icon
                                        const Icon(
                                          Icons.calendar_month, // Example icon
                                          color: Color(0xFF0098a6), // Icon color
                                        ),
                                        SizedBox(width: 8), // Spacing between Icon and Text

                                        // Second widget inside the Container: Text widget
                                        Text(
                                          '$toDate',
                                            style: AppTextStyle.font14OpenSansRegularBlack45TextStyle
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 55,
                              child: Row(
                                children: [
                                  // First widget: Text widget with fixed width
                                  Flexible(
                                    flex: 2, // Adjust the flex value as per your design
                                    child: Text(
                                      'Reason :',
                                      style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                      overflow: TextOverflow.ellipsis, // Add ellipsis if the text is too long
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  // Second widget: Container with the TextFormField
                                  Flexible(
                                    flex: 9, // Adjust the flex value as per your design
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                                      ),
                                      child: TextFormField(
                                        focusNode: _reasonfocus,
                                        controller: _reasonController,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          filled: true, // Enable background color
                                          fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                        ),
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        maxLines: null, // Allows the TextFormField to grow vertically
                                        minLines: 1, // Ensures the field starts with a single line
                                        keyboardType: TextInputType.multiline, // Enables multi-line input
                                        showCursor: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 15),
                            Container(
                              height: 55,
                              child: Row(
                                children: [
                                  // First widget: Text widget with fixed width
                                  Flexible(
                                    flex: 2, // Adjust the flex value as per your design
                                    child: Text(
                                      'Address:',
                                      style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                      overflow: TextOverflow.ellipsis, // Add ellipsis if the text is too long
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  // Second widget: Container with the TextFormField
                                  Flexible(
                                    flex: 9, // Adjust the flex value as per your design
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                                      ),
                                      child: TextFormField(
                                        focusNode: _addressfocus,
                                        controller: _addressController,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          filled: true, // Enable background color
                                          fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                        ),
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        maxLines: null, // Allows the TextFormField to grow vertically
                                        minLines: 1, // Ensures the field starts with a single line
                                        keyboardType: TextInputType.multiline, // Enables multi-line input
                                        showCursor: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   height: 55,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between widgets
                            //     children: [
                            //       // First widget: Text widget
                            //       Text(
                            //         'Address:',
                            //       style: AppTextStyle.font14OpenSansRegularBlack45TextStyle
                            //       ),
                            //       SizedBox(width: 10),
                            //       // Second widget: Container with light gray background
                            //       Expanded(
                            //         child: Container(
                            //           //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding inside the Container
                            //           decoration: BoxDecoration(
                            //             color: Colors.white, // Light gray background color
                            //             borderRadius: BorderRadius.circular(8), // Rounded corners
                            //           ),
                            //           child: TextFormField(
                            //             focusNode: _owenerfocus,
                            //             controller: _expenseController,
                            //             // textInputAction: TextInputAction.next,
                            //             // onEditingComplete: () =>
                            //             //     FocusScope.of(context).nextFocus(),
                            //             decoration: const InputDecoration(
                            //               border: OutlineInputBorder(),
                            //               // contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            //               filled: true, // Enable background color
                            //               fillColor: Color(0xFFf2f3f5),// Set your desired background color here
                            //             ),
                            //             autovalidateMode:
                            //             AutovalidateMode.onUserInteraction,
                            //             maxLines: null, // Allows the TextFormField to grow vertically
                            //             minLines: 1, // Ensures the field starts with a single line
                            //             keyboardType: TextInputType.multiline, // Enables multi-line input
                            //             showCursor: false,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between widgets
                              children: [
                                // First widget: Text widget
                                Text(
                                  'Applied For :',
                                style: AppTextStyle.font14OpenSansRegularBlack45TextStyle
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Container(
                            height: 50,
                            color: Colors.grey[200], // Light gray color
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Radio<String>(
                                      value: "Full Day",
                                      groupValue: _selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value!;
                                        });
                                      },
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Full Day",
                                        style: AppTextStyle.font10OpenSansRegularBlack45TextStyle, // Reduce font size
                                        overflow: TextOverflow.ellipsis, // Handle overflow
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Radio<String>(
                                      value: "First Half",
                                      groupValue: _selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value!;
                                        });
                                      },
                                    ),
                                     Flexible(
                                      child: Text(
                                        "First Half",
                                        style: AppTextStyle.font10OpenSansRegularBlack45TextStyle, // Reduce font size
                                        overflow: TextOverflow.ellipsis, // Handle overflow
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Radio<String>(
                                      value: "Second Half",
                                      groupValue: _selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value!;
                                        });
                                      },
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Second Half",
                                        style: AppTextStyle.font10OpenSansRegularBlack45TextStyle, // Reduce font size
                                        overflow: TextOverflow.ellipsis, // Handle overflow
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                            SizedBox(height: 25),
                            Center(
                              child: Text('You are going to apply for a leave of 0 day',style: AppTextStyle
                                  .font14OpenSansRegularBlack45TextStyle),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () async {

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var sEmpCode = prefs.getString('sEmpCode');
                                  var reason = _reasonController.text;
                                  var address = _addressController.text;

                                  if(_formKey.currentState!.validate() && reason.isNotEmpty && address.isNotEmpty){
                                  // Call Api
                                  print('---call Api---');
                                      var hrmsPopWarning = await HrmsLeaveApplicationRepo()
                                          .hrmsleave(
                                          context,
                                          formDate,
                                          toDate,
                                          reason,
                                          address,
                                          _selectedValue,
                                          '${widget.sFirstName}',
                                          '${widget.sLvDesc}');

                                      print('---975--$hrmsPopWarning');
                                      msg = "${hrmsPopWarning[0]['Msg']}";
                                      displayToast(msg);

                                }else{
                                   print('---Api not call-----');
                                  if(reason.isEmpty || reason==null){
                                    displayToast('Please Enter Reason');
                                  }else if(address.isEmpty || address==null){
                                    displayToast('Please Enter Address');
                                  }else if(address==null) {
                                    displayToast('Please Address');
                                  }
                                } // condition to fetch a response form a api

                              },
                              child: Container(
                                width: double.infinity,
                                // Make container fill the width of its parent
                                height: AppSize.s45,
                                padding: EdgeInsets.all(AppPadding.p5),
                                decoration: BoxDecoration(
                                  color: AppColors.loginbutton,
                                  // Background color using HEX value
                                  borderRadius: BorderRadius.circular(AppMargin.m10), // Rounded corners
                                ),
                                //  #00b3c7
                                child: Center(
                                  child: Text(
                                    "Apply",
                                    style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
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

}
