import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/requestOtpRepo.dart';
import '../dashboard/dashboard.dart';
import '../login/loginScreen.dart';
import '../resources/values_manager.dart';
import 'otpPage.dart';


class ForgotPassword extends StatelessWidget {

  const ForgotPassword({super.key});

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
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // Forgot Password
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
              MaterialPageRoute(builder: (context) => const LoginScreen()),
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
            'Forgot Password',
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Initializing Recovery !',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xff3f617d),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Your password is safe with us.',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xff3f617d),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 120.0),
                      Container(
                        //color: Colors.white,
                        height: 250,
                        decoration: BoxDecoration(
                          // Set container color
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20), // Set border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              Center(
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      // border: Border.all(color: Colors.black),
                                      // Just for visualization
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white
                                              .withOpacity(0.5), // Set shadow color
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Icon(Icons.phone,size: 35,color: Color(0xFF0098a6),),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: AppPadding.p15, right: AppPadding.p15),
                                        // PHONE NUMBER TextField
                                        child: TextFormField(
                                          autofocus: true,
                                          controller: _phoneNumberController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            labelText: "Mobile Number",
                                            labelStyle: TextStyle(
                                                color: Color(0xFFd97c51)
                                            ),
                                            border: const OutlineInputBorder(),
                                            contentPadding: const EdgeInsets.symmetric(
                                              vertical: AppPadding.p10,
                                              horizontal: AppPadding.p10, // Add horizontal padding
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.mobile_friendly_sharp,
                                              color: Color(0xFF0098a6),
                                            ),
                                          ),
                                          autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                                            //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow digits
                                          ],
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter mobile number';
                                            }
                                            if (value.length > 1 && value.length < 10) {
                                              return 'Enter 10 digit mobile number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      InkWell(
                                        // onTap: (){
                                        //         Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(builder: (context) => OtpPage(phone:"9871950881")),
                                        //         );
                                        // },

                                        //       Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(builder: (context) => OtpPage(phone:phone)),
                                        //       );

                                        onTap: () async {
                                          var phone = _phoneNumberController.text;
                                          if(_formKey.currentState!.validate() && phone!=null){
                                            /// Call Api

                                            var requestotpresponse = await RequestOtpRepo().requestOtp(context, phone!);
                                            print("----230---reqestOtp---$requestotpresponse");


                                            var result =  "${requestotpresponse[0]['Result'].toString()}";
                                            var msg =  "${requestotpresponse[0]['Msg'].toString()}";
                                            var otp =  "${requestotpresponse[0]['sOtp'].toString()}";
                                            print("-----otp---$otp");
                                            print("-----msg---$msg");
                                            print("-----result---$result");

                                            // nested condition
                                            if(result=="1"){
                                              print('----209------$phone');

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => OtpPage(phone:phone,otp:otp)),
                                              );

                                             // displayToast(msg);
                                            }else{
                                              print('----216------$phone');
                                              displayToast(msg);
                                            }

                                          }else{
                                            displayToast("Please enter mobile Number");
                                          }
                                        },

                                        child: Container(
                                          width: double
                                              .infinity, // Make container fill the width of its parent
                                          height: 45,
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF0098a6), // Background color using HEX value
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Rounded corners
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  )),

                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),



              ],
            ),
          )
        ],
      ),
    );
  }
  //TOAST
  void displayToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
}

// class ForgotPassword extends StatelessWidget {
//   const ForgotPassword({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ForgotPassWordScreen());
//
//
//   }
// }
// class ForgotPassWordScreen extends StatefulWidget {
//   const ForgotPassWordScreen({super.key});
//
//   @override
//   State<ForgotPassWordScreen> createState() => _forgotPassWordScreenState();
// }
//
// class _forgotPassWordScreenState extends State<ForgotPassWordScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // statusBarColore
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           // Status bar color  // 2a697b
//           statusBarColor: Color(0xFF2a697b),
//           // Status bar brightness (optional)
//           statusBarIconBrightness: Brightness.dark,
//           // For Android (dark icons)
//           statusBarBrightness: Brightness.light, // For iOS (dark icons)
//         ),
//         // backgroundColor: Colors.blu
//         backgroundColor: Color(0xFF0098a6),
//         leading: InkWell(
//           onTap: () {
//             // Navigator.pop(context);
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => const PolicyDoc()),
//             // );
//           },
//           child: const Padding(
//             padding: EdgeInsets.only(left: 5.0),
//             child: Icon(
//               Icons.arrow_back_ios,
//               size: 24,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         title: const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             'ForgotPassWord',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.normal,
//               fontFamily: 'Montserrat',
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ), // Removes shadow under the AppBar
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Center(
//             child: Text("ForgotPassword",style: TextStyle(
//               fontSize: 16,
//               color: Colors.black45
//             ),),
//           )
//         ],
//       ),
//     );
//   }
// }

