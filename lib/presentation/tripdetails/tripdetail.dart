import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/baseurl.dart';
import '../../data/hrmsTripStartEnd_Repo.dart';
import '../../data/loader_helper.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class TripDetail extends StatelessWidget {
  const TripDetail({super.key});

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
      home: WorkDetailPage(),
    );
  }
}

class WorkDetailPage extends StatefulWidget {
  const WorkDetailPage({super.key});

  @override
  State<WorkDetailPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WorkDetailPage> {
  late String randomNumber;
  double? lat, long;
  var dTripDateTime;
  File? image;
  var uplodedImage;
  final _formKey = GlobalKey<FormState>();

  var  Msg ;
  var  sTranNo ;
  var  Result ;

  // InitState
  TextEditingController _takeAction = TextEditingController();
  // get a currectDate Date and time  function

  String getCurrentFormattedDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd/MMM/yyyy HH:mm').format(now);
    return formattedDateTime;
  }
  // get a currecr location latitude and longitude
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

    lat = position.latitude;
    long = position.longitude;
    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }
  // function to generate random no
  String generateRandomNumber() {
    Random random = Random();
    int firstPart = 1000000000 + random.nextInt(900000000); // Generate the first part (10 digits)
    return firstPart.toString();
  }
  // to pick a images
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
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // to uplode image and get a imageurl
  Future<void> uploadImage(String token, File imageFile) async {
    var baseURL = BaseRepo().baseurl;
    var endPoint = "UploadTrackingImage/UploadTrackingImage";
    var uplodeImageApi = "$baseURL$endPoint";
    try {
      print('-----xx-x----214----');
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$uplodeImageApi'),
      );

      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'sImagePath', imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      List<dynamic> responseData = json.decode(response.body);

      // Extracting the image path
      uplodedImage = responseData[0]['Data'][0]['sImagePath'];
      print('Uploaded Image Path----245--: $uplodedImage');

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    randomNumber = generateRandomNumber();
    dTripDateTime = getCurrentFormattedDateTime();
    print('Current Date : $dTripDateTime');
    print(randomNumber); // Example output: 1234567890
    getLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _takeAction.dispose();
  }

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
            'Trip Detail',
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
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                // decoration: BoxDecoration(
                //     color: Colors.white, // Background color of the container
                //     borderRadius: BorderRadius.circular(20),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.5), // Color of the shadow
                //         spreadRadius: 5, // Spread radius
                //         blurRadius: 7, // Blur radius
                //         offset: Offset(0, 3), // Offset of the shadow
                //
                //       ),
                //     ]),
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
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Icon(Icons.light_mode_rounded,size: 25,color: Colors.redAccent,),
                                Image.asset('assets/images/tripicon.jpeg',
                                height: 25,
                                  width: 25,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(width: 10),
                                Text('Trip Details',
                                    style: AppTextStyle
                                        .font12OpenSansRegularBlackTextStyle,
                                    maxLines: 2, // Limits the text to 2 lines
                                    overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                    softWrap: true,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // take a EditTextView
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: TextFormField(
                              controller: _takeAction,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                filled: true, // Enable background color
                                fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                hintText: 'Enter Odometer', // Add your hint text here
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal keyboard
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,10}')), // Allow only numbers with optional decimal point
                                //LengthLimitingTextInputFormatter(10), // Limit input to 10 characters
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 1.0,
                              dashPattern: [4, 2],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(5.0),
                              child:  Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  height: 200,
                                   child: Center(
                                     child: InkWell(
                                       onTap: (){
                                         print('----click photo---');
                                         pickImage();
                                       },
                                       child:
                                       image ==null ?
                                       Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         children: [
                                          // Icon(Icons.camera,size: 25),
                                           Image.asset('assets/images/camra.jpeg',
                                             height: 25,
                                             width: 25,
                                             fit: BoxFit.fill,
                                           ),
                                           SizedBox(height: 5),
                                           Text('Click Odometer Photo', style: AppTextStyle
                                               .font12OpenSansRegularBlackTextStyle,)
                                         ],
                                       )
                                           : Container(
                                            height: 190,
                                             width: MediaQuery.of(context).size.width,
                                           child: Image.file(
                                             image!,
                                             fit: BoxFit.cover,
                                           )),
                                     ),
                                   ),

                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                             onPressed: () async {
                               var sImage;
                               var edtOdometer = _takeAction.text;
                               SharedPreferences prefs = await SharedPreferences.getInstance();
                               String? sContactNo = prefs.getString('sContactNo');


                               if(_formKey.currentState!.validate() && edtOdometer != null && image != null){
                                    print('---Api call---');
                                  var  tripStart = await HrmstripstartendRepo().tripStart(context, sContactNo!,lat,long,randomNumber,uplodedImage,edtOdometer,dTripDateTime);
                                  print('---380--$tripStart');
                                    Msg = "${tripStart[0]['Msg']}";
                                    sTranNo = "${tripStart[0]['sTranNo']}";
                                    Result = "${tripStart[0]['Result']}";


                               }else{
                                 print('---Api not call---');
                               }
                               if(Result=="1"){
                                 displayToast(Msg);
                               }else{
                                 displayToast(Msg);
                               }

                               /// todo here you get record value and hit the api
                               // to get a contact number from a sharedPrefernce

                               // print('----sContactNo--15---$sContactNo');
                               // print('----dTripDateTime--15---$sContactNo');
                               // print('----iTripFor--15---${'1'}');
                               // print('----flat--15---$lat');
                               // print('----flong--15---$long');
                               // print('----sTranNo--15---$randomNumber');
                               // print('----sImage--15---$uplodedImage');
                               // print('----sImage--15---${_takeAction.text}');

                               /// todo call the Api with static parameters
                               // var  tripStart = await HrmstripstartendRepo().tripStart(context);
                               // print('---380--$tripStart');



                               },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF0098a6), // Hex color code (FF for alpha, followed by RGB)
                              ),
                              child: const Text(
                                "START TRIP",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(height: 15),
                          ElevatedButton(
                              onPressed: (){
                                print('----217----');
                              },
                              style: ElevatedButton.styleFrom(
                               // backgroundColor: Color(0xFF0098a6), // Hex color code (FF for alpha, followed by RGB)
                              backgroundColor: Colors.grey
                              ),
                              child: const Text(
                                "STOP TRIP",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(height: 15),
                          Text('lat : $lat and longitude : $long',style: TextStyle(
                            color: Colors.black,fontSize: 16
                          ),)
                        ],
                      ),
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
  // display tost
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
}
