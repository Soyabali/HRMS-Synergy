import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/login/loginScreen.dart';
import 'package:untitled/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/appversionrepo.dart';
import '../dashboard/dashboard.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';


class SplashView extends StatefulWidget {

  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  var sContactNo;
  Timer? _timer;
  // to check Internet is connected or not
  bool activeConnection = false;
  String T = "";

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
          versionAliCall();
          //displayToast(T);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
        displayToast(T);
      });
    }
  }
  void _launchGooglePlayStore() async {
    const url = 'https://play.google.com/store/apps/details?id=com.instagram.android&hl=en_IN&gl=US'; // Replace <YOUR_APP_ID> with your app's package name
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void displayToast(String msg) {
    Fluttertoast.showToast(
      msg,
      duration: Duration(seconds: 1),
      position: Fluttertoast.ToastPosition.center,
      backgroundColor: Colors.black45,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }
  // void displayToast(String msg){
  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  // }
  // local database
  getLocalDataInfo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // get a stored value
    setState(() {
    var  sFirstName = prefs.getString('sFirstName');
    var  sCompEmailId = prefs.getString('sCompEmailId');
    if(sFirstName!=null && sFirstName!=''){
      // to Open DashBoard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoard()),
            (Route<dynamic> route) => false, // Remove all previous routes
      );
       //print("------84---$sFirstName");
    }else{
     // print("------86---$sFirstName");
      // call the Api
     checkUserConnection();
    }
    });
  }
  //
  Future<void> getUserValueFromLocalDataBase() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sEmpCode = prefs.getString('sEmpCode');

    if (sEmpCode != null && sEmpCode.isNotEmpty) {
      print("-------97---xx--->>>>-$sEmpCode");
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const DashBoard()),
      // );

    } else {
      print("-------104--xx---->>>>>--$sEmpCode");
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const LoginScreen()),
      // );

    }
  }


  @override
  void initState() {
    super.initState();
    getLocalDataInfo();
    //checkUserConnection();

  }
  //
  Future<void> _checkPermissions() async {
    //var status = await Permission.location.status;
    var status = await Permission.location.status;

    if (status.isGranted) {
      // Permission is granted, continue with your logic.
      print("Location permission granted.");
    } else if (status.isDenied) {
      // Request permission.
      var newStatus = await Permission.location.request();
      if (newStatus.isGranted) {
        // Permission granted, continue.
        print("Location permission granted.");
      } else if (newStatus.isPermanentlyDenied) {
        // Show a message directing users to settings.
        _showPermissionDeniedDialog();
      }
    } else if (status.isPermanentlyDenied) {
      // Show a message directing users to settings.
      _showPermissionDeniedDialog();
    }
  }
  // show permissinDialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text("Please enable location permissions in settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Redirects to app settings.
            },
            child: Text("Settings"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
  // version api call
  versionAliCall() async {
    /// TODO HERE YOU SHOULD CHANGE APP VERSION FLUTTER VERSION MIN 3 DIGIT SUCH AS 1.0.0
    /// HERE YOU PASS variable _appVersion
    var loginMap = await AppVersionRepo().appversion(context,'19');  //  16
    var result = "${loginMap[0]['Msg']}";
     var msg = "${loginMap[0]['sVersonName']}";
     print('----117---$result');

     if(result=="1"){

       Navigator.pushNamed(
         context,
         '/loginScreen',
       );
     }else{
      showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Version Available'),
            content: const Text('Download the latest version of the app from the Play Store.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _launchGooglePlayStore(); // Close the dialog
                },
                child: const Text('Downlode'),
              ),

            ],
          );
        },
      );
      displayToast(msg);
      //print('----F---');
    }
  }
  //

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(
          height: AppPadding.p150,
          width: AppPadding.p150,
          image: AssetImage(ImageAssets.passwordlogin),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
