import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/baseurl.dart';
import '../../data/hrmsTripEndRepo.dart';
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

  var Msg;
  var sTranNo;
  var Result;
  bool isStartButtonActive = true;
  bool isStopButtonActive = false;
  Color startButtonColor = Color(0xFF0098a6); // Green color for start
  Color stopButtonColor = Colors.grey;
  bool isStartTripEnabled = true;
  bool isEndTripEnabled = false;
  String? tripMsg;
  bool isTripStarted = false;
  // Inactive color for stop button
  Future<void> _loadTripStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tripMsg = prefs.getString('tripMsg');
      isTripStarted = tripMsg == 'Trip has been started';
    });
  }

  Color getButtonColor(String msg) {
    return msg == 'Trip has been started' ? Colors.grey : Color(0xFF0098a6);
  }

  Color getButtonColorStoptrip(String msg) {
    return msg == 'Trip has been started' ? Colors.green : Colors.grey;
  }

  // InitState
  TextEditingController _takeAction = TextEditingController();
  // get a currectDate Date and time  function

  String getCurrentFormattedDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd/MMM/yyyy HH:mm').format(now);
    return formattedDateTime;
  }
  // trip dialog success


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
    int firstPart = 1000000000 +
        random.nextInt(900000000); // Generate the first part (10 digits)
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
        'sImagePath',
        imageFile.path,
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

  // void getlocalDataInSharedPreference() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //    tripMsg = prefs.getString('tripMsg');//  tripMsg
  //   print('----188---$tripMsg');
  //   getButtonColor(tripMsg ?? "Not a value");
  // }
  void getlocalDataInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tripMsg = prefs.getString('tripMsg');
      sTranNo = prefs.getString('sTranNo');
      print('---Trip Message---$tripMsg');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    randomNumber = generateRandomNumber();
    dTripDateTime = getCurrentFormattedDateTime();
    print('Current Date : $dTripDateTime');
    print(randomNumber); // Example output: 1234567890
    getLocation();
    _loadTripStatus();
    //getlocalDataInSharedPreference();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _takeAction.dispose();
    FocusScope.of(context).unfocus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
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
              statusBarIconBrightness:
                  Brightness.dark, // For Android (dark icons)
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        color: Colors.white, // Background color of the container
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.5), // Color of the shadow
                            spreadRadius: 5, // Spread radius
                            blurRadius: 7, // Blur radius
                            offset: Offset(0, 3), // Offset of the shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
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
                                    Image.asset(
                                      'assets/images/tripicon.jpeg',
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Trip Details',
                                      style: AppTextStyle
                                          .font12OpenSansRegularBlackTextStyle,
                                      maxLines: 2, // Limits the text to 2 lines
                                      overflow: TextOverflow
                                          .ellipsis, // Truncates the text with an ellipsis if it's too long
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
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    filled: true, // Enable background color
                                    fillColor: Color(
                                        0xFFf2f3f5), // Set your desired background color here
                                    hintText:
                                        'Enter Odometer', // Add your hint text here
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true), // Allow decimal keyboard
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'^\d*\.?\d{0,2}')), // Allow only numbers with optional decimal point
                                    LengthLimitingTextInputFormatter(
                                        5), // Limit input to 10 characters
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
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 200,
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            print('----click photo---');
                                            pickImage();
                                          },
                                          child: image == null
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Icon(Icons.camera,size: 25),
                                                    Image.asset(
                                                      'assets/images/camra.jpeg',
                                                      height: 25,
                                                      width: 25,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Click Odometer Photo',
                                                      style: AppTextStyle
                                                          .font12OpenSansRegularBlackTextStyle,
                                                    )
                                                  ],
                                                )
                                              : Container(
                                                  height: 190,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
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
                              // Start Trip Button
                              ElevatedButton(
                                onPressed: isTripStarted
                                    ? null
                                    : () async {
                                        // Your trip start API logic
                                        SharedPreferences prefs =
                                            await SharedPreferences.getInstance();
                                        var sImage;
                                        var edtOdometer = _takeAction.text;
                                        String? sContactNo =
                                            prefs.getString('sContactNo');

                                        if (_formKey.currentState!.validate() &&
                                            edtOdometer != null &&
                                            uplodedImage != null) {

                                          var tripStart =
                                              await HrmstripstartendRepo()
                                                  .tripStart(
                                                      context,
                                                      sContactNo!,
                                                      lat,
                                                      long,
                                                      randomNumber,
                                                      uplodedImage,
                                                      edtOdometer,
                                                      dTripDateTime);


                                          print('---472---$tripStart');

                                          String Msg = "${tripStart[0]['Msg']}";
                                          String sTranNo = "${tripStart[0]['sTranNo']}";
                                          String Result = "${tripStart[0]['Result']}";

                                          prefs.setString('sTranNo', sTranNo);
                                          prefs.setString('tripMsg', Msg);

                                          setState(() {
                                            tripMsg = Msg;
                                            isTripStarted = tripMsg == 'Trip has been started';
                                          });
                                          // todo celan foield adm image data
                                          _takeAction.clear();
                                          image == null;
                                          print('---487---$tripMsg');

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return _buildDialogSucces2(
                                                    context, tripMsg!);
                                              }
                                              );
                                          // Dialog logic and other actions
                                        } else {
                                          if (edtOdometer == null ||
                                              edtOdometer == '') {
                                            print('----print---424---');
                                            displayToast(
                                                'Enter Odometer details ');
                                          } else if (uplodedImage == null ||
                                              uplodedImage == '') {
                                            displayToast(
                                                'Please click Odometer image');
                                            //print('----print---424---');
                                          }
                                          print('---Api not call---');
                                          // displayToast('Click Photo');
                                        }
                                        if (Result == "1") {
                                          // displayToast(Msg);
                                          _takeAction.clear();
                                          image == null;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return _buildDialogSucces2(
                                                  context, Msg);
                                            },
                                          );
                                          setState(() {});
                                        } else {
                                          //displayToast(Msg);
                                        }
                                      },


                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      getButtonColor(tripMsg ?? "Not a value"),
                                ),
                                child: const Text(
                                  "START TRIP",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 15),

                              ElevatedButton(
                                onPressed: isTripStarted
                                    ? () async {
                                        // Your trip stop API logic
                                        SharedPreferences prefs =
                                            await SharedPreferences.getInstance();
                                        var edtOdometer = _takeAction.text;
                                        String? sContactNo =
                                            prefs.getString('sContactNo');
                                        String? sTranNo =
                                            prefs.getString('sTranNo');

                                        if (_formKey.currentState!.validate() &&
                                            edtOdometer != null &&
                                            uplodedImage != null) {
                                          var tripEnd = await HrmstripEndRepo()
                                              .tripEnd(
                                                  context,
                                                  sContactNo!,
                                                  lat,
                                                  long,
                                                  sTranNo!,
                                                  uplodedImage,
                                                  edtOdometer,
                                                  dTripDateTime);

                                            print('----572---$tripEnd');

                                          String Msg = "${tripEnd[0]['Msg']}";
                                          String Result = "${tripEnd[0]['Result']}";

                                          prefs.setString('tripMsg', Msg);
                                          setState(() {
                                            tripMsg = Msg;
                                            isTripStarted = false;
                                          });
                                          print('-----576---$tripMsg');

                                          _takeAction.clear();
                                          image == null;
                                          print('---487---$tripMsg');
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return _buildDialogSucces2(
                                                    context, tripMsg!);
                                              }
                                          );
                                          // Dialog logic and other actions
                                        } else {
                                          if (edtOdometer == null ||
                                              edtOdometer == '') {
                                            print('----print---424---');
                                            displayToast('Enter Odometer details ');
                                          } else if (uplodedImage == null ||
                                              uplodedImage == '') {
                                            displayToast('Please click Odometer image');
                                            //print('----print---424---');
                                          }
                                          print('---Api not call---');
                                          // displayToast('Click Photo');
                                        }
                                        if (Result == "1") {
                                          // displayToast(Msg);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return _buildDialogSucces2(
                                                  context, Msg);
                                            },
                                          );
                                          setState(() {});
                                        } else {
                                          //displayToast(Msg);
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: getButtonColorStoptrip(
                                      tripMsg ?? "Not a value"),
                                ),
                                child: const Text(
                                  "STOP TRIP",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // ElevatedButton(
                              //    onPressed: () async {
                              //      var sImage;
                              //      var edtOdometer = _takeAction.text;
                              //      SharedPreferences prefs = await SharedPreferences.getInstance();
                              //      String? sContactNo = prefs.getString('sContactNo');//  tripMsg
                              //
                              //      if(_formKey.currentState!.validate() && edtOdometer != null && uplodedImage != null){
                              //           print('---Api call---');
                              //         var  tripStart = await HrmstripstartendRepo().tripStart(context, sContactNo!,lat,long,randomNumber,uplodedImage,edtOdometer,dTripDateTime);
                              //         print('---380--$tripStart');
                              //
                              //           Msg = "${tripStart[0]['Msg']}";
                              //           sTranNo = "${tripStart[0]['sTranNo']}";
                              //           Result = "${tripStart[0]['Result']}";
                              //           /// todo here you should short sTranNo
                              //           SharedPreferences prefs = await SharedPreferences.getInstance();
                              //           prefs.setString('sTranNo',sTranNo);
                              //           prefs.setString('tripMsg',Msg);
                              //           print('---423---msg--$Msg');
                              //
                              //      }else{
                              //        if(edtOdometer==null || edtOdometer==''){
                              //          print('----print---424---');
                              //          displayToast('Enter Odometer details ');
                              //        }else if(uplodedImage==null || uplodedImage==''){
                              //          displayToast('Please click Odometer image');
                              //          //print('----print---424---');
                              //        }
                              //        print('---Api not call---');
                              //       // displayToast('Click Photo');
                              //      }
                              //      if(Result=="1"){
                              //       // displayToast(Msg);
                              //        showDialog(
                              //          context: context,
                              //          builder: (BuildContext context) {
                              //            return _buildDialogSucces2(context,Msg);
                              //          },
                              //        );
                              //        setState(() {
                              //
                              //        });
                              //      }else{
                              //        //displayToast(Msg);
                              //      }
                              //      /// todo here you get record value and hit the api
                              //    },
                              //
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: getButtonColor(tripMsg ?? "Not a value") // Hex color code (FF for alpha, followed by RGB)
                              //     ),
                              //     child: const Text(
                              //       "START TRIP",
                              //       style: TextStyle(
                              //           fontFamily: 'Montserrat',
                              //           color: Colors.white,
                              //           fontSize: 16.0,
                              //           fontWeight: FontWeight.bold),
                              //     )),
                              //
                              // SizedBox(height: 15),
                              // ElevatedButton(
                              //     onPressed: () async {
                              //       var sImage;
                              //       var edtOdometer = _takeAction.text;
                              //       SharedPreferences prefs = await SharedPreferences.getInstance();
                              //       String? sContactNo = prefs.getString('sContactNo');
                              //       String? sTranNo = prefs.getString('sTranNo');
                              //
                              //       if(_formKey.currentState!.validate() && edtOdometer != null && image != null){
                              //         print('---Api call---');
                              //         var  tripEnd = await HrmstripEndRepo().tripEnd(context, sContactNo!,lat,long,sTranNo!,uplodedImage,edtOdometer,dTripDateTime);
                              //         print('---425--$tripEnd');
                              //         Msg = "${tripEnd[0]['Msg']}";
                              //         sTranNo = "${tripEnd[0]['sTranNo']}";
                              //         Result = "${tripEnd[0]['Result']}";
                              //         // todo
                              //         SharedPreferences prefs = await SharedPreferences.getInstance();
                              //         prefs.setString('sTranNo',sTranNo);
                              //         prefs.setString('tripMsg',Msg);
                              //         setState(() {
                              //         });
                              //         String? msgg = prefs.getString('tripMsg');
                              //         print('---517---$Msg');
                              //         print('---519---$msgg');
                              //
                              //
                              //
                              //       }else{
                              //         print('---Api not call---');
                              //       }
                              //       if(Result=="1"){
                              //        // displayToast(Msg);
                              //        // _buildDialogSucces2(context,Msg);
                              //         showDialog(
                              //           context: context,
                              //           builder: (BuildContext context) {
                              //             return _buildDialogSucces2(context,Msg);
                              //           },
                              //         );
                              //         setState(() {
                              //
                              //         });
                              //       }else{
                              //         displayToast(Msg);
                              //       }
                              //       /// todo here you get record value and hit the api
                              //     },
                              //     style: ElevatedButton.styleFrom(
                              //      // backgroundColor: Color(0xFF0098a6), // Hex color code (FF for alpha, followed by RGB)
                              //       backgroundColor : getButtonColorStoptrip(tripMsg ?? "Not a value"),
                              //     ),
                              //     child: const Text(
                              //       "STOP TRIP",
                              //       style: TextStyle(
                              //           fontFamily: 'Montserrat',
                              //           color: Colors.white,
                              //           fontSize: 16.0,
                              //           fontWeight: FontWeight.bold),
                              //     )),
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

  // tripSuccessDialog
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashBoard()),
                        );

                        // Navigator.of(context).pop();
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
                  'assets/images/sussess.jpeg', // Replace with your asset image path
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
  //
}
