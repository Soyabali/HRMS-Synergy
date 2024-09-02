import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../data/getCurrentAndPreviousMonth.dart';
import '../../data/hrmsMonthlyAttendanceRepo.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';


class Attendancelist extends StatelessWidget {

  const Attendancelist({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  List<dynamic> getCurrentAndPreviouseMonthModel = [];
  List<Map<String, dynamic>>? myPoinList;
  List<dynamic>?  getCurrentAndPreviousMonth;
  List<dynamic>?  monthlyAttendance;
  Color? containerColor;
  List? reversedList;
  bool isMarked = false;
  int? markedIndex=0;
  String? status;


  getCurrentMonthandPreviousMonth() async {
    getCurrentAndPreviousMonth = await GetCurrentAndpreviousMonthRepo().getCurrentAndPreviousMonth();
    print(" -----xxxxx-  distList--49---> $getCurrentAndPreviousMonth");
    reversedList = getCurrentAndPreviousMonth?.reversed.toList();
    var dDate =  '${reversedList?[0]['dDate']}';
    print('---56---$dDate');
    if(dDate!=null){
      monthAttendance(dDate);
    }
    print('-----52---reversedList----$reversedList');
    setState(() {});
  }
  //
  monthAttendance(String dDate) async {
    monthlyAttendance = await HrmsmonthlyattendanceRepo().monthlyAttendanceList(context,dDate);
    print(" -----57---  monthlyAttendanceList--42---> $monthlyAttendance");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentMonthandPreviousMonth();
    super.initState();
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
          onTap: (){
           // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashBoard()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(Icons.arrow_back_ios, size: 24,color: Colors.white,),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                height: 35, // Set the height for the horizontal list
                child: GestureDetector(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: reversedList?.length ?? 0, // Adjust the number of items as needed
                    itemBuilder: (context, index) {
                      bool isMarked = markedIndex == index;
                      // Generate a random color
                      final randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
                      return GestureDetector(
                        onTap: (){
                          markedIndex = isMarked ? null : index;
                          var dDate = '${reversedList?[index]['dDate']}';
                           print('----150----xxx---$dDate');
                           /// TODO CALL A NEXT API
                          monthAttendance(dDate);
                          },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8), // Add spacing between items
                          height: 35,
                          width: 135, // Width of the container
                          decoration: BoxDecoration(
                            color: randomColor, // Use the randomly generated color
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center, // Center the text within the container
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isMarked)
                                const Positioned(
                                  left: 5,
                                  top: 0,
                                  bottom: 0,
                                  child: Icon(
                                    Icons.check_circle, // Mark symbol
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                        Positioned.fill(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: isMarked ? 35 : 0), // Adjust left padding when icon is present
                              child:  Text('${reversedList?[index]['sMonthName']}', // Example month text
                                 style: TextStyle(color: Colors.white, fontSize: 20),
                               ),
                            ),
                          ),
                        ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),

              Padding(
                 padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10,top: 10),
                 child: Container(
                  height: MediaQuery.of(context).size.height-50,
                  color: Colors.white,
                   child:
                     Padding(
                         padding: const EdgeInsets.only(left: 0.0, right: 0.0,bottom: 85), // Left and right padding of 5
                         child: Container(
                           child: ListView.builder(
                               itemCount: monthlyAttendance?.length ?? 0,
                               itemBuilder: (context,index){
                                 status = '${monthlyAttendance?[index]['sStatus']}';
                                  // Determine the color based on the country
                                  containerColor;
                                  if (status == "Early Going") {
                                   containerColor = Colors.redAccent;
                                 } else if (status == "Present") {
                                   containerColor = Colors.green;
                                 } else if (status == "Holiday"){
                                   containerColor = Color(0xFF0098a6); // Default color for other countries
                                 }else if(status == "Weekly Off"){
                                   containerColor = Color(0xFF2a697b);
                                 }
                                 return Padding(
                                   padding: const EdgeInsets.only(left: 5,right: 5,bottom: 20),
                                   child: Card(
                                     margin: EdgeInsets.zero,
                                     elevation: 5.0,
                                     color: Colors.white,
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(10.0), // Border radius of the card
                                     ),
                                     child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       SizedBox(height: 10),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                                         children: [
                                           Padding(
                                             padding: const EdgeInsets.only(left: 10),
                                             child: Container(
                                               height: 40, // Height of the first container
                                               width: 40, // Width of the first container
                                               decoration: BoxDecoration(
                                                 color: Color(0xFFD3D3D3), // Background color of the first container
                                                 borderRadius: BorderRadius.circular(20), // Border radius
                                               ),
                                               alignment: Alignment.center, // Center the text within the container
                                               child: Text(
                                                   '${index+1}', style: AppTextStyle.font14OpenSansRegularBlackTextStyle
                                               ),
                                             ),
                                           ),
                                           SizedBox(width: 15), // Spacing between the two containers
                                           Text(
                                               '${monthlyAttendance?[index]['dDate']}', // The text to display
                                               style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                           ),
                                           Spacer(),
                                           Padding(
                                             padding: const EdgeInsets.only(right: 10),
                                             child: Container(
                                               height: 30, // Height of the second container
                                               width: 90, // Width of the second container
                                               decoration: BoxDecoration(
                                                 color: containerColor, // Background color of the second container
                                                 borderRadius: BorderRadius.circular(20), // Border radius
                                               ),
                                               alignment: Alignment.center, // Center the text within the container
                                               child: Text(
                                                   '${monthlyAttendance?[index]['sStatus']}', // The text to display
                                                   style: AppTextStyle.font12OpenSansRegularWhiteTextStyle
                                               ),
                                             ),
                                           ),
                                         ],
                                       ),
                                       SizedBox(height: 10),
                                       Center(
                                         child: Container(
                                           height: 35,
                                           child: DottedBorder(
                                             color: Colors.grey, // Color of the dotted line
                                             strokeWidth: 1.0, // Width of the dotted line
                                             dashPattern: [4, 2], // Dash pattern for the dotted line
                                             borderType: BorderType.RRect,
                                             radius: Radius.circular(5.0), // Optional: rounded corners
                                             child: Padding(
                                               padding: EdgeInsets.all(8.0), // Equal padding on all sides
                                               child: Row(
                                                 mainAxisSize: MainAxisSize.min, // Center the row contents
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
                                                       '${monthlyAttendance?[index]['sDay']}',
                                                       style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                       SizedBox(height: 10),
                                       Visibility(
                                         visible: '${monthlyAttendance?[index]['sStatus']}' != 'Holiday' && '${monthlyAttendance?[index]['sStatus']}' != 'Weekly Off',
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           children: [
                                             Padding(
                                               padding: const EdgeInsets.only(left: 10),
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 children: [
                                                   // Icon(Icons.refresh,size: 20,color: Colors.black),
                                                   Image.asset('assets/images/attendancelisticon_2.jpeg',height: 16,width: 16,
                                                     fit: BoxFit.cover,),
                                                   SizedBox(width: 10),
                                                   Text('In / Out Attendance Time Details',style: AppTextStyle.font12OpenSansRegularBlackTextStyle)
                                                 ],
                                               ),
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
                                               padding: const EdgeInsets.only(bottom: 5),
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                                                 children: [
                                                   Container(
                                                     height: 25, // Height of the first container
                                                     width: 20, // Width of the first container
                                                     decoration: BoxDecoration(
                                                       color: Colors.white, // Background color of the first container
                                                       borderRadius: BorderRadius.circular(20), // Border radius
                                                     ),
                                                     alignment: Alignment.center, // Center the text within the container
                                                     child: 
                                                       Padding(
                                                         padding: const EdgeInsets.only(left: 4),
                                                         child: Icon(Icons.watch_later_rounded,size: 25,color: Color(0xFFD3D3D3)),
                                                       ),
                                                     // Image.asset('assets/images/attendenclisticon_1.jpeg',
                                                     //   height: 20,width: 20,
                                                     //   fit: BoxFit.cover,),

                                                   ),
                                                   SizedBox(width: 19), // Spacing between the two containers
                                                   Text(
                                                       'In Time', // The text to display
                                                       style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                                   ),
                                                   Spacer(),
                                                   Container(
                                                     height: 25, // Height of the container
                                                     width: 150, // Width of the container
                                                     decoration: BoxDecoration(// Background color of the container
                                                       borderRadius: BorderRadius.circular(20), // Border radius
                                                     ),
                                                     alignment: Alignment.centerRight, // Align the text to the right within the container
                                                     padding: EdgeInsets.only(right: 10.0), // Optional: Add some padding to the right
                                                     child: Text(
                                                         '${monthlyAttendance?[index]['sInTime']}', // The text to display
                                                         style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
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
                                                     height: 25, // Height of the first container
                                                     width: 35, // Width of the first container
                                                     decoration: BoxDecoration(
                                                       color: Colors.white, // Background color of the first container
                                                       borderRadius: BorderRadius.circular(20), // Border radius
                                                     ),
                                                     alignment: Alignment.center, // Center the text within the container
                                                     child:
                                                     Icon(Icons.watch_later_rounded,size: 25,color: Color(0xFFD3D3D3)),

                                                   ),
                                                   SizedBox(width: 5), // Spacing between the two containers
                                                   Text(
                                                       'Out Time', // The text to display
                                                       style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                                   ),
                                                   Spacer(),
                                                   Container(
                                                     height: 25, // Height of the container
                                                     width: 150, // Width of the container
                                                     decoration: BoxDecoration(// Background color of the container
                                                       borderRadius: BorderRadius.circular(20), // Border radius
                                                     ),
                                                     alignment: Alignment.centerRight, // Align the text to the right within the container
                                                     padding: EdgeInsets.only(right: 10.0), // Optional: Add some padding to the right
                                                     child: Text(
                                                         '${monthlyAttendance?[index]['sOutTime']}', // The text to display
                                                         style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),
                                       )




                                     ],
                                                                    ),
                                   ),

                                 );
                               },
                         )


                     ),
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
