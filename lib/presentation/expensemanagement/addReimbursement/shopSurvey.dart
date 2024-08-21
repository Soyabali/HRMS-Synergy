import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noidaone/Controllers/shopSubmitRepo.dart';
import 'package:noidaone/screens/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/district_repo.dart';
import '../Controllers/postimagerepo.dart';
import '../Controllers/shopTypeRepo.dart';
import '../Helpers/loader_helper.dart';
import '../resources/values_manager.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'flull_screen_image.dart';


class ShopSurvey extends StatelessWidget {
  const ShopSurvey({super.key});

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List stateList = [];
  List distList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2,msg2;

  // Distic List
  updatedSector() async {
    distList = await DistRepo().getDistList();
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
  TextEditingController _shopController = TextEditingController();
  TextEditingController _ownerController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _landMarkController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

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
  double? lat, long;

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
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));

      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'file', imageFile.path,
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

    var headers = {
      'token': '$sToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));
    request.body = json.encode({
      "sImagePath": "$image"
    });
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
                  text: "Select a Sector",
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
              ), // Not necessary for Option 1
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
                      setState(() {
                      });
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
                  text: "Select a Shop Type",
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
              ), // Not necessary for Option 1
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
        backgroundColor: Color(0xFF255899),
        leading: GestureDetector(
            onTap: () {
              //Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back_ios),
            )),
        title: const Text(
          'Shop Survey',
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150, // Height of the container
              width: 200, // Width of the container
              child: Opacity(
                opacity: 0.9,
                //step3.jpg
                child: Image.asset(
                  'assets/images/markpointheader.jpeg', // Replace 'image_name.png' with your asset image path
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // 'assets/images/favicon.png',
                            Container(
                              margin:
                              EdgeInsets.only(left: 0, right: 10, top: 10),
                              child: Image.asset(
                                'assets/images/ic_expense.png', // Replace with your image asset path
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text('Fill the below details',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5,top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 2, bottom: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Sector',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // _casteDropDownWithValidation(),
                       // _bindMarkLocation(),
                        _bindSector(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Shop Type',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // _casteDropDownWithValidation(),
                        //_bindSector(),
                        _bindShopType(),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Shop Name',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            height: 42,
                            color: Color(0xFFf2f3f5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                focusNode: _shopfocus,
                                controller: _shopController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: const InputDecoration(
                                  // labelText: AppStrings.txtMobile,
                                  // border: OutlineInputBorder(),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppPadding.p10),
                                ),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return 'Enter location';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Owner Name',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            height: 42,
                            color: Color(0xFFf2f3f5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                focusNode: _owenerfocus,
                                controller: _ownerController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: const InputDecoration(
                                  // labelText: AppStrings.txtMobile,
                                  // border: OutlineInputBorder(),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppPadding.p10),
                                ),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return 'Enter location';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Contact No',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            height: 42,
                            color: Color(0xFFf2f3f5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                focusNode: _contactfocus,
                                controller: _contactController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                                  //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow digits
                                ],
                                decoration: const InputDecoration(
                                  // labelText: AppStrings.txtMobile,
                                  // border: OutlineInputBorder(),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppPadding.p10),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return 'Enter location';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Landmark',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            height: 42,
                            //  color: Colors.black12,
                            color: Color(0xFFf2f3f5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                focusNode: _landMarkfocus,
                                controller: _landMarkController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: const InputDecoration(
                                  // labelText: AppStrings.txtMobile,
                                  //  border: OutlineInputBorder(),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppPadding.p10),
                                  //prefixIcon: Icon(Icons.phone,color:Color(0xFF255899),),
                                ),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return 'Enter Description';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Address',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            height: 42,
                            //  color: Colors.black12,
                            color: Color(0xFFf2f3f5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                focusNode: _addressfocus,
                                controller: _addressController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: const InputDecoration(
                                  // labelText: AppStrings.txtMobile,
                                  //  border: OutlineInputBorder(),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppPadding.p10),
                                  //prefixIcon: Icon(Icons.phone,color:Color(0xFF255899),),
                                ),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return 'Enter Description';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Upload Photo',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        //ContainerWithRow(),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFf2f3f5),
                            borderRadius:
                            BorderRadius.circular(10.0), // Border radius
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Click Photo',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.black54,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Please clock here to take a photo',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.redAccent,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 10),
                                            Image(image: AssetImage('assets/images/ic_long_right_arrow.PNG'),
                                              width: 15,
                                              height: 15,
                                              fit: BoxFit.fill,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // pickImage();
                                    // _getImageFromCamera();
                                    pickImage();
                                    print('---------530-----');
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 10, top: 5),
                                    child: Image(image: AssetImage('assets/images/ic_camera.PNG'),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              image != null
                                  ? Stack(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenPage(
                                                    child: image!,
                                                    dark: true,
                                                  )));
                                    },
                                    child: Container(
                                        color: Colors.lightGreenAccent,
                                        height: 100,
                                        width: 70,
                                        child: Image.file(
                                          image!,
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                                  Positioned(
                                      bottom: 65,
                                      left: 35,
                                      child: IconButton(
                                        onPressed: () {
                                          image = null;
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ))
                                ],
                              )
                                  : Text(
                                "Photo is required.",
                                style: TextStyle(color: Colors.red[700]),
                              )
                            ]),

                        ElevatedButton(
                            onPressed: () async {
                              // random number
                              // var random = Random();
                              // // Generate an 8-digit random number
                              // int randomNumber = random.nextInt(99999999 - 10000000) + 10000000;
                              // print('Random 8-digit number---770--: $randomNumber');
                              //
                              // DateTime currentDate = DateTime.now();
                              // todayDate = DateFormat('dd/MMM/yyyy HH:mm').format(currentDate);

                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              iUserTypeCode = prefs.getString('iUserTypeCode');
                              userId = prefs.getString('iUserId');


                              var shopName = _shopController.text;
                              var ownerName = _ownerController.text;
                              var contactNo = _contactController.text;
                              var landMark = _landMarkController.text;
                              var address = _addressController.text;

                              print('---995--sShopName---$shopName');
                              print('---996--OwnerName---$ownerName');
                              print('---997--sShopType---$_selectedShopId');
                              print('---998--sContactNo ---$contactNo');
                              print('---1000--isectorCode ---$_selectedSectorId');
                              print('---1001--sAddress ---$address');
                              print('---1002--sLandmark ---$landMark');
                              print('---1003--sPhoto ---$uplodedImage');
                              print('---1004--slat ---$lat');
                              print('---1005--slong ---$long');
                              print('---1006--sGoogleLocation ---');
                              print('---1007--sSurveyBt ---$userId');

                              // apply condition
                              if (_formKey.currentState!.validate() &&
                                  _selectedSectorId != null &&
                                  _selectedShopId != null &&
                                  shopName != null &&
                                  ownerName !=null &&
                                  contactNo !=null &&
                                  address!=null &&
                                  uplodedImage!=null) {
                                print('---call Api---');

                                var shopSurveyResponse =
                                await ShopSubmitRepo().shopSummit(
                                    context,
                                    shopName,
                                    ownerName,
                                    _selectedShopId,
                                    contactNo,
                                    _selectedSectorId,
                                    address,
                                    landMark,
                                    uplodedImage,
                                    lat,
                                    long,
                                    userId
                                );
                                print('---1036----$shopSurveyResponse');
                                result2 = shopSurveyResponse['Result'];
                                msg2 = shopSurveyResponse['Msg'];

                              } else {
                                if(_selectedSectorId==null){
                                  displayToast('Select Sector');
                                }else if(_selectedShopId==null){
                                  displayToast('Select Shop Type');
                                }else if(shopName==""){
                                  displayToast('Enter Shop Name');
                                }else if(ownerName==""){
                                  displayToast('Enter Owner Name');
                                }else if(contactNo==""){
                                  displayToast('Enter Contact No');
                                }else if(address==""){
                                  displayToast('Enter Address');
                                }else if(uplodedImage==null){
                                  displayToast('Please pick a Photo');
                                }
                              }
                              if(result2=="1"){
                                print('------823----xxxxxxxxxxxxxxx----');
                                print('------823---result2  -xxxxxxxxxxxxxxx--$result2');
                                displayToast(msg2);
                               // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );

                              }else{
                                displayToast(msg2);
                              }

                              /// Todo next Apply condition
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                  0xFF255899), // Hex color code (FF for alpha, followed by RGB)
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
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
