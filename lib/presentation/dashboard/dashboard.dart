import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/applyleave/applyLeave.dart';
import 'package:untitled/presentation/profile/profile.dart';
import '../../app/generalFunction.dart';
import '../../data/hrmsattendance.dart';
import '../../data/hrmsupdategsmidios.dart';
import '../../data/loader_helper.dart';
import '../attandanceCalendar/customCalendarScreen.dart';
import '../attendancelist/attendancelist.dart';
import '../expensemanagement/expense_management.dart';
import '../holiday/holidaylist.dart';
import '../markAttendance/markAttendance.dart';
import '../notification/notification.dart';
import '../policydoc/policydoc.dart';
import '../resources/app_text_style.dart';
import '../setpin/setpin.dart';
import '../userquery/userQuery.dart';
import '../workdetail/workdetail.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';



class DashBoard extends StatelessWidget {

  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // change StatusBarColore
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      home: DashBoardHomePage(),
    );
  }
}

class DashBoardHomePage extends StatefulWidget {

  const DashBoardHomePage({super.key});

  @override
  State<DashBoardHomePage> createState() => _DashBoardHomePageState();
}

class _DashBoardHomePageState extends State<DashBoardHomePage> {

  GeneralFunction generalFunction = GeneralFunction();

  double? lat, long;
  var sFirstName, sCompEmailId, sLastName, fullName;
  var token;
  var locationAddress;
  String _version = '';

  // internet Connectivity
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // DialogBo

