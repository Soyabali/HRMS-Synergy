import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../dashboard/dashboard.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';

class ShortLeave extends StatelessWidget {
  const ShortLeave({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShortLeaveScreen(),
    );
  }
}

class ShortLeaveScreen extends StatefulWidget {
  const ShortLeaveScreen({super.key});

  @override
  State<ShortLeaveScreen> createState() => _ShortLeaveScreenState();
}

class _ShortLeaveScreenState extends State<ShortLeaveScreen> {
  String? dExpDate;
  TextEditingController _expenseController = TextEditingController();

  FocusNode _owenerfocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // background colore
        backgroundColor: Colors.white,
        // AppBar
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
              'Short Leave',
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/leave.jpeg",
                      height: 200,
                      width: MediaQuery.of(context).size.width
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        color: Colors.white, // Background color of the container
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.grey.withOpacity(0.5), // Color of the shadow
                            spreadRadius: 5, // Spread radius
                            blurRadius: 7, // Blur radius
                            offset: Offset(0, 3), // Offset of the shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // 'assets/images/favicon.png',
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 0, right: 10, top: 10),
                                child: Image.asset(
                                  'assets/images/ic_expense.png',
                                  // Replace with your image asset path
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Fill the below details',
                                    style: AppTextStyle
                                        .font16OpenSansRegularBlack45TextStyle
                                  // style: TextStyle(
                                  //     fontFamily: 'Montserrat',
                                  //     color: Color(0xFF707d83),
                                  //     fontSize: 14.0,
                                  //     fontWeight: FontWeight.bold)

                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              print('---pick a date---');

                              // Set current date
                              DateTime today = DateTime.now();

                              // Show date picker and store the picked date
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: today, // Set the initial date to today
                                firstDate: today,   // Restrict selection to today as the earliest date
                                lastDate: today,    // Restrict selection to today as the latest date
                              );

                              // Check if a date was picked
                              if (pickedDate != null) {
                                // Format the picked date
                                String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);

                                // Update the state with the picked date
                                setState(() {
                                  dExpDate = formattedDate;
                                });
                                print('$dExpDate');
                              } else {
                                print('---no date is selected----');
                              }
                            },
                            child: Container(
                              height: 30,
                              child: DottedBorder(
                                color: Colors.grey, // Color of the dotted line
                                strokeWidth: 1.0, // Width of the dotted line
                                dashPattern: [4, 2], // Dash pattern for the dotted line
                                borderType: BorderType.RRect,
                                radius: Radius.circular(5.0), // Optional: rounded corners
                                child: Padding(
                                  padding: EdgeInsets.all(2.0), // Equal padding on all sides
                                  child: Row(
                                    // Center the row contents
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        size: 20,
                                        color: Color(0xFF0098a6),
                                      ),
                                      SizedBox(width: 5.0),
                                      // Display the selected date or a placeholder if no date is selected
                                      Text(
                                        dExpDate == null
                                            ? 'Select Short Leave Date'
                                            : '$dExpDate',
                                        style: AppTextStyle
                                            .font16OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 0, right: 2),
                                    child: const Icon(
                                      Icons.forward_sharp,
                                      size: 12,
                                      color: Colors.black54,
                                    )),
                                const Text('Reason',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFF707d83),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 0),
                            child: Container(
                              height: 42,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: TextFormField(
                                  focusNode: _owenerfocus,
                                  controller: _expenseController,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    filled: true, // Enable background color
                                    fillColor: Color(0xFFf2f3f5),// Set your desired background color here
                                  ),
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  // validator: (value) {
                                  //   if (value !=null && value =="0") {
                                  //     return 'Enter an amount greater than 0';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 35,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your onPressed functionality here
                                var reason = _expenseController.text;
                                print("-----274---$reason");
                                print("----275---$dExpDate");
                                if((reason!=null && reason!="") && dExpDate!=null){
                                  print("---Api call---");
                                  /// TO CALL A API
                                  ///
                                }else{
                                  // to give a toast
                                  print("---Api  not call---");
                                }


                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), backgroundColor: AppColors.loginbutton, // Set the button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppMargin.m10), // Rounded corners
                                ),
                                minimumSize: Size(0, AppSize.s45), // Set height, width will adapt to text
                              ),
                              child: Text(
                                "Submit",
                                style: AppTextStyle.font16OpenSansRegularWhiteTextStyle, // Your text style
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
