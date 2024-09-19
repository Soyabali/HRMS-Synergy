import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/companyPolicy_repo.dart';
import '../../domain/policy_model.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PolicyDoc extends StatelessWidget {

  const PolicyDoc({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PolicydocScreen(),
    );
  }
}
class PolicydocScreen extends StatefulWidget {
  const PolicydocScreen({super.key});

  @override
  State<PolicydocScreen> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<PolicydocScreen> {

  //late Future<List<PolicyDoc>> policyDoclist;
  //late Future<List<PolicyDoc>> policyDoclist;
  late Future<List<PolicyDocModel>> polocyDocList;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polocyDocList = HrmsPolicyDocRepo().policyDocList(context);
    print('----40--$polocyDocList');
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
            'Policy Doc',
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

           Expanded(
             child: Container(
               height: MediaQuery.of(context).size.height,
               child: FutureBuilder<List<PolicyDocModel>>(
                   future: polocyDocList,
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
                     final polocyDocList = snapshot.data!; // Access the resolved data

                     return ListView.builder(
                         itemCount: polocyDocList.length,
                         itemBuilder: (context, index) {
                           final policyDocData = polocyDocList[index];
                           return
                             Padding(
                                 padding: const EdgeInsets.only(left: 5, right: 5),
                                 child: Card(
                                   elevation: 5, // Elevation for shadow effect
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(5),
                                       // Rounded corners
                                       side: BorderSide(color: Colors.grey)),
                                   child: Padding(
                                     padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                                     child: Container(
                                       color: Colors.white,
                                       child: Padding(
                                         padding: const EdgeInsets.only(left: 5),
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Row(
                                               children: [
                                                 // First Column: Takes 80% of the width
                                                 Expanded(
                                                   flex: 8, // 80% of width
                                                   child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment
                                                         .start,
                                                     children: [
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment
                                                             .start,
                                                         children: <Widget>[
                                                           Container(
                                                             height: 10,
                                                             width: 10,
                                                             decoration: BoxDecoration(
                                                               color: Colors.red, // Red color
                                                               borderRadius: BorderRadius
                                                                   .circular(5), // Radius of 5
                                                             ),
                                                           ),
                                                           SizedBox(width: 5),
                                                           Text(
                                                             policyDocData.dUploadDate,
                                                             style: AppTextStyle
                                                                 .font12OpenSansRegularBlackTextStyle,
                                                           ),

                                                         ],
                                                       ),
                                                       const SizedBox(height: 4),
                                                       // Spacing between the two texts
                                                       Text(
                                                         policyDocData.sPolictyTitle,
                                                         style: AppTextStyle
                                                             .font12OpenSansRegularBlackTextStyle,

                                                       ),
                                                     ],
                                                   ),
                                                 ),

                                                 Expanded(
                                                   flex: 2, // 20% of width
                                                   child: Align(
                                                     alignment: Alignment.centerRight,
                                                     child: Transform.rotate(
                                                       angle: 45 * (3.1415927 / 180),
                                                       // Rotate by 90 degrees (convert degrees to radians)
                                                       child: GestureDetector(
                                                         child: IconButton(
                                                           icon: Icon(Icons.attach_file),
                                                           onPressed: () {
                                                             print('---Downlode pdf--');
                                                             // Handle onPressed for icon here
                                                           },
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                 )

                                               ],
                                             ),
                                             SizedBox(height: 5),
                                             Text(
                                               policyDocData.sPolictyDescription,
                                               style: AppTextStyle
                                                   .font10OpenSansRegularBlackTextStyle,
                                             ),
                                             SizedBox(height: 5),
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.end,
                                               // Aligns Row to the right
                                               children: [
                                                 // Accept text with iOS forward icon
                                                 Row(
                                                   children: [
                                                     Text('ACCEPT', style: AppTextStyle
                                                         .font12OpenSansRegularGreenTextStyle,

                                                     ),
                                                     SizedBox(width: 8),
                                                     // Space between text and icon
                                                     Icon(Icons.arrow_forward_ios, size: 12),
                                                   ],
                                                 ),
                                                 SizedBox(width: 20),
                                                 // Space between "Accept" and "Reject"

                                                 // Reject text with iOS forward icon
                                                 Row(
                                                   children: [
                                                     Text('REJECT', style: AppTextStyle
                                                         .font12OpenSansRegularRedTextStyle),
                                                     SizedBox(width: 8),
                                                     // Space between text and icon
                                                     Icon(Icons.arrow_forward_ios, size: 12),
                                                   ],
                                                 ),
                                               ],
                                             ),
                                             SizedBox(height: 5),
                                           ],
                                         ),
                                       ),
                                     ),
                                   ),
                                 )
                             );
                         }
                     );
                   }
               ),
             ),
           )
        ],
      )
    );
  }
}

