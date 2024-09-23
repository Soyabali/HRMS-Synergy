import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/presentation/profile/profile.dart';

import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class ProfileEducation extends StatelessWidget {
  const ProfileEducation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileEducationPage(),
    );
  }
}

class ProfileEducationPage extends StatefulWidget {
  const ProfileEducationPage({super.key});

  @override
  State<ProfileEducationPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileEducationPage> {
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
              'Education',
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
                            'https://via.placeholder.com/150'), // Replace with your image URL or use AssetImage
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Soyab Ali', // First Text (Name)
                              style: AppTextStyle
                                  .font14OpenSansRegularBlackTextStyle),
                          SizedBox(height: 0),
                          Text('Male', // Second Text (Designation)
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
                          Text('20/Jun/1992',
                              style: AppTextStyle
                                  .font12OpenSansRegularBlackTextStyle),
                          SizedBox(width: 5.0), // Space between 'Day' and ':'
                          Text(':',
                              style: AppTextStyle
                                  .font12OpenSansRegularBlackTextStyle),
                          SizedBox(
                              width: 5.0), // Space between ':' and 'Monday'
                          Text('',
                              style: AppTextStyle
                                  .font12OpenSansRegularBlackTextStyle),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize:
                MainAxisSize.min, // Wrap content inside the container
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
                                borderRadius: BorderRadius.circular(
                                    5), // Border radius of 5
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Container(
                                height: 100,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: Colors.grey, // Black color
                                  borderRadius: BorderRadius.circular(
                                      0), // Border radius of 5
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
                              Text('Mr.Sabir Ali',
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
                                'Mrs.Khasroon',
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
                                'Married',
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
                        height: 120,
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
                                Text('Not Specified',
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
                                    'Vill - Bharampur,Badhli, Dist Hapur,Post- Nagli Via kithore, 250104',
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
                                            .font14OpenSansRegularBlack45TextStyle),
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
                                              Icon(Icons.card_giftcard,
                                                  size: 18),
                                              SizedBox(
                                                  width:
                                                  8), // Space between icon and text
                                              Text(
                                                'Aadhar No.',
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 4), // Space between Row and Text
                                          // Text below the Row
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(right: 12),
                                            child: Text(
                                              '331919758643',
                                              style: AppTextStyle
                                                  .font14OpenSansRegularBlackTextStyle,
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
                                                'Pan No.',
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 4), // Space between Row and Text
                                          // Text below the Row
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(right: 28),
                                            child: Text(
                                              'AAACB8403F',
                                              style: AppTextStyle
                                                  .font14OpenSansRegularBlackTextStyle,
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
                                                'Passport No.',
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 4), // Space between Row and Text
                                          // Text below the Row
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(right: 22),
                                            child: Text(
                                              'Not Specified',
                                              style: AppTextStyle
                                                  .font14OpenSansRegularBlackTextStyle,
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
                                                    .font14OpenSansRegularBlack45TextStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 4), // Space between Row and Text
                                          // Text below the Row
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(right: 28),
                                            child: Text(
                                              'No Specified',
                                              style: AppTextStyle
                                                  .font14OpenSansRegularBlackTextStyle,
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
        )
    );
  }
}
