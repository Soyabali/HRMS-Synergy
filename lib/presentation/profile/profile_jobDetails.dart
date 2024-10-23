import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/presentation/profile/profile.dart';
import '../../data/jobDetailRepo.dart';
import '../../domain/jobDetailModel.dart';
import '../resources/app_text_style.dart';

class ProfileJobdetails extends StatelessWidget {

  const ProfileJobdetails({super.key});

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

  late Future<List<JobDetailmodel>> jobDetailRes;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    jobDetailRes = JobDetailRepo().jobDetailList(context);
    print('-------36---$jobDetailRes');
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
              'Job Detail',
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
        body:
          Column(
            children: [
              Expanded(
                  child: FutureBuilder<List<JobDetailmodel>>(
                      future: jobDetailRes,
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
                              final jobDetail = educationList[index];
                              var companyName = jobDetail.sCompanyName;
                              print('------110---$companyName');

                              return
                                (companyName!="Fresher") ?
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                                    height: 155,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 5, right: 5, top: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            // Row with Icon and "Qualification" text
                                            Row(
                                              children: [
                                                Icon(Icons.school, color: Colors.blue,size: 16),
                                                SizedBox(width: 8),
                                                Text(jobDetail.sCompanyName,
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlack45TextStyle),
                                              ],
                                            ),
                                            // M.C.A Text
                                            Padding(
                                              padding: EdgeInsets.only(left: 25),
                                              child: Text('Company Name',
                                                  style: AppTextStyle
                                                      .font12OpenSansRegularBlackTextStyle),
                                            ),
                                            // Divider
                                            SizedBox(height: 5),
                                            // Row with two Columns (Institution)
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Text('From Date : ',
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlack45TextStyle),
                                                      Text(jobDetail.dFromDate,
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                      children: [
                                                        Text('To Date : ',
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlack45TextStyle),
                                                       // SizedBox(width: 15),
                                                        Text(jobDetail.dToDate,
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlackTextStyle),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            // Divider
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                                Icon(Icons.notes_outlined, size: 16),
                                                SizedBox(width: 5),
                                                Text('Other Detail',
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularBlackTextStyle),

                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                jobDetail.sLeavingReason,
                                                style: AppTextStyle
                                                    .font12OpenSansRegularBlack45TextStyle),
                                            SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: 25,
                                                child: DottedBorder(
                                                  color: Colors.grey,
                                                  // Color of the dotted line
                                                  strokeWidth: 1.0,
                                                  // Width of the dotted line
                                                  dashPattern: [4, 2],
                                                  // Dash pattern for the dotted line
                                                  borderType: BorderType.RRect,
                                                  radius: Radius.circular(5.0),
                                                  // Optional: rounded corners
                                                  child: Padding(
                                                    padding: EdgeInsets.all(2.0),
                                                    // Equal padding on all sides
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      // Center the row contents
                                                      children: [
                                                        Text(
                                                            'Last Salary',
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlackTextStyle
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        // Space between 'Day' and ':'
                                                        Text(
                                                            ':',
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlackTextStyle
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        // Space between ':' and 'Monday'
                                                        Text(
                                                          jobDetail.fLastSalary,
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    :Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.emoji_people,size: 16),
                                        SizedBox(width: 5),
                                        Text('You are working here as a fresher',style: AppTextStyle
                                            .font14OpenSansRegularBlackTextStyle)
                                      ],
                                );
                            }
                        );
                      }
                  )
              )
            ],
          )
    );
    //);

  }

}



