import 'package:flutter/material.dart';
import 'package:untitled/presentation/resources/strings_manager.dart';
import '../attendancelist/attendancelist.dart';
import '../dashboard/dashboard.dart';
import '../login/loginScreen.dart';
import '../splash/splash.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String dashboardRoute = "/dashboard";
  static const String homeRoute = "/home";
  static const String attendanceListRoute = "/attendancelist";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}
class RouteGenerator
{
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    print('Navigating to--20--xxxx---x: ${routeSettings.name}');
    switch (routeSettings.name) {
      case Routes.splashRoute:
           return MaterialPageRoute(builder: (_) => SplashView());
        case Routes.loginRoute:
      //  initLoginModule();
        return MaterialPageRoute(builder: (_) => LoginScreen());
        case Routes.dashboardRoute:
        return MaterialPageRoute(builder: (_) => DashBoard());
        case Routes.attendanceListRoute:
        return MaterialPageRoute(builder: (_) => Attendancelist());
        default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound),
              ),
              body: Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
