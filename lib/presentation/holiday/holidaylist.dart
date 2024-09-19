import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';
import 'package:intl/intl.dart';

class Holidaylist extends StatelessWidget {
  const Holidaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HolidaylistScreen(),
    );
  }
}

class HolidaylistScreen extends StatefulWidget {
  const HolidaylistScreen({super.key});

  @override
  State<HolidaylistScreen> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<HolidaylistScreen> {
  // month name list
  late String currentMonth;
  late String selectedMonth;

  final List<String> months = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];

  // DateTime now = DateTime.now(); // Get the current date and time
  //String currentMonth = DateFormat('MMM').format(now); // Format it to get the short month name (e.g., "Jan")

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    currentMonth = DateFormat('MMM')
        .format(now)
        .toUpperCase(); // Format to get the month as "Jan"
    selectedMonth = currentMonth;
    print('----44---$selectedMonth');
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
              'Holiday List',
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
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Container(
                  height: 50, // Set the height of the list
                  // width: 70,
                  color: Colors.white,
                  child: ListView.builder(
                      scrollDirection:
                          Axis.horizontal, // Makes the list horizontal
                      itemCount: months.length, // Number of months
                      itemBuilder: (context, index) {
                        bool isCurrentMonth = months[index] == currentMonth;
                        bool isSelectedMonth = months[index] == selectedMonth;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedMonth = months[index];
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                decoration: BoxDecoration(
                                  // color: Colors.blueAccent,
                                  color: isSelectedMonth
                                      ? Color(0xFF0098a6)
                                      : Colors.transparent,
                                  //color: isCurrentMonth ? Color(0xFF0098a6) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(months[index],
                                    style: AppTextStyle
                                        .font16OpenSansRegularBlack45TextStyle),
                              ),
                            ),
                          ),
                        );
                      })),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 5), // Margin around the container
                decoration: BoxDecoration(
                  border:
                  Border.all(color: Colors.grey, width: 1), // Outline border
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                     // color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 0, // Spread radius of shadow
                      blurRadius: 0, // Blur radius of shadow
                      offset: Offset(0, 3), // Offset for the shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2, top: 5,bottom: 5),
                      child: Container(
                        height: 75,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              /// todo here change a color as a dynamic in a future
                            color: Colors.blue, width: 5), // Left border
                          ),
                        ),
                        padding: EdgeInsets.all(8), // Padding inside the container
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Aug',
                                style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                            ),
                            Text('15', style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 30),
                    SizedBox(width: 15),
                    Center(
                      child: Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thursday',
                              style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                          ),
                          Text('Independence Day', style: AppTextStyle.font10OpenSansRegularBlackTextStyle
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 5), // Margin around the container
              decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey, width: 1), // Outline border
                borderRadius: BorderRadius.circular(5), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    // color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 0, // Spread radius of shadow
                    blurRadius: 0, // Blur radius of shadow
                    offset: Offset(0, 3), // Offset for the shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 5,bottom: 5),
                    child: Container(
                      height: 75,
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            /// todo here change a color as a dynamic in a future
                              color: Colors.blue, width: 5), // Left border
                        ),
                      ),
                      padding: EdgeInsets.all(8), // Padding inside the container
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Aug',
                              style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                          ),
                          Text('15', style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 30),
                  SizedBox(width: 15),
                  Center(
                    child: Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Thursday',
                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                        ),
                        Text('Independence Day', style: AppTextStyle.font10OpenSansRegularBlackTextStyle
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 5), // Margin around the container
              decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey, width: 1), // Outline border
                borderRadius: BorderRadius.circular(5), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    // color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 0, // Spread radius of shadow
                    blurRadius: 0, // Blur radius of shadow
                    offset: Offset(0, 3), // Offset for the shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 5,bottom: 5),
                    child: Container(
                      height: 75,
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            /// todo here change a color as a dynamic in a future
                              color: Colors.blue, width: 5), // Left border
                        ),
                      ),
                      padding: EdgeInsets.all(8), // Padding inside the container
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Aug',
                              style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                          ),
                          Text('15', style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 30),
                  SizedBox(width: 15),
                  Center(
                    child: Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Thursday',
                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                        ),
                        Text('Independence Day', style: AppTextStyle.font10OpenSansRegularBlackTextStyle
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


          ],
        ));
  }
}
