
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/presentation/expensemanagement/pendingteamreimb/pendingteamreimb.dart';
import 'package:untitled/presentation/expensemanagement/reimbursementStatus/reimbursementstatus.dart';
import 'package:untitled/presentation/expensemanagement/reimbursementclarification/reimbursementclarification.dart';
import 'package:untitled/presentation/expensemanagement/teamreimstatus/teamreimstatus.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';
import 'addReimbursement/shopSurvey.dart';

class ExpenseManagement extends StatelessWidget {

  const ExpenseManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  // mobile back buttoncontroll

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you really want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in the app
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit the app
            child: Text('Exit'),
          ),
        ],
      ),
    ) ??
        false; // Return false if dialog is dismissed
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: WillPopScope(
        onWillPop: () async {
          // Show the confirmation dialog when the back button is pressed
          bool shouldExit = await _showExitConfirmationDialog(context);
          return shouldExit; // Return true if user wants to exit
        },

        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            // statusBarColore
            systemOverlayStyle: const SystemUiOverlayStyle(
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
            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: GridView.count(
                crossAxisCount: 2,
                primary: false,
                crossAxisSpacing: 5.0,
                childAspectRatio: 1.5, // Adjust this to maintain the proportion of the items
                mainAxisSpacing: 5.0,
                shrinkWrap: true,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print('---Profile----');
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => AddReimbursement()),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShopSurvey()),
                      );
                    },
                    child: Container(
                      height: 100.0,  // Set the height to 100
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
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/ic_profile_dashboard.PNG',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Center(
                              child: Text(
                                "Add Reimbursement",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Repeat for the other containers...
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Reimbursementstatus()),
                      );
                    },
                    child: Container(
                      height: 100.0,  // Set the height to 100
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
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/ic_reminder_dashboard.PNG',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Center(
                              child: Text(
                                "Reimbursement Status",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReimbursementClarification()),
                      );
                    },
                    child: Container(
                      height: 100.0,  // Set the height to 100
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
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/ic_attendance_dashboard.PNG',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Center(
                              child: Text(
                                "Reimbursement Clarification",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PendingTeamReimbPage()),
                      );
                    },
                    child: Container(
                      height: 100.0,  // Set the height to 100
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
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/ic_attendance_dashboard.PNG',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Center(
                              child: Text(
                                "Pending Team Reimb",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TeamReimStatus()),
                      );
                    },
                    child: Container(
                      height: 100.0,  // Set the height to 100
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
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/ic_attendance_dashboard.PNG',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Center(
                              child: Text(
                                "Team Reim Status",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
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
        ),
      ),
    );
  }
}
