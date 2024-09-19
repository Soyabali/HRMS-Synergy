import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class Userquery extends StatelessWidget {
  const Userquery({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserqueryScreen(),
    );
  }
}

class UserqueryScreen extends StatefulWidget {
  const UserqueryScreen({super.key});

  @override
  State<UserqueryScreen> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<UserqueryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              'User Query',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: Card(
                          elevation: 4, // Adds shadow to the card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Rounded corners
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(5.0), // Padding inside the container
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                borderRadius: BorderRadius.circular(10), // Same radius as the Card
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // Wrap content inside the container
                               crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Color(0xFF0098a6), // Black color
                              borderRadius: BorderRadius.circular(5), // Border radius of 5
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Container(
                              height: 100,
                              width: 2,
                              decoration: BoxDecoration(
                                color: Colors.grey, // Black color
                                borderRadius: BorderRadius.circular(0), // Border radius of 5
                              ),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Color(0xFF2a697b), // Black color
                              borderRadius: BorderRadius.circular(5), // Border radius of 5
                            ),
                          ),

                        ],
                      ),
                      SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('Query At',style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                            ),
                          SizedBox(height: 2),
                          Text('17/Sep/2024',style: AppTextStyle.font12OpenSansRegularBlackTextStyle),
                          SizedBox(height: 2),
                          Container(
                            height: 25,
                            child: DottedBorder(
                              color: Colors.grey, // Color of the dotted line
                              strokeWidth: 1.0, // Width of the dotted line
                              dashPattern: [4, 2], // Dash pattern for the dotted line
                              borderType: BorderType.RRect,
                              radius: Radius.circular(5.0), // Optional: rounded corners
                              child: Padding(
                                padding: EdgeInsets.all(2.0), // Equal padding on all sides
                                child: Row(
                                  mainAxisSize: MainAxisSize.min, // Center the row contents
                                  children: [
                                    Text(
                                        'Title',
                                        style: AppTextStyle.font12OpenSansRegularBlack45TextStyle
                                    ),
                                    SizedBox(width: 5.0), // Space between 'Day' and ':'
                                    Text(
                                        ':',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                    ),
                                    SizedBox(width: 5.0), // Space between ':' and 'Monday'
                                    Text(
                                        'Test',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                         // Text('Data Query',style: AppTextStyle.font12OpenSansRegularBlackTextStyle,),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Query :',style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,),
                              SizedBox(width: 5),
                              Text('Test',style: AppTextStyle.font12OpenSansRegularBlackTextStyle,),
                            ],
                          ),
                          SizedBox(height: 2),
                         // Text('Data Query',style: AppTextStyle.font12OpenSansRegularBlackTextStyle,),
                          Text('Response At',style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,),
                          SizedBox(height: 2),
                          Text('Not Updated Yet',style: AppTextStyle.font12OpenSansRegularBlackTextStyle,),
                        ],
                      )
                    ],
                  ),

                                ],
                              ),
                            ),
                          ),
                ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10), // Adjust padding as necessary
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0098a6), // Green color
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Post Query',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),


        ],
       )
       ],
    )
    );
  }
}
