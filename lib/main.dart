import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/app.dart';

void main()
{
  /// TOD0  RUNTIME PERMISSION ON

  _requestPermissions();
  runApp(MyApp());
  configLoading();
}

configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
Future<void> _requestPermissions() async {
  // Check the status of location permission
  var locationStatus = await Permission.location.status;
  if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
    // Request location permission
    await Permission.location.request();
  }

  // Check the status of camera permission
  var cameraStatus = await Permission.camera.status;
  if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
    // Request camera permission
    await Permission.camera.request();
  }

  // You can request other permissions similarly
}