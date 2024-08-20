
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../attendancelist/attendancelist.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';


class ExpenseManagement extends StatelessWidget {
  const ExpenseManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      home: ExpenseManagementHome(),
    );
  }
}

class ExpenseManagementHome extends StatefulWidget {
  const ExpenseManagementHome({super.key});

  @override
  State<ExpenseManagementHome> createState() => _AttendaceListHomeState();
}

class _AttendaceListHomeState extends State<ExpenseManagementHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color  // 2a697b
          statusBarColor: Color(0xFF2a697b),
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        backgroundColor: Color(0xFF0098a6),
        leading: InkWell(
          onTap: (){
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashBoard()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Icon(Icons.arrow_back_ios, size: 24,color: Colors.white,),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Expense Management',
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
        padding: const EdgeInsets.only(left: 12,right: 12),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            crossAxisCount: 2,
            primary: false,
            crossAxisSpacing: 5.0,
            childAspectRatio: 0.85,
            mainAxisSpacing: 5.0,
            shrinkWrap: true,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  print('---Profle----');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const DummyScreen(title: 'Apply Leave')),
                  // );
                },
                child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                          shape: BoxShape.circle, // Container shape
                        ),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/images/ic_profile_dashboard.PNG', // Replace with your SVG asset
                              fit: BoxFit.contain, // Ensure the SVG fits within the container
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Text(
                            "Add Reimbursement",
                            textAlign: TextAlign.center, // Center align the text
                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                            // style: TextStyle(
                            //   fontFamily: 'Quicksand',
                            //   fontSize: 12.0,
                            //   fontWeight: FontWeight.normal,
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  print('---Mark Attendance----');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const DummyScreen(title: 'Apply Leave')),
                  // );
                },
                child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                          shape: BoxShape.circle, // Container shape
                        ),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/images/ic_reminder_dashboard.PNG', // Replace with your SVG asset
                              fit: BoxFit.contain, // Ensure the SVG fits within the container
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Text(
                            "Reimbursement Status",
                            textAlign: TextAlign.center, // Center align the text
                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                            // style: TextStyle(
                            //   fontFamily: 'Quicksand',
                            //   fontSize: 12.0,
                            //   fontWeight: FontWeight.normal,
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  print('---AttendanceList----');
                  // Navigator.pushNamed(context, '/attendancelist');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Attendancelist()),
                  );
                },
                child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                          shape: BoxShape.circle, // Container shape
                        ),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/images/ic_attendance_dashboard.PNG', // Replace with your SVG asset
                              fit: BoxFit.contain, // Ensure the SVG fits within the container
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Text(
                            "Attendance List",
                            textAlign: TextAlign.center, // Center align the text
                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                            // style: TextStyle(
                            //   fontFamily: 'Quicksand',
                            //   fontSize: 12.0,
                            //   fontWeight: FontWeight.normal,
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Second Part
              GestureDetector(
                onTap: (){
                  print('-------');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const DummyScreen(title: 'Apply Leave')),
                  // );
                },
                child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                          shape: BoxShape.circle, // Container shape
                        ),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/images/ic_attendance_dashboard.PNG', // Replace with your SVG asset
                              fit: BoxFit.contain, // Ensure the SVG fits within the container
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Text(
                            "Attandance",
                            textAlign: TextAlign.center, // Center align the text
                            style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                            // style: TextStyle(
                            //   fontFamily: 'Quicksand',
                            //   fontSize: 12.0,
                            //   fontWeight: FontWeight.normal,
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
