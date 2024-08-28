import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/expensemanagement/reimbursementStatus/reimbursementlog.dart';
import '../../../app/generalFunction.dart';
import '../../../data/district_repo.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../../data/shopTypeRepo.dart';
import '../../dashboard/dashboard.dart';
import '../../resources/app_text_style.dart';

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

  List<Map<String, dynamic>>? pendingSchedulepointList;
  List<Map<String, dynamic>> _filteredData = [];
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
  List distList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  // Distic List
  updatedSector() async {
    distList = await ProjectRepo().projectList();
    print(" -----xxxxx-  list Data--65---> $distList");
    setState(() {});
  }

  shopType() async {
    shopTypeList = await ShopTypeRepo().getShopType();
    print(" -----xxxxx-  shopTypeList--- Data--65---> $shopTypeList");
    setState(() {});
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
  var _dropDownValueDistric;
  var _dropDownValueShopeType;
  var _dropDownSector;
  var _dropDownSector2gi;

  var _dropDownValue;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final sectorFocus = GlobalKey();
  File? _imageFile;
  var _selectedShopId;
  var _selectedBlockId;
  var _selectedSectorId;
  final _formKey = GlobalKey<FormState>();
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;

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

  // datepicker
  // InitState
  @override
  void initState() {
    // TODO: implement initState
    updatedSector();
    shopType();
    getLocation();
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
                    SizedBox(width: 4),
                    Icon(Icons.calendar_month,size: 16,color: Colors.white),
                    SizedBox(width: 4),
                    const Text('From',style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                    ),),
                    SizedBox(width: 4),
                    Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // Optional: Adjust padding for horizontal space
                      decoration: BoxDecoration(
                        color: Colors.white, // Change this to your preferred color
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          '01/Aug/2024',
                          style: TextStyle(
                            color: Colors.grey, // Change this to your preferred text color
                            fontSize: 12.0, // Adjust font size as needed
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
                    Text('To',style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                    ),),
                    SizedBox(width: 4),
                    Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // Optional: Adjust padding for horizontal space
                      decoration: BoxDecoration(
                        color: Colors.white, // Change this to your preferred color
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          '01/Aug/2024',
                          style: TextStyle(
                            color: Colors.grey, // Change this to your preferred text color
                            fontSize: 12.0, // Adjust font size as needed
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
              // scroll item after search bar
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
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
                                        style: AppTextStyle.font14OpenSansRegularBlackTextStyle
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
                                    'Fright Inward / Outward',
                                      style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                  ),
                                  Text(
                                    'Project Name : ATPL-Chandigarh Drone (SDPC_IOS)',
                                      style: AppTextStyle.font12OpenSansRegularBlackTextStyle
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
                                  color: Colors.black, // Change this to your preferred color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              SizedBox(width: 5),
                              //  '‣ Sector',
                              Text(
                                'Bill Date',
                                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              '21/Aug/2024',
                                style: AppTextStyle.font12OpenSansRegularBlack45TextStyle
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
                                  color: Colors.black, // Change this to your preferred color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Entry At',
                                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              '21/Aug/2024 14:11',
                                style: AppTextStyle.font12OpenSansRegularBlack45TextStyle
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
                                  color: Colors.black, // Change this to your preferred color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Expense Details',
                                style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Testing',
                                style: AppTextStyle.font12OpenSansRegularBlack45TextStyle
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width-40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.speaker_notes,size: 20,color: Colors.black,),
                                SizedBox(width: 10),
                                const Text('Status',style: TextStyle(
                                  color: Color(0xFF0098a6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal
                                ),),
                                SizedBox(width: 5),
                                const Text(':',style: TextStyle(
                                    color: Color(0xFF0098a6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal
                                ),),
                                SizedBox(width: 5),
                                const Text('Pending At Manager',style: TextStyle(
                                    color: Color(0xFF0098a6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal
                                ),),
                                Spacer(),
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 16.0), // Optional: Adjust padding for horizontal space
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0098a6), // Change this to your preferred color
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '₹ 1',
                                      style: TextStyle(
                                        color: Colors.white, // Change this to your preferred text color
                                        fontSize: 14.0, // Adjust font size as needed
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space between the two columns
                              children: [
                                // First Column
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                                        height: 40, // Adjust the height as needed
                                        decoration: BoxDecoration(
                                          color: Color(0xFF0098a6), // Change this to your preferred color
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: Text(
                                                'View Image',
                                                  style: AppTextStyle.font14OpenSansRegularWhiteTextStyle
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Second Column
                                SizedBox(width: 5.0),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                                        height: 40, // Adjust the height as needed
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2a697b), // Change this to your preferred color
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: GestureDetector(
                                          onTap: (){
                                            print('---TAKE ACTION---');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ReimbursementLog()),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Center(
                                                child: Text(
                                                  'Take Action',
                                                    style: AppTextStyle.font16OpenSansRegularWhiteTextStyle
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              ),
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
              ),

              // Expanded(
              //   child: ListView.builder(
              //     itemCount: _filteredData.length ?? 0,
              //     itemBuilder: (context, index) {
              //       Map<String, dynamic> item = _filteredData[index];
              //       return Padding(
              //         padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
              //         child: Container(
              //           child: Column(
              //             children: [
              //               Card(
              //                 elevation: 1,
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(5.0),
              //                     border: Border.all(
              //                       color: Colors.grey, // Outline border color
              //                       width: 0.2, // Outline border width
              //                     ),
              //                   ),
              //                   child: Padding(
              //                     padding:
              //                         const EdgeInsets.only(left: 8, right: 8),
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.start,
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           children: <Widget>[
              //                             Container(
              //                                 width: 30.0,
              //                                 height: 30.0,
              //                                 decoration: BoxDecoration(
              //                                   borderRadius:
              //                                       BorderRadius.circular(15.0),
              //                                   border: Border.all(
              //                                     color: Color(0xFF255899),
              //                                     // Outline border color
              //                                     width:
              //                                         0.5, // Outline border width
              //                                   ),
              //                                   color: Colors.white,
              //                                 ),
              //                                 child: Center(
              //                                   child: Text(
              //                                     "${index + 1}",
              //                                     style: const TextStyle(
              //                                         fontFamily: 'Montserrat',
              //                                         color: Color(0xFF255899),
              //                                         fontSize: 14.0,
              //                                         fontWeight:
              //                                             FontWeight.bold),
              //                                   ),
              //                                 )),
              //                             SizedBox(width: 5),
              //                             Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: <Widget>[
              //                                 Text(
              //                                   item['sPointTypeName'] ?? '',
              //                                   style: const TextStyle(
              //                                       fontFamily: 'Montserrat',
              //                                       color: Color(0xff3f617d),
              //                                       fontSize: 14.0,
              //                                       fontWeight:
              //                                           FontWeight.bold),
              //                                 ),
              //                                 const Text(
              //                                   'Point Name',
              //                                   style: TextStyle(
              //                                       fontFamily: 'Montserrat',
              //                                       color: Color(0xff3f617d),
              //                                       fontSize: 12.0,
              //                                       fontWeight:
              //                                           FontWeight.bold),
              //                                 ),
              //                               ],
              //                             )
              //                           ],
              //                         ),
              //                         const SizedBox(height: 10),
              //                         Padding(
              //                           padding: const EdgeInsets.only(
              //                               left: 15, right: 15),
              //                           child: Container(
              //                             height: 0.5,
              //                             color: Color(0xff3f617d),
              //                           ),
              //                         ),
              //                         SizedBox(height: 5),
              //                         const Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           children: <Widget>[
              //                             Icon(
              //                               Icons.forward,
              //                               size: 10,
              //                               color: Color(0xff3f617d),
              //                             ),
              //                             SizedBox(width: 5),
              //                             //  '‣ Sector',
              //                             Text(
              //                               'Sector',
              //                               style: TextStyle(
              //                                   fontFamily: 'Montserrat',
              //                                   color: Color(0xFF255899),
              //                                   fontSize: 14.0,
              //                                   fontWeight: FontWeight.bold),
              //                             )
              //                           ],
              //                         ),
              //                         Padding(
              //                           padding: EdgeInsets.only(left: 15),
              //                           child: Text(
              //                             item['sSectorName'] ?? '',
              //                             style: const TextStyle(
              //                                 fontFamily: 'Montserrat',
              //                                 color: Color(0xff3f617d),
              //                                 fontSize: 14.0,
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                         ),
              //                         const Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           children: <Widget>[
              //                             Icon(Icons.forward,
              //                                 size: 10,
              //                                 color: Color(0xff3f617d)),
              //                             SizedBox(width: 5),
              //                             Text(
              //                               'Location',
              //                               style: TextStyle(
              //                                   fontFamily: 'Montserrat',
              //                                   color: Color(0xFF255899),
              //                                   fontSize: 14.0,
              //                                   fontWeight: FontWeight.bold),
              //                             )
              //                           ],
              //                         ),
              //                         Padding(
              //                           padding: EdgeInsets.only(left: 15),
              //                           child: Text(
              //                             item['sLocation'] ?? '',
              //                             style: const TextStyle(
              //                                 fontFamily: 'Montserrat',
              //                                 color: Color(0xff3f617d),
              //                                 fontSize: 14.0,
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                         ),
              //                         SizedBox(height: 10),
              //                         Container(
              //                           color: Color(0xffe4e4e4),
              //                           height: 40,
              //                           child: Padding(
              //                             padding: const EdgeInsets.only(
              //                                 left: 10, right: 10),
              //                             child: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.spaceBetween,
              //                               children: <Widget>[
              //                                 Row(
              //                                   mainAxisAlignment:
              //                                       MainAxisAlignment.start,
              //                                   children: [
              //                                     InkWell(
              //                                       onTap: () {
              //                                         print('00000000----');
              //                                         var sBeforePhoto =
              //                                             "${item['sBeforePhoto']}";
              //                                         print('---$sBeforePhoto');
              //
              //                                         if (sBeforePhoto !=
              //                                             null) {
              //                                           // Navigator.push(
              //                                           //     context,
              //                                           //     MaterialPageRoute(
              //                                           //         builder: (context) =>
              //                                           //             ImageScreen(
              //                                           //                 sBeforePhoto:
              //                                           //                     sBeforePhoto)));
              //                                         } else {
              //                                           // toast
              //                                         }
              //                                       },
              //                                       child: const Text(
              //                                         'View Image',
              //                                         style: TextStyle(
              //                                             fontFamily:
              //                                                 'Montserrat',
              //                                             color:
              //                                                 Color(0xFF255899),
              //                                             fontSize: 14.0,
              //                                             fontWeight:
              //                                                 FontWeight.bold),
              //                                       ),
              //                                     ),
              //                                     const SizedBox(width: 5),
              //                                     const Icon(
              //                                       Icons.forward_sharp,
              //                                       color: Color(0xFF255899),
              //                                     )
              //                                   ],
              //                                 ),
              //                                 Container(
              //                                     height: 10,
              //                                     width: 1,
              //                                     color: Colors.grey),
              //                                 GestureDetector(
              //                                   onTap: () {
              //                                     print('---406--$lat');
              //                                     print('---407--$long');
              //                                     var sBeforePhoto =
              //                                         "${item['sBeforePhoto']}";
              //                                     var iTaskCode =
              //                                         "${item['iTaskCode']}";
              //                                     print(
              //                                         '---410----$sBeforePhoto');
              //                                     print('---411----$iTaskCode');
              //
              //                                     // create an instance of the class
              //
              //                                     // Navigator.push(
              //                                     //   context,
              //                                     //   MaterialPageRoute(
              //                                     //       builder: (context) =>
              //                                     //           ActionOnSchedultPointScreen(
              //                                     //               sBeforePhoto:
              //                                     //                   sBeforePhoto,
              //                                     //               iTaskCode:
              //                                     //                   iTaskCode,
              //                                     //               lat: lat,
              //                                     //               long: long)),
              //                                     // );
              //
              //                                   },
              //                                   child: Padding(
              //                                     padding:
              //                                         const EdgeInsets.all(8.0),
              //                                     child: Container(
              //                                       child: const Row(
              //                                         mainAxisAlignment:
              //                                             MainAxisAlignment
              //                                                 .start,
              //                                         children: [
              //                                           Text(
              //                                             'Action',
              //                                             style: TextStyle(
              //                                                 fontFamily:
              //                                                     'Montserrat',
              //                                                 color: Color(
              //                                                     0xFF255899),
              //                                                 fontSize: 14.0,
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .bold),
              //                                           ),
              //                                           SizedBox(width: 5),
              //                                           Icon(
              //                                             Icons.forward_sharp,
              //                                             color:
              //                                                 Color(0xFF255899),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 Container(
              //                                     height: 10,
              //                                     width: 1,
              //                                     color: Colors.grey),
              //                                 GestureDetector(
              //                                   onTap: () {
              //                                     print('-----458--');
              //                                     // getLocation();
              //                                     var fLatitude =
              //                                         item['fLatitude'] ?? '';
              //                                     var fLongitude =
              //                                         item['fLongitude'] ?? '';
              //                                     print(
              //                                         '----462----${fLatitude}');
              //                                     print(
              //                                         '-----463---${fLongitude}');
              //
              //                                     if (fLatitude != null &&
              //                                         fLongitude != null) {
              //                                       //launchGoogleMaps()
              //                                       print(
              //                                           '---472----$fLatitude');
              //                                       print(
              //                                           '---473----$fLongitude');
              //                                       generalfunction
              //                                           .launchGoogleMaps(
              //                                               fLatitude,
              //                                               fLongitude);
              //                                     } else {
              //                                       displayToast(
              //                                           "Please check the location.");
              //                                     }
              //                                   },
              //                                   child: Padding(
              //                                     padding: EdgeInsets.all(6.0),
              //                                     child: InkWell(
              //                                       onTap: () {
              //                                         var fLatitude =
              //                                             item['fLatitude'] ??
              //                                                 '';
              //                                         var fLongitude =
              //                                             item['fLongitude'] ??
              //                                                 '';
              //                                         print(
              //                                             '----462----${fLatitude}');
              //                                         print(
              //                                             '-----463---${fLongitude}');
              //
              //                                         if (fLatitude != null &&
              //                                             fLongitude != null) {
              //                                           //launchGoogleMaps()
              //                                           print(
              //                                               '---472----$fLatitude');
              //                                           print(
              //                                               '---473----$fLongitude');
              //                                           generalfunction
              //                                               .launchGoogleMaps(
              //                                                   fLatitude,
              //                                                   fLongitude);
              //                                         } else {
              //                                           displayToast(
              //                                               "Please check the location.");
              //                                         }
              //                                       },
              //                                       child: const Row(
              //                                         mainAxisAlignment:
              //                                             MainAxisAlignment
              //                                                 .start,
              //                                         children: [
              //                                           Text('Navigate',
              //                                               style: TextStyle(
              //                                                   fontFamily:
              //                                                       'Montserrat',
              //                                                   color: Color(
              //                                                       0xFF255899),
              //                                                   fontSize: 14.0,
              //                                                   fontWeight:
              //                                                       FontWeight
              //                                                           .bold)),
              //                                           // SizedBox(width: 5),
              //                                           //Icon(Icons.forward_sharp,color: Color(0xFF255899))
              //                                         ],
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // )
            ]));
  }
}
