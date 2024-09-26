import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/profile/profile.dart';
import '../../data/personalDetail.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';
import 'dart:convert';

class ProfilePersonal extends StatelessWidget {
  const ProfilePersonal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePersonalPage(),
    );
  }
}

class ProfilePersonalPage extends StatefulWidget {
  const ProfilePersonalPage({super.key});

  @override
  State<ProfilePersonalPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePersonalPage> {

  var sEmpName,sGender,dDOB,sFatherName,sMotherName,sMaritalStatus,sEmpImage,
      sPersonalEmailId,sPermanentAddr,sAdharCardNo,sPanNo,sPassportNo,sVoterId;

  @override
  void initState() {
    // TODO: implement initState
    personalDetailResponse();
    toGetLocalImages();
    super.initState();
  }
  personalDetailResponse() async{
  var   res = await PersonaldetailRepo().personal_detail(context);
    print('---47---$res');
    setState(() {
      sEmpName = "${res[0]['sEmpName']}";
      sGender = "${res[0]['sGender']}";
      dDOB = "${res[0]['dDOB']}";
      sFatherName = "${res[0]['sFatherName']}";
      sMotherName = "${res[0]['sMotherName']}";
      sMaritalStatus = "${res[0]['sMaritalStatus']}";
      sPersonalEmailId = "${res[0]['sPersonalEmailId']}";
      sPermanentAddr = "${res[0]['sPermanentAddr']}";
      sAdharCardNo = "${res[0]['sAdharCardNo']}";
      sPanNo = "${res[0]['sPanNo']}";
      sPassportNo = "${res[0]['sPassportNo']}";
      sVoterId = "${res[0]['sVoterId']}";
    });

  }
  // get local Image from a system
  toGetLocalImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sEmpImage = prefs.getString('sEmpImage');
      print('--65---$sEmpImage');

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
                MaterialPageRoute(builder: (context) => const Profile()),
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
              'Personal Detail',
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20, // Adjust the size as needed
                        backgroundImage: NetworkImage(
                          (sEmpImage != null && sEmpImage.isNotEmpty)
                              ? sEmpImage
                              : 'https://via.placeholder.com/150', // Dummy image URL
                        ),
                      ),
                      // CircleAvatar(
                      //   radius: 20, // Adjust the size as needed
                      //   backgroundImage: NetworkImage(sEmpImage ?? 'https://via.placeholder.com/150'), // Replace with your image URL or use AssetImage
                      // ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$sEmpName', // First Text (Name)
                              style: AppTextStyle
                                  .font14OpenSansRegularBlackTextStyle),
                          SizedBox(height: 0),
                          Text('$sGender', // Second Text (Designation)
                              style: AppTextStyle
                                  .font12OpenSansRegularBlack45TextStyle),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: DottedBorder(
                    color: Colors.grey, // Color of the dotted line
                    strokeWidth: 1.0, // Width of the dotted line
                    dashPattern: [4, 2], // Dash pattern for the dotted line
                    borderType: BorderType.RRect,
                    radius: Radius.circular(5.0), // Optional: rounded corners
                    child: Padding(
                      padding:
                          EdgeInsets.all(2.0), // Equal padding on all sides
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Center the row contents
                        children: [
                          Text('$dDOB',
                              style: AppTextStyle
                                  .font12OpenSansRegularBlackTextStyle),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min, // Wrap content inside the container
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
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
                                borderRadius: BorderRadius.circular(
                                    5), // Border radius of 5
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Father Name',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlack45TextStyle,
                              ),
                              SizedBox(height: 2),
                              Text('$sFatherName',
                                  style: AppTextStyle
                                      .font12OpenSansRegularBlackTextStyle),
                              SizedBox(height: 2),
                              Text(
                                'Mother Name',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlack45TextStyle,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '$sMotherName',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlackTextStyle,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Marriage Status',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlack45TextStyle,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '$sMaritalStatus',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlackTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Material(
                      elevation: 8.0, // Elevation for shadow effect
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width-30,
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Personal Email ID',
                                    style: AppTextStyle
                                        .font12OpenSansRegularBlack45TextStyle),
                                SizedBox(height: 2),
                                Text('$sPersonalEmailId',
                                    style: AppTextStyle
                                        .font12OpenSansRegularBlackTextStyle),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Permanent Addresss',
                                    style: AppTextStyle
                                        .font12OpenSansRegularBlack45TextStyle),
                                SizedBox(height: 2),
                                Flexible(
                                  child: Text(
                                    '$sPermanentAddr',
                                    style: AppTextStyle
                                        .font12OpenSansRegularBlackTextStyle,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Material(
                      elevation: 8.0, // Elevation for shadow effect
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 155,
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.notes_outlined,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text('Government Identity Detail',
                                        style: AppTextStyle
                                            .font12OpenSansRegularBlack45TextStyle),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // First Column
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          // Row with Icon and Text
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.card_giftcard, size: 16),
                                              SizedBox(width: 8), // Space between icon and text
                                              Text('Aadhar No.',
                                                style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4), // Space between Row and Text
                                          // Text below the Row
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 20),
                                            child: Text(
                                              '$sAdharCardNo',
                                              style: AppTextStyle
                                                  .font12OpenSansRegularBlackTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16), // Space between two columns
                                    // Second Column
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          // Row with Icon and Text
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.card_giftcard, size: 16),
                                              SizedBox(width: 8), // Space between icon and text
                                              Text(
                                                'Pan No.',
                                                style: AppTextStyle
                                                    .font12OpenSansRegularBlack45TextStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 4), // Space between Row and Text
                                          // Text below the Row
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(right: 45),
                                            child: Text(
                                              '$sPanNo',
                                              style: AppTextStyle
                                                  .font12OpenSansRegularBlackTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // First Column
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // Row with Icon and Text
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.card_giftcard, size: 16),
                                              SizedBox(width: 8), // Space between icon and text
                                              Text(
                                                'Passport No.',
                                                style: AppTextStyle
                                                    .font12OpenSansRegularBlack45TextStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4), // Space between Row and Text
                                          // Text below the Row
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 22),
                                            child: Text(
                                              '$sPassportNo',
                                              style: AppTextStyle
                                                  .font12OpenSansRegularBlackTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width: 16), // Space between two columns
                                    // Second Column
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Row with Icon and Text
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.card_giftcard,
                                                  size: 18),
                                              SizedBox(
                                                  width:
                                                  8), // Space between icon and text
                                              Text(
                                                'Voter Id No.',
                                                style: AppTextStyle
                                                    .font12OpenSansRegularBlack45TextStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 4), // Space between Row and Text
                                          // Text below the Row
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 25),
                                            child: Text(
                                              '8787',
                                              //'$sVoterId',
                                              style: AppTextStyle
                                                  .font12OpenSansRegularBlackTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
