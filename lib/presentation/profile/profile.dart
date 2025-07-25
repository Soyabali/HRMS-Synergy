import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/profile/profile_education.dart';
import 'package:untitled/presentation/profile/profile_jobDetails.dart';
import 'package:untitled/presentation/profile/profile_personal.dart';
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

  // field declare
  String? sEmpCode,sFirstName,sLastName,sContactNo,sLocation,sDeptName,sDsgName;
  String? fullName,sBloodGroup,sCategory,sCompEmailId,sMngrName,sMngrContactNo,sMngrDesgName,
      sEmergencyContactPerson,sEmergencyContactNo,sEmergencyContactRelation,
      sBankName,sBankAcNo,sISFCode,sCompEmpCode
  ;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  @override
  initState() {
    //print("initState Called");
    toGetLocalDataBaseValue();
  }
  toGetLocalDataBaseValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      sCompEmpCode = prefs.getString('sCompEmpCode');
      sFirstName = prefs.getString('sFirstName');
      sLastName = prefs.getString('sLastName');
      sContactNo = prefs.getString('sContactNo');
      sLocation = prefs.getString('sLocation');//  sDeptName
      fullName = "$sFirstName $sLastName";
      sDeptName = prefs.getString('sDeptName'); // sDsgName
      sDsgName = prefs.getString('sDsgName');  // sBloodGroup
      sBloodGroup = prefs.getString('sBloodGroup'); // sCategory
      sCategory = prefs.getString('sCategory');
      sCompEmailId = prefs.getString('sCompEmailId');
      sMngrName = prefs.getString('sMngrName');// sMngrContactNo
      sMngrContactNo = prefs.getString('sMngrContactNo');
      sMngrDesgName = prefs.getString('sMngrDesgName'); // sEmergencyContactPerson
      sEmergencyContactPerson = prefs.getString('sEmergencyContactPerson');
      sEmergencyContactPerson = prefs.getString('sEmergencyContactPerson'); // sEmergencyContactNo
      sEmergencyContactNo = prefs.getString('sEmergencyContactNo'); // sEmergencyContactRelation
      sEmergencyContactRelation = prefs.getString('sEmergencyContactRelation');  // sBankName
      sBankName = prefs.getString('sBankName');
      sBankAcNo = prefs.getString('sBankAcNo');
      sISFCode = prefs.getString('sISFCode');
    });


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
          child: Padding(
            padding: const EdgeInsets.only(left: 0,right: 0),
            child: Column(
             children: [
               Container(
                 height: 145,
                // color: Color(0xFF2a697b),
                 color: Color(0xFF00acc2),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 16,top: 10),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Image.asset('assets/images/ic_user_profile.PNG',
                             height: 16,
                             width: 16,
                             fit: BoxFit.fill,
                           ),
                           //Icon(Icons.account_box,color: Colors.white,size: 18),
                           SizedBox(width: 10),
                           Text('${fullName}',style: AppTextStyle
                               .font12OpenSansRegularWhiteTextStyle)
                         ],
                       ),
                     ),
                     SizedBox(height: 10),
                     Padding(
                       padding: const EdgeInsets.only(left:50),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           //Icon(Icons.phone,color: Colors.white,size: 18,),
                           Image.asset('assets/images/ic_mobile_phone_white.PNG',
                             height: 16,
                             width: 16,
                             fit: BoxFit.fill,
                           ),
                           SizedBox(width: 10),
                           Text('Mobile No : $sContactNo',style: AppTextStyle
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
                          // Icon(Icons.account_box,color: Colors.white,size: 18),
                           Image.asset('assets/images/ic_id.PNG',
                             height: 16,
                             width: 16,
                             fit: BoxFit.fill,
                           ),
                           SizedBox(width: 10),
                           Text('Employee ID : $sCompEmpCode',style: AppTextStyle
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
                          // Icon(Icons.location_on,color: Colors.white,size: 18,),
                           Image.asset('assets/images/ic_location.PNG',
                             height: 16,
                             width: 16,
                             fit: BoxFit.fill,
                           ),
                           SizedBox(width: 10),
                           Text('$sLocation',style: AppTextStyle
                               .font12OpenSansRegularWhiteTextStyle)
                         ],
                       ),
                     ),
                   ],
                 ),

               ),
               Padding(
                 padding: const EdgeInsets.only(left: 5,right: 5),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                       child: Material(
                         elevation: 4.0, // Elevation for shadow effect
                         borderRadius: BorderRadius.circular(5),
                         child: Container(
                           height: 250,
                           color: Colors.white,
                           child: Padding(
                               padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       GestureDetector(
                                         onTap: (){
                                           print('---Personal--');
                                           Navigator.push(
                                             context,
                                             MaterialPageRoute(builder: (context) => const ProfilePersonal()),
                                           );
                                         },
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: [
                                             //Icon(Icons.file_copy_sharp,size: 16),
                                             Image.asset('assets/images/ic_experience.PNG',
                                               height: 16,
                                               width: 16,
                                               fit: BoxFit.fill,
                                             ),
                                             SizedBox(height: 2),
                                             Text('Personal',style: AppTextStyle
                                                 .font12OpenSansRegularBlackTextStyle)

                                           ],
                                         ),
                                       ),
                                       GestureDetector(
                                         onTap: (){
                                           print('----Education---');
                                           Navigator.push(
                                             context,
                                             MaterialPageRoute(builder: (context) => const ProfileEducation()),
                                           );
                                         },
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: [
                                             Image.asset('assets/images/ic_education.PNG',
                                               height: 16,
                                               width: 16,
                                               fit: BoxFit.fill,
                                             ),
                                             // Icon(Icons.file_copy_outlined,size: 16),
                                             SizedBox(height: 2),
                                             Text('Education',style: AppTextStyle
                                                 .font12OpenSansRegularBlackTextStyle)

                                           ],
                                         ),
                                       ),
                                       GestureDetector(
                                         onTap: (){
                                           print('----job Details----');
                                           Navigator.push(
                                             context,
                                             MaterialPageRoute(builder: (context) => const ProfileJobdetails()),
                                           );
                                         },
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: [
                                             //Icon(Icons.details,size: 16),
                                             Image.asset('assets/images/ic_answers.PNG',
                                               height: 16,
                                               width: 16,
                                               fit: BoxFit.fill,
                                             ),
                                             SizedBox(height: 2),
                                             Text('Job Details',style: AppTextStyle
                                                 .font12OpenSansRegularBlackTextStyle)
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),
                                   // divider
                                   Divider(
                                     color: Colors.grey[400],   // Set the color of the divider to gray
                                     thickness: 0.5,         // Set the thickness of the line
                                     indent: 10,           // Optional: Indent from the left
                                     endIndent: 10,        // Optional: Indent from the right
                                   ),
                                   SizedBox(height: 5),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Expanded(
                                         flex: 1,
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               'Department',
                                               style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                                             ),
                                             SizedBox(height: 5),
                                             Text(
                                               '$sDeptName',
                                               style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                               maxLines: 2, // Allow text to wrap into 2 lines
                                               softWrap: true, // Enable text wrapping
                                               overflow: TextOverflow.ellipsis, // Optional: Show '...' if text exceeds 2 lines
                                             ),
                                           ],
                                         ),
                                       ),
                                       SizedBox(width: 10), // Add some spacing between the two columns if needed
                                       Expanded(
                                         flex: 1,
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               'Designation',
                                               style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                                             ),
                                             SizedBox(height: 5),
                                             Text(
                                               '$sDsgName',
                                               style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                               maxLines: 2, // Allow text to wrap into 2 lines
                                               softWrap: true, // Enable text wrapping
                                               overflow: TextOverflow.ellipsis, // Optional: Show '...' if text exceeds 2 lines
                                             ),
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),

                                   SizedBox(height: 5),
                                   Divider(
                                     color: Colors.grey[400],   // Set the color of the divider to gray
                                     thickness: 0.5,         // Set the thickness of the line
                                     indent: 10,           // Optional: Indent from the left
                                     endIndent: 10,        // Optional: Indent from the right
                                   ),
                                   Row(
                                     children: [
                                       Expanded(
                                         flex: 1, // Flex to equally divide the space
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               'Blood Group',
                                               style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                                             ),
                                             SizedBox(height: 5),
                                             Text(
                                               '$sBloodGroup',
                                               style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                               maxLines: 2, // Wraps the text into 2 lines if too long
                                               softWrap: true, // Enable text wrapping
                                               overflow: TextOverflow.ellipsis, // Optional: show '...' if text exceeds 2 lines
                                             ),
                                           ],
                                         ),
                                       ),
                                       SizedBox(width: 10), // Add spacing between columns if necessary
                                       Expanded(
                                         flex: 1, // Flex to equally divide the space
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               'Category',
                                               style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                                             ),
                                             SizedBox(height: 5),
                                             Text(
                                               '$sCategory',
                                               style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                               maxLines: 2, // Wraps the text into 2 lines if too long
                                               softWrap: true, // Enable text wrapping
                                               overflow: TextOverflow.ellipsis, // Optional: show '...' if text exceeds 2 lines
                                             ),
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: 5),

                                   Divider(
                                     color: Colors.grey[400],   // Set the color of the divider to gray
                                     thickness: 0.5,         // Set the thickness of the line
                                     indent: 10,           // Optional: Indent from the left
                                     endIndent: 10,        // Optional: Indent from the right
                                   ),
                                   Text('Email ID',style: AppTextStyle
                                       .font12OpenSansRegularBlack45TextStyle),
                                   SizedBox(height: 2),
                                   Text('$sCompEmailId',style: AppTextStyle
                                       .font12OpenSansRegularBlackTextStyle),
                                 ],
                               )
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                       child: Material(
                         elevation: 4.0, // Elevation for shadow effect
                         borderRadius: BorderRadius.circular(5),
                         child: Container(
                           height: 195,
                           color: Colors.white,
                           child: Padding(
                               padding: const EdgeInsets.only(
                                left: 5,right: 5,top: 5),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Icon(Icons.notes_outlined,size: 16),
                                       SizedBox(width: 5),
                                       Text('Reporting Person Detail',style: AppTextStyle
                                           .font12OpenSansRegularBlack45TextStyle),
                                     ],
                                   ),
                                   SizedBox(height: 5),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 22),
                                     child: Text('$sMngrName',style: AppTextStyle
                                         .font12OpenSansRegularBlackTextStyle),
                                   ),
                                   SizedBox(height: 5),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 20),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Icon(Icons.call,size: 16),
                                         SizedBox(width: 5),
                                         Text('$sMngrContactNo',style: AppTextStyle
                                             .font12OpenSansRegularBlack45TextStyle),
                                       ],
                                     ),
                                   ),
                                   SizedBox(height: 5),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 20),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('Designation :',style: AppTextStyle
                                             .font12OpenSansRegularBlack45TextStyle),
                                         SizedBox(width: 5),
                                         Flexible(
                                           child: Text('$sMngrDesgName',style: AppTextStyle
                                               .font12OpenSansRegularBlackTextStyle,
                                             overflow: TextOverflow.visible,

                                           ),
                                         ),

                                       ],
                                     ),
                                   ),
                                   SizedBox(height: 5),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Icon(Icons.notes_outlined,size: 16),
                                       SizedBox(width: 5),
                                       Text('Emergency Person Detail',style: AppTextStyle
                                           .font12OpenSansRegularBlack45TextStyle),

                                     ],
                                   ),
                                   SizedBox(height: 5),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 22),
                                     child: Text('$sEmergencyContactPerson',style: AppTextStyle
                                         .font12OpenSansRegularBlackTextStyle),
                                   ),
                                   SizedBox(height:5),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 20),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Icon(Icons.call,size: 16),
                                         SizedBox(width: 5),
                                         Text('$sEmergencyContactNo',style: AppTextStyle
                                             .font12OpenSansRegularBlack45TextStyle),

                                       ],
                                     ),
                                   ),
                                   SizedBox(height: 5),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 20),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('Relation :',style: AppTextStyle
                                             .font12OpenSansRegularBlack45TextStyle),
                                         SizedBox(width: 5),
                                         Flexible(
                                           child: Text('$sEmergencyContactRelation',style: AppTextStyle
                                               .font12OpenSansRegularBlackTextStyle,
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
                       padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                       child: Material(
                         elevation: 4.0, // Elevation for shadow effect
                         borderRadius: BorderRadius.circular(5),
                         child: Container(
                           height: 90,
                           color: Colors.white,
                           child: Padding(
                               padding: const EdgeInsets.only(
                                   left: 5,right: 5,top: 5),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       // Icon(Icons.food_bank,size:16),
                                       Image.asset('assets/images/ic_bank.PNG',
                                         height: 16,
                                         width: 16,
                                         fit: BoxFit.fill,
                                       ),
                                       SizedBox(width: 5),
                                       Text('Bank Name : $sBankName',style: AppTextStyle
                                           .font12OpenSansRegularBlack45TextStyle),

                                     ],
                                   ),
                                   SizedBox(height: 5),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 22),
                                     child: Text('IFSC : $sISFCode',style: AppTextStyle
                                         .font12OpenSansRegularBlackTextStyle),
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
                                             Text('Account Number',
                                                 style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                             ),
                                             SizedBox(width: 5.0), // Space between 'Day' and ':'
                                             Text(
                                                 ': $sBankAcNo',
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

             ],
                ),
          ),
        )
    );
  }
}
