import 'package:flutter/material.dart';
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
 // AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  void didChangeDependencies() {
    //_appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // localizationsDelegates: context.localizationDelegates,
      //supportedLocales: context.supportedLocales,
      //locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashView(),
        '/loginScreen': (context) => const LoginScreen(),
        '/dashBoard': (context) => const DashBoard(),
        '/attendancelist': (context) => const Attendancelist(),
        // Add other routes here
      },
     // debugShowCheckedModeBanner: false,
      //onGenerateRoute: RouteGenerator.getRoute,
    //  initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
