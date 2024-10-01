import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard.dart';

class All extends StatelessWidget {
  const All({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllPage(),
    );
  }
}
class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  @override
  void initState() {
    // TODO: implement initState
    print('----------28-----All----');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   // statusBarColore
      //   systemOverlayStyle: const SystemUiOverlayStyle(
      //     // Status bar color  // 2a697b
      //     statusBarColor: Color(0xFF2a697b),
      //     // Status bar brightness (optional)
      //     statusBarIconBrightness: Brightness.dark,
      //     // For Android (dark icons)
      //     statusBarBrightness: Brightness.light, // For iOS (dark icons)
      //   ),
      //   // backgroundColor: Colors.blu
      //   backgroundColor: Color(0xFF0098a6),
      //   leading: InkWell(
      //     onTap: () {
      //       // Navigator.pop(context);
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const DashBoard()),
      //       );
      //     },
      //     child: const Padding(
      //       padding: EdgeInsets.only(left: 5.0),
      //       child: Icon(
      //         Icons.arrow_back_ios,
      //         size: 24,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      //   title: const Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 16.0),
      //     child: Text(
      //       'All',
      //       style: TextStyle(
      //         color: Colors.black,
      //         fontSize: 18,
      //         fontWeight: FontWeight.normal,
      //         fontFamily: 'Montserrat',
      //       ),
      //       textAlign: TextAlign.center,
      //     ),
      //   ), // Removes shadow under the AppBar
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("All",style: TextStyle(
              color: Colors.black45,fontSize: 18
          ))
        ],
      ),
    );
  }
}
