import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

      // routes: {
      //   '/': (context) => SplashView(),
      //   '/loginScreen': (context) => LoginScreen(),
      //   '/dashBoard': (context) => DashBoardHomePage(),
      // },


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
