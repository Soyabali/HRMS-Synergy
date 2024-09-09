import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';


class TripDetail extends StatelessWidget {
  const TripDetail({super.key});

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

  // InitState
  TextEditingController _takeAction = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _takeAction.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Trip Detail',
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
        child: Column(
          children: <Widget>[


            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Color of the shadow
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Offset of the shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.light_mode_rounded,size: 25,color: Colors.redAccent,),
                                SizedBox(width: 10),
                                Text('Trip Details',
                                    style: AppTextStyle
                                        .font12OpenSansRegularBlackTextStyle,
                                    maxLines: 2, // Limits the text to 2 lines
                                    overflow: TextOverflow.ellipsis, // Truncates the text with an ellipsis if it's too long
                                    softWrap: true,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // take a EditTextView
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: TextFormField(
                              controller: _takeAction,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                filled: true, // Enable background color
                                fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter a value';
                              //   }
                              //   final intValue = int.tryParse(value);
                              //   if (intValue == null || intValue <= 0) {
                              //     return 'Enter an amount greater than 0';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          SizedBox(height: 10),

                          Container(
                            alignment: Alignment.centerLeft,
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 1.0,
                              dashPattern: [4, 2],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(5.0),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min, // This ensures the Row only takes up as much space as needed
                                  children: [
                                    Icon(Icons.camera_alt_outlined, size: 25),
                                    SizedBox(width: 5),
                                    Text(
                                      'Head Office',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),

                          SizedBox(height: 15),
                          ElevatedButton(
                             onPressed: (){
                               print('----217----');
                             },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF0098a6), // Hex color code (FF for alpha, followed by RGB)
                              ),
                              child: const Text(
                                "SUBMIT",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
