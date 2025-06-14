import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/dashboard/dashboard.dart';
import '../../../app/generalFunction.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../../data/reimbursementStatusTakeAction.dart';
import '../../data/allLeaveStatusRepo.dart';
import '../../domain/allLeaveStatusModel.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';

class AllLeaveStatus extends StatelessWidget {
  const AllLeaveStatus({super.key});

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
      home: AllLeaveStatusPage(),
    );
  }
}

class AllLeaveStatusPage extends StatefulWidget {
  const AllLeaveStatusPage({super.key});

  @override
  State<AllLeaveStatusPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AllLeaveStatusPage> {

  List<Map<String, dynamic>>? reimbursementStatusList;

  // List<Map<String, dynamic>> _filteredData = [];
  ///List<dynamic>  hrmsReimbursementList;
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
  late Future<List<LeaveStatusModel>> reimbursementStatusV3;
  List<LeaveStatusModel> _allData = []; // Holds original data
  List<LeaveStatusModel> _filteredData = []; // Holds filtered data
  TextEditingController _takeActionController = TextEditingController();

  // Distic List
  hrmsReimbursementStatus(String firstOfMonthDay, String lastDayOfCurrentMonth) async {
    // reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay, lastDayOfCurrentMonth);

    reimbursementStatusV3 = HrmsAllLeaveStatusRepo()
        .allleaveStatusList(context, firstOfMonthDay, lastDayOfCurrentMonth);

    reimbursementStatusV3.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
    print(" -----xxxxx-  reimbursementStatusList--90-----> $reimbursementStatusList");
  }

  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData; // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sName
                  .toLowerCase()
                  .contains(query.toLowerCase()) || // Filter by project name
              item.sDesg.toLowerCase().contains(query.toLowerCase()) ||
              item.sLeaveStatus.toLowerCase().contains(query.toLowerCase());
          // Filter by employee name
        }).toList();
      }
    });
  }
  // postImage

  postimage() async {
    print('----ImageFile----$_imageFile');
    var postimageResponse =
        await PostImageRepo().postImage(context, _imageFile);
    print(" -----xxxxx-  --72---> $postimageResponse");
    setState(() {});
  }

  String? _chosenValue;

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  // focus
  // FocusNode locationfocus = FocusNode();
  FocusNode _shopfocus = FocusNode();
  FocusNode _owenerfocus = FocusNode();
  FocusNode _contactfocus = FocusNode();
  FocusNode _landMarkfocus = FocusNode();
  FocusNode _addressfocus = FocusNode();

  // FocusNode descriptionfocus = FocusNode();
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

  // Uplode Id Proof with gallary
  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------135----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // multifilepath
  // toast
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
  // void displayToast(String msg) {
  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.black,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  // image code
  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest('POST',
          Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));
      // Add headers
      request.headers['token'] = token;
      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();
      // Get the response
      var response = await http.Response.fromStream(streamedResponse);
      // Parse the response JSON
      var responseData = json.decode(response.body);
      // Print the response data
      print(responseData);
      hideLoader();
      print('---------172---$responseData');
      uplodedImage = "${responseData['Data'][0]['sImagePath']}";
      print('----174---$uplodedImage');
    } catch (error) {
      showLoader();
      print('Error uploading image: $error');
    }
  }

  multipartProdecudre() async {
    print('----139--$image');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token---$sToken');

    var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));
    request.body = json.encode({"sImagePath": "$image"});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    print('---155----$responseData');
  }

  // leave type
  final List<Color> colorList = [
    Color(0xFF4DB6AC),
    Color(0xFFE1A245),
    Color(0xFFC888D3),
    Color(0xFFE88989),
    Color(0xFFA6A869),
    Color(0xFF379BF3),
  ];

  // InitState
  @override
  void initState() {
    // TODO: implement initState
    //getLocation();
    // getCurrentdate();
    getACurrentDate();
    hrmsReimbursementStatus(formDate!, toDate!);
    super.initState();
    _shopfocus = FocusNode();
    _owenerfocus = FocusNode();
    _contactfocus = FocusNode();
    _landMarkfocus = FocusNode();
    _addressfocus = FocusNode();
  }

  // date logic

  getACurrentDate() {
    // DateTime now = DateTime.now();
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    formDate = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    print("------288--fromDate--$formDate");

    setState(() {
      //formDate = DateFormat('dd/MMM/yyyy').format(now);
    });
    //
    DateTime now2 = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    toDate = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);
    print("--------296----ToDate---$toDate");
    setState(() {
      //toDate = DateFormat('dd/MMM/yyyy').format(now2);
    });
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
      print('----------307----$toDate');
      displayToast("To Date can not be less than From Date");
    } else {
      hrmsReimbursementStatus(formDate!, toDate!);
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
      // calculateTotalDays();
      displayToast("From date can not be greater than To Date");
    } else {
      hrmsReimbursementStatus(formDate!, toDate!);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _shopfocus.dispose();
    _owenerfocus.dispose();
    _contactfocus.dispose();
    _landMarkfocus.dispose();
    _addressfocus.dispose();
    _searchController.dispose();
    FocusScope.of(context).unfocus();
  }
  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
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
                  'All Leave Status',
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
                  Container(
                    height: 45,
                    color: Color(0xFF2a697b),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 4),
                        Icon(Icons.calendar_month,
                            size: 15, color: Colors.white),
                        const SizedBox(width: 4),
                        const Text(
                          'From',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 4),

                        GestureDetector(
                          onTap: () async {
                            /// TODO Open Date picke and get a date
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
                                // calculateTotalDays();
                              });
                              fromDateSelectLogic();
                            }
                          },
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                            // Optional: Adjust padding for horizontal space
                            decoration: BoxDecoration(
                              color: Colors.white, // Change this to your preferred color
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '$formDate',
                                style: TextStyle(
                                  color: Colors.grey,
                                  // Change this to your preferred text color
                                  fontSize: 12.0, // Adjust font size as needed
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Container(
                          height: 32,
                          width: 32,
                          child: Image.asset(
                            "assets/images/reimicon_2.png",
                            fit: BoxFit.contain, // or BoxFit.cover depending on the desired effect
                          ),
                        ),
                        //Icon(Icons.arrow_back_ios,size: 16,color: Colors.white),
                        SizedBox(width: 8),
                        Icon(Icons.calendar_month, size: 16, color: Colors.white),
                        SizedBox(width: 5),
                        const Text(
                          'To',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
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
                                tempDate = toDate; // Save the current toDate before updating
                                toDate = formattedDate;
                                // calculateTotalDays();
                              });
                              toDateSelectLogic();
                            }
                          },
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                            // Optional: Adjust padding for horizontal space
                            decoration: BoxDecoration(
                              color: Colors.white, // Change this to your preferred color
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '$toDate',
                                style: TextStyle(
                                  color: Colors.grey,
                                  // Change this to your preferred text color
                                  fontSize: 12.0, // Adjust font size as needed
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                      child: FutureBuilder<List<LeaveStatusModel>>(
                          future: reimbursementStatusV3,
                          builder: (context, snapshot) {
                            return ListView.builder(
                                // itemCount: snapshot.data!.length ?? 0,
                                // itemBuilder: (context, index)
                                itemCount: _filteredData.length ?? 0,
                                itemBuilder: (context, index) {
                                  final leaveStatus = _filteredData[index];
                                  final randomColor = colorList[index % colorList.length];
                                  status = leaveStatus.sLeaveStatus;
                                  containerColor;
                                  if (status == "Sanctioned") {
                                    containerColor = Color(0xFF689F38);
                                  } else if (status == "Request For Cancellation") {
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
                                          color: Colors.grey, // Outline border color
                                          width: 0.2, // Outline border width
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 70, // 85% of the available space
                                                      child: Container(
                                                       // color: Colors.blue, // Example styling for visualization
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              onTap: () {
                                                                var images = leaveStatus
                                                                    .sImageLink;
                                                                var designation =
                                                                    leaveStatus.sDesg;
                                                                openFullScreenDialog(
                                                                    context,
                                                                    images,
                                                                    designation
                                                                    // 'https://your-image-url.com/image.jpg', // Replace with your image URL
                                                                    // 'Bill Date: 01-01-2024', // Replace with your bill date
                                                                    );
                                                              },
                                                              child: Center(
                                                                child: ClipOval(
                                                                  child: Container(
                                                                    child: leaveStatus.sImageLink != null && leaveStatus.sImageLink.isNotEmpty
                                                                        ? Image.network(
                                                                      leaveStatus.sImageLink,
                                                                      height: 35, // Adjust height as needed
                                                                      width: 35,  // Adjust width as needed
                                                                      fit: BoxFit.cover, // Make the image cover the container
                                                                    )
                                                                        : Text(
                                                                      'No image',
                                                                      style: TextStyle(fontSize: 16), // Optional: adjust text style as needed
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            // Wrap the column in Flexible to prevent overflow
                                                            Flexible(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    leaveStatus.sName,
                                                                    //'Prabhat Yadav',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle,
                                                                    maxLines: 2,
                                                                    // Limits the text to 2 lines
                                                                    overflow: TextOverflow
                                                                        .ellipsis, // Truncates with an ellipsis if too long
                                                                  ),
                                                                  // SizedBox(height: 4), // Add spacing between texts if needed
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                         right: 10),
                                                                    child: Text(
                                                                      leaveStatus.sDesg,
                                                                      //leaveData.sProjectName,
                                                                      style: AppTextStyle
                                                                          .font12OpenSansRegularBlack45TextStyle,
                                                                      maxLines: 2,
                                                                      // Limits the text to 2 lines
                                                                      overflow: TextOverflow.ellipsis, // Truncates with an ellipsis if too long
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 30, // 15% of the available space
                                                      child: Align(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(right: 5),
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4), // Padding for spacing inside the container
                                                            decoration: BoxDecoration(
                                                              color: Color(0xFFD3D3D3), // Light gray color
                                                              borderRadius: BorderRadius.circular(10), // Rounded corners on both sides
                                                            ),
                                                            child: Center( // Centers the text inside the container
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 10,right: 5),
                                                                child: Text(
                                                                  leaveStatus.sLeaveTypeStatus, // Example text
                                                                  style: TextStyle(
                                                                    color: Colors.black45,
                                                                    fontSize: 12,
                                                                  ),
                                                                  maxLines: null, // Allows the text to wrap to a second line if needed
                                                                  overflow: TextOverflow.visible, // Ensures text can wrap instead of being clipped
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )

                                              // child: Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.start,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.start,
                                              //   children: <Widget>[
                                              //     GestureDetector(
                                              //       onTap: () {
                                              //         var images = leaveStatus
                                              //             .sImageLink;
                                              //         var designation =
                                              //             leaveStatus.sDesg;
                                              //
                                              //         openFullScreenDialog(
                                              //             context,
                                              //             images,
                                              //             designation
                                              //             // 'https://your-image-url.com/image.jpg', // Replace with your image URL
                                              //             // 'Bill Date: 01-01-2024', // Replace with your bill date
                                              //             );
                                              //       },
                                              //       child: Center(
                                              //         child: ClipOval(
                                              //           child: Container(
                                              //             child: leaveStatus.sImageLink != null && leaveStatus.sImageLink.isNotEmpty
                                              //                 ? Image.network(
                                              //               leaveStatus.sImageLink,
                                              //               height: 35, // Adjust height as needed
                                              //               width: 35,  // Adjust width as needed
                                              //               fit: BoxFit.cover, // Make the image cover the container
                                              //             )
                                              //                 : Text(
                                              //               'No image',
                                              //               style: TextStyle(fontSize: 16), // Optional: adjust text style as needed
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //     SizedBox(width: 10),
                                              //     // Wrap the column in Flexible to prevent overflow
                                              //     Flexible(
                                              //       child: Column(
                                              //         crossAxisAlignment: CrossAxisAlignment.start,
                                              //         children: <Widget>[
                                              //           Text(
                                              //             leaveStatus.sName,
                                              //             //'Prabhat Yadav',
                                              //             style: AppTextStyle
                                              //                 .font12OpenSansRegularBlackTextStyle,
                                              //             maxLines: 2,
                                              //             // Limits the text to 2 lines
                                              //             overflow: TextOverflow
                                              //                 .ellipsis, // Truncates with an ellipsis if too long
                                              //           ),
                                              //           // SizedBox(height: 4), // Add spacing between texts if needed
                                              //           Padding(
                                              //             padding: const EdgeInsets
                                              //                 .only(
                                              //                  right: 10),
                                              //             child: Text(
                                              //               leaveStatus.sDesg,
                                              //               //leaveData.sProjectName,
                                              //               style: AppTextStyle
                                              //                   .font12OpenSansRegularBlack45TextStyle,
                                              //               maxLines: 2,
                                              //               // Limits the text to 2 lines
                                              //               overflow: TextOverflow.ellipsis, // Truncates with an ellipsis if too long
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //     Spacer(),
                                              //     Text("1 Day Leave",style: TextStyle(
                                              //         color: Colors.black45,
                                              //         fontSize: 12
                                              //     ),
                                              //     ),
                                              //   ],
                                              // ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.notes_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 5),
                                                Text('Leave Details',
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlackTextStyle),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 25),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Leave Status :',
                                                    style: GoogleFonts.openSans(
                                                      color: containerColor,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Flexible(
                                                    child: Text(
                                                      leaveStatus.sLeaveStatus,
                                                      style: GoogleFonts.openSans(
                                                        color: containerColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                  Spacer(), // Pushes the DottedBorder to the right side
                                                  Container(
                                                    alignment: Alignment.centerRight,
                                                    height: 25,
                                                    child: DottedBorder(
                                                      color: Colors.grey,
                                                      strokeWidth: 1.0,
                                                      dashPattern: [4, 2],
                                                      borderType: BorderType.RRect,
                                                      radius: Radius.circular(5.0),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(2.0),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                'Leave Type',
                                                                style: AppTextStyle.font8OpenSansRegularBlack45TextStyle,
                                                              ),
                                                              SizedBox(width: 2.0),
                                                              Text(
                                                                ' : ',
                                                                style: AppTextStyle.font8OpenSansRegularBlack45TextStyle,
                                                              ),
                                                              SizedBox(width: 2.0),
                                                              Text(
                                                                leaveStatus.sLeaveType,
                                                                style: AppTextStyle.font8OpenSansRegularBlackTextStyle,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 0),
                                              child: Container(
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200], // Background color
                                                    border: Border(
                                                      left: BorderSide(
                                                        color: randomColor,
                                                        // color: Colors.grey, // Left border color
                                                        width: 3.0, // Left border width
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.all(2.0),
                                                            child: Icon(
                                                                Icons
                                                                    .calendar_month,
                                                                size: 16),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'Applied At',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlack45TextStyle),
                                                                Text(
                                                                    leaveStatus
                                                                        .dLeaveAt,
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Icon(
                                                                Icons
                                                                    .calendar_month,
                                                                size: 16),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 5),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'Applied for',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlack45TextStyle),
                                                                //sLeaveApplyFor
                                                                Text(
                                                                    leaveStatus
                                                                        .sLeaveApplyFor,
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ),
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

  // take a action Dialog
  Widget _takeActionDialog(BuildContext context) {
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
                  'Remove Reimbursement',
                  style: AppTextStyle.font16OpenSansRegularRedTextStyle,
                ),
                SizedBox(height: 10),
                // TextFormField for entering data

                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: TextFormField(
                    controller: _takeAction,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      filled: true, // Enable background color
                      fillColor: Color(
                          0xFFf2f3f5), // Set your desired background color here
                    ),
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

                // Submit button
                InkWell(
                  onTap: () async {
                    var takeAction = _takeAction.text.trim();
                    print('-----1102--$takeAction');
                    print(sTranCode);

                    // Check if the input is not empty
                    if (takeAction != null && takeAction != '') {
                      print('---Call Api-----');

                      // Make API call here
                      var loginMap = await Reimbursementstatustakeaction()
                          .reimbursementTakeAction(context, sTranCode);

                      print('---418----$loginMap');

                      setState(() {
                        result = "${loginMap[0]['Result']}";
                        msg = "${loginMap[0]['Msg']}";
                      });

                      print('---1114----$result');
                      print('---1115----$msg');

                      // Check the result of the API call
                      if (result == "1") {
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
                      } else if (result == "0") {
                        // Keep the dialog open and show an error message (if needed)
                        // You can display an error message in the same dialog without dismissing it
                        displayToast(
                            msg); // Optionally, show a toast message to indicate failure

                        // Optionally clear the input field if needed
                        // _takeAction.clear();  // Do not clear to allow retrying
                      }
                    } else {
                      // Handle the case where no input is provided
                      displayToast("Enter remarks");
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
                        "Submit",
                        style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                      ),
                    ),
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
                        hrmsReimbursementStatus(
                            firstOfMonthDay!, lastDayOfCurrentMonth!);
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
