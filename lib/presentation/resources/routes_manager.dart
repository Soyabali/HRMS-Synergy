import 'package:flutter/material.dart';
import 'package:untitled/presentation/resources/strings_manager.dart';
import '../dashboard/dashboard.dart';
import '../login/loginScreen.dart';
import '../splash/splash.dart';


class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String dashboardRoute = "/dashboard";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}
class RouteGenerator
{
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
           return MaterialPageRoute(builder: (_) => SplashView());
        case Routes.loginRoute:
      //  initLoginModule();
        return MaterialPageRoute(builder: (_) => LoginScreen());
       case Routes.dashboardRoute:
        return MaterialPageRoute(builder: (_) => DashBoard());
      //case Routes.registerRoute:
        //initRegisterModule();
       //  return MaterialPageRoute(builder: (_) => DashBoard());
      // case Routes.forgotPasswordRoute:
      //   initFogotPasswordModule();
      //   return MaterialPageRoute(builder: (_) => ForgotPasswordView());
      // case Routes.mainRoute:
      //    initHomeModule();
      //   return MaterialPageRoute(builder: (_) => MainView());
      // case Routes.storeDetailsRoute:
      //   initStoreDetailsModule();
      //   return MaterialPageRoute(builder: (_) => StoreDetailsView());
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
