import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../app/generalFunction.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // change StatusBarColore
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

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

  // get a location :
  void getLocation() async {
    print('---location---');
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });

    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
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
            // Status bar color  // 2a697b
            statusBarColor: Color(0xFF2a697b),
            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
         // backgroundColor: Colors.blu
          backgroundColor: Color(0xFF0098a6),
          // leading: Padding(
          //   padding: const EdgeInsets.only(left: 5.0),
          //   child: Icon(Icons.menu, size: 24,color: Colors.white,),
          // ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              child: Icon(Icons.logout, size: 24,color: Colors.white),
            ),
          ],
          elevation: 0, // Removes shadow under the AppBar
        ),
      // drawer
      drawer: generalFunction.drawerFunction(context,'Abc','9871xxxxxx'),

      body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200.0, // Set the height of the container
                  decoration: BoxDecoration(
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
                      _buildFoodCard('Profile', 'assets/images/ic_profile_dashboard.PNG'),
                     // _buildFoodCard('Profile', 'assets/images/ic_profile'),
                      GestureDetector(
                          onTap: (){
                            print('---Mark Attendance---');
                            getLocation();
                          },
                          child: _buildFoodCard('Mark Attendance','assets/images/ic_reminder_dashboard.PNG')),
                      _buildFoodCard('Attendance List','assets/images/ic_achievement.PNG'),
                      _buildFoodCard('Attandance','assets/images/ic_attendance_dashboard.PNG'),
                      _buildFoodCard('Apply Leave','assets/images/ic_leave_dashboard.PNG'),
                      _buildFoodCard('Pay Slip','assets/images/ic_payslip.PNG'),
                      _buildFoodCard('Policy Doc','assets/images/ic_policy_dashboard.PNG'),
                      _buildFoodCard('Holiday','assets/images/ic_holiday_dashboard.PNG'),
                      _buildFoodCard('User Query','assets/images/ic_user_query_dashboard.PNG'),
                      _buildFoodCard('Expense Management','assets/images/ic_expeses.PNG'),
                      _buildFoodCard('Work Detail','assets/images/ic_master_work_status.PNG'),
                      _buildFoodCard('Notification','assets/images/ic_announcement.PNG'),

                    ],
                  ),
                ),
              ),
            ),

          ],

      ),
    );
  }
  // gridView Card
  Widget _buildFoodCard(String name, String cardImage) {
    return GestureDetector(
      onTap: (){
        print('------$name---');
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
                    cardImage, // Replace with your SVG asset
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
                  name,
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
    );
  }

}

