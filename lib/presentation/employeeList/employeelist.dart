import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:untitled/presentation/dashboard/dashboard.dart';
import '../../../app/generalFunction.dart';
import '../../../data/postimagerepo.dart';
import '../../data/stafListRepo.dart';
import '../../domain/employeeListModel.dart';
import '../resources/app_text_style.dart';


class EmployeeList extends StatelessWidget {

  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: EmployeelistPage(),
    );
  }
}

class EmployeelistPage extends StatefulWidget {

  const EmployeelistPage({super.key});

  @override
  State<EmployeelistPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmployeelistPage> {

  List<Map<String, dynamic>>? reimbursementStatusList;

  TextEditingController _searchController = TextEditingController();
  double? lat;
  double? long;
  GeneralFunction generalfunction = GeneralFunction();

  DateTime? _date;

  List stateList = [];
  List hrmsReimbursementList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  late Future<List<EmployeeListModel>> reimbursementStatusV3;
  List<EmployeeListModel> _allData = []; // Holds original data
  List<EmployeeListModel> _filteredData = []; // Holds filtered data

  // Distic List
  hrmsReimbursementStatus() async {
     reimbursementStatusV3 = StaffListRepo().staffList(context);

     reimbursementStatusV3.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
  }
  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData; // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sEmpName
              .toLowerCase()
              .contains(query.toLowerCase()) || // Filter by project name
              item.sDsgName.toLowerCase().contains(query.toLowerCase()) ||
              item.sContactNo.toLowerCase().contains(query.toLowerCase());
          // Filter by employee name
        }).toList();
      }
    });
  }
  // postImage

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();
  String? todayDate;

  List? data;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final sectorFocus = GlobalKey();
  File? _imageFile;
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  String? firstOfMonthDay;
  String? lastDayOfCurrentMonth;
  var fromPicker;
  var toPicker;
  var sTranCode;
  Color? containerColor;
  String? status;
  String? tempDate;
  String? formDate;
  String? toDate;

  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  // InitState
  @override
  void initState() {
    hrmsReimbursementStatus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
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
                  'Employee List',
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

            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 15, right: 15, top: 10),
                      // child: SearchBar(),
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.grey, // Outline border color
                            width: 0.2, // Outline border width
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _searchController,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Keywords',
                                      prefixIcon: Icon(Icons.search),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (query) {
                                      filterData(
                                          query); // Call the filter function on text input change
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Expanded(
                    child: Container(
                      child: FutureBuilder<List<EmployeeListModel>>(
                          future: reimbursementStatusV3,
                          builder: (context, snapshot) {
                            return ListView.builder(
                                itemCount: _filteredData.length ?? 0,
                                itemBuilder: (context, index) {
                                  final leaveStatus = _filteredData[index];
                                  final randomColor =
                                 // colorList[index % colorList.length];
                                  status = leaveStatus.sEmpName;
                                  containerColor;
                                  if (status == "Sanctioned") {
                                    containerColor = Color(0xFF689F38);
                                  } else if (status ==
                                      "Request For Cancellation") {
                                    containerColor = Colors.redAccent;
                                  } else {
                                    containerColor = Color(0xFFFFD700);
                                  }
                                  return Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0.0),
                                        border: Border.all(
                                          color:
                                          Colors.grey, // Outline border color
                                          width: 0.2, // Outline border width
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 8, top: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      var images =
                                                          leaveStatus.sEmpImage;
                                                      var designation =
                                                          leaveStatus.sDsgName;

                                                      openFullScreenDialog(
                                                          context,
                                                          images,
                                                          designation
                                                          );
                                                    },
                                                    child: Center(
                                                      child: ClipOval(
                                                        // Clip the image to make it circular
                                                        child: Container(
                                                          child: leaveStatus.sEmpImage != null && leaveStatus.sEmpImage.isNotEmpty
                                                              ? Image.network(
                                                            leaveStatus.sEmpImage, // Replace with your image URL
                                                            height: 35, // Adjust height as needed
                                                            width: 35, // Adjust width as needed
                                                            fit: BoxFit.cover, // Make the image cover the container
                                                          )
                                                              : const Center(
                                                            child: Text(
                                                              'No image', // Display this text if the image is null
                                                              style: TextStyle(
                                                                fontSize: 12, // Adjust font size as needed
                                                                color: Colors.grey, // Optional: Customize the text color
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  // Wrap the column in Flexible to prevent overflow
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          leaveStatus.sEmpName,
                                                          //'Prabhat Yadav',
                                                          style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                                          maxLines: 2,      // Limits the text to 2 lines
                                                          overflow: TextOverflow.ellipsis, // Truncates with an ellipsis if too long
                                                        ),
                                                        // SizedBox(height: 4), // Add spacing between texts if needed
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 10),
                                                          child: Text(
                                                            leaveStatus.sDsgName,
                                                            //leaveData.sProjectName,
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlack45TextStyle,
                                                            maxLines:
                                                            2, // Limits the text to 2 lines
                                                            overflow: TextOverflow
                                                                .ellipsis, // Truncates with an ellipsis if too long
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.end,
                                             children: [
                                               Container(
                                                 padding: EdgeInsets.all(4),
                                                 decoration: BoxDecoration(
                                                   color: Colors.white, // Background color
                                                   border: Border.all(
                                                     color: Color(0xFF0098a6), // Border color
                                                     width: 2, // Border width
                                                   ),
                                                   borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                                                 ),
                                                 child: Center(
                                                   child: Text(
                                                     'Mobile No: ${leaveStatus.sContactNo}',
                                                     style: TextStyle(fontSize: 16),
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(width: 5),
                                               Container(
                                                 height: 30,
                                                 child: ElevatedButton(
                                                     onPressed: (){
                                                      /// todo to show dialog box
                                                       ///
                                                       var sEmpName = "${leaveStatus.sEmpName}";
                                                       var sContactNo = "${leaveStatus.sContactNo}";

                                                       showDialog(
                                                           context: context,
                                                           builder: (BuildContext context)
                                                       {
                                                         return generalfunction.buildDialogCall(context,sEmpName,sContactNo);
                                                       });
                                                       },
                                                     style: ElevatedButton.styleFrom(
                                                       backgroundColor: Color(0xFF0098a6), // Button background color
                                                       shape: RoundedRectangleBorder(
                                                         borderRadius: BorderRadius.circular(17), // Border radius
                                                       ),
                                                     ),
                                                     child: Text('Call', style: AppTextStyle
                                                         .font16OpenSansRegularWhiteTextStyle,
                                                     )),
                                               ),

                                             ],
                                           ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),
                  ),
                ])),
      ),
    );
  }

  // Opend Full Screen DialogbOX
  void openFullScreenDialog(
      BuildContext context, String imageUrl, String billDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Makes the dialog full screen
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: [
              // Fullscreen Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Adjust the image to fill the dialog
                ),
              ),

              // White container with Bill Date at the bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          billDate,
                          style:
                          AppTextStyle.font12OpenSansRegularBlackTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Close button in the bottom-right corner
              Positioned(
                right: 16,
                bottom: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    padding: EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
