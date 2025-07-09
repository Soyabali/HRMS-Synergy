import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/dashboard/dashboard.dart';
import '../../data/loader_helper.dart';
import '../../data/hrmsattendance.dart';
import '../resources/app_text_style.dart';

class MarkAttendanceScreen extends StatefulWidget {

  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {

  bool isChecked = false;
  String? timeString = "Loading...";
  Timer? _timer;

   var fullName,sEmpImage,sContactNo,sDsgName,sLocName;
   var imageurl ;
  double? lat, long,distanceInMeters;
  var locationAddress;
  DateTime? internetTime;
  var timeInternet;
  double staticLat =  27.20354;
  double staticLng = 78.00586;
  double threshold = 100.00;
  var locationCheck;

  double calculateDistanceInMeters(
      double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

   @override
  void initState() {
    // TODO: implement initState
     getLocalDatabaseValue();
     checkInternetAndGetLocation();
     _startUpdatingTime();
     checkLocationService();
    // getCurrentLocationInMeter();
     // calculate distance
     super.initState();
      imageurl = "https://picsum.photos/200";
  }

  // gps is on or off
  Future<void> checkLocationService() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print("🔴 Location services are OFF");
      locationCheck="Off";
      print('-----71---$locationCheck');
      // You can prompt user to turn it on
    } else {
      print("🟢 Location services are ON");
      locationCheck="On";
      print('-----76--OFF---$locationCheck');
      // Safe to proceed with location tasks
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  void _startUpdatingTime() async {
    // Initial fetch
    await _fetchInternetTime();

    // Update every second
    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      await _fetchInternetTime();
    });
  }

  Future<void> _fetchInternetTime() async {
    try {
      final response = await http.get(Uri.parse('https://google.com'));
      final dateHeader = response.headers['date'];
      if (dateHeader != null) {
        final utcTime = HttpDate.parse(dateHeader);
        final istTime = utcTime.add(Duration(hours: 5, minutes: 30));
        final formatted = DateFormat('HH:mm:ss').format(istTime);
        setState(() {
          timeString = formatted;
        });
      } else {
        setState(() {
          timeString = "Time Error";
        });
      }
    } catch (e) {
      setState(() {
        timeString = "Network Error";
      });
    }
  }

  getLocalDatabaseValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sFirstName = prefs.getString('sFirstName');
    String? sLastName = prefs.getString('sLastName');

    setState(() {
      fullName = "${sFirstName} ${sLastName}";
      sEmpImage = prefs.getString('sEmpImage');
      sContactNo = prefs.getString('sContactNo');
      sDsgName = prefs.getString('sDsgName');
      sLocName = prefs.getString('sLocName');
    });

