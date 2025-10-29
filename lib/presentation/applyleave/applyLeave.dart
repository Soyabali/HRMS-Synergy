import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/hrmsLeaveBalaceV2.dart';
import '../../domain/leavebalance.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';
import 'applyleaveSubmitForm.dart';

class Applyleave extends StatefulWidget {
  Applyleave();


  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<Applyleave> {

  late Future<List<LeaveData>> futureLeaveData;
  Color? containerColor;
  Color? textColor;
  var abc;
  var sLvDescTitle;
  var dDate;
  var sLvDesc;

  final List<Color> colorList = [
    Color(0xFF4DB6AC),
    Color(0xFFE1A245),
    Color(0xFFC888D3),
    Color(0xFFE88989),
    Color(0xFFA6A869),
    Color(0xFF379BF3),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  @override
  void initState() {
    super.initState();
    futureLeaveData = Hrmsleavebalacev2Repo().getHrmsleavebalacev2(context);
    print('---46--response---$futureLeaveData');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              // statusBarColore
              systemOverlayStyle: const SystemUiOverlayStyle(
                // Status bar color  // 2a697b
                statusBarColor: Color(0xFF2a697b),
                // Status bar brightness (optional)
                statusBarIconBrightness:
                    Brightness.dark, // For Android (dark icons)
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

            body: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Container(
                child: FutureBuilder<List<LeaveData>>(
                  future: futureLeaveData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          LeaveData leaveData = snapshot.data![index];
                          sLvDesc = leaveData.sLvDesc;
                          sLvDescTitle = (sLvDesc == "Leave Without Pay")
                              ? "Note:-Salary will be deducted for this leave."
                              : "";
                          var containerColor;
                          var textColor;
                          if (sLvDesc == "Leave Without Pay") {
                            containerColor = Colors.redAccent;
                            textColor = Colors.redAccent;
                          } else {
                            containerColor = Color(0xFF0098a6);
                            textColor = Colors.black;
                          }
                          final randomColor = colorList[index % colorList.length];

                          return Container(
                            child: Card(
                              color: Colors.white,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    0), // Remove border radius
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF0F0F0),
                                            border: Border(
                                              left: BorderSide(
                                                color: randomColor,
                                                width: 5.0,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Leave Type',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF607D8B),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        leaveData.sLvDesc,
                                                        style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Material(
                                            elevation: 4, // Elevation of the container
                                            borderRadius: BorderRadius.circular(25),
                                            // Border radius
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white, // inner background color
                                                border: Border.all(
                                                  color: Colors.grey, // light gray border color
                                                  width: 2, // border thickness
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                leaveData.fOpeningBal,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Opening', // The text to display
                                            style: TextStyle(
                                              color: Colors.black, // Text color
                                              fontSize: 14, // Text size
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Material(
                                            elevation:
                                                5, // Elevation of the container
                                            borderRadius: BorderRadius.circular(25), // Border radius
                                             child: Container(
                                               width: 50,
                                               height: 50,
                                               decoration: BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 color: Colors.white, // inner background color
                                                 border: Border.all(
                                                   color: Colors.grey, // light gray border color
                                                   width: 2, // border thickness
                                                 ),
                                               ),
                                               alignment: Alignment.center,
                                               child: Text(
                                                 leaveData.fEntitlement,
                                                 style: const TextStyle(
                                                   color: Colors.grey,
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                             ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Entitlement', // The text to display
                                            style: TextStyle(
                                              color: Colors.black, // Text color
                                              fontSize: 14, // Text size
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Material(
                                            elevation:
                                                5, // Elevation of the container
                                            borderRadius: BorderRadius.circular(25), // Border radius
                                             child: Container(
                                               width: 50,
                                               height: 50,
                                               decoration: BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 color: Colors.white, // inner background color
                                                 border: Border.all(
                                                   color: Colors.grey, // light gray border color
                                                   width: 2, // border thickness
                                                 ),
                                               ),
                                               alignment: Alignment.center,
                                               child: Text(
                                                 leaveData.fAvailed,
                                                 style: const TextStyle(
                                                   color: Colors.grey,
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                             ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Availed', // The text to display
                                            style: TextStyle(
                                              color: Colors.black, // Text color
                                              fontSize: 14, // Text size
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Material(
                                            elevation:
                                                5, // Elevation of the container
                                            borderRadius: BorderRadius.circular(25), // Border radius
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white, // inner background color
                                                border: Border.all(
                                                  color: Colors.grey, // light gray border color
                                                  width: 2, // border thickness
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                leaveData.fClosingBalance,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Balance', // The text to display
                                            style: TextStyle(
                                              color: Colors.black, // Text color
                                              fontSize: 14, // Text size
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          '$sLvDescTitle',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Spacer(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, right: 10),
                                          child: GestureDetector(
                                            onTap: () async {
                                              var sLvTypeCode =
                                                  leaveData.sLvTypeCode;
                                              // var sLvTypeCode = '${hrmsLeaveBalaceV2List?[index].sLvTypeCode}';
                                              //sLvDesc = '${hrmsLeaveBalaceV2List?[index].sLvDesc}';
                                              sLvDesc = leaveData.sLvDesc;
                                              // print('---511---${sLvDesc}');
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              var sFirstName = prefs.getString(
                                                  'sFirstName'); // sLvTypeCode
                                              var sLastName =
                                                  prefs.getString('sLastName');
                                              // var sLvTypeCode = prefs.getString('sLvTypeCode');
                                              print('----517--${sFirstName}');
                                              print('----518--${sLvTypeCode}');

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ApplyLeaveSubmitFormHome(
                                                            sLvDesc,
                                                            sFirstName,
                                                            sLvTypeCode,
                                                            sLastName)),
                                              );
                                            },
                                            child: Container(
                                              height:
                                                  30, // Height of the second container
                                              width:
                                                  80, // Width of the second container
                                              decoration: BoxDecoration(
                                                color:
                                                    containerColor, // Background color of the second container
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20), // Border radius
                                              ),
                                              alignment: Alignment
                                                  .center, // Center the text within the container
                                              child: Center(
                                                child: Text(
                                                    'Apply', // The text to display
                                                    style: AppTextStyle
                                                        .font12OpenSansRegularWhiteTextStyle),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  // ... rest of the code for your columns and buttons
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            )));
  }

  // Helper function to build each Column
  Column buildColumn(String label, String value) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
