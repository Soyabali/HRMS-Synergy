import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/dashboard.dart';
import 'payslip.dart';
import '../resources/app_text_style.dart';

class Setpin extends StatelessWidget {

  const Setpin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SetPinScren(),
    );
  }
}

class SetPinScren extends StatefulWidget {

  const SetPinScren({super.key});

  @override
  State<SetPinScren> createState() => _setPinScrenState();
}

class _setPinScrenState extends State<SetPinScren> {

  TextEditingController pinController = TextEditingController();
  var storedPin;

  // Example function to handle button press
  void onNumberPressed(String value) {
    if (value == 'X') {
      if (pinController.text.isNotEmpty) {
        pinController.text = pinController.text.substring(0, pinController.text.length - 1);
      }
    } else {
      if (pinController.text.length < 4) { // Assuming a 4-digit PIN
        pinController.text += value;
      }
    }
  }

  @override
  void initState() {
    fetchStoreLocalPin();
    // TODO: implement initState
    pinController.addListener(() {
      // Check if the length is 4
      if (pinController.text.length == 4) {
        // Check if the entered value matches the stored value
         var setPin = pinController.text;
         print('-----setPin------');
        ///TODO HERE YOU SHOULD STORE pin code

        if (pinController.text == "1234") {
          // Navigate to the next screen
          //   PaySlip
          storePinInaLocalDatabase(setPin);
          print('PIN matched! Navigate to next screen');
          // Here you can use Navigator.push to navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaySlip()),
          );
          pinController.clear();
        } else {
          pinController.clear();
          // Show validation message
          print('Wrong PIN number');
          // You can display a Snackbar or set validation error in the UI
          _showValidationError();
        }
      }
    });
    super.initState();
  }
  storePinInaLocalDatabase(pin) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('setPin',pin);
    print('----83---store value--$pin');
    //prefs.setInt('setPin',pin);
  }
  fetchStoreLocalPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedPin = prefs.getString('setPin');
    setState(() {
    });
    print('-------88----XXX---XX--$storedPin');
  }
  void _showValidationError() {
    // Display a validation message (e.g., using a SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wrong Pin Code'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pinController.dispose();
    super.dispose();
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
            'Set Pin',
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
            Stack(
          children: [
            Container(
              height: 220, // Set the desired height
              width: double.infinity, // Make it stretch to the width of the screen
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logintopheader.jpeg'), // Replace with your image path
                  fit: BoxFit.fill, // Cover the entire container
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/camra.jpeg', // Replace with your image path
                    height: 60, // Adjust size as needed
                  ),
                  SizedBox(height: 10),
                  Text('HRMS',style: AppTextStyle
                      .font16OpenSansRegularWhiteTextStyle
                  ),
                  SizedBox(height: 10),
                  Text('Human Resource Management System',style: AppTextStyle
                      .font16OpenSansRegularWhiteTextStyle)
                ],
              ),
            )
          ],
      ),
          SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              controller: pinController,
              obscureText: true,
              obscuringCharacter: '●', // Shows dot for entered number
              textAlign: TextAlign.center,
              readOnly: true, // Disable manual input; only use the keypad
              style: TextStyle(fontSize: 24,color: Color(0xFF0098a6)),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
               hintText: storedPin == null ? 'Set Pin Code' : 'Enter Pin Again',
                //hintText: 'Set Pin Code',
               // hintStyle: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.normal),
                hintStyle: AppTextStyle.font16OpenSansRegularBlack45TextStyle,
                contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjust vertical padding to control height
              ),
              // Set the height of the TextField
              maxLines: 1, // Ensure it remains a single line
            ),
          ),
          SizedBox(height: 15),
          _buildKeyPad(),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              // Handle "Can't Remember?" tap event
            },
            child: Center(
              child: Text(
                "Can't Remember?",
                  style: AppTextStyle.font16OpenSansRegularBlack45TextStyle
              ),
            ),
          ),
        ],
      )
    );
  }
  // Function to build the custom keypad
  Widget _buildKeyPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('1'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('2'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('3'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('4'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('5'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('6'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('7'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('8'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildKeyButton('9'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: _buildKeyButton('0'),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: _buildKeyButton('X'),
            ), // X for delete
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Function to build a circular key button
  Widget _buildKeyButton(String value) {
    return GestureDetector(
      onTap: () {
        onNumberPressed(value);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white, // Container background color
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFF0098a6), // Border color
            width: 3.0, // Increased border width for better visibility
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 32, // Slightly smaller font size for balance
              color: Color(0xFF0098a6), // Text color matching the border
              fontWeight: FontWeight.bold, // Bold text for better readability
            ),
          ),
        ),
      ),
    );
  }

}

