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
import '../../../app/generalFunction.dart';
import '../../../data/district_repo.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../../data/shopTypeRepo.dart';
import '../../dashboard/dashboard.dart';
import '../../resources/app_text_style.dart';

class TeamReimStatus extends StatelessWidget {
  const TeamReimStatus({super.key});

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
      home: TeamReimStatusPage(),
    );
  }
}

class TeamReimStatusPage extends StatefulWidget {
  const TeamReimStatusPage({super.key});

  @override
  State<TeamReimStatusPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TeamReimStatusPage> {

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }


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

  // Todo bind sector code
  Widget _bindSector() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 42,
        color: Color(0xFFf2f3f5),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: const TextSpan(
                  text: "Select Project",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Not necessary for Option 1
              value: _dropDownSector,
              key: sectorFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownSector = newValue;
                  print('---187---$_dropDownSector');
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  distList.forEach((element) {
                    if (element["sSectorName"] == _dropDownSector) {
                      _selectedSectorId = element['iSectorCode'];
                      setState(() {});
                      print('-----286-----sector id---$_selectedSectorId');
                    }
                  });
                });
              },
              items: distList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sSectorName'].toString()),
                  value: item["sSectorName"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Todo same way you should bind point Type data.
  Widget _bindShopType() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 42,
        color: Color(0xFFf2f3f5),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: const TextSpan(
                  text: "Select Expense Category",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Not necessary for Option 1
              value: _dropDownValueShopeType,
              // key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueShopeType = newValue;
                  print('---333-------$_dropDownValueShopeType');
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  shopTypeList.forEach((element) {
                    if (element["sShopType"] == _dropDownValueShopeType) {
                      setState(() {
                        _selectedShopId = element['iTranId'];
                        print('----349--shoptype id ------$_selectedShopId');
                      });
                      print('-----Point id----241---$_selectedShopId');
                      if (_selectedShopId != null) {
                        // updatedBlock();
                      } else {
                        print('-------');
                      }
                      // print("Distic Id value xxxxx.... $_selectedDisticId");
                      print("Distic Name xxxxxxx.... $_dropDownValueDistric");
                      print("Block list Ali xxxxxxxxx.... $blockList");
                    }
                  });
                });
              },
              items: shopTypeList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sShopType'].toString()),
                  value: item["sShopType"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
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
              'Team Reim Status',
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
                child: Text('Expense Report',style: TextStyle(
                    color: Colors.black,fontSize: 14,
                    fontWeight: FontWeight.normal
                ),),
              )
              // scroll item after search bar


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
