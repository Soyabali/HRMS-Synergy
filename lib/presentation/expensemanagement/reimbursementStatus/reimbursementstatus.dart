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
import 'package:untitled/presentation/expensemanagement/reimbursementStatus/reimbursementlog.dart';
import '../../../app/generalFunction.dart';
import '../../../data/hrmsreimbursementstatusV3_repo.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../resources/app_text_style.dart';
import '../expense_management.dart';

class Reimbursementstatus extends StatelessWidget {
  const Reimbursementstatus({super.key});

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
      home: ReimbursementstatusPage(),
    );
  }
}

class ReimbursementstatusPage extends StatefulWidget {
  const ReimbursementstatusPage({super.key});

  @override
  State<ReimbursementstatusPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ReimbursementstatusPage> {

  List<Map<String, dynamic>>? reimbursementStatusList;
  List<Map<String, dynamic>> _filteredData = [];
  ///List<dynamic>  hrmsReimbursementList;
  TextEditingController _searchController = TextEditingController();
  double? lat;
  double? long;
  GeneralFunction generalfunction = GeneralFunction();

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

  // Distic List
  hrmsReimbursementStatus(String firstOfMonthDay,String lastDayOfCurrentMonth) async {
    showLoader();
    reimbursementStatusList = await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay,lastDayOfCurrentMonth);
    _filteredData = List<Map<String, dynamic>>.from(reimbursementStatusList ?? []);
    if(_filteredData!=null){
      hideLoader();
    }
    print(" -----xxxxx-  reimbursementStatusList--90-----> $reimbursementStatusList");
    // setState(() {});
  }

  void _search() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = reimbursementStatusList?.where((item) {
        String location = item['sProjectName'].toLowerCase();
        String pointType = item['sStatusName'].toLowerCase();
        String sector = item['sExpHeadName'].toLowerCase();
        return location.contains(query) ||
            pointType.contains(query) ||
            sector.contains(query);
      }).toList() ??
          [];
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

  getCurrentdate(){
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    firstOfMonthDay = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    // last day of the current month
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    lastDayOfCurrentMonth = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);
  }

  // InitState
  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    getCurrentdate();
    hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
    _searchController.addListener(_search);
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
    return Scaffold(
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
              'Reimbursement Status',
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
                    Icon(Icons.calendar_month,size: 16,color: Colors.white),
                    const SizedBox(width: 4),
                    const Text('From',style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                    ),),
                    SizedBox(width: 4),

                    GestureDetector(
                      onTap: () async{
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
                            hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          });
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
                        padding: EdgeInsets.symmetric(horizontal: 16.0), // Optional: Adjust padding for horizontal space
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

                    SizedBox(width: 10),
                    Container(
                      height: 32,
                      width: 32,
                      child: Image.asset(
                        "assets/images/reimicon_2.png",
                        fit: BoxFit.contain, // or BoxFit.cover depending on the desired effect
                      ),
                    ),
                    //Icon(Icons.arrow_back_ios,size: 16,color: Colors.white),
                    SizedBox(width: 10),
                    Icon(Icons.calendar_month,size: 16,color: Colors.white),
                    SizedBox(width: 4),
                    const Text('To',style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                    ),),
                    SizedBox(width: 4),
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
                          // Update the state with the picked date
                          setState(() {
                            lastDayOfCurrentMonth = formattedDate;
                            hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          });
                          print('---465--$lastDayOfCurrentMonth');
                          //hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          // Display the selected date as a toast
                          //displayToast(dExpDate.toString());
                        } else {
                          // Handle case where no date was selected
                          //displayToast("No date selected");
                        }
                      },
                      child: Container(
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 16.0), // Optional: Adjust padding for horizontal space
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
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
              _filteredData == null || _filteredData!.isEmpty
                  ? const Center(
                child: Center(
                  child: Text(
                    'No reimbursement found',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
              :
               Expanded(
      child: ListView.builder(
      itemCount: _filteredData.length ?? 0,
      itemBuilder: (context, index) {
        Map<String, dynamic> item = _filteredData[index];
        return
          Padding(
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
                                child: Text(
                                    "${1}",
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlackTextStyle
                                ),
                              )),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  item['sExpHeadName'] ?? '',
                                  style: AppTextStyle
                                      .font12OpenSansRegularBlackTextStyle,
                                maxLines: 2, // Limits the text to 2 lines
                                overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                softWrap: true,
                              ),
                              Text(
                                  item['sProjectName'] ?? '',
                                  style: AppTextStyle
                                      .font12OpenSansRegularBlackTextStyle,
                                maxLines: 2, // Limits the text to 2 lines
                                overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                softWrap: true,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15),
                        child: Container(
                          height: 0.5,
                          color: Color(0xff3f617d),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
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
                          Text(
                              'Bill Date',
                              style: AppTextStyle
                                  .font12OpenSansRegularBlackTextStyle
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                            item['dExpDate'] ??'',
                            style: AppTextStyle
                                .font12OpenSansRegularBlack45TextStyle
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
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
                          Text(
                              'Entry At',
                              style: AppTextStyle
                                  .font12OpenSansRegularBlackTextStyle
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                            item['dEntryAt'] ?? '',
                            style: AppTextStyle
                                .font12OpenSansRegularBlack45TextStyle
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
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
                          Text(
                              'Expense Details',
                              style: AppTextStyle
                                  .font12OpenSansRegularBlackTextStyle
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                            item['sExpDetails'] ?? '',
                            style: AppTextStyle
                                .font12OpenSansRegularBlack45TextStyle
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 1,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 40,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.speaker_notes, size: 20, color: Colors.black),
                            SizedBox(width: 10),
                             Text(
                              'Status',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlackTextStyle
                            ),
                            SizedBox(width: 5),
                            const Text(
                              ':',
                              style: TextStyle(
                                color: Color(0xFF0098a6),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                item['sStatusName'] ?? '',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlackTextStyle,
                                maxLines: 2, // Allows up to 2 lines for the text
                                overflow: TextOverflow.ellipsis, // Adds an ellipsis if the text overflows
                              ),
                            ),
                           // Spacer(),
                            Container(
                              height: 30,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF0098a6),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Expanded(
                                  child: Text(
                                    item['fAmount'] ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 2, // Allows up to 2 lines for the text
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // Space between the two columns
                          children: [
                            // First Column
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                              color: Color(0xFF0098a6),
                                              // Change this to your preferred color
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('View Image',style: AppTextStyle.font14OpenSansRegularWhiteTextStyle),
                                        Icon(Icons.arrow_forward_ios ,color: Colors.white,size: 16,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0098a6),
                                      // Change this to your preferred color
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(builder: (context) =>
                                                    //       ReimbursementLog()),
                                                    // );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Take Action',style: AppTextStyle
                                              .font14OpenSansRegularWhiteTextStyle),
                                          Icon(Icons.arrow_forward_ios,color: Colors.white,size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0098a6),
                                      // Change this to your preferred color
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {

                                        var projact =  item['sProjectName'] ??'';
                                        var sTranCode =   item['sTranCode'] ?? '';
                                        print('--project---$projact');
                                        print('--sTranCode---$sTranCode');


                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => ReimbursementLog(projact,sTranCode)),
                                        // );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ReimbursementLogPage(projact,sTranCode)),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Log',style: AppTextStyle.font14OpenSansRegularWhiteTextStyle),
                                          SizedBox(width: 10),
                                          Icon(Icons.arrow_forward_ios,color: Colors.white,size: 18,),
                                        ],
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
                ),
              ),
            ),
          );
      }
      
      ),
    )
            ]
        ));
  }
}
