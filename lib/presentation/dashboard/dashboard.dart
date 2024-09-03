import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/applyleave/applyLeave.dart';
import '../../app/generalFunction.dart';
import '../../data/hrmsattendance.dart';
import '../../data/loader_helper.dart';
import '../attendancelist/attendancelist.dart';
import '../expensemanagement/expense_management.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../workdetail/workdetail.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // change StatusBarColore
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      home: DashBoardHomePage(),
    );
  }
}
class DashBoardHomePage extends StatefulWidget {
  const DashBoardHomePage({super.key});

  @override
  State<DashBoardHomePage> createState() => _DashBoardHomePageState();
}

class _DashBoardHomePageState extends State<DashBoardHomePage> {

  GeneralFunction generalFunction = GeneralFunction();
  double? lat, long;
  var sFirstName,sCompEmailId;
   // DialogBox
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: const Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Attendance',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to confirm attendance?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Perform the "Yes" action here
                  getLocation();
                  Navigator.of(context).pop(); // Dismiss the dialog after action
                  // You can call a function or perform any action you need here
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        }
    );
  }

  // get a location :
  void getLocation() async {
    showLoader();
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      hideLoader();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      hideLoader();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        hideLoader();
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      hideLoader();
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    if(lat!=null && long !=null){
       var location = '{$lat$long}';
     //  displayToast(location);
       attendaceapi(lat,long);
      print('---call Api---xxxxxxxxx--');
      hideLoader();
    }else{
      displayToast("Please pick location");
    }


    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }

   attendaceapi(double? lat, double? long) async{
    print('----lat--162--$lat');
    print('----long----163--$long');

    var attendance = await HrmsAttendanceRepo().hrmsattendance(context,lat,long);
    print('-----99---$attendance');

    if(attendance!=null){
      var result = "${attendance[0]['Result']}";
      var msg = "${attendance[0]['Msg']}";
     // displayToast(msg);
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }else{
      displayToast("Attendance not confirmed.");
    }
  }

  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
   getLocalDataInfo()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     // get a stored value
     setState(() {
       sFirstName = prefs.getString('sFirstName');
       sCompEmailId = prefs.getString('sCompEmailId');
     });
   }

   @override
  void initState() {
    // TODO: implement initState
     getLocalDataInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // change status bar colore

    return Scaffold(
      backgroundColor: Colors.white,
        // appBar
      appBar: AppBar(
          // statusBarColore
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF2a697b),

            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
         // backgroundColor: Colors.blu
          backgroundColor: Color(0xFF0098a6),
         title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Welcome, Have a nice day!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
             // child: Icon(Icons.logout, size: 24,color: Colors.white),
              child:  InkWell(
                onTap: (){
                  generalFunction.logout(context);
                },
                child: Container(
                  margin: EdgeInsets.all(8.0), // Apply margin around the image
                  child: Image.asset(
                    'assets/images/logout.jpeg',
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ),
          ],
          elevation: 0, // Removes shadow under the AppBar
        ),
      // drawer
      drawer: generalFunction.drawerFunction(context,'$sFirstName','$sCompEmailId'),

      body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200.0, // Set the height of the container
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.deshboardtop), // Path to your asset image
                      fit: BoxFit.cover, // Adjust the image to cover the container
                    ),
                  ),
                ),
                    const Positioned(
                      bottom: 20, // Position from the bottom
                      right: 20,  // Position from the right
                      child: Text(
                        'Version 1.5.9',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,        // Text size
                          fontWeight: FontWeight.bold, // Text style
                        ),
                      ),
                    ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12,right: 12),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    crossAxisCount: 3,
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
                                height: 50,
                                width: 50,
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
                                    "Profile",
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
                          _showConfirmationDialog(context);
                          /// TODO TO OPEN DIALOG AND THEN GET A LOCATION
                          //getLocation();

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
                                height: 50,
                                width: 50,
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
                                    "Mark Attendance",
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
                        //  Navigator.pushNamed(context, '/attendancelist');
                         // Navigator.pushNamed(context, "/attendancelist");
                        //  Navigator.pushNamed(context, '/login');
                          // Navigator.pushNamed(context, Routes.attendanceListRoute);
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
                                height: 50,
                                width: 50,
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
                                height: 50,
                                width: 50,
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
                      GestureDetector(
                        onTap: (){
                          print('---AttendanceList----');
                          // Navigator.pushNamed(context, '/attendancelist');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Applyleave()),
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
                                height: 50,
                                width: 50,
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
                                      'assets/images/ic_leave_dashboard.PNG', // Replace with your SVG asset
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
                                    "Apply Leave",
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
                                height: 50,
                                width: 50,
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
                                      'assets/images/ic_payslip.PNG', // Replace with your SVG asset
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
                                    "Pay Slip",
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
                      // third Part
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
                                height: 50,
                                width: 50,
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
                                      'assets/images/ic_policy_dashboard.PNG', // Replace with your SVG asset
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
                                    "Policy Doc",
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
                                height: 50,
                                width: 50,
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
                                      'assets/images/ic_holiday_dashboard.PNG', // Replace with your SVG asset
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
                                    "Holiday",
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
                                height: 50,
                                width: 50,
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
                                      'assets/images/ic_user_query_dashboard.PNG', // Replace with your SVG asset
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
                                    "User Query",
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
                      // fourth part
                      GestureDetector(
                        onTap: (){
                          print('-------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ExpenseManagement()),
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
                                height: 50,
                                width: 50,
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
                                    child: Image.asset('assets/images/ic_expeses.PNG', // Replace with your SVG asset
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
                                    "Expense Management",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WorkDetail()),
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
                                height: 50,
                                width: 50,
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
                                    child: Image.asset('assets/images/ic_master_work_status.PNG', // Replace with your SVG asset
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
                                    "Work Detail",
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
                                height: 50,
                                width: 50,
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
                                      'assets/images/ic_announcement.PNG', // Replace with your SVG asset
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
                                    "Notification",
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
            ),
          ],
      ),
    );
  }

}