    print('---fullName--$fullName');
    print('---sEmpImage--$sEmpImage');
    print('---sContactNo--$sContactNo');
    print('---sDsgName--$sDsgName');
    print('------location-----105---$sLocName');
  }

  //  location function process
  void checkInternetAndGetLocation() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print("-------551----Internet Connectivity----$connectivityResult");
    if (connectivityResult != ConnectivityResult.none) {
      // Internet is available
      getLocation(); // Call your existing function
    } else {
      // No internet
      displayToast("Please connect internet");
    }
  }
  // toast function
  void displayToast(String msg) {
    Fluttertoast.showToast(
      msg,
      duration: Duration(seconds: 2),
      position: Fluttertoast.ToastPosition.center,
      backgroundColor: Colors.red,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }
  // getLocation function
  void getLocation() async {
    showLoader();
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      hideLoader();
      displayToast("Location services are disabled. Please enable them in settings.");
      // AppSettings.openLocationSettings(); // Redirect to location settings
      AppSettings.openAppSettings();// on ios to open a settongs
      return;
    }
    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        hideLoader();
        displayToast("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      hideLoader();
      displayToast("Location permission permanently denied. Please enable it in app settings.");
      AppSettings.openAppSettings(); // Redirect to app settings
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        lat = position.latitude;
        long = position.longitude;
        locationAddress = address;
      });

      print('Address: $locationAddress');
      print('Latitude: $lat');
      print('Longitude: $long');

      if (lat != null && long != null) {
        hideLoader();
        print('---------210----$lat');
        print('---------211----$long');
        // call a distance metrics.
         distanceInMeters = calculateDistanceInMeters(
            staticLat, staticLng, lat!, long!);

        print('-----216---Distance in M---$distanceInMeters');

        /// TODO HERE YOU SHOULD NOT CALL A ATTENDACE API YOU SHOULD CAL THIS API
        /// ON A SUBMIT BUTTON
       // attendaceapi(lat, long, locationAddress);
      } else {
        displayToast("Please select your location to proceed.");
      }
    } catch (e) {
      hideLoader();
      displayToast("Failed to get location: $e");
    } finally {
      hideLoader();
    }
  }
  /// Attendance repo
  attendaceapi(double? lat, double? long, locationAddress) async {
    var attendance = await HrmsAttendanceRepo().hrmsattendance(
        context, lat, long,locationAddress);
    print("---Attendace response-----494-----$attendance");

    if (attendance != null) {
      var msg = "${attendance[0]['Msg']}";
      var result = "${attendance[0]['Result']}";
      setState(() {

      });
      // here you should apply logic if result 0 then show info Dialog otherwise show
      // sucess Dialog
      if(result==0){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _buildDialogSucces2(context, msg);
          },
        );
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _buildDialogInfo(context, msg);
          },
        );
      }
      // dialog
      /// todo mark Attendance Success Dialog

    } else {
      displayToast("Attendance not confirmed.");
    }
  }
  // ---build dialog sucess
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
            height: 210,
            padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Success',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.justify, // Justify the text
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // Set the background color to white
                        foregroundColor: Colors
                            .black, // Set the text color to black
                      ),
                      child: Text('Ok', style: AppTextStyle
                          .font16OpenSansRegularBlackTextStyle),
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
  // dialoginfo
  Widget _buildDialogInfo(BuildContext context, String msg) {
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
            height: 210,
            padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Information',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.justify, // Justify the text
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // Set the background color to white
                        foregroundColor: Colors
                            .black, // Set the text color to black
                      ),
                      child: Text('Ok', style: AppTextStyle
                          .font16OpenSansRegularBlackTextStyle),
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
                  'assets/images/information.jpeg',
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
    // statusBarColore
    systemOverlayStyle: SystemUiOverlayStyle(
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
    'Mark Attendance',
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
        //padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌈 Gradient Card with Overlapping Info Card
            Stack(
              children: [
                // 🔲 Background White Container (acts as base)
                Container(
                  height: 285, // outer container
                  color: Colors.white,
                ),
                // 🎨 Inner Gradient Container
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 240,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00B3C6), Color(0xFF2A687C)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                       // mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: Image.network(
                            sEmpImage ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/actionOnLeave.jpeg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              );
                            },
                          ),
                        ),
                        ),
                          SizedBox(height: 5),
                          Text(
                            fullName ?? "No name",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 2),
                          Text(
                            sDsgName ?? "No Designation",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 📦 Overlapping Bottom Container
                Positioned(
                  top: 190, // overflows above the 400 height container
                  left: 10,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // Rounded edges
                      ),
                      elevation: 6,
                      shadowColor: Colors.black26, // Stronger shadow visibility
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            // 📱 Left Side - Contact Info
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/phone.png',
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sContactNo ?? "No Contact",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "Mobile No",
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // 🟨 Divider
                            // Container(
                            //   width: 1,
                            //   height: 45,
                            //   color: Colors.grey.shade400,
                            //   margin: const EdgeInsets.symmetric(horizontal: 10),
                            // ),

                            // 📍 Right Side - Location Info
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Image.asset(
                                        'assets/images/location1.png',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sLocName ?? "No Location",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "Location",
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // ✅ Rounded corners
                ),
                elevation: 6, // ✅ Stronger elevation
                shadowColor: Colors.black26, // ✅ More visible shadow
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12), // ✅ Same radius as Card
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 🟩 Left side
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                timeString ?? "No time",
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ⬛ Right side
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(
                                'assets/images/clock.png',
                                fit: BoxFit.contain,
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
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // ✅ Rounded corners
                ),
                elevation: 6, // ✅ Stronger elevation
                shadowColor: Colors.black26, // ✅ Visible shadow
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // ✅ Match Card radius
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 🟩 Left Half - Location Text
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  locationCheck =='On'?
                                  Text(
                                    '(GPS ON)',
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                  ):
                                  Text(
                                    '(GPS OFF)',
                                    style: GoogleFonts.poppins(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 2),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Text(
                                    locationAddress ?? "No Address Found",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black38,
                                      fontSize: 12,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ⬛ Right Half - Google Map Icon
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            checkInternetAndGetLocation();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset(
                                  'assets/images/ic_google_map_location.png',
                                  fit: BoxFit.contain,
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
            SizedBox(height: 5),
            sLocName!="Noida" ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // ✅ Rounded corners
                ),
                elevation: 6,
                shadowColor: Colors.black26, // ✅ Stronger shadow
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 🟩 Left Half
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Agra Smart City Limited',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 5),

                                  // ✅ Distance Text (Dynamic)
                                  if (distanceInMeters != null)
                                    Expanded(
                                      child: Text(
                                        distanceInMeters! > threshold
                                            ? 'Too far: ${distanceInMeters!.toStringAsFixed(2)} meters'
                                            : 'Within range: ${distanceInMeters!.toStringAsFixed(2)} meters',
                                        style: TextStyle(
                                          color: distanceInMeters! > threshold ? Colors.red : Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  else
                                    const Text(
                                      'Calculating distance...',
                                      style: TextStyle(color: Colors.grey, fontSize: 10),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ⬛ Right Half (Image)
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(
                                'assets/images/agralocation.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            :Container(),

            SizedBox(height: 5),
            ElevatedButton(
        onPressed: () {
          if (lat != null && long != null) {
            hideLoader();
            attendaceapi(lat, long, locationAddress);
          } else {
            displayToast("Please select your location to proceed.");
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color(0xFF00B3C6), // ✅ Converted hex color with 100% opacity
          ),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          shape: MaterialStateProperty.all(
            const StadiumBorder(),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.grey.shade300; // Ripple color on press
              }
              return null;
            },
          ),
        ),
        child: Text(
          'Submit',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          ],
        ),
      ),
    );
  }

}
