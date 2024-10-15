//
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:ui' as ui;
// import 'dart:async';
// import 'dart:ui' as ui;
//
// import '../../app/generalFunction.dart';
//
// class TempleGoogleMap extends StatefulWidget {
//
//   final double fLatitude;
//   final double fLongitude;
//   final String locationName;
//   final String sLocationAddress;
//
//   const TempleGoogleMap({
//     Key? key,
//     required this.fLatitude,
//     required this.fLongitude,
//     required this.locationName,
//     required this.sLocationAddress,
//   }) : super(key: key);
//
//   @override
//   State<TempleGoogleMap> createState() => _TempleGoogleMapState();
// }
//
// class _TempleGoogleMapState extends State<TempleGoogleMap> {
//
//   GoogleMapController? mapController;
//
//   late LatLng _center;
//   final Set<Marker> _markers = {};
//   LatLng? _currentMapPosition;
//   dynamic? lat,long;
//
//   @override
//   void initState() {
//     print('-----41----${widget.fLatitude}');
//     print('-----41---${widget.fLongitude}');
//     super.initState();
//     _initializeMap();
//   }
//
//   @override
//   void didUpdateWidget(TempleGoogleMap oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.fLatitude != widget.fLatitude || oldWidget.fLongitude != widget.fLongitude) {
//       _initializeMap();
//     }
//   }
//
//   void _initializeMap() {
//     _center = LatLng(widget.fLatitude, widget.fLongitude);
//     _currentMapPosition = _center;
//     _clearMarkers();
//     _addMarker();
//     _moveCamera();
//   }
//
//   @override
//   void dispose() {
//     mapController?.dispose();
//     super.dispose();
//   }
//
//   void _clearMarkers() {
//     setState(() {
//       _markers.clear();
//     });
//   }
//
//   void _addMarker() async {
//     if (_currentMapPosition != null) {
//       final Uint8List markerIcon = await _createCustomMarkerBitmap(
//         widget.locationName,
//         widget.sLocationAddress,
//       );
//       setState(() {
//         _markers.add(Marker(
//           markerId: MarkerId(_currentMapPosition.toString()),
//           position: _currentMapPosition!,
//           icon: BitmapDescriptor.fromBytes(markerIcon),
//         ));
//       });
//     }
//   }
//
//   void _onCameraMove(CameraPosition position) {
//     _currentMapPosition = position.target;
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     _moveCamera();
//   }
//
//   void _moveCamera() {
//     mapController?.animateCamera(CameraUpdate.newLatLng(_center));
//   }
//
//   Future<Uint8List> _createCustomMarkerBitmap(String title, String snippet) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint = Paint()..color = Colors.white;
//
//     // TextPainter to measure the text size
//     final TextPainter titleTextPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       text: TextSpan(
//         text: title,
//         style: TextStyle(
//           fontSize: 25.0,
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//
//     final TextPainter snippetTextPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       text: TextSpan(
//         text: snippet,
//         style: TextStyle(
//           fontSize: 25.0,
//           color: Colors.black,
//         ),
//       ),
//     );
//
//     // Layout the text to get the size
//     titleTextPainter.layout(minWidth: 0, maxWidth: double.infinity);
//     snippetTextPainter.layout(minWidth: 0, maxWidth: double.infinity);
//
//     // Calculate the width and height based on text size
//     final double width = (titleTextPainter.width > snippetTextPainter.width
//         ? titleTextPainter.width
//         : snippetTextPainter.width) +
//         20.0;
//     final double height = titleTextPainter.height + snippetTextPainter.height + 40.0;
//
//     // Draw rounded rectangle
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(0.0, 0.0, width, height),
//         Radius.circular(10.0),
//       ),
//       paint,
//     );
//
//     const double iconSize = 100.0;
//     final Paint markerPaint = Paint()..color = Colors.red;
//
//     // Draw the marker path
//     final Path markerPath = Path()
//       ..moveTo(width / 2 - iconSize / 2, height)
//       ..lineTo(width / 2, height + iconSize / 2)
//       ..lineTo(width / 2 + iconSize / 2, height)
//       ..close();
//     canvas.drawPath(markerPath, markerPaint);
//
//     // Draw title
//     titleTextPainter.paint(
//       canvas,
//       Offset(10.0, 10.0),
//     );
//
//     // Draw snippet
//     snippetTextPainter.paint(
//       canvas,
//       Offset(10.0, titleTextPainter.height + 20.0),
//     );
//
//     // Convert canvas to image
//     final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
//       width.toInt(),
//       height.toInt() + (iconSize / 2).toInt(),
//     );
//
//     final ByteData? byteData = await markerAsImage.toByteData(
//       format: ui.ImageByteFormat.png,
//     );
//
//     return byteData!.buffer.asUint8List();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: AppBar(
//       //  title: Text(widget.locationName),
//       // ),
//      // appBar: getAppBarBack(context,"${widget.locationName}"),
//        appBar: AppBar(title: Text('Google Map'),),
//       body: Stack(
//         children: <Widget>[
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: _center,
//               zoom: 15.0,
//             ),
//             markers: _markers,
//             onCameraMove: _onCameraMove,
//           ),
//           Positioned(
//             bottom: 16.0,
//             left: 16.0,
//             child: FloatingActionButton(
//               onPressed: _moveCamera,
//               child: GestureDetector(
//                 onTap: (){
//                   setState(() {
//                     lat = double.parse('${widget.fLatitude}');
//                     long = double.parse('${widget.fLongitude}');
//                     print('---215--$lat');
//                     print('---216--$long');
//
//                    // launchGoogleMaps(lat!, long!);
//
//                   });
//                   setState(() {
//
//                   });
//                 },
//                 // child: Icon(Icons.my_location)
//                 child: Container(
//                     height: 25,
//                     width: 25,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Image.asset('assets/images/direction.jpeg',
//                       height: 25,
//                       width: 25,
//                       fit: BoxFit.fill,
//                     )
//                 ),
//
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// void navigateToTempleGoogleMap(
//     BuildContext context,
//     double fLatitude,
//     double fLongitude,
//     String locationName,
//     String sLocationAddress,
//     ) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => TempleGoogleMap(
//         fLatitude: fLatitude,
//         fLongitude: fLongitude,
//         locationName: locationName,
//         sLocationAddress: sLocationAddress,
//       ),
//     ),
//   );
// }
//
