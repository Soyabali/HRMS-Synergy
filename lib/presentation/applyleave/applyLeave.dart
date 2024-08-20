import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';


class Applyleave extends StatelessWidget {
  const Applyleave({super.key});

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
      home: ApplyLeaveHome(),
    );
  }
}

class ApplyLeaveHome extends StatefulWidget {
  const ApplyLeaveHome({super.key});

  @override
  State<ApplyLeaveHome> createState() => _AttendaceListHomeState();
}

class _AttendaceListHomeState extends State<ApplyLeaveHome> {
  bool _isSwitchOn = false;
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
            'Apply Leave',
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
        children:[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             SizedBox(height: 15),
             Padding(
               padding: const EdgeInsets.only(left: 5.0,right: 5.0),
               child: Row(
                         mainAxisAlignment: MainAxisAlignment.start, // Aligns items to the start
                         children: [
                           // AssetImage inside an Image widget
                           Image.asset(
                'assets/images/ic_expense.png', // Replace with your asset image path
                width: 25, // Set the width of the image
                height: 25, // Set the height of the image
                           ),
                           SizedBox(width: 10), // Adds spacing between the image and the text
                           // Text Widget
                           Text(
                'Check Your YTD Entitlement',
                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                           ),
                           SizedBox(width: 10), // Adds spacing between the text and the checkbox
                           // Checkbox Widget
                           Switch(
                value: _isSwitchOn,
                onChanged: (value) {
                  setState(() {
                    _isSwitchOn = value; // Update the switch state
                  });
                },
                           ),
                           // Display the state of the switch
                           Text(
                _isSwitchOn
                    ? 'ON' : 'OFF',
                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                           ),
                         ],
                       ),
             ),
              _isSwitchOn
              ? Column(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10,top: 10),
                    child:Card(
                        color: Colors.white,
                        elevation: 5.0, // Elevation of the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Border radius of the card
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                              children: [
                                Container(
                                  height: 56, // Height of the first container
                                  width: MediaQuery.of(context).size.width-20, // Width of the first container
                                  decoration: BoxDecoration(
                                    color: Colors.grey, // Background color of the first container
                                    borderRadius: BorderRadius.circular(0), // Border radius
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.blue, // Color of the left border
                                        width: 5.0, // Width of the left border
                                      ),
                                    ),
                                  ),
                                  // Center the text within the container
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Leave Type',
                                              style: TextStyle(
                                                  color: Color(0xFF0098a6),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Casual Leave',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ],
                                        ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 12,right: 15),
                                child: Container(
                                  height: 30, // Height of the container
                                  width: 100, // Width of the container
                                  //color: Colors.white, // Background color of the container
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color of the container
                                    borderRadius: BorderRadius.circular(15), // Border radius
                                  ),
                                  alignment: Alignment.center, // Center the text within the container
                                  child: Text(
                                    'YTD : 2', // The text to display
                                    style: TextStyle(
                                      color: Colors.black, // Text color
                                      fontSize: 16, // Text size
                                    ),
                                  ),
                                ),
                              )


                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '0', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '3', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '0', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '2', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 40, // Height of the second container
                                  width: 110, // Width of the second container
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0098a6), // Background color of the second container
                                    borderRadius: BorderRadius.circular(20), // Border radius
                                  ),
                                  alignment: Alignment.center, // Center the text within the container
                                  child: Text(
                                      'Apply', // The text to display
                                      style: AppTextStyle.font12OpenSansRegularWhiteTextStyle
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5,bottom: 0,top: 0),
                    child:Card(
                        color: Colors.white,
                        elevation: 5.0, // Elevation of the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Border radius of the card
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                              children: [
                                Container(
                                  height: 56, // Height of the first container
                                  width: MediaQuery.of(context).size.width-20, // Width of the first container
                                  decoration: BoxDecoration(
                                    color: Colors.grey, // Background color of the first container
                                    borderRadius: BorderRadius.circular(0), // Border radius
                                    border: const Border(
                                      left: BorderSide(
                                        color: Colors.blue, // Color of the left border
                                        width: 5.0, // Width of the left border
                                      ),
                                    ),
                                  ),
                                  // Center the text within the container
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Leave Type',
                                          style: TextStyle(
                                              color: Color(0xFF0098a6),
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                        // Text(
                                        //   'Leave Type',
                                        //   style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                        // ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Leave Without Pay',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: const Text(
                                          '0', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    const Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: const Text(
                                          '3', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    const Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '0', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    const Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: const Text(
                                          '2', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Note:-Salary will be deducated for this leave.',style: TextStyle(
                                    color: Colors.redAccent,fontSize: 10,fontWeight: FontWeight.normal
                                ),),
                                Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      height: 40, // Height of the second container
                                      width: 110, // Width of the second container
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent, // Background color of the second container
                                        borderRadius: BorderRadius.circular(20), // Border radius
                                      ),
                                      alignment: Alignment.center, // Center the text within the container
                                      child: Text(
                                          'Apply', // The text to display
                                          style: AppTextStyle.font12OpenSansRegularWhiteTextStyle
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        )
                    ),
                  ),
                ],
              )
             :
              Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10,top: 10),
                        child:Card(
                            color: Colors.white,
                            elevation: 5.0, // Elevation of the card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0), // Border radius of the card
                            ),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                                  children: [
                                    Container(
                                      height: 56, // Height of the first container
                                      width: MediaQuery.of(context).size.width-20, // Width of the first container
                                      decoration: BoxDecoration(
                                        color: Colors.grey, // Background color of the first container
                                        borderRadius: BorderRadius.circular(0), // Border radius
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.blue, // Color of the left border
                                            width: 5.0, // Width of the left border
                                          ),
                                        ),
                                      ),
                                      // Center the text within the container
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Leave Type',
                                              style: TextStyle(
                                                  color: Color(0xFF0098a6),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                            // Text(
                                            //   'Leave Type',
                                            //   style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                            // ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Casual Leave',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 5, // Elevation of the container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                          child: Container(
                                            height: 40, // Height of the container
                                            width: 40, // Width of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                              borderRadius: BorderRadius.circular(20), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: Text(
                                              '0', // The text to display
                                              style: TextStyle(
                                                color: Colors.grey, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Opening', // The text to display
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 5, // Elevation of the container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                          child: Container(
                                            height: 40, // Height of the container
                                            width: 40, // Width of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                              borderRadius: BorderRadius.circular(20), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: Text(
                                              '3', // The text to display
                                              style: TextStyle(
                                                color: Colors.grey, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Opening', // The text to display
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 5, // Elevation of the container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                          child: Container(
                                            height: 40, // Height of the container
                                            width: 40, // Width of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                              borderRadius: BorderRadius.circular(20), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: Text(
                                              '0', // The text to display
                                              style: TextStyle(
                                                color: Colors.grey, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Opening', // The text to display
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 5, // Elevation of the container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                          child: Container(
                                            height: 40, // Height of the container
                                            width: 40, // Width of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                              borderRadius: BorderRadius.circular(20), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: Text(
                                              '2', // The text to display
                                              style: TextStyle(
                                                color: Colors.grey, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Opening', // The text to display
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      height: 40, // Height of the second container
                                      width: 110, // Width of the second container
                                      decoration: BoxDecoration(
                                        color: Color(0xFF0098a6), // Background color of the second container
                                        borderRadius: BorderRadius.circular(20), // Border radius
                                      ),
                                      alignment: Alignment.center, // Center the text within the container
                                      child: Text(
                                          'Apply', // The text to display
                                          style: AppTextStyle.font12OpenSansRegularWhiteTextStyle
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5,right: 5,bottom: 0,top: 0),
                        child:Card(
                            color: Colors.white,
                            elevation: 5.0, // Elevation of the card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0), // Border radius of the card
                            ),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                                  children: [
                                    Container(
                                      height: 56, // Height of the first container
                                      width: MediaQuery.of(context).size.width-20, // Width of the first container
                                      decoration: BoxDecoration(
                                        color: Colors.grey, // Background color of the first container
                                        borderRadius: BorderRadius.circular(0), // Border radius
                                        border: const Border(
                                          left: BorderSide(
                                            color: Colors.blue, // Color of the left border
                                            width: 5.0, // Width of the left border
                                          ),
                                        ),
                                      ),
                                      // Center the text within the container
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Leave Type',
                                              style: TextStyle(
                                                  color: Color(0xFF0098a6),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                            // Text(
                                            //   'Leave Type',
                                            //   style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                            // ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Leave Without Pay',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 5, // Elevation of the container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                          child: Container(
                                            height: 40, // Height of the container
                                            width: 40, // Width of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                              borderRadius: BorderRadius.circular(20), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: const Text(
                                              '0', // The text to display
                                              style: TextStyle(
                                                color: Colors.grey, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        const Text(
                                          'Opening', // The text to display
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 5, // Elevation of the container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                          child: Container(
                                            height: 40, // Height of the container
                                            width: 40, // Width of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                              borderRadius: BorderRadius.circular(20), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: const Text(
                                              '3', // The text to display
                                              style: TextStyle(
                                                color: Colors.grey, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        const Text(
                                          'Opening', // The text to display
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 5, // Elevation of the container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                          child: Container(
                                            height: 40, // Height of the container
                                            width: 40, // Width of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                              borderRadius: BorderRadius.circular(20), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: Text(
                                              '0', // The text to display
                                              style: TextStyle(
                                                color: Colors.grey, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        const Text(
                                          'Opening', // The text to display
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 5, // Elevation of the container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                          child: Container(
                                            height: 40, // Height of the container
                                            width: 40, // Width of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                              borderRadius: BorderRadius.circular(20), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: const Text(
                                              '2', // The text to display
                                              style: TextStyle(
                                                color: Colors.grey, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Opening', // The text to display
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text('Note:-Salary will be deducated for this leave.',style: TextStyle(
                                          color: Colors.redAccent,fontSize: 10,fontWeight: FontWeight.normal
                                      ),),
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          height: 40, // Height of the second container
                                          width: 110, // Width of the second container
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent, // Background color of the second container
                                            borderRadius: BorderRadius.circular(20), // Border radius
                                          ),
                                          alignment: Alignment.center, // Center the text within the container
                                          child: Text(
                                              'Apply', // The text to display
                                              style: AppTextStyle.font12OpenSansRegularWhiteTextStyle
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                              ],
                            )
                        ),
                      ),
                    ],
                  ),


            ],
          ),
        ],
      ),
    );
  }
}
