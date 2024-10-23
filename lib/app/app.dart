import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/presentation/dashboard/dashboard.dart';
import 'package:untitled/presentation/login/loginScreen.dart';

import '../presentation/attendancelist/attendancelist.dart';
import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';
import '../presentation/splash/splash.dart';


class MyApp extends StatefulWidget {

  MyApp._internal(); // private named constructor
  int appState = 0;
  static final MyApp instance = MyApp._internal(); // single instance -- singleton
  factory MyApp() => instance; // factory for the class instance
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> checkPermissions() async {
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

  @override
  void initState() {
    // TODO: implement initState
    checkPermissions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const SplashView(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/loginScreen': (context) => const LoginScreen(),
        // dashboardScreen
        '/dashBoard': (context) => const DashBoard(),
      },

     // localizationsDelegates: context.localizationDelegates,
      //supportedLocales: context.supportedLocales,
      //locale: context.locale,
      builder: EasyLoading.init(),
     // debugShowCheckedModeBanner: false,
      //onGenerateRoute: RouteGenerator.getRoute,
       //initialRoute: Routes.splashRoute,
       //onGenerateRoute: RouteGenerator.getRoute,
      theme: getApplicationTheme(),
    );
  }
}
