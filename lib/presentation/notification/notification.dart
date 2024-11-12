import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/generalFunction.dart';
import '../../data/notificatinDeleteRepo.dart';
import '../../data/notificationRepo.dart';
import '../../domain/notification_model.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  GeneralFunction generalFunction = GeneralFunction();

  var iTranId;
  late Future<List<NotificationModel>> _notificationList;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  // deleteDialogBox
  Widget _deleteItemDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 160,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Delete',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                Text(
                  "Do you want to Delete ?",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Container(
                  height: 35, // Reduced height to 35
                  padding: EdgeInsets.symmetric(horizontal: 5), // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    border: Border.all(color: Colors.grey), // Border color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                           // generalFunction.logout(context);
                            /// todo heere you shold call a delete item api

                            var  hrmsPopWarning = await NotificatindeleteRepo().notification(context,iTranId);
                            print('---80--$hrmsPopWarning');
                            var  result = "${hrmsPopWarning[0]['Result']}";
                            var  msg = "${hrmsPopWarning[0]['Msg']}";
                            generalFunction.displayToast(msg);
                            Navigator.of(context).pop();
                            //
                            setState(() {
                              _notificationList = NotificationRepo().notificationList(context);
                            });

                            },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove default padding
                            minimumSize: Size(0, 0), // Remove minimum size constraints
                            backgroundColor: Colors.white, // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              color: Colors.green, // Text color for "Yes"
                              fontSize: 12, // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey, // Divider color
                        width: 20, // Space between buttons
                        thickness: 1, // Thickness of the divider
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove default padding
                            minimumSize: Size(0, 0), // Remove minimum size constraints
                            backgroundColor: Colors.white, // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              color: Colors.red, // Text color for "No"
                              fontSize: 12, // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/delete.jpeg', // Replace with your asset image path
                  fit: BoxFit.fill,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // api call
  notificationList() async {
    _notificationList = NotificationRepo().notificationList(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    notificationList();
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
              'Notification',
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
            padding: const EdgeInsets.all(16.0), // Padding around the card
            child: FutureBuilder<List<NotificationModel>>(
                future: _notificationList,
                builder: (context, snapshot) {
                  // Check if the snapshot has data and is not null
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for data
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Handle error scenario
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Handle the case where the data is empty or null
                    return Center(child: Text('No notifications found'));
                  }

                  // Once data is available, build the ListView
                  final notificationList = snapshot.data!; // Access the resolved data

                  return ListView.builder(
                      itemCount: notificationList.length,
                      itemBuilder: (context, index) {
                        final notificationData = notificationList[index];

                        return GestureDetector(
                          onLongPress: (){
                            //_deleteItemDialog(context);

                            setState(() {
                               iTranId = notificationData.iTranId;
                             });

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteItemDialog(context);
                              },
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5.0), // Rounded corners
                            ),
                            elevation: 5, // Shadow under the card
                            color: Colors.white,
                            child:Padding(
                              padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom: 10), // Padding inside the card
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // First Row for the icon and the title
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.notifications, // Notification icon
                                        color: Color(0xFF0098a6),
                                        size: 22,
                                      ),
                                      const SizedBox(
                                          width:
                                              10), // Space between icon and text
                                      Text(
                                        notificationData.sTitle,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height:
                                          5), // Space between the title and message
                                  // Notification message
                                  Text(
                                    notificationData.sNotification,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.calendar_month, size: 16),
                                      const SizedBox(width: 5),
                                      Text(
                                        notificationData.sNotiDate,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
                )
        )
    );
  }
}
