import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
              'Profile',
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
           children: [
             Container(
               height: 135,
               color: Color(0xFF2a697b),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 16,top: 10),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Icon(Icons.account_box,color: Colors.white,size: 18),
                         SizedBox(width: 10),
                         Text('Soyab Ali',style: AppTextStyle
                             .font12OpenSansRegularWhiteTextStyle)
                       ],
                     ),
                   ),
                   SizedBox(height: 10),
                   Padding(
                     padding: const EdgeInsets.only(left:50,),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Icon(Icons.phone,color: Colors.white,size: 18,),
                         SizedBox(width: 10),
                         Text('Mobile No : 9871950881',style: AppTextStyle
                             .font12OpenSansRegularWhiteTextStyle)
                       ],
                     ),
                   ),
                   SizedBox(height: 10),
                   Padding(
                     padding: const EdgeInsets.only(left:50,),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Icon(Icons.account_box,color: Colors.white,size: 18),
                         SizedBox(width: 10),
                         Text('Employee ID : ST2322',style: AppTextStyle
                             .font12OpenSansRegularWhiteTextStyle)
                       ],
                     ),
                   ),
                   SizedBox(height: 10),
                   Padding(
                     padding: const EdgeInsets.only(left: 16,top: 5),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Icon(Icons.location_on,color: Colors.white,size: 18,),
                         SizedBox(width: 10),
                         Text('A-5 Block-A,Sector 57,Noida,Uttar Pradesh',style: AppTextStyle
                             .font12OpenSansRegularWhiteTextStyle)
                       ],
                     ),
                   ),
                 ],
               ),
          
             ),
             Padding(
               padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
               child: Material(
                 elevation: 8.0, // Elevation for shadow effect
                 borderRadius: BorderRadius.circular(15),
                 child: Container(
                   height: 220,
                   color: Colors.white,
                   child: Padding(
                     padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Icon(Icons.file_copy_sharp,size: 18),
                                 SizedBox(height: 2),
                                 Text('Personal',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle)
          
                               ],
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Icon(Icons.file_copy_outlined,size: 18),
                                 SizedBox(height: 2),
                                 Text('Education',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle)
          
                               ],
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Icon(Icons.details,size: 18),
                                 SizedBox(height: 2),
                                 Text('Job Details',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle)
          
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Department',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle),
                                 SizedBox(height: 5),
                                 Text('IT',style: AppTextStyle
                                     .font14OpenSansRegularBlackTextStyle)
                               ],
          
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Designation',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle),
                                 SizedBox(height: 5),
                                 Text('Flutter Developer',style: AppTextStyle
                                     .font14OpenSansRegularBlackTextStyle)
                               ],
          
                             ),
                           ],
                         ),
                         SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Blood Group',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle),
                                 SizedBox(height: 5),
                                 Text('o+',style: AppTextStyle
                                     .font14OpenSansRegularBlackTextStyle)
                               ],
          
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Category',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle),
                                 SizedBox(height: 5),
                                 Text('GENERAL',style: AppTextStyle
                                     .font14OpenSansRegularBlackTextStyle)
                               ],
          
                             ),
                           ],
                         ),
                         SizedBox(height: 10),
                         Text('Email ID',style: AppTextStyle
                             .font14OpenSansRegularBlack45TextStyle),
                         SizedBox(height: 2),
                         Text('soyabali64@gmail.com',style: AppTextStyle
                             .font14OpenSansRegularBlackTextStyle),
                       ],
                     )
                   ),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
               child: Material(
                 elevation: 8.0, // Elevation for shadow effect
                 borderRadius: BorderRadius.circular(15),
                 child: Container(
                   height: 160,
                   color: Colors.white,
                   child: Padding(
                       padding: const EdgeInsets.only(
                       left: 10,right: 10,top: 10),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Icon(Icons.menu_open_outlined,size: 18,),
                               SizedBox(width: 5),
                               Text('Reporting Person Detail',style: AppTextStyle
                                   .font14OpenSansRegularBlack45TextStyle),
          
                             ],
                           ),
                           SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.only(left: 22),
                             child: Text('Jitender Wadhwan',style: AppTextStyle
                                 .font14OpenSansRegularBlackTextStyle),
                           ),
                           SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.only(left: 20),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Icon(Icons.call,size: 18,),
                                 SizedBox(width: 5),
                                 Text('9810754385',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle),
          
                               ],
                             ),
                           ),
                           SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.only(left: 20),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text('Designation :',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle),
                                 SizedBox(width: 5),
                                 Flexible(
                                   child: Text('Deputy General Manager - Software Development',style: AppTextStyle
                                       .font14OpenSansRegularBlackTextStyle,
                                     overflow: TextOverflow.visible,
                                   
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
             ),
             Padding(
               padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
               child: Material(
                 elevation: 8.0, // Elevation for shadow effect
                 borderRadius: BorderRadius.circular(15),
                 child: Container(
                   height: 130,
                   color: Colors.white,
                   child: Padding(
                       padding: const EdgeInsets.only(
                           left: 10,right: 10,top: 10),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Icon(Icons.menu_open_outlined,size: 18,),
                               SizedBox(width: 5),
                               Text('Emergency Person Detail',style: AppTextStyle
                                   .font14OpenSansRegularBlack45TextStyle),
          
                             ],
                           ),
                           SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.only(left: 22),
                             child: Text('Huma',style: AppTextStyle
                                 .font14OpenSansRegularBlackTextStyle),
                           ),
                           SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.only(left: 20),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Icon(Icons.call,size: 18,),
                                 SizedBox(width: 5),
                                 Text('7055088386',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle),
          
                               ],
                             ),
                           ),
                           SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.only(left: 20),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text('Relation :',style: AppTextStyle
                                     .font14OpenSansRegularBlack45TextStyle),
                                 SizedBox(width: 5),
                                 Flexible(
                                   child: Text('Wife',style: AppTextStyle
                                       .font14OpenSansRegularBlackTextStyle,
                                     overflow: TextOverflow.visible,
          
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
             ),
             Padding(
               padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
               child: Material(
                 elevation: 8.0, // Elevation for shadow effect
                 borderRadius: BorderRadius.circular(15),
                 child: Container(
                   height: 130,
                   color: Colors.white,
                   child: Padding(
                       padding: const EdgeInsets.only(
                           left: 10,right: 10,top: 10),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Icon(Icons.food_bank,size: 18,),
                               SizedBox(width: 5),
                               Text('Bank Name : NA',style: AppTextStyle
                                   .font14OpenSansRegularBlack45TextStyle),

                             ],
                           ),
                           SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.only(left: 22),
                             child: Text('IFSC :',style: AppTextStyle
                                 .font14OpenSansRegularBlackTextStyle),
                           ),
                           SizedBox(height: 10),
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
                                           'Account Number',
                                           style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                       ),
                                       SizedBox(width: 5.0), // Space between 'Day' and ':'
                                       Text(
                                           ':',
                                           style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                       ),
                                       SizedBox(width: 5.0), // Space between ':' and 'Monday'
                                       Text(
                                           '',
                                           style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             ),
                         ],
                       )
                   ),
                 ),
               ),
             ),
          
           ],
              ),
        )
    );
  }
}
