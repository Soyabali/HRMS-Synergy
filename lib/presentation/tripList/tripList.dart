import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../data/hrmsTripDetailRepo.dart';
import '../../domain/tripDetailModel.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class TripList extends StatelessWidget {

  const TripList({super.key});

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
      home: TripListPage(),
    );
  }
}

class TripListPage extends StatefulWidget {

  const TripListPage({super.key});

  @override
  State<TripListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TripListPage> {

  List<Map<String, dynamic>>? reimbursementStatusList;

  DateTime? _date;
  List stateList = [];
  List hrmsReimbursementList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;
  late Future<List<TripDetailModel>> tripDetailModel;
  List<TripDetailModel> _allData = []; // Holds original data
  List<TripDetailModel> _filteredData = []; // Holds filtered data

  // Distic List
  hrmsTripList(String firstOfMonthDay, String lastDayOfCurrentMonth) async {
    tripDetailModel = HrmstripdetailRepo()
        .hrmsTripDetail(context, firstOfMonthDay, lastDayOfCurrentMonth);
    print('-----70---$tripDetailModel');

    tripDetailModel.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
  }

  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData; // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sDsgName
                  .toLowerCase()
                  .contains(query.toLowerCase()) || // Filter by project name
              item.dTripStart.toLowerCase().contains(query.toLowerCase()) ||
              item.sTripStartImage.toLowerCase().contains(query.toLowerCase());

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
  var sTripEndLocation;

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
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  // filter data

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

  getCurrentdate() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    firstOfMonthDay = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    // last day of the current month
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    lastDayOfCurrentMonth = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);
    setState(() {});
    if (firstDayOfNextMonth != null && lastDayOfCurrentMonth != null) {
      print('You should call api');
    } else {
      print('You should  not call api');
    }
  }

  // InitState
  @override
  void initState() {
    // TODO: implement initState
    getCurrentdate();
    hrmsTripList(firstOfMonthDay!, lastDayOfCurrentMonth!);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  // google lunche code
  Future<void> openGoogleMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

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
                  //Navigator.pop(context);
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
                  'Trip List',
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
                        Icon(Icons.calendar_month, size: 15, color: Colors.white),
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
                            // Check if a date was picked
                            if (pickedDate != null) {
                              // Format the picked date
                              String formattedDate =
                                  DateFormat('dd/MMM/yyyy').format(pickedDate);
                              // Update the state with the picked date
                              setState(() {
                                firstOfMonthDay = formattedDate;
                                // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                              });
                              hrmsTripList(
                                  firstOfMonthDay!, lastDayOfCurrentMonth!);
                              // reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                              print(
                                  '--FirstDayOfCurrentMonth----$firstOfMonthDay');
                              hrmsTripList(
                                  firstOfMonthDay!, lastDayOfCurrentMonth!);
                              print('---formPicker--$firstOfMonthDay');
                              // Call API
                              //hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                              // print('---formPicker--$firstOfMonthDay');

                              // Display the selected date as a toast
                              //displayToast(dExpDate.toString());
                            } else {
                              // Handle case where no date was selected
                              //displayToast("No date selected");
                            }
                          },
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    14.0), // Optional: Adjust padding for horizontal space
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Change this to your preferred color
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '$firstOfMonthDay',
                                style: TextStyle(
                                  color: Colors
                                      .grey, // Change this to your preferred text color
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
                            fit: BoxFit
                                .contain, // or BoxFit.cover depending on the desired effect
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
                            // Check if a date was picked
                            if (pickedDate != null) {
                              // Format the picked date
                              String formattedDate =
                                  DateFormat('dd/MMM/yyyy').format(pickedDate);
                              // Update the state with the picked date
                              setState(() {
                                lastDayOfCurrentMonth = formattedDate;
                                // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                              });
                              hrmsTripList(
                                  firstOfMonthDay!, lastDayOfCurrentMonth!);
                              //reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                              print(
                                  '--LastDayOfCurrentMonth----$lastDayOfCurrentMonth');
                            } else {}
                          },
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    14.0), // Optional: Adjust padding for horizontal space
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Change this to your preferred color
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '$lastDayOfCurrentMonth',
                                style: TextStyle(
                                  color: Colors
                                      .grey, // Change this to your preferred text color
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
                  // ui part
                  /// todo this is a start journey ui
                  Expanded(
                    child: Container(
                        child: FutureBuilder<List<TripDetailModel>>(
                            future: tripDetailModel,
                            builder: (context, snapshot) {
                              return ListView.builder(
                                  // itemCount: snapshot.data!.length ?? 0,
                                  // itemBuilder: (context, index)
                                  itemCount: _filteredData.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final tripDetailData = _filteredData[index];
                                    sTripEndLocation = tripDetailData.sTripEndLocation;

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: Card(
                                        elevation: 1,
                                        color: Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                              color: Colors.grey, // Outline border color
                                              width: 0.2, // Outline border width
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, bottom: 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 32,
                                                      width: 32,
                                                      child: Image.asset(
                                                        "assets/images/triplist_1.jpeg",
                                                        fit: BoxFit
                                                            .contain, // or BoxFit.cover depending on the desired effect
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          tripDetailData.sEmpName,
                                                          // item['sExpHeadName'] ?? '',
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle,
                                                          maxLines:
                                                              2, // Limits the text to 2 lines
                                                          overflow: TextOverflow
                                                              .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                          softWrap: true,
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          tripDetailData.sDsgName,
                                                          // item['sExpHeadName'] ?? '',
                                                          style: AppTextStyle
                                                              .font10OpenSansRegularBlackTextStyle,
                                                          maxLines:
                                                              2, // Limits the text to 2 lines
                                                          overflow: TextOverflow
                                                              .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                          softWrap: true,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                // const SizedBox(height: 5),
                                                // Padding(
                                                //   padding: const EdgeInsets.only(
                                                //       left: 15, right: 15),
                                                //   child: Container(
                                                //     height: 0.5,
                                                //     color: Color(0xff3f617d),
                                                //   ),
                                                // ),
                                                SizedBox(height: 5),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.notes_outlined,
                                                            size: 16,
                                                            color:
                                                                Color(0xFF0098a6),
                                                          ))),
                                                      SizedBox(width: 10),
                                                      Flexible(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              'Start Location',
                                                              // item['sExpHeadName'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlackTextStyle,
                                                              maxLines:
                                                                  2, // Limits the text to 2 lines
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                              softWrap: true,
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    2), // sRemarks
                                                            Text(
                                                              tripDetailData
                                                                  .sStartLocation,
                                                              // item['sExpHeadName'] ?? '',
                                                              style: AppTextStyle
                                                                  .font10OpenSansRegularBlackTextStyle,
                                                              maxLines:
                                                                  2, // Limits the text to 2 lines
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                              softWrap: true,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Container(
                                                  height: 25,
                                                  color: Colors.white,
                                                  // color: Colors.grey[300], // Light gray background
                                                  padding: EdgeInsets.symmetric(
                                                   horizontal: 10), // Padding to give space for the content
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end, // Align text and icon at the ends
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          print(
                                                              '---Open location ON Google map---');
                                                          var fTripStartLat =
                                                              tripDetailData
                                                                  .fTripStartLat;
                                                          var fTripStartLon =
                                                              tripDetailData
                                                                  .fTripStartLon;
                                                          double lat = double.parse(
                                                              '${tripDetailData.fTripStartLat}');
                                                          double long = double.parse(
                                                              '${tripDetailData.fTripStartLon}');
                                                          print(
                                                              '---614---$fTripStartLat');
                                                          print(
                                                              '---615---$fTripStartLon');

                                                          // openGoogleMap(28.6019931,77.3561923);
                                                          openGoogleMap(
                                                              lat, long);
                                                        },
                                                        child: Container(
                                                          child: Image.asset(
                                                            'assets/images/map.jpeg',
                                                            height: 25,
                                                            width: 25,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Container(
                                                          height: 25,
                                                          width: 180,
                                                          color: Colors.red,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              const Padding(
                                                                padding:
                                                                    EdgeInsets.only(left: 10),
                                                                child: Text(
                                                                  'Dur :',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                    FontWeight.normal,
                                                                    fontFamily: 'Montserrat',
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                        left: 5,right: 5),
                                                                child: Text(
                                                                  "${tripDetailData.sDuration} HH:MM" ??
                                                                      "0",
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                  ),
                                                                     overflow: TextOverflow.ellipsis,
                                                                  softWrap: false,

                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      SizedBox(width: 10),
                                                      GestureDetector(
                                                        onTap: () {
                                                          print('-----667---');
                                                          var images =
                                                              tripDetailData
                                                                  .sTripStartImage;
                                                          var dTripsStart =
                                                              tripDetailData
                                                                  .dTripStart;
                                                          var tripstrat =
                                                              'TripStart : $dTripsStart';

                                                          openFullScreenDialog(
                                                              context,
                                                              images,
                                                              tripstrat);
                                                        },
                                                        child: Container(
                                                          child: Image.asset(
                                                            'assets/images/triplistphoto.jpeg',
                                                            height: 25,
                                                            width: 25,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 5),

                                                /// todo visible and invisible part
                                                Visibility(
                                                  visible: sTripEndLocation == "",
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        // color: Colors.grey[300], // Light gray background
                                                        // padding: EdgeInsets.symmetric(horizontal: 10),
                                                        // Padding to give space for the content
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .white, // Background color of the container
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10), // Rounded corners (optional)
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey, // Outline (border) color
                                                            width:
                                                                1.0, // Border width
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween, // Align text and icon at the ends
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Trip Start At',
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                  Text(
                                                                    tripDetailData
                                                                        .dTripStart,
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlack45TextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const VerticalDivider(
                                                              color: Colors
                                                                  .grey, // Color of the divider
                                                              thickness:
                                                                  1, // Thickness of the line
                                                              width:
                                                                  20, // Space around the divider
                                                              indent:
                                                                  10, // Top spacing of the divider
                                                              endIndent:
                                                                  10, // Bottom spacing of the divider
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Trip End At',
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                  Text(
                                                                    tripDetailData
                                                                        .dTripEnd,
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlack45TextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Container(
                                                        height:
                                                            170, // Height of the container
                                                        padding: EdgeInsets.all(
                                                            16), // Padding around the container
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround, // Space around columns
                                                          children: [
                                                            // First Column
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                // Circular Network Image
                                                                ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    '${tripDetailData.sTripStartImage}', // Replace with your image URL
                                                                    width:
                                                                        110, // Width of the circular image
                                                                    height:
                                                                        110, // Height of the circular image
                                                                    fit: BoxFit
                                                                        .cover, // Ensures the image fits the circle
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 10), // Spacing between the image and text
                                                                // TextView
                                                                Text(
                                                                  'Start Odometer',
                                                                  style: AppTextStyle
                                                                      .font12OpenSansRegularBlackTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                            // Second Column
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                /// todo visible and invisible part
                                                Visibility(
                                                  visible: sTripEndLocation != "",
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 25,
                                                        color: Colors.grey[
                                                            300], // Light gray background
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal:
                                                                10), // Padding to give space for the content
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween, // Align text and icon at the ends
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .av_timer_sharp,
                                                                    size: 25),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  'Start Odo :',
                                                                  // item['sExpHeadName'] ?? '',
                                                                  style: AppTextStyle
                                                                      .font10OpenSansRegularBlackTextStyle,
                                                                  maxLines:
                                                                      2, // Limits the text to 2 lines
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                  softWrap: true,
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  // tripDetailData.fStartOdometers,
                                                                  "${tripDetailData.fStartOdometers} KM",
                                                                  // item['sExpHeadName'] ?? '',
                                                                  style: AppTextStyle
                                                                      .font10OpenSansRegularBlackTextStyle,
                                                                  maxLines:
                                                                      2, // Limits the text to 2 lines
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                  softWrap: true,
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .av_timer_sharp,
                                                                    size: 25),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  'End Odo :',
                                                                  // item['sExpHeadName'] ?? '',
                                                                  style: AppTextStyle
                                                                      .font10OpenSansRegularBlackTextStyle,
                                                                  maxLines:
                                                                      2, // Limits the text to 2 lines
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                  softWrap: true,
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  "${tripDetailData.fEndOdometers} KM",
                                                                  // tripDetailData.fEndOdometers,
                                                                  // item['sExpHeadName'] ?? '',
                                                                  style: AppTextStyle
                                                                      .font10OpenSansRegularBlackTextStyle,
                                                                  maxLines:
                                                                      2, // Limits the text to 2 lines
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                  softWrap: true,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                                width: 20.0,
                                                                height: 20.0,
                                                                child: Center(
                                                                    child: Icon(
                                                                  Icons
                                                                      .notes_outlined,
                                                                  size: 16,
                                                                  color: Color(
                                                                      0xFF0098a6),
                                                                ))),
                                                            SizedBox(width: 10),
                                                            Flexible(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    'End Location',
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          2), // sRemarks
                                                                  Text(
                                                                    tripDetailData
                                                                        .sTripEndLocation,
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font10OpenSansRegularBlackTextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      // here you apply complete distace
                                                      Container(
                                                        height: 25,
                                                        color: Colors.white,
                                                        // color: Colors.grey[300], // Light gray background
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal:
                                                                10), // Padding to give space for the content
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end, // Align text and icon at the ends
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                /// todo open google route
                                                                ///   print('---Open location ON Google map---');
                                                                var fTripStartLat =
                                                                    tripDetailData
                                                                        .fTripStartLat;
                                                                var fTripStartLon =
                                                                    tripDetailData
                                                                        .fTripStartLon;
                                                                double lat =
                                                                    double.parse(
                                                                        '${tripDetailData.fTripStartLat}');
                                                                double long =
                                                                    double.parse(
                                                                        '${tripDetailData.fTripStartLon}');
                                                                print(
                                                                    '---614---$fTripStartLat');
                                                                print(
                                                                    '---615---$fTripStartLon');

                                                                // openGoogleMap(28.6019931,77.3561923);
                                                                openGoogleMap(
                                                                    lat, long);
                                                              },
                                                              child: Container(
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/map.jpeg',
                                                                  height: 25,
                                                                  width: 25,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Container(
                                                              height: 25,
                                                              width: 180,
                                                              color: Color(
                                                                  0xFF0098a6),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left: 10),
                                                                    child: Text(
                                                                      'Dur :',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left: 5,right: 5),
                                                                          //  ${tripDetailData.sDuration} HH:MM" ??
                                                                    child: Text(
                                                                      "${tripDetailData.fDistance} Km" ??
                                                                          "0",
                                                                      // tripDetailData.sDuration,
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    '-----1099---');

                                                                var images =
                                                                    tripDetailData
                                                                        .sTripEndImage;
                                                                var dTripsStart =
                                                                    tripDetailData
                                                                        .dTripEnd;
                                                                var tripEnd =
                                                                    'TripEnd : $dTripsStart';

                                                                openFullScreenDialog(
                                                                    context,
                                                                    images,
                                                                    tripEnd);
                                                              },
                                                              child: Container(
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/triplistphoto.jpeg',
                                                                  height: 25,
                                                                  width: 25,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),

                                                      Container(
                                                        height: 40,
                                                        // color: Colors.grey[300], // Light gray background
                                                        // padding: EdgeInsets.symmetric(horizontal: 10),
                                                        // Padding to give space for the content
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .white, // Background color of the container
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10), // Rounded corners (optional)
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey, // Outline (border) color
                                                            width:
                                                                1.0, // Border width
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween, // Align text and icon at the ends
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Trip Start At',
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                  Text(
                                                                    tripDetailData
                                                                        .dTripStart,
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlack45TextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            VerticalDivider(
                                                              color: Colors
                                                                  .grey, // Color of the divider
                                                              thickness:
                                                                  1, // Thickness of the line
                                                              width:
                                                                  20, // Space around the divider
                                                              indent:
                                                                  10, // Top spacing of the divider
                                                              endIndent:
                                                                  10, // Bottom spacing of the divider
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Trip End At',
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                  Text(
                                                                    tripDetailData
                                                                        .dTripEnd,
                                                                    // item['sExpHeadName'] ?? '',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlack45TextStyle,
                                                                    maxLines:
                                                                        2, // Limits the text to 2 lines
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Truncates the text with an ellipsis if it's too long
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Container(
                                                        height:
                                                            160, // Height of the container
                                                        padding: EdgeInsets.all(
                                                            16), // Padding around the container
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround, // Space around columns
                                                          children: [
                                                            // First Column
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                // Circular Network Image
                                                                ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    '${tripDetailData.sTripStartImage}', // Replace with your image URL
                                                                    width:
                                                                        100, // Width of the circular image
                                                                    height:
                                                                        100, // Height of the circular image
                                                                    fit: BoxFit
                                                                        .cover, // Ensures the image fits the circle
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        10), // Spacing between the image and text
                                                                // TextView
                                                                Text(
                                                                  'Start Odometer',
                                                                  style: AppTextStyle
                                                                      .font12OpenSansRegularBlackTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                            // Second Column
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                // Circular Network Image
                                                                ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    '${tripDetailData.sTripEndImage}', // Replace with your image URL
                                                                    width:
                                                                        100, // Width of the circular image
                                                                    height:
                                                                        100, // Height of the circular image
                                                                    fit: BoxFit
                                                                        .cover, // Ensures the image fits the circle
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        10), // Spacing between the image and text
                                                                // TextView
                                                                Text(
                                                                  'End Odometer',
                                                                  style: AppTextStyle
                                                                      .font12OpenSansRegularBlackTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }

                            /// todo in a future  uncomment this is a complete journey code

                            //        Padding(
                            //   padding: const EdgeInsets.only(left: 10, right: 10),
                            //   child: Card(
                            //     elevation: 1,
                            //     color: Colors.white,
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         border: Border.all(
                            //           color: Colors.grey, // Outline border color
                            //           width: 0.2, // Outline border width
                            //         ),
                            //       ),
                            //       child: Padding(
                            //         padding:
                            //         const EdgeInsets.only(left: 8, right: 8,bottom: 10),
                            //         child: Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Row(
                            //               mainAxisAlignment: MainAxisAlignment.start,
                            //               children: <Widget>[
                            //                 Container(
                            //                     width: 40.0,
                            //                     height: 40.0,
                            //                     decoration: BoxDecoration(
                            //                       borderRadius:
                            //                       BorderRadius.circular(15.0),
                            //                       border: Border.all(
                            //                         color: Color(0xFF255899),
                            //                         // Outline border color
                            //                         width:
                            //                         0.5, // Outline border width
                            //                       ),
                            //                       color: Colors.white,
                            //                     ),
                            //                     child: Center(
                            //                         child: Icon(Icons.account_box,size: 40,color: Color(0xFF0098a6),)
                            //                     )),
                            //                 SizedBox(width: 10),
                            //                 Column(
                            //                   mainAxisAlignment:
                            //                   MainAxisAlignment.start,
                            //                   crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //                   children: <Widget>[
                            //                     Text(
                            //                       'Jintendar Kumar Wadhawan',
                            //                       // item['sExpHeadName'] ?? '',
                            //                       style: AppTextStyle
                            //                           .font12OpenSansRegularBlackTextStyle,
                            //                       maxLines: 2, // Limits the text to 2 lines
                            //                       overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                       softWrap: true,
                            //                     ),
                            //                     SizedBox(height: 2),
                            //                     Text(
                            //                         'Deputy General Manager - Software Development',
                            //                         // item['sExpHeadName'] ?? '',
                            //                         style: AppTextStyle
                            //                             .font10OpenSansRegularBlackTextStyle,
                            //                         maxLines: 2, // Limits the text to 2 lines
                            //                         overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                         softWrap: true,
                            //                       ),
                            //                   ],
                            //                 )
                            //               ],
                            //             ),
                            //             const SizedBox(height: 10),
                            //             Padding(
                            //               padding: const EdgeInsets.only(
                            //                   left: 15, right: 15),
                            //               child: Container(
                            //                 height: 0.5,
                            //                 color: Color(0xff3f617d),
                            //               ),
                            //             ),
                            //             SizedBox(height: 5),
                            //             Padding(
                            //               padding: const EdgeInsets.only(top: 5),
                            //               child: Row(
                            //                 mainAxisAlignment:
                            //                 MainAxisAlignment.start,
                            //                 children: <Widget>[
                            //                   Container(
                            //                       width: 20.0,
                            //                       height: 20.0,
                            //                       child: Center(
                            //                           child: Icon(Icons.notes_outlined,size: 16,color: Color(0xFF0098a6),)
                            //                       )),
                            //                   SizedBox(width: 10),
                            //                   Flexible(
                            //                     child: Column(
                            //                       mainAxisAlignment:
                            //                       MainAxisAlignment.start,
                            //                       crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                       children: <Widget>[
                            //                         Text(
                            //                           'Start Location',
                            //                           // item['sExpHeadName'] ?? '',
                            //                           style: AppTextStyle
                            //                               .font12OpenSansRegularBlackTextStyle,
                            //                           maxLines: 2, // Limits the text to 2 lines
                            //                           overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                           softWrap: true,
                            //                         ),
                            //                         SizedBox(height: 2), // sRemarks
                            //                         Text(
                            //                           'A6, Bishanpura Rd, Block A,Sector 57, Noida, Uttar Pradesh 201301,India',
                            //                           // item['sExpHeadName'] ?? '',
                            //                           style: AppTextStyle
                            //                               .font10OpenSansRegularBlackTextStyle,
                            //                           maxLines: 2, // Limits the text to 2 lines
                            //                           overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                           softWrap: true,
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             SizedBox(height: 5),
                            //             Container(
                            //               height: 25,
                            //              color: Colors.white,
                            //              // color: Colors.grey[300], // Light gray background
                            //               padding: EdgeInsets.symmetric(horizontal: 10), // Padding to give space for the content
                            //               child: Row(
                            //                 mainAxisAlignment: MainAxisAlignment.end, // Align text and icon at the ends
                            //                 children: [
                            //                   Image.asset('assets/images/map.jpeg',
                            //                     height: 25,width: 25,
                            //                     fit: BoxFit.cover,
                            //                   ),
                            //                   SizedBox(width: 10),
                            //                   Container(
                            //                     height: 25,
                            //                     width: 150,
                            //                     color: Colors.red,
                            //                     child: const Row(
                            //                       mainAxisAlignment: MainAxisAlignment.start,
                            //                       children: [
                            //                         Padding(
                            //                           padding: EdgeInsets.only(left: 20),
                            //                           child: Text('Dur :',style: TextStyle(
                            //                             color: Colors.white,
                            //                             fontSize: 14,
                            //                             fontWeight: FontWeight.normal,
                            //                             fontFamily: 'Montserrat',
                            //                           ), ),
                            //                         ),
                            //                         Padding(
                            //                           padding: EdgeInsets.only(left: 10),
                            //                           child: Text('0 HH:MM',style: TextStyle(
                            //                             color: Colors.white,
                            //                             fontSize: 14,
                            //                             fontWeight: FontWeight.normal,
                            //                             fontFamily: 'Montserrat',
                            //                           ), ),
                            //                         ),
                            //
                            //                       ],
                            //                     ),
                            //                   ),
                            //                   SizedBox(width: 10),
                            //                   Image.asset('assets/images/camra.jpeg',
                            //                     height: 25,width: 25,
                            //                     fit: BoxFit.cover,
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             SizedBox(height: 5),
                            //             Container(
                            //               height: 25,
                            //               color: Colors.grey[300], // Light gray background
                            //               padding: EdgeInsets.symmetric(horizontal: 10), // Padding to give space for the content
                            //               child: Row(
                            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align text and icon at the ends
                            //                 children: [
                            //                   Row(
                            //                     mainAxisAlignment: MainAxisAlignment.start,
                            //                     children: [
                            //                       Icon(Icons.av_timer_sharp,size: 25),
                            //                       SizedBox(width: 10),
                            //                       Text(
                            //                         'Start Odo :',
                            //                         // item['sExpHeadName'] ?? '',
                            //                         style: AppTextStyle
                            //                             .font10OpenSansRegularBlackTextStyle,
                            //                         maxLines: 2, // Limits the text to 2 lines
                            //                         overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                         softWrap: true,
                            //                       ),
                            //                       SizedBox(width: 10),
                            //                       Text(
                            //                         '835 km',
                            //                         // item['sExpHeadName'] ?? '',
                            //                         style: AppTextStyle
                            //                             .font10OpenSansRegularBlackTextStyle,
                            //                         maxLines: 2, // Limits the text to 2 lines
                            //                         overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                         softWrap: true,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                   Spacer(),
                            //                   Row(
                            //                     mainAxisAlignment: MainAxisAlignment.start,
                            //                     children: [
                            //                       Icon(Icons.av_timer_sharp,size: 25),
                            //                       SizedBox(width: 10),
                            //                       Text(
                            //                         'End Odo :',
                            //                         // item['sExpHeadName'] ?? '',
                            //                         style: AppTextStyle
                            //                             .font10OpenSansRegularBlackTextStyle,
                            //                         maxLines: 2, // Limits the text to 2 lines
                            //                         overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                         softWrap: true,
                            //                       ),
                            //                       SizedBox(width: 10),
                            //                       Text(
                            //                         '6464 km',
                            //                         // item['sExpHeadName'] ?? '',
                            //                         style: AppTextStyle
                            //                             .font10OpenSansRegularBlackTextStyle,
                            //                         maxLines: 2, // Limits the text to 2 lines
                            //                         overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                         softWrap: true,
                            //                       ),
                            //
                            //                     ],
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             SizedBox(height: 5),
                            //             Padding(
                            //               padding: const EdgeInsets.only(top: 5),
                            //               child: Row(
                            //                 mainAxisAlignment:
                            //                 MainAxisAlignment.start,
                            //                 children: <Widget>[
                            //                   Container(
                            //                       width: 20.0,
                            //                       height: 20.0,
                            //                       child: Center(
                            //                           child: Icon(Icons.notes_outlined,size: 16,color: Color(0xFF0098a6),)
                            //                       )),
                            //                   SizedBox(width: 10),
                            //                   Flexible(
                            //                     child: Column(
                            //                       mainAxisAlignment:
                            //                       MainAxisAlignment.start,
                            //                       crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                       children: <Widget>[
                            //                         Text(
                            //                           'End Location',
                            //                           // item['sExpHeadName'] ?? '',
                            //                           style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                            //                           maxLines: 2, // Limits the text to 2 lines
                            //                           overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                           softWrap: true,
                            //                         ),
                            //                         SizedBox(height: 2), // sRemarks
                            //                         Text(
                            //                           'A6, Bishanpura Rd, Block A,Sector 57, Noida, Uttar Pradesh 201301,India',
                            //                           // item['sExpHeadName'] ?? '',
                            //                           style: AppTextStyle
                            //                               .font10OpenSansRegularBlackTextStyle,
                            //                           maxLines: 2, // Limits the text to 2 lines
                            //                           overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                           softWrap: true,
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             SizedBox(height: 15),
                            //             Container(
                            //               height: 25,
                            //               color: Colors.white,
                            //               // color: Colors.grey[300], // Light gray background
                            //               padding: EdgeInsets.symmetric(horizontal: 10), // Padding to give space for the content
                            //               child: Row(
                            //                 mainAxisAlignment: MainAxisAlignment.end, // Align text and icon at the ends
                            //                 children: [
                            //                   Image.asset('assets/images/map.jpeg',
                            //                     height: 25,width: 25,
                            //                     fit: BoxFit.cover,
                            //                   ),
                            //                   SizedBox(width: 10),
                            //                   Container(
                            //                     height: 25,
                            //                     width: 150,
                            //                     color: Color(0xFF0098a6),
                            //                     child: const Row(
                            //                       mainAxisAlignment: MainAxisAlignment.start,
                            //                       children: [
                            //                         Padding(
                            //                           padding: EdgeInsets.only(left: 20),
                            //                           child: Text('Dur :',style: TextStyle(
                            //                             color: Colors.white,
                            //                             fontSize: 14,
                            //                             fontWeight: FontWeight.normal,
                            //                             fontFamily: 'Montserrat',
                            //                           ), ),
                            //                         ),
                            //                         Padding(
                            //                           padding: EdgeInsets.only(left: 10),
                            //                           child: Text('5629 Km',style: TextStyle(
                            //                             color: Colors.white,
                            //                             fontSize: 14,
                            //                             fontWeight: FontWeight.normal,
                            //                             fontFamily: 'Montserrat',
                            //                           ), ),
                            //                         ),
                            //
                            //                       ],
                            //                     ),
                            //                   ),
                            //                   SizedBox(width: 10),
                            //                   Image.asset('assets/images/camra.jpeg',
                            //                     height: 25,width: 25,
                            //                     fit: BoxFit.cover,
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             SizedBox(height: 5),
                            //             Container(
                            //               height: 40,
                            //              // color: Colors.grey[300], // Light gray background
                            //              // padding: EdgeInsets.symmetric(horizontal: 10),
                            //               // Padding to give space for the content
                            //               decoration: BoxDecoration(
                            //                 color: Colors.white, // Background color of the container
                            //                 borderRadius: BorderRadius.circular(10), // Rounded corners (optional)
                            //                 border: Border.all(
                            //                   color: Colors.grey, // Outline (border) color
                            //                   width: 1.0, // Border width
                            //                 ),
                            //               ),
                            //               child: Row(
                            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align text and icon at the ends
                            //                 children: [
                            //                   Padding(
                            //                     padding: const EdgeInsets.only(left: 10),
                            //                     child: Column(
                            //                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //                     // crossAxisAlignment: CrossAxisAlignment.start,
                            //                      children: [
                            //                        Text(
                            //                          'Trip Start At',
                            //                          // item['sExpHeadName'] ?? '',
                            //                          style: AppTextStyle
                            //                              .font12OpenSansRegularBlackTextStyle,
                            //                          maxLines: 2, // Limits the text to 2 lines
                            //                          overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                          softWrap: true,
                            //                        ),
                            //                        Text(
                            //                          '09/Sep/2024 14:51',
                            //                          // item['sExpHeadName'] ?? '',
                            //                          style: AppTextStyle
                            //                              .font12OpenSansRegularBlack45TextStyle,
                            //                          maxLines: 2, // Limits the text to 2 lines
                            //                          overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                          softWrap: true,
                            //                        ),
                            //                      ],
                            //                                              ),
                            //                   ),
                            //                   VerticalDivider(
                            //                     color: Colors.grey, // Color of the divider
                            //                     thickness: 1,       // Thickness of the line
                            //                     width: 20,          // Space around the divider
                            //                     indent: 10,         // Top spacing of the divider
                            //                     endIndent: 10,      // Bottom spacing of the divider
                            //                   ),
                            //                   Padding(
                            //                     padding: const EdgeInsets.only(right: 10),
                            //                     child: Column(
                            //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //                      // crossAxisAlignment: CrossAxisAlignment.start,
                            //                       children: [
                            //                         Text(
                            //                           'Trip End At',
                            //                           // item['sExpHeadName'] ?? '',
                            //                           style: AppTextStyle
                            //                               .font12OpenSansRegularBlackTextStyle,
                            //                           maxLines: 2, // Limits the text to 2 lines
                            //                           overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                           softWrap: true,
                            //                         ),
                            //                         Text(
                            //                           '09/Sep/2024 16:21',
                            //                           // item['sExpHeadName'] ?? '',
                            //                           style: AppTextStyle
                            //                               .font12OpenSansRegularBlack45TextStyle,
                            //                           maxLines: 2, // Limits the text to 2 lines
                            //                           overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                            //                           softWrap: true,
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             SizedBox(height: 5),
                            //             Container(
                            //               height: 160, // Height of the container
                            //               padding: EdgeInsets.all(16), // Padding around the container
                            //               child: Row(
                            //                 mainAxisAlignment: MainAxisAlignment.spaceAround, // Space around columns
                            //                 children: [
                            //                   // First Column
                            //                   Column(
                            //                     mainAxisAlignment: MainAxisAlignment.center,
                            //                     children: [
                            //                       // Circular Network Image
                            //                       ClipOval(
                            //                         child: Image.network(
                            //                           'http://upegov.in/HrmsTestapis/TrackingImgs/090920240933343326.jpg', // Replace with your image URL
                            //                           width: 100, // Width of the circular image
                            //                           height: 100, // Height of the circular image
                            //                           fit: BoxFit.cover, // Ensures the image fits the circle
                            //                         ),
                            //                       ),
                            //                       SizedBox(height: 10), // Spacing between the image and text
                            //                       // TextView
                            //                       Text(
                            //                         'Start Odometer',
                            //                         style: AppTextStyle
                            //                             .font12OpenSansRegularBlackTextStyle,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                   // Second Column
                            //                   Column(
                            //                     mainAxisAlignment: MainAxisAlignment.center,
                            //                     children: [
                            //                       // Circular Network Image
                            //                       ClipOval(
                            //                         child: Image.network(
                            //                           'http://upegov.in/HrmsTestapis/TrackingImgs/090920240933343326.jpg', // Replace with your image URL
                            //                           width: 100, // Width of the circular image
                            //                           height: 100, // Height of the circular image
                            //                           fit: BoxFit.cover, // Ensures the image fits the circle
                            //                         ),
                            //                       ),
                            //                       SizedBox(height: 10), // Spacing between the image and text
                            //                       // TextView
                            //                       Text(
                            //                         'End Odometer',style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ],
                            //               ),
                            //             )
                            //
                            //
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )

                            )),
                  )
                ])),
      ),
    );
  }

  // open dialog mages
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
                      Text(billDate,
                          style:
                              AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
