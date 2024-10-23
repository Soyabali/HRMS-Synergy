
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../resources/app_text_style.dart';
import 'setpin.dart';

class PaySlip extends StatelessWidget {

  const PaySlip({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaySlipPage(),
    );
  }
}
class PaySlipPage extends StatefulWidget {

  const PaySlipPage({super.key});

  @override
  State<PaySlipPage> createState() => _PaySlipPageState();
}

class _PaySlipPageState extends State<PaySlipPage> {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              MaterialPageRoute(builder: (context) => const Setpin()),
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
            'Pay Slip',
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
          ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text('Sep-2024',style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
            ),
             trailing: Padding(
               padding: const EdgeInsets.only(right: 5),
               child: Container(
                 height: 35, // Set the height of the container
                 width: 100,
                 decoration: BoxDecoration(
                   color: Colors.white, // Background color of the container
                   border: Border.all(
                     color: Colors.black, // Border color
                     width: 1.0, // Border width
                   ),
                   borderRadius: BorderRadius.circular(16.0), // Rounded corners
                 ),
                 child: Center( // Center the text inside the container
                   child: Text(
                     'Pay Slip',
                     style: TextStyle(
                       color: Colors.black, // Text color
                       fontSize: 14.0, // Font size
                       fontWeight: FontWeight.w500, // Optional: adjust text weight
                     ),
                   ),
                 ),
               ),
             )
            ,
            // trailing: Container(
            //   height: 55,
            //     decoration: BoxDecoration(
            //       color: Colors.white, // Background color of the container
            //       border: Border.all(
            //         color: Colors.black, // Border color
            //         width: 1.0, // Border width
            //       ),
            //       borderRadius: BorderRadius.circular(16.0), // Optional: to make the border rounded
            //     ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Text('Pay Slip',style: TextStyle(
            //       color: Colors.black45,fontSize: 14
            //     ),),
            //   ),
            // ),
            // trailing: Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white, // Background color of the container
            //     border: Border.all(
            //       color: Colors.black, // Border color
            //       width: 1.0, // Border width
            //     ),
            //     borderRadius: BorderRadius.circular(8.0), // Optional: to make the border rounded
            //   ),
            //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding inside the container
            //   child: const Center(
            //     child: Text(
            //       'Pay Slip',
            //       style: TextStyle(
            //         fontSize: 16.0, // Adjust font size
            //         fontWeight: FontWeight.bold, // Optional: make text bold
            //         color: Colors.black, // Text color
            //       ),
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}

