import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/expensemanagement/reimbursementclarification/reimbursementRevert.dart';
import '../../../app/generalFunction.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../../data/reimbursementClarificationRepo.dart';
import '../../../domain/rimbursementclarificationmodel.dart';
import '../../resources/app_text_style.dart';
import '../expense_management.dart';

class ReimbursementClarification extends StatelessWidget {

  const ReimbursementClarification({super.key});

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
      home: ReimbursementClarificationPage(),
    );
  }
}

class ReimbursementClarificationPage extends StatefulWidget {

  const ReimbursementClarificationPage({super.key});

  @override
  State<ReimbursementClarificationPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ReimbursementClarificationPage> {

  List<Map<String, dynamic>>? reimbursementStatusList;

  TextEditingController _searchController = TextEditingController();
  double? lat;
  double? long;
  GeneralFunction generalfunction = GeneralFunction();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  DateTime? _date;
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _date = selectedDate;
      });
    }
    print('------67---${_date?.toLocal().toString()}'.split(' ')[0]);
  }

  List stateList = [];
  List hrmsReimbursementList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  late Future<List<HrmsReimbursementClarificationModel>> reimbursementStatusV3;
  List<HrmsReimbursementClarificationModel> _allData = [];  // Holds original data
  List<HrmsReimbursementClarificationModel> _filteredData = [];  // Holds filtered data

  // Distic List
  hrmsReimbursementStatus(String firstOfMonthDay,String lastDayOfCurrentMonth) async {
    reimbursementStatusV3 = HrmsreimbursementClarificationRepo().hrmsReimbursementClarificationList(context, firstOfMonthDay, lastDayOfCurrentMonth);
    print('-----91---$reimbursementStatusV3');

    reimbursementStatusV3.then((data) {
      setState(() {
        _allData = data;  // Store the data
        _filteredData = _allData;  // Initially, no filter applied
      });
    });
  }
  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData;  // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sProjectName.toLowerCase().contains(query.toLowerCase()) ||  // Filter by project name
              item.sExpHeadName.toLowerCase().contains(query.toLowerCase()) ||
              item.sStatusName.toLowerCase().contains(query.toLowerCase());
          // Filter by employee name
        }).toList();
      }
    });
  }
  // postImage
  postimage() async {
    print('----ImageFile----$_imageFile');
    var postimageResponse = await PostImageRepo().postImage(context, _imageFile);
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
  // Uplode Id Proof with gallary

  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');

    try {
      final pickFileid = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 65);
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
  getCurrentdate() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    firstOfMonthDay = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    // last day of the current month
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    lastDayOfCurrentMonth = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);
    setState(() {
    });
    if(firstDayOfNextMonth!=null && lastDayOfCurrentMonth!=null){
      print('You should call api');
      //reimbursementStatusV3 = (await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay!,lastDayOfCurrentMonth!)) as Future<List<Hrmsreimbursementstatusv3model>>;
      //print('---255--$reimbursementStatusV3');
      /// reimbursementStatusList = await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay!,lastDayOfCurrentMonth!);
      // _filteredData = List<Map<String, dynamic>>.from(reimbursementStatusList ?? []);
      // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
    }else{
      print('You should  not call api');
    }
  }

  // InitState
  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    getCurrentdate();
    hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);

    super.initState();
    _shopfocus = FocusNode();
    _owenerfocus = FocusNode();
    _contactfocus = FocusNode();
    _landMarkfocus = FocusNode();
    _addressfocus = FocusNode();
  }
  // location
  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });

    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }
  // didUpdateWidget

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _shopfocus.dispose();
    _owenerfocus.dispose();
    _contactfocus.dispose();
    _landMarkfocus.dispose();
    _addressfocus.dispose();
  }
  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
                  MaterialPageRoute(builder: (context) => const ExpenseManagement()),
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
                'Reimbursement Clarification',
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
                      Icon(Icons.calendar_month,size: 15,color: Colors.white),
                      const SizedBox(width: 4),
                      const Text('From',style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                      ),),
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
                            String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                            // Update the state with the picked date
                            setState(() {
                              firstOfMonthDay = formattedDate;
                              // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                            });
                            hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                            // reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                            print('--FirstDayOfCurrentMonth----$firstOfMonthDay');
                            hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
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
                          padding: EdgeInsets.symmetric(horizontal: 14.0), // Optional: Adjust padding for horizontal space
                          decoration: BoxDecoration(
                            color: Colors.white, // Change this to your preferred color
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '$firstOfMonthDay',
                              style: TextStyle(
                                color: Colors.grey, // Change this to your preferred text color
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
                      Icon(Icons.calendar_month,size: 16,color: Colors.white),
                      SizedBox(width: 5),
                      const Text('To',style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                      ),),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap:()async {
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
                              lastDayOfCurrentMonth = formattedDate;
                              // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                            });
                            hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                            //reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                            print('--LastDayOfCurrentMonth----$lastDayOfCurrentMonth');
                          } else {
                          }
                        },
                        child: Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 14.0), // Optional: Adjust padding for horizontal space
                          decoration: BoxDecoration(
                            color: Colors.white, // Change this to your preferred color
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '$lastDayOfCurrentMonth',
                              style: TextStyle(
                                color: Colors.grey, // Change this to your preferred text color
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
                // SizedBox(height: 10),
                Expanded(
                  child: Container(
                    child: FutureBuilder<List<HrmsReimbursementClarificationModel>>(
                        future: reimbursementStatusV3,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            // itemCount: snapshot.data!.length ?? 0,
                            // itemBuilder: (context, index)
                              itemCount: _filteredData.length?? 0,
                              itemBuilder: (context, index)
                              {
                                final leaveData = _filteredData[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: Colors.grey, // Outline border color
                                          width: 0.2, // Outline border width
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(left: 8, right: 8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    width: 30.0,
                                                    height: 30.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(15.0),
                                                      border: Border.all(
                                                        color: Color(0xFF255899),
                                                        // Outline border color
                                                        width:
                                                        0.5, // Outline border width
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    child: Center(
                                                      child: Icon(Icons.email,size: 20,color: Color(0xFF0098a6),)
                                                    )),
                                                SizedBox(width: 10),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      leaveData.sExpHeadName,
                                                      style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                                      maxLines: 2, // Limits the text to 2 lines
                                                      overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                                      softWrap: true,
                                                    ),
                                                    SizedBox(height: 2),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Icon(Icons.location_on, color: Color(0xFF0098a6), size: 20),
                                                        Text(
                                                          'Project Name :',
                                                          style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                                          maxLines: 1, // Limits the text to 1 line
                                                          overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                                        ),
                                                        SizedBox(width: 2),
                                                         Text(
                                                            leaveData.sProjectName,
                                                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                                            maxLines: null, // Limits the text to 1 line
                                                            overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                                            softWrap: false, // Prevents the text from wrapping to a new line
                                                          ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15, right: 15),
                                              child: Container(
                                                height: 0.5,
                                                color: Color(0xff3f617d),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    // Change this to your preferred color
                                                    borderRadius: BorderRadius.circular(5.0),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                //  '‣ Sector',
                                                Text('Expense Details',
                                                    style: AppTextStyle.font14OpenSansRegularBlackTextStyle
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 15),
                                              child: Text(
                                                  leaveData.sExpDetails,
                                                  //item['dExpDate'] ??'',
                                                  style: AppTextStyle.font12OpenSansRegularBlack45TextStyle
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      child: Center(
                                                          child: Icon(Icons.calendar_today,size: 16,color: Color(0xFF0098a6),)
                                                      )),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        leaveData.dEntryAt,
                                                        // item['sExpHeadName'] ?? '',
                                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                                        maxLines: 2, // Limits the text to 2 lines
                                                        overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                                        softWrap: true,
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        'Entry At',
                                                        // item['sExpHeadName'] ?? '',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle,
                                                        maxLines: 2, // Limits the text to 2 lines
                                                        overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                                        softWrap: true,
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    height: 25,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(17), // Border radius of 17
                                                      border: Border.all(color: Colors.grey, width: 1), // Red border color
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '₹ ${leaveData.fAmount}', // Replace with your text
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,right: 10),
                                              child: Container(
                                                color: Colors.grey,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      child: Center(
                                                          child: Icon(Icons.notes_outlined,size: 16,color: Color(0xFF0098a6),)
                                                      )),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('Remark',
                                                        // item['sExpHeadName'] ?? '',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle,
                                                        maxLines: 2, // Limits the text to 2 lines
                                                        overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                                        softWrap: true,
                                                      ),
                                                      SizedBox(height: 2), // sRemarks
                                                      Text(
                                                        leaveData.sRemarks,
                                                        // item['sExpHeadName'] ?? '',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle,
                                                        maxLines: 2, // Limits the text to 2 lines
                                                        overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                                        softWrap: true,
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    height: 25,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                      Text('Bill Date :', // Replace with your text
                                                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                                        ),
                                                      SizedBox(width: 5),
                                                      Text('${leaveData.dRemarksAt}', // Replace with your text
                                                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            GestureDetector(
                                              onTap: (){
                                                // Reimbursementrevert
                                                /// todo here get a value from a form and send to next activity
                                                  var sProjectName = leaveData.sProjectName;
                                                  var sExpHeadName = leaveData.sExpHeadName; // dEntryAt
                                                  var dEntryAt = leaveData.dEntryAt;
                                                  var fAmount = leaveData.fAmount;
                                                  var sExpDetails = leaveData.sExpDetails;
                                                  var sExpBillPhoto = leaveData.sExpBillPhoto;
                                                  var sExpBillPhoto2 = leaveData.sExpBillPhoto2;
                                                  var sExpBillPhoto3 = leaveData.sExpBillPhoto3;
                                                  var sExpBillPhoto4 = leaveData.sExpBillPhoto4;
                                                 var sProjectCode = leaveData.sProjectCode;
                                                  var sExpHeadCode = leaveData.sExpHeadCode;
                                                  var sTranCode = leaveData.sTranCode;
                                                  var dExpDate = leaveData.dExpDate;
                                                  // sRemarks
                                                  var sRemarks = leaveData.sRemarks;

                                                  print('--sExpBillPhoto-------$sExpBillPhoto');
                                                  print('--sExpBillPhoto2-------$sExpBillPhoto2');
                                                  print('--sExpBillPhoto3-------$sExpBillPhoto3');
                                                  print('--sExpBillPhoto4-------$sExpBillPhoto4');
                                                  print('--sTranCode-----xx--$sTranCode');
                                                  print('--dExpDate-------$dExpDate');
                                                  print('--sExpHeadName-------$sExpHeadName');
                                                //
                                                  Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ReimbursementrevertPage(sProjectName,sExpHeadName,dEntryAt,fAmount,sExpDetails,sExpBillPhoto,sProjectCode,sExpHeadCode,sExpBillPhoto2,sExpBillPhoto3,sExpBillPhoto4,sTranCode,dExpDate,sRemarks)),
                                                );

                                              },
                                              child: Container(
                                                height: 40,
                                                color: Colors.grey[300], // Light gray background
                                                padding: EdgeInsets.symmetric(horizontal: 10), // Padding to give space for the content
                                                child: const Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align text and icon at the ends
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        'Revert', // Centered text
                                                        style: TextStyle(
                                                          color: Colors.red, // Text color
                                                          fontSize: 16, // Adjust font size if needed
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios, // iOS forward icon
                                                      color: Colors.red, // Icon color
                                                      size: 16, // Adjust icon size if needed
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                              });

                        }

                    ),
                  ),
                ),

              ]
          )),
    );
  }
}
