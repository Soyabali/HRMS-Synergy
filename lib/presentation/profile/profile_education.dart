import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/data/educationResponseRepo.dart';
import 'package:untitled/domain/educationModel.dart';
import 'package:untitled/presentation/profile/profile.dart';
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

  late Future<List<EducationModel>> educationRes;

  @override
  void initState() {
    // TODO: implement initState

    educationRes = EducationrRepo().educationList(context);
    print('-----38---$educationRes');
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
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

        body: Column(
          children: [
            Expanded(
                child: FutureBuilder<List<EducationModel>>(
                    future: educationRes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No data'));
                      }
                      final educationList = snapshot.data!;

                      return ListView.builder(
                          itemCount: educationList.length,
                          itemBuilder: (context, index) {
                            final education = educationList[index];

                            return Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                              child: Container(
                               // margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                height: 195,
                                child: Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Row with Icon and "Qualification" text
                                        Row(
                                          children: [
                                            Image.asset('assets/images/ic_qualification.PNG',
                                              height: 16,
                                              width: 16,
                                              fit: BoxFit.fill,
                                            ),
                                           // Icon(Icons.school, color: Colors.blue),
                                            SizedBox(width: 8),
                                            Text('Qualification',
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        // M.C.A Text
                                        Padding(
                                          padding: EdgeInsets.only(left: 28),
                                          child: Text(education.sQualdName,
                                              style: AppTextStyle
                                                  .font12OpenSansRegularBlackTextStyle),
                                        ),
                                        // Divider
                                        Divider(color: Colors.grey),
                                        SizedBox(height: 2),
                                        // Row with two Columns (Institution)
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  Image.asset('assets/images/ic_institutation.PNG',
                                                    height: 16,
                                                    width: 16,
                                                    fit: BoxFit.fill,
                                                  ),
                                                 // Icon(Icons.business, color: Colors.blue),
                                                  SizedBox(width: 8),
                                                  Text('Institution',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularBlack45TextStyle),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(':',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle),
                                                    SizedBox(width: 15),
                                                    Text(education.sInstitutation,
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        // Divider
                                        Divider(color: Colors.grey),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                 // Icon(Icons.business, color: Colors.blue),
                                                  Image.asset('assets/images/ic_subject.PNG',
                                                    height: 16,
                                                    width: 16,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('Subject',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularBlack45TextStyle),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(':',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle),
                                                    SizedBox(width: 15),
                                                    Text(education.sSubjects,
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Divider(color: Colors.grey),
                                        Row(
                                          children: [
                                            // First Column (Passed Year)
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text('Passed Year',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularBlack45TextStyle),
                                                  SizedBox(height: 4),
                                                  Text(education.dPassedOut,
                                                      style: AppTextStyle
                                                          .font12OpenSansRegularBlackTextStyle),
                                                ],
                                              ),
                                            ),

                                            // Vertical Divider
                                            Container(
                                              height:
                                              40, // Ensure the height of the divider is sufficient
                                              child: VerticalDivider(
                                                color: Colors.grey,
                                                thickness:
                                                1, // Thickness of the divider line
                                              ),
                                            ),

                                            // Second Column (Percentage)
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text('Percentage',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularBlack45TextStyle),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '${education.fPercentage}%',  // Concatenating % to the value
                                                    style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                                  ),
                                                  // Text(education.fPercentage,
                                                  //     style: AppTextStyle
                                                  //         .font12OpenSansRegularBlackTextStyle),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }))
          ],
        )

    );
  }
}
