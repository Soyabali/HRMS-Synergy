import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';


class Attendancelist extends StatelessWidget {
  const Attendancelist({super.key});

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
      home: AttendaceListHome(),
    );
  }
}

class AttendaceListHome extends StatefulWidget {
  const AttendaceListHome({super.key});

  @override
  State<AttendaceListHome> createState() => _AttendaceListHomeState();
}

class _AttendaceListHomeState extends State<AttendaceListHome> {
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
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        backgroundColor: Color(0xFF0098a6),
        leading: InkWell(
          onTap: (){
           // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashBoard()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Icon(Icons.arrow_back_ios, size: 24,color: Colors.white,),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Attendance List',
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
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              SizedBox(
                height: 40, // Set the height for the horizontal list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10, // Adjust the number of items as needed
                  itemBuilder: (context, index) {
                    // Generate a random color
                    final randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8), // Add spacing between items
                      height: 40,
                      width: 120, // Width of the container
                      decoration: BoxDecoration(
                        color: randomColor, // Use the randomly generated color
                        borderRadius: BorderRadius.circular(25), // Border radius
                      ),
                      alignment: Alignment.center, // Center the text within the container
                      child: Text(
                        'Dummy Text',
                        style: AppTextStyle.font12OpenSansRegularWhiteTextStyle,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10,top: 10),
                child:Card(
                  color: Colors.white,
                  elevation: 5.0, // Elevation of the card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Border radius of the card
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0), // Left and right padding of 5
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                            children: [
                              Container(
                                height: 40, // Height of the first container
                                width: 40, // Width of the first container
                                decoration: BoxDecoration(
                                  color: Colors.grey, // Background color of the first container
                                  borderRadius: BorderRadius.circular(20), // Border radius
                                ),
                                alignment: Alignment.center, // Center the text within the container
                                child: Text(
                                  '1', style: AppTextStyle.font14OpenSansRegularBlackTextStyle
                                ),
                              ),
                              SizedBox(width: 15), // Spacing between the two containers
                              Text(
                                '20/Aug/2024', // The text to display
                                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                              ),
                              Spacer(),
                              Container(
                                height: 40, // Height of the second container
                                width: 110, // Width of the second container
                                decoration: BoxDecoration(
                                  color: Colors.green, // Background color of the second container
                                  borderRadius: BorderRadius.circular(20), // Border radius
                                ),
                                alignment: Alignment.center, // Center the text within the container
                                child: Text(
                                  'Present', // The text to display
                                    style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: DottedBorder(
                              color: Colors.grey, // Color of the dotted line
                              strokeWidth: 1.0, // Width of the dotted line
                              dashPattern: [4, 2], // Dash pattern for the dotted line
                              borderType: BorderType.RRect,
                              radius: Radius.circular(5.0), // Optional: rounded corners
                              child: Padding(
                                padding: EdgeInsets.all(8.0), // Equal padding on all sides
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
                                  children: [
                                    Text(
                                      'Day',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                    ),
                                    SizedBox(width: 5.0), // Space between 'Day' and ':'
                                    Text(
                                      ':',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                    ),
                                    SizedBox(width: 5.0), // Space between ':' and 'Monday'
                                    Text(
                                      'Monday',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                             // Icon(Icons.refresh,size: 20,color: Colors.black),
                              Image.asset('assets/images/attendancelisticon_2.jpeg',height: 16,width: 16,
                                  fit: BoxFit.cover,),
                              SizedBox(width: 10),
                              Text('In / Out Attendance Time Details',style: AppTextStyle.font12OpenSansRegularBlackTextStyle)
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Container(
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                              children: [
                                Container(
                                  height: 35, // Height of the first container
                                  width: 35, // Width of the first container
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color of the first container
                                    borderRadius: BorderRadius.circular(20), // Border radius
                                  ),
                                  alignment: Alignment.center, // Center the text within the container
                                  child: Image.asset('assets/images/attendenclisticon_1.jpeg',height: 20,width: 20,
                                    fit: BoxFit.cover,),

                                ),
                                SizedBox(width: 15), // Spacing between the two containers
                                Text(
                                  'In Time', // The text to display
                                    style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                ),
                                Spacer(),
                                Container(
                                  height: 40, // Height of the container
                                  width: 150, // Width of the container
                                  decoration: BoxDecoration(// Background color of the container
                                    borderRadius: BorderRadius.circular(20), // Border radius
                                  ),
                                  alignment: Alignment.centerRight, // Align the text to the right within the container
                                  padding: EdgeInsets.only(right: 10.0), // Optional: Add some padding to the right
                                  child: Text(
                                    '08:55', // The text to display
                                      style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      )
                    ),
                  ),
                ),



            ],
          ),
        ],
      ),
    );
  }
}
