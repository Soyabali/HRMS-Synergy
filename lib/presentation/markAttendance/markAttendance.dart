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
import 'dart:convert';
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

  var fullName, sEmpImage, sContactNo, sDsgName, sLocName;
  var imageurl;
  double? lat, long, distanceInMeters;
  var locationAddress;
  DateTime? internetTime;
  var timeInternet;
  double staticLat =  27.20354; //27.20354;  //27.20354;
  double staticLng =  78.00586;//78.00586;   //78.00586;
  double threshold = 100.00;
  var locationCheck;
  //var locationCode="6084110826"; // Agra
  //  8482110634  // noida code
  var sLocCode;

  double calculateDistanceInMeters(
      double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  @override
  void initState() {
    // TODO: implement initState
    checkLocationService();
    getLocalDatabaseValue();
   // checkInternetAndGetLocation();

    _startUpdatingTime();
    Future.delayed(Duration(milliseconds: 500), () {
      checkInternetAndGetLocation();
    });

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
      locationCheck = "Off";
      print('-----71---$locationCheck');
      // You can prompt user to turn it on
    } else {
      print("🟢 Location services are ON");
      locationCheck = "On";
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
    sLocCode = prefs.getString('sLocCode');
    print("------128----xx---$sLocCode");
    // sLocCode

    setState(() {
      fullName = "${sFirstName} ${sLastName}";
      sEmpImage = prefs.getString('sEmpImage');
      sContactNo = prefs.getString('sContactNo');
      sDsgName = prefs.getString('sDsgName');
      sLocName = prefs.getString('sLocName');
      sLocCode = prefs.getString('sLocCode');
    });

    print('---fullName--$fullName');
    print('---sEmpImage--$sEmpImage');
    print('---sContactNo--$sContactNo');
    print('---sDsgName--$sDsgName');
    print('------location-----105---$sLocName');
    print('------sLocCode -----146---$sLocCode');
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
  Future<void> getLocation() async {
    showLoader();

    // 1) check location service & permissions (keeps your existing logic)
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      hideLoader();
      displayToast("Location services are disabled. Please enable them in settings.");
      AppSettings.openAppSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
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
      AppSettings.openAppSettings();
      return;
    }

    try {
      // 2) Try to get a stable/accurate position using getPositionStream for a short window
      Position? best;
      final stream = Geolocator.getPositionStream(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 0));
      final completer = Completer<Position>();
      Timer timeout = Timer(Duration(seconds: 6), () {
        if (!completer.isCompleted) {
          completer.completeError('timeout');
        }
      });

      final sub = stream.listen((pos) {
        // pick first position with acceptable accuracy, or keep best seen
        if (best == null || (pos.accuracy < best!.accuracy)) {
          best = pos;
        }
        if (pos.accuracy <= 25) { // threshold: 25 meters is pretty good
          if (!completer.isCompleted) completer.complete(pos);
        }
      });

      // If we get no good fix within the timeout, fall back
      Position position;
      try {
        position = await completer.future;
      } catch (_) {
        // did not get a good stream position in time — fall back to single call
        position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } finally {
        timeout.cancel();
        await sub.cancel();
      }

      // 3) Reverse geocode using Google Geocoding API for accurate address
      print("-----239----xxx-----${position.latitude}");
      print("-----240----xxx-----${position.longitude}");

      String address = '';

      try {
        // Get Google API key from config or SharedPreferences
        // TODO: Store your API key securely. For now, replace 'YOUR_GOOGLE_API_KEY' with your actual key
        // Best practice: Use environment variables or secure storage instead
        const googleApiKey = 'AIzaSyAkUfhrldqKHWEk5wEHLrTTPSaURHcmwPQ';

        // Only proceed if API key is configured (check if it's not the placeholder)
        if (googleApiKey.isNotEmpty && !googleApiKey.contains('YOUR_GOOGLE_API_KEY')) {
          final geocodeUrl = Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json'
            '?latlng=${position.latitude},${position.longitude}'
            '&language=en'
            '&key=$googleApiKey',
          );

          final geocodeResp = await http.get(geocodeUrl).timeout(Duration(seconds: 8));

          if (geocodeResp.statusCode == 200) {
            final map = json.decode(geocodeResp.body) as Map<String, dynamic>;
            if ((map['status'] as String?) == 'OK' && (map['results'] as List).isNotEmpty) {
              final results = map['results'] as List;

              // Get the FIRST result (usually most accurate for the exact lat/lng)
              final firstResult = results.first as Map<String, dynamic>;

              // Build detailed address from address_components (includes building number, street, etc.)
              final comps = (firstResult['address_components'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
              final componentMap = <String, String>{};

              // Extract all components and map by type
              for (final comp in comps) {
                final longName = comp['long_name'] as String? ?? '';
                final types = (comp['types'] as List<dynamic>?)?.cast<String>() ?? [];
                for (final type in types) {
                  componentMap[type] = longName;
                }
              }

              // Build address in priority order: building details → street → city → state → postal → country
              final parts = <String>[];

              // 1. Start with street number if available
              if ((componentMap['street_number']?.isNotEmpty ?? false)) {
                parts.add(componentMap['street_number']!);
              }

              // 2. Add detailed premises (building names, colonies, etc.)
              if ((componentMap['subpremise']?.isNotEmpty ?? false)) {
                parts.add(componentMap['subpremise']!);
              }
              if ((componentMap['premise']?.isNotEmpty ?? false)) {
                parts.add(componentMap['premise']!);
              }

             // 3. Add street/route name
              if ((componentMap['route']?.isNotEmpty ?? false)) {
                parts.add(componentMap['route']!);
              }

              // 4. Add sub-locality (area/neighborhood)
              if ((componentMap['sublocality_level_2']?.isNotEmpty ?? false)) {
                parts.add(componentMap['sublocality_level_2']!);
              }
              if ((componentMap['sublocality_level_1']?.isNotEmpty ?? false)) {
                parts.add(componentMap['sublocality_level_1']!);
              }
              if ((componentMap['sublocality']?.isNotEmpty ?? false)) {
                parts.add(componentMap['sublocality']!);
              }

              // 5. Add city
              if ((componentMap['locality']?.isNotEmpty ?? false)) {
                parts.add(componentMap['locality']!);
              }

              // 6. Add state
              if ((componentMap['administrative_area_level_1']?.isNotEmpty ?? false)) {
                parts.add(componentMap['administrative_area_level_1']!);
              }

              // 7. Add postal code
              if ((componentMap['postal_code']?.isNotEmpty ?? false)) {
                parts.add(componentMap['postal_code']!);
              }

              // 8. Add country
              if ((componentMap['country']?.isNotEmpty ?? false)) {
                parts.add(componentMap['country']!);
              }

              // Join all parts
              address = parts.join(', ');

              if (address.isNotEmpty) {
                print('✅ Google Geocode Result: $address');
              } else {
                // Ultimate fallback: use formatted_address
                final formatted = firstResult['formatted_address'] as String? ?? '';
                address = formatted;
                print('⚠️  Using formatted_address as fallback: $formatted');
              }
            }
          } else {
            print('❌ Google Geocode API error: ${geocodeResp.statusCode}');
          }
        } else {
          print('⚠️  Google API key not configured. Using platform geocoding as fallback.');
          // Fallback to platform geocoding if API key not available
          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            final parts = <String>[];
            if ((place.name ?? '').isNotEmpty) parts.add(place.name!);
            if ((place.subThoroughfare ?? '').isNotEmpty) parts.add(place.subThoroughfare!);
            if ((place.thoroughfare ?? '').isNotEmpty) parts.add(place.thoroughfare!);
            if ((place.subLocality ?? '').isNotEmpty) parts.add(place.subLocality!);
            if ((place.locality ?? '').isNotEmpty) parts.add(place.locality!);
            if ((place.administrativeArea ?? '').isNotEmpty) parts.add(place.administrativeArea!);
            if ((place.postalCode ?? '').isNotEmpty) parts.add(place.postalCode!);
            if ((place.country ?? '').isNotEmpty) parts.add(place.country!);
            address = parts.join(', ');
          }
        }
      } catch (err) {
        print('❌ Geocoding error: $err');
      }

      // 4) Update state
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        locationAddress = (address.isNotEmpty) ? address : 'Lat:${position.latitude}, Lon:${position.longitude}';
      });

      print('Address: $locationAddress');
      print("---322----xx address---$address");
      print('Latitude: $lat');
      print('Longitude: $long');

      // compute distance etc
      if (lat != null && long != null) {
        distanceInMeters = calculateDistanceInMeters(staticLat, staticLng, lat!, long!);
        print('Distance: $distanceInMeters meters');
        // do not auto-call attendaceapi — keep on submit as you do
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
  // Future<void> getLocation() async {
  //   showLoader();
  //
  //   // 1) check location service & permissions (keeps your existing logic)
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     hideLoader();
  //     displayToast("Location services are disabled. Please enable them in settings.");
  //     AppSettings.openAppSettings();
  //     return;
  //   }
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       hideLoader();
  //       displayToast("Location permission denied.");
  //       return;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     hideLoader();
  //     displayToast("Location permission permanently denied. Please enable it in app settings.");
  //     AppSettings.openAppSettings();
  //     return;
  //   }
  //
  //   try {
  //     // 2) Try to get a stable/accurate position using getPositionStream for a short window
  //     Position? best;
  //     final stream = Geolocator.getPositionStream(
  //         locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 0));
  //     final completer = Completer<Position>();
  //     Timer timeout = Timer(Duration(seconds: 6), () {
  //       if (!completer.isCompleted) {
  //         completer.completeError('timeout');
  //       }
  //     });
  //
  //     final sub = stream.listen((pos) {
  //       // pick first position with acceptable accuracy, or keep best seen
  //       if (best == null || (pos.accuracy < best!.accuracy)) {
  //         best = pos;
  //       }
  //       if (pos.accuracy <= 25) { // threshold: 25 meters is pretty good
  //         if (!completer.isCompleted) completer.complete(pos);
  //       }
  //     });
  //
  //     // If we get no good fix within the timeout, fall back
  //     Position position;
  //     try {
  //       position = await completer.future;
  //     } catch (_) {
  //       // did not get a good stream position in time — fall back to single call
  //       position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //     } finally {
  //       timeout.cancel();
  //       await sub.cancel();
  //     }
  //
  //     // 3) Reverse geocode (use locale if you want, e.g. localeIdentifier: 'en')
  //     print("-----239----xxx-----${position.latitude}");
  //     print("-----240----xxx-----${position.longitude}");
  //     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude/*, localeIdentifier: 'en'*/);
  //
  //     String address = '';
  //     if (placemarks.isNotEmpty) {
  //       final place = placemarks.first;
  //       // Build address from the best available parts, skipping null/empty fields
  //       final parts = <String>[];
  //       if ((place.name ?? '').isNotEmpty) parts.add(place.name!); // building name or POI
  //       if ((place.subThoroughfare ?? '').isNotEmpty) parts.add(place.subThoroughfare!); // number
  //       if ((place.thoroughfare ?? '').isNotEmpty) parts.add(place.thoroughfare!); // street
  //       if ((place.subLocality ?? '').isNotEmpty) parts.add(place.subLocality!);
  //       if ((place.locality ?? '').isNotEmpty) parts.add(place.locality!); // city
  //       if ((place.subAdministrativeArea ?? '').isNotEmpty) parts.add(place.subAdministrativeArea!);
  //       if ((place.administrativeArea ?? '').isNotEmpty) parts.add(place.administrativeArea!); // state
  //       if ((place.postalCode ?? '').isNotEmpty) parts.add(place.postalCode!);
  //       if ((place.country ?? '').isNotEmpty) parts.add(place.country!);
  //
  //       address = parts.join(', ');
  //     }
  //
  //     // 2) If placemark didn't provide a clear POI/premise, call Google Geocoding API for a better formatted address.
  //     //    This helps get establishment / building names when the platform placemark is generic (e.g. "Civil Lines").
  //     if (address.isEmpty || (placemarks.isNotEmpty && (placemarks.first.name == null || placemarks.first.name!.isEmpty))) {
  //       try {
  //         // IMPORTANT: replace with your real API key and keep it secure (do not hardcode for production)
  //         const googleApiKey = 'YOUR_GOOGLE_API_KEY';
  //
  //         final geocodeUrl = Uri.parse(
  //           'https://maps.googleapis.com/maps/api/geocode/json'
  //               '?latlng=${position.latitude},${position.longitude}'
  //               '&language=en'
  //               '&key=$googleApiKey',
  //         );
  //
  //         final geocodeResp = await http.get(geocodeUrl).timeout(Duration(seconds: 8));
  //
  //         if (geocodeResp.statusCode == 200) {
  //           final map = json.decode(geocodeResp.body) as Map<String, dynamic>;
  //           if ((map['status'] as String?) == 'OK' && (map['results'] as List).isNotEmpty) {
  //             final results = map['results'] as List;
  //
  //             // Prefer results that look like an establishment/premise/point_of_interest or street address
  //             Map<String, dynamic>? chosen;
  //             for (var r in results) {
  //               final types = (r['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
  //               if (types.any((t) => ['premise', 'establishment', 'point_of_interest', 'street_address', 'subpremise', 'route'].contains(t))) {
  //                 chosen = r as Map<String, dynamic>;
  //                 break;
  //               }
  //             }
  //
  //             // If none matched the preferred types, pick the first result
  //             chosen ??= results.first as Map<String, dynamic>;
  //
  //             final formatted = chosen['formatted_address'] as String?;
  //             if (formatted != null && formatted.isNotEmpty) {
  //               address = formatted;
  //             } else {
  //               // As backup, build from address_components (try to pick named component like premise/establishment)
  //               final comps = (chosen['address_components'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  //               final componentMap = <String, String>{};
  //               for (final c in comps) {
  //                 final types = (c['types'] as List<dynamic>).cast<String>();
  //                 final longName = c['long_name'] as String? ?? '';
  //                 for (final t in types) {
  //                   componentMap[t] = longName;
  //                 }
  //               }
  //               // try some useful component keys
  //               final candidateParts = <String>[];
  //               if (componentMap['premise']?.isNotEmpty ?? false) candidateParts.add(componentMap['premise']!);
  //               if (componentMap['establishment']?.isNotEmpty ?? false) candidateParts.add(componentMap['establishment']!);
  //               if (componentMap['point_of_interest']?.isNotEmpty ?? false) candidateParts.add(componentMap['point_of_interest']!);
  //               if (componentMap['route']?.isNotEmpty ?? false) candidateParts.add(componentMap['route']!);
  //               if (componentMap['street_number']?.isNotEmpty ?? false) candidateParts.add(componentMap['street_number']!);
  //               if (componentMap['locality']?.isNotEmpty ?? false) candidateParts.add(componentMap['locality']!);
  //               if (componentMap['administrative_area_level_1']?.isNotEmpty ?? false) candidateParts.add(componentMap['administrative_area_level_1']!);
  //               if (componentMap['postal_code']?.isNotEmpty ?? false) candidateParts.add(componentMap['postal_code']!);
  //               if (candidateParts.isNotEmpty) address = candidateParts.join(', ');
  //             }
  //           }
  //         }
  //       } catch (err) {
  //         // Non-fatal: keep whatever address we have or fallback to lat/lon later
  //         print('Google geocode error: $err');
  //       }
  //     }
  //     // if (placemarks.isNotEmpty) {
  //     //   final place = placemarks.first;
  //     //   print("----243----xxx--$place");
  //     //
  //     //   // Build address from the best available parts, skipping null/empty fields
  //     //   final parts = <String>[];
  //     //   if ((place.name ?? '').isNotEmpty) parts.add(place.name!); // building name or POI
  //     //   if ((place.subThoroughfare ?? '').isNotEmpty) parts.add(place.subThoroughfare!); // number
  //     //   if ((place.thoroughfare ?? '').isNotEmpty) parts.add(place.thoroughfare!); // street
  //     //   //if ((place.subLocality ?? '').isNotEmpty) parts.add(place.subLocality!);
  //     //   if ((place.locality ?? '').isNotEmpty) parts.add(place.locality!); // city
  //     //   //if ((place.subAdministrativeArea ?? '').isNotEmpty) parts.add(place.subAdministrativeArea!);
  //     //   if ((place.administrativeArea ?? '').isNotEmpty) parts.add(place.administrativeArea!); // state
  //     //   if ((place.postalCode ?? '').isNotEmpty) parts.add(place.postalCode!);
  //     //   if ((place.country ?? '').isNotEmpty) parts.add(place.country!);
  //     //
  //     //   address = parts.join(', ');
  //     // }
  //
  //     // Optional: if placemark yields nothing useful, you can call Google Geocoding API here (requires API key)
  //     // if (address.isEmpty) { ... call google maps geocoding endpoint with lat/lng ... }
  //
  //     // 4) Update state
  //     setState(() {
  //       lat = position.latitude;
  //       long = position.longitude;
  //       locationAddress = (address.isNotEmpty) ? address : 'Lat:${position.latitude}, Lon:${position.longitude}';
  //     });
  //
  //     print('Address: $locationAddress');
  //     print('Latitude: $lat');
  //     print('Longitude: $long');
  //
  //     // compute distance etc
  //     if (lat != null && long != null) {
  //       distanceInMeters = calculateDistanceInMeters(staticLat, staticLng, lat!, long!);
  //       print('Distance: $distanceInMeters meters');
  //       // do not auto-call attendaceapi — keep on submit as you do
  //     } else {
  //       displayToast("Please select your location to proceed.");
  //     }
  //   } catch (e) {
  //     hideLoader();
  //     displayToast("Failed to get location: $e");
  //   } finally {
  //     hideLoader();
  //   }
  // }
  // void getLocation() async {
  //   showLoader();
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Check if location service is enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     hideLoader();
  //     displayToast(
  //         "Location services are disabled. Please enable them in settings.");
  //     // AppSettings.openLocationSettings(); // Redirect to location settings
  //     AppSettings.openAppSettings(); // on ios to open a settongs
  //     return;
  //   }
  //   // Check permission status
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       hideLoader();
  //       displayToast("Location permission denied.");
  //       return;
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     hideLoader();
  //     displayToast(
  //         "Location permission permanently denied. Please enable it in app settings.");
  //     AppSettings.openAppSettings(); // Redirect to app settings
  //     return;
  //   }
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );
  //
  //     Placemark place = placemarks[0];
  //     print("------219----xxx----place : $place");
  //     String address =
  //         "${place.street}, ${place.subLocality},${place.locality},${place.administrativeArea},${place.postalCode},${place.country}";
  //
  //     // String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  //
  //     setState(() {
  //       lat = position.latitude;
  //       long = position.longitude;
  //       locationAddress = address;
  //     });
  //
  //     print('Address: $locationAddress');
  //     print('Latitude: $lat');
  //     print('Longitude: $long');
  //
  //     if (lat != null && long != null) {
  //       hideLoader();
  //       print('---------210----$lat');
  //       print('---------211----$long');
  //       // call a distance metrics.
  //       distanceInMeters =
  //           calculateDistanceInMeters(staticLat, staticLng, lat!, long!);
  //
  //       print('-----216---Distance in M---$distanceInMeters');
  //
  //       /// TODO HERE YOU SHOULD NOT CALL A ATTENDACE API YOU SHOULD CAL THIS API
  //       /// ON A SUBMIT BUTTON
  //       // attendaceapi(lat, long, locationAddress);
  //     } else {
  //       displayToast("Please select your location to proceed.");
  //     }
  //   } catch (e) {
  //     hideLoader();
  //     displayToast("Failed to get location: $e");
  //   } finally {
  //     hideLoader();
  //   }
  // }

  /// Attendance repo
  attendaceapi(double? lat, double? long, locationAddress) async {
    var attendance = await HrmsAttendanceRepo()
        .hrmsattendance(context, lat, long, locationAddress);
    print("---Attendace response-----494-----$attendance");

    if (attendance != null) {
      var msg = "${attendance[0]['Msg']}";
      var result = "${attendance[0]['Result']}";
      setState(() {});
      // here you should apply logic if result 0 then show info Dialog otherwise show
      // sucess Dialog
      if (result == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            //return _buildDialogSucces2(context, msg);
            return _buildDialogInfo(context, msg);
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            //return _buildDialogInfo(context, msg);
            return _buildDialogSucces2(context, msg);
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
                Text('Success',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
                Text('Information',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
                        children: [
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
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
                        borderRadius:
                            BorderRadius.circular(16), // Rounded edges
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                    borderRadius:
                        BorderRadius.circular(12), // ✅ Same radius as Card
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
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
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12), // ✅ Match Card radius
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
                          // color: Colors.grey,
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 10),
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
                                  locationCheck == 'On'
                                      ? Text(
                                          '(GPS ON)',
                                          style: GoogleFonts.poppins(
                                            color: Colors.green,
                                            fontSize: 14,
                                          ),
                                        )
                                      : Text(
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
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 500),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                    child: Text(
                                      locationAddress ?? "No Address Found",
                                      key: ValueKey<String>(locationAddress ?? "No Address Found"),
                                      style: GoogleFonts.poppins(
                                        color: Colors.black38,
                                        fontSize: 12,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    ),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
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
            // 6084110826  agra code
            sLocCode == "6084110826"
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // ✅ Rounded corners
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
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                color: distanceInMeters! >
                                                        threshold
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        else
                                          const Text(
                                            'Calculating distance...',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
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
                : Container(),
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
