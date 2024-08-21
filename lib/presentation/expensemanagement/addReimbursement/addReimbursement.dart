import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../expense_management.dart';

class AddReimbursement extends StatelessWidget {
  const AddReimbursement({super.key});

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
      home: AddreimbursementHome(),
    );
  }
}
class AddreimbursementHome extends StatefulWidget {
  const AddreimbursementHome({super.key});

  @override
  State<AddreimbursementHome> createState() => _AddreimbursementHomeState();
}

class _AddreimbursementHomeState extends State<AddreimbursementHome> {
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
              MaterialPageRoute(builder: (context) => const ExpenseManagement()),
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
            'Add Reimbursement',
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
      body: Container(
        child: ListView(
          children: [
             Center(
               child: Text('Add Reimbursement',style: TextStyle(
                 color: Colors.red,fontSize: 16
               ),),
             )
          ],
        ),
      ),

    );
  }
}

