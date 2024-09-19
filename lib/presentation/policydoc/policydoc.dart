import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class PolicyDoc extends StatelessWidget {

  const PolicyDoc({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PolicydocScreen(),
    );
  }
}
class PolicydocScreen extends StatefulWidget {
  const PolicydocScreen({super.key});

  @override
  State<PolicydocScreen> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<PolicydocScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      // appBar
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
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
            'Policy Doc',
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
          Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: Card(
             elevation: 5, // Elevation for shadow effect
                     shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
              side: BorderSide(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // First Column: Takes 80% of the width
                             Expanded(
                              flex: 8, // 80% of width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.red, // Red color
                                          borderRadius: BorderRadius.circular(5), // Radius of 5
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                       Text(
                                        '04 Mar 2024',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 4), // Spacing between the two texts
                                  Text(
                                    'Holiday Calender 2024',
                                    style: AppTextStyle.font12OpenSansRegularBlackTextStyle,

                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2, // 20% of width
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Transform.rotate(
                                  angle: 45 * (3.1415927 / 180), // Rotate by 90 degrees (convert degrees to radians)
                                  child: IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () {
                                      // Handle onPressed for icon here
                                    },
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'The Public hoilday for the year 2024. The Public hoilday for the year 2024 The Public hoilday for the year 2024The Public hoilday for the year 2024',
                          style: AppTextStyle.font10OpenSansRegularBlackTextStyle,
                        ),
                        SizedBox(height: 5),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Aligns Row to the right
                          children: [
                            // Accept text with iOS forward icon
                            Row(
                              children: [
                                Text('ACCEPT', style: AppTextStyle.font12OpenSansRegularGreenTextStyle,

                                ),
                                SizedBox(width: 8), // Space between text and icon
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                            SizedBox(width: 20), // Space between "Accept" and "Reject"

                            // Reject text with iOS forward icon
                            Row(
                              children: [
                                Text('REJECT', style: AppTextStyle.font12OpenSansRegularRedTextStyle),
                                SizedBox(width: 8), // Space between text and icon
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: Card(
              elevation: 5, // Elevation for shadow effect
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  side: BorderSide(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // First Column: Takes 80% of the width
                            Expanded(
                              flex: 8, // 80% of width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.red, // Red color
                                          borderRadius: BorderRadius.circular(5), // Radius of 5
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '04 Mar 2024',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 4), // Spacing between the two texts
                                  Text(
                                    'Holiday Calender 2024',
                                    style: AppTextStyle.font12OpenSansRegularBlackTextStyle,

                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2, // 20% of width
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Transform.rotate(
                                  angle: 45 * (3.1415927 / 180), // Rotate by 90 degrees (convert degrees to radians)
                                  child: IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () {
                                      // Handle onPressed for icon here
                                    },
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Leave Policy',
                          style: AppTextStyle.font10OpenSansRegularBlackTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Aligns Row to the right
                          children: [
                            // Accept text with iOS forward icon
                            Row(
                              children: [
                                Text('ACCEPT', style: AppTextStyle.font12OpenSansRegularGreenTextStyle,

                                ),
                                SizedBox(width: 8), // Space between text and icon
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                            SizedBox(width: 20), // Space between "Accept" and "Reject"

                            // Reject text with iOS forward icon
                            Row(
                              children: [
                                Text('REJECT', style: AppTextStyle.font12OpenSansRegularRedTextStyle),
                                SizedBox(width: 8), // Space between text and icon
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: Card(
              elevation: 5, // Elevation for shadow effect
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  side: BorderSide(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // First Column: Takes 80% of the width
                            Expanded(
                              flex: 8, // 80% of width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.red, // Red color
                                          borderRadius: BorderRadius.circular(5), // Radius of 5
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '04 Mar 2024',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 4), // Spacing between the two texts
                                  Text(
                                    'Holiday Calender 2024',
                                    style: AppTextStyle.font12OpenSansRegularBlackTextStyle,

                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2, // 20% of width
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Transform.rotate(
                                  angle: 45 * (3.1415927 / 180), // Rotate by 90 degrees (convert degrees to radians)
                                  child: IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () {
                                      // Handle onPressed for icon here
                                    },
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Leave Policy',
                          style: AppTextStyle.font10OpenSansRegularBlackTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Aligns Row to the right
                          children: [
                            // Accept text with iOS forward icon
                            Row(
                              children: [
                                Text('ACCEPT', style: AppTextStyle.font12OpenSansRegularGreenTextStyle,

                                ),
                                SizedBox(width: 8), // Space between text and icon
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                            SizedBox(width: 20), // Space between "Accept" and "Reject"

                            // Reject text with iOS forward icon
                            Row(
                              children: [
                                Text('REJECT', style: AppTextStyle.font12OpenSansRegularRedTextStyle),
                                SizedBox(width: 8), // Space between text and icon
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: Card(
              elevation: 5, // Elevation for shadow effect
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  side: BorderSide(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // First Column: Takes 80% of the width
                            Expanded(
                              flex: 8, // 80% of width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.red, // Red color
                                          borderRadius: BorderRadius.circular(5), // Radius of 5
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '04 Mar 2024',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 4), // Spacing between the two texts
                                  Text(
                                    'Holiday Calender 2024',
                                    style: AppTextStyle.font12OpenSansRegularBlackTextStyle,

                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2, // 20% of width
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Transform.rotate(
                                  angle: 45 * (3.1415927 / 180), // Rotate by 90 degrees (convert degrees to radians)
                                  child: IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () {
                                      // Handle onPressed for icon here
                                    },
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Leave Policy',
                          style: AppTextStyle.font10OpenSansRegularBlackTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Aligns Row to the right
                          children: [
                            // Accept text with iOS forward icon
                            Row(
                              children: [
                                Text('ACCEPT', style: AppTextStyle.font12OpenSansRegularGreenTextStyle,

                                ),
                                SizedBox(width: 8), // Space between text and icon
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                            SizedBox(width: 20), // Space between "Accept" and "Reject"

                            // Reject text with iOS forward icon
                            Row(
                              children: [
                                Text('REJECT', style: AppTextStyle.font12OpenSansRegularRedTextStyle),
                                SizedBox(width: 8), // Space between text and icon
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