  Widget _buildDialogSucces(BuildContext context) {
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
            height: 170,
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Space for the image
                const Row(
                  children: [
                    Icon(
                      Icons.error_outline, // Exclamation icon
                      color: Colors.red, // Color of the icon
                      size: 22, // Size of the icon
                    ),
                    SizedBox(width: 8), // Spacing between the icon and text
                    Text(
                      'Attendance Confirmation',
                      style: TextStyle(
                        fontSize: 16, // Adjust font size
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.black, // Text color
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded( // Wrap the text in Expanded to allow it to take available space and wrap
                  child: Text(
                    "Are you sure you want to mark today's attendance?",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.left,
                    // Align the text to the left
                    softWrap: true,
                    // Allow text to wrap
                    maxLines: 2,
                    // Set the maximum number of lines the text can take
                    overflow: TextOverflow.ellipsis, // Add ellipsis if the text exceeds the available space
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 35,
                  // Reduced height to 35
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    border: Border.all(color: Colors.grey), // Border color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            //generalFunction.logout(context);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // Remove default padding
                            minimumSize: Size(0, 0),
                            // Remove minimum size constraints
                            backgroundColor: Colors.white,
                            // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              color: Colors.red,
                              // Text color for "Yes"
                              fontSize: 12,
                              // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.grey, // Divider color
                        width: 20, // Space between buttons
                        thickness: 1, // Thickness of the divider
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            //getLocation();
                            checkInternetAndGetLocation();
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // Remove default padding
                            minimumSize: Size(0, 0),
                            // Remove minimum size constraints
                            backgroundColor: Colors.white,
                            // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              color: Colors.green,
                              // Text color for "No"
                              fontSize: 12,
                              // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
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
    );
  }

  // logoutdialog
  Widget _logoutDialog(BuildContext context) {
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
            height: 160,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Logout',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                Text(
                  "Do you want to Logout ?",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Container(
                  height: 35,
                  // Reduced height to 35
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    border: Border.all(color: Colors.grey), // Border color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            generalFunction.logout(context);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // Remove default padding
                            minimumSize: Size(0, 0),
                            // Remove minimum size constraints
                            backgroundColor: Colors.white,
                            // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              color: Colors.green,
                              // Text color for "Yes"
                              fontSize: 12,
                              // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey, // Divider color
                        width: 20, // Space between buttons
                        thickness: 1, // Thickness of the divider
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // Remove default padding
                            minimumSize: Size(0, 0),
                            // Remove minimum size constraints
                            backgroundColor: Colors.white,
                            // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              color: Colors.red,
                              // Text color for "No"
                              fontSize: 12,
                              // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  'assets/images/logoutnew.jpeg',
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
                // Text(
                //   msg,
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey[600],
                //   ),
                //   maxLines: 2,
                //   textAlign: TextAlign.center,
                // ),
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
                // Text(
                //   msg,
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey[600],
                //   ),
                //   maxLines: 2,
                //   textAlign: TextAlign.center,
                // ),
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
  // getInternetAndLocation
  // void checkInternetAndGetLocation() async {
  //   (await isInternetAvailable())
  //       ? getLocation()
  //       : displayToast("Please connect internet");
  // }
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

  // get a location :
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
        attendaceapi(lat, long, locationAddress);
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

  // toast
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

  getLocalDataInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // get a stored value
    setState(() {
      sFirstName = prefs.getString('sFirstName');
      sLastName = prefs.getString('sLastName');
      fullName = "$sFirstName $sLastName";
      sCompEmailId = prefs.getString('sCompEmailId');
    });
  }

  // firebase get token code---

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    token = await fcm.getToken();
    print("🔥 Firebase Messaging Instance Info:");
    print("📌 Token:----550----xxx $token");

    NotificationSettings settings = await fcm.getNotificationSettings();
    print("🔔 Notification Permissions:");
    print("  - Authorization Status: ${settings.authorizationStatus}");
    print("  - Alert: ${settings.alert}");
    print("  - Sound: ${settings.sound}");
    print("  - Badge: ${settings.badge}");

    // ✅ Ensure notifications play default sound
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 New foreground notification received!");
      print("📦 Data Payload----563---xx--: ${message.data}");
      if (message.notification != null) {
        _showNotification(message.notification!);
      }
    });

    if (token != null && token!.isNotEmpty) {
      notificationResponse(token);
    } else {
      print("🚨 No Token Received!");
    }
  }

// ✅ Show Notification with Default Sound
  void _showNotification(RemoteNotification notification) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true, // 🔊 Ensure sound is enabled
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentSound: true, // 🔊 Enable sound for iOS
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      notification.title,
      notification.body,
      details,
    );
  }

  notificationResponse(token) async {
   var   Notiresponse = await HrmsUpdateGsmidIosRepo().updateGsmidIos(context,token);
   print("-----517---notification Response----$Notiresponse");

  }
  // get a packageVersion
  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _version = packageInfo.version;
    });
    print("-----770---$_version");
  }
  @override
  void initState() {
    // TODO: implement initState
     isInternetAvailable();
     getLocalDataInfo();
     setupPushNotifications();
     getAppVersion();
     super.initState();
     // firebase foreground msg
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       // Handle the foreground notification here
       print("Received message:---530-- ${message.notification?.title}");
       // You can show a dialog or display the notification in the UI
       // dialog
       showDialog(
         context: context,
         builder: (_) => AlertDialog(
           title: Text(message.notification?.title ?? 'New Notification',style:AppTextStyle.font12OpenSansRegularBlackTextStyle),
           content: Text(message.notification?.body ?? 'You have a new message',style: AppTextStyle.font12OpenSansRegularBlackTextStyle),
         ),
       );
     });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  @override
  Widget build(BuildContext context) {
    // change status bar colore
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
            // appBar
          appBar: AppBar(
              // statusBarColore
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Color(0xFF2a697b),
                statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
             // backgroundColor: Colors.blu
              backgroundColor: Color(0xFF0098a6),
             title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Welcome, Have a nice day !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              //centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                 // child: Icon(Icons.logout, size: 24,color: Colors.white),
                  child:  InkWell(
                    onTap: (){
                      // logout function
                     // _showlogoutDialog(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _logoutDialog(context);
                        },
                      );
                      },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0), // Optional: add rounded corners if needed
                      child: Image.asset(
                        'assets/images/logout2.jpeg',
                        fit: BoxFit.contain, // Ensure the image fits properly in the container
                      ),
                    ),

                  )
                ),
              ],
              elevation: 0, // Removes shadow under the AppBar
            ),
          // drawer
          drawer: generalFunction.drawerFunction(context,'$fullName','$sCompEmailId'),
          body: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 170.0, // Set the height of the container
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/leave.jpeg"),
                         // image: AssetImage(ImageAssets.deshboardtop), // Path to your asset image
                          fit: BoxFit.cover, // Adjust the image to cover the container
                        ),
                      ),
                    ),
                        Positioned(
                          bottom: 10, // Position from the bottom
                          right: 28,  // Position from the right
                          child: Text(
                            'Version $_version',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 12,        // Text size
                              fontWeight: FontWeight.bold, // Text style
                            ),
                          ),
                        ),
                  ],
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                        crossAxisCount: 3,
                        primary: false,
                        crossAxisSpacing: 5.0,
                        childAspectRatio: 0.95,
                        mainAxisSpacing: 5.0,
                        shrinkWrap: true,
                        children: <Widget>[
                          // profile
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Profile()),
                              );
                              },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_profile_dashboard.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Profile",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // markAttendance
                          GestureDetector(
                            onTap: (){
                              /// todo this is a dialog to take a attendance.
                              //
                              // showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //   return _buildDialogSucces(context);
                              // },
                              // );
                              ///   todo here i want to create a new widget to take a attendance.

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MarkAttendanceScreen()),
                              );


                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_reminder_dashboard.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Mark Attendance",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // AttendanceList
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Attendancelist()),
                              );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/attendancelist.jpeg', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Attendance List",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Second Part
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CustomCalendarScreen()),
                              );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_attendance_dashboard.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Attandance",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Applyleave()),
                              );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_leave_dashboard.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Apply Leave",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Setpin()),
                              );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_payslip.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Pay Slip",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // third Part
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PolicyDoc()
                                ),
                              );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_policy_dashboard.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Policy Doc",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HolidaylistScreen()),
                              );
                            },

                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_holiday_dashboard.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Holiday",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                        // style: TextStyle(
                                        //   fontFamily: 'Quicksand',
                                        //   fontSize: 12.0,
                                        //   fontWeight: FontWeight.normal,
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Userquery()),
                              );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_user_query_dashboard.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "User Query",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // fourth part
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ExpenseManagement()),
                              );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset('assets/images/ic_expeses.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Expense Management",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => WorkDetail()),
                                    (Route<dynamic> route) => false, // Remove all previous routes
                              );
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => WorkDetail()),
                              // );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset('assets/images/ic_master_work_status.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Work Detail",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NotificationPage()),
                              );
                            },
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      shape: BoxShape.circle, // Container shape
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/ic_announcement.PNG', // Replace with your SVG asset
                                          fit: BoxFit.contain, // Ensure the SVG fits within the container
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "Notification",
                                        textAlign: TextAlign.center, // Center align the text
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
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
              ],
          ),
        ),
      ),
    );
  }

}



