import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../dashboard/dashboard.dart';
import 'dart:convert';

import '../resources/app_text_style.dart';

class WorkDetail extends StatelessWidget {
  const WorkDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WorkDetailPage(),
    );
  }
}

class WorkDetailPage extends StatefulWidget {
  const WorkDetailPage({super.key});

  @override
  State<WorkDetailPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WorkDetailPage> {
  final int itemCount = 2;
  final String jsonResponse = '''
  [
    {"sDate": "Jan 01", "sDayName": "Monday", "sHolidayName": "New Year"},
    {"sDate": "Jan 26", "sDayName": "Friday", "sHolidayName": "Republic Day"},
    {"sDate": "Mar 25", "sDayName": "Monday", "sHolidayName": "Holi"},
    {"sDate": "Aug 15", "sDayName": "Thursday", "sHolidayName": "Independence Day"},
    {"sDate": "Aug 19", "sDayName": "Monday", "sHolidayName": "Rakshabandhan"},
    {"sDate": "Aug 26", "sDayName": "Monday", "sHolidayName": "Janmashtami"},
    {"sDate": "Oct 02", "sDayName": "Wednesday", "sHolidayName": "Gandhi Jayanti"},
    {"sDate": "Nov 01", "sDayName": "Friday", "sHolidayName": "Diwali"},
    {"sDate": "Dec 25", "sDayName": "Wednesday", "sHolidayName": "Christmas Day"}
  ]
  ''';

  final _formKey = GlobalKey<FormState>();
  final List<String> _items = ["aa", "bb", "cc", "dd"];
  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _items.add(_controller.text);
        print("--List Item--$_items");
        _controller.clear();
      });
    }
  }

  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

  @override
  Widget build(BuildContext context) {
    List<dynamic> holidays = json.decode(jsonResponse);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color  // 2a697b
          statusBarColor: Color(0xFF2a697b),
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
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
            'Work Detail',
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
      body: Column(
       mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 10),
          child: SizedBox(
            height: 150, // Height of the container
            width: MediaQuery.of(context).size.width,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/deshboardtop.jpeg',
                fit: BoxFit.fill, // Adjust the image fit to cover the container
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              // itemCount: _items.length,
              itemCount: 2,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5,bottom: 5),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        decoration: BoxDecoration(
                            color: Colors
                                .white, // Background color of the container
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Color of the shadow
                                spreadRadius: 5, // Spread radius
                                blurRadius: 7, // Blur radius
                                offset: Offset(0, 3), // Offset of the shadow
                              ),
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Form(
                               // key: _formKey,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 15),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: DottedBorder(
                                                    color: Colors.grey,
                                                    strokeWidth: 1.0,
                                                    dashPattern: [4, 2],
                                                    borderType:
                                                        BorderType.RRect,
                                                    radius:
                                                        const Radius.circular(
                                                            5.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // This ensures the Row only takes up as much space as needed
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              size: 25),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            'Head Office',
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularBlack45TextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                Container(
                                                  height: 65,
                                                  color: Color(0xFFf2f3f5),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0),
                                                    child: TextFormField(
                                                      focusNode: FocusNode(),
                                                      controller:
                                                          TextEditingController(),
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onEditingComplete: () =>
                                                          FocusScope.of(context)
                                                              .nextFocus(),
                                                      maxLines:
                                                          null, // Allows multiple lines
                                                      expands:
                                                          true, // Makes the TextFormField fill the height
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Enter work detail",
                                                        labelStyle: AppTextStyle
                                                            .font14OpenSansRegularBlack45TextStyle,
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                          vertical:
                                                              10, // Adjust vertical padding as needed
                                                          horizontal: 10,
                                                        ),
                                                      ),
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]))))));

              }),
        ),
        SizedBox(height: 10),
        Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10), // Adjust padding as necessary
                  child: ElevatedButton(
                    onPressed: () async {
                      // open dialogBox
                      print('---310---');

                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0098a6), // Green color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
        ]
      ),
    );
  }
}
