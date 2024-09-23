import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/presentation/profile/profile.dart';

import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class ProfileJobdetails extends StatelessWidget {
  const ProfileJobdetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileEducationPage(),
    );
  }
}

class ProfileEducationPage extends StatefulWidget {
  const ProfileEducationPage({super.key});

  @override
  State<ProfileEducationPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileEducationPage> {
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
                MaterialPageRoute(builder: (context) => const Profile()),
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
              'Job Detail',
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text('Job Detail',style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              )

            ],
          ),
        )
    );
  }
}
