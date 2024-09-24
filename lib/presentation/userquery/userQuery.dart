import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/generalFunction.dart';
import '../../data/postQueryRepo.dart';
import '../../data/queryResponse.dart';
import '../../domain/queryResponseModel.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';

class Userquery extends StatelessWidget {
  const Userquery({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserqueryScreen(),
    );
  }
}

class UserqueryScreen extends StatefulWidget {

  const UserqueryScreen({super.key});

  @override
  State<UserqueryScreen> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<UserqueryScreen> {

  var result,msg;
  late Future<List<QueryResponsemodel>> queryResponsemodel;

  GeneralFunction generalfunction = GeneralFunction();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryResponsemodel = QueryResponseRepo().quryList(context);
    print('----37----$queryResponsemodel');
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
              'User Query',
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

        body:Column(
          children: [
            Expanded(
                child: FutureBuilder<List<QueryResponsemodel>>(
                    future: queryResponsemodel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No data'));
                      }
                      final polocyDocList = snapshot.data!;

                      return ListView.builder(
                          itemCount: polocyDocList.length,
                          itemBuilder: (context, index) {
                            final query = polocyDocList[index];

                            return
                              GestureDetector(
                                onTap: (){
                                  print("----113---${query.sTitle}");
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5, right: 5),
                                      child: Card(
                                        elevation: 4, // Adds shadow to the card
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded corners
                                        ),
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          padding: const EdgeInsets.all(
                                              5.0), // Padding inside the container
                                          decoration: BoxDecoration(
                                            color: Colors.white, // Background color
                                            borderRadius: BorderRadius.circular(
                                                10), // Same radius as the Card
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min, // Wrap content inside the container
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF0098a6), // Black color
                                                          borderRadius: BorderRadius.circular(
                                                              5), // Border radius of 5
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 4),
                                                        child: Container(
                                                          height: 100,
                                                          width: 2,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey, // Black color
                                                            borderRadius: BorderRadius.circular(
                                                                0), // Border radius of 5
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF2a697b), // Black color
                                                          borderRadius: BorderRadius.circular(
                                                              5), // Border radius of 5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Query At',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlack45TextStyle,
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(query.dRequestTime,
                                                          style: AppTextStyle
                                                              .font12OpenSansRegularBlackTextStyle),
                                                      SizedBox(height: 2),
                                                      Container(
                                                        height: 25,
                                                        child: DottedBorder(
                                                          color: Colors
                                                              .grey,
                                                          // Color of the dotted line
                                                          strokeWidth:
                                                          1.0,
                                                          // Width of the dotted line
                                                          dashPattern: [
                                                            4,
                                                            2
                                                          ],
                                                          // Dash pattern for the dotted line
                                                          borderType: BorderType.RRect,
                                                          radius: Radius.circular(
                                                              5.0),
                                                          // Optional: rounded corners
                                                          child: Padding(
                                                            padding: EdgeInsets.all(
                                                                2.0),
                                                            // Equal padding on all sides
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize
                                                                  .min, // Center the row contents
                                                              children: [
                                                                Text('Title',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlack45TextStyle),
                                                                SizedBox(
                                                                    width:
                                                                    5.0),
                                                                // Space between 'Day' and ':'
                                                                Text(':',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle),
                                                                SizedBox(
                                                                    width:
                                                                    5.0),
                                                                // Space between ':' and 'Monday'
                                                                Text(query.sTitle,
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Text('Data Query',style: AppTextStyle.font12OpenSansRegularBlackTextStyle,),
                                                      SizedBox(height: 2),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            'Query :',
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlack45TextStyle,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            query.sDescription,
                                                            style: AppTextStyle
                                                                .font12OpenSansRegularBlackTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 2),
                                                      // Text('Data Query',style: AppTextStyle.font12OpenSansRegularBlackTextStyle,),
                                                      Text(
                                                        'Response At',
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlack45TextStyle,
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        query.sResponse,
                                                        style: AppTextStyle
                                                            .font12OpenSansRegularBlackTextStyle,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                          }
                      );
                    }
                )
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 5,bottom: 5), // Adjust padding as necessary
                child: ElevatedButton(
                  onPressed: () async {
                   // open dialogBox
                    print('---310---');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _takeActionDialog(context);
                      },
                    );


                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0098a6), // Green color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Post Query',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

          ],
        )

       );
  }
  //
  //Open Dialog
  Widget _takeActionDialog(BuildContext context) {
    TextEditingController _queryTitleEditText = TextEditingController();
    TextEditingController _enterYourQuery = TextEditingController();

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
            height: 265, // Adjusted height to accommodate the TextFormField and Submit button
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TextFormField for entering data
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: TextFormField(
                    controller: _queryTitleEditText,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      filled: true, // Enable background color
                      fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                      hintText: 'Query title', // Add your hint text here
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter a value';
                    //   }
                    //   final intValue = int.tryParse(value);
                    //   if (intValue == null || intValue <= 0) {
                    //     return 'Enter an amount greater than 0';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: TextFormField(
                    controller: _enterYourQuery,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      filled: true, // Enable background color
                      fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                      hintText: 'Enter your query', // Add your hint text here
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter a value';
                    //   }
                    //   final intValue = int.tryParse(value);
                    //   if (intValue == null || intValue <= 0) {
                    //     return 'Enter an amount greater than 0';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                SizedBox(height: 15),
                // Submit button
                InkWell(
                  onTap: ()async{
                    var queryTitle = _queryTitleEditText.text.trim();
                    var enterYourQuery = _enterYourQuery.text.trim();

                    print('-----1102--$queryTitle');
                    //print(sTranCode);

                    // Check if the input is not empty
                    if (queryTitle != null && queryTitle != '' && enterYourQuery!=null && enterYourQuery!='') {
                      print('---Call Api-----');

                      // Make API call here

                      var postQuery = await PostqueryRepo().postquery(context,queryTitle,enterYourQuery);
                      print('--326--$postQuery');

                      setState(() {
                        result = "${postQuery[0]['Result']}";
                        msg = "${postQuery[0]['Msg']}";
                      });

                      print('---449----$result');
                      print('---450----$msg');

                    } else{
                      if(queryTitle==null || queryTitle==''){
                        generalfunction.displayToast('Enter query title');
                      }else{
                        generalfunction.displayToast('Enter Query');
                      }
                      print('---Api not Call -----');
                    }
                    if(result=="1"){
                          Navigator.of(context).pop();
                          /// calla api again
                          queryResponsemodel = QueryResponseRepo().quryList(context);

                          // Show the success dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildDialogSucces2(context, msg); // A new dialog for showing success
                            },
                          );
                    }else{
                      generalfunction.displayToast(msg);
                    }

                      // Check the result of the API call
                    //   if (result == "1") {
                    //     // Close the current dialog and show a success dialog
                    //     Navigator.of(context).pop();
                    //
                    //     // Show the success dialog
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return _buildDialogSucces2(context, msg); // A new dialog for showing success
                    //       },
                    //     );
                    //     print('-----1123---');
                    //   } else if (result == "0") {
                    //     // Keep the dialog open and show an error message (if needed)
                    //     // You can display an error message in the same dialog without dismissing it
                    //     generalfunction.displayToast(msg);  // Optionally, show a toast message to indicate failure
                    //
                    //     // Optionally clear the input field if needed
                    //     // _takeAction.clear();  // Do not clear to allow retrying
                    //   }
                    // } else {
                    //   // Handle the case where no input is provided
                    //   generalfunction.displayToast("Enter remarks");
                    // }

                  },

                  child: Container(
                    //width: double.infinity,
                    // Make container fill the width of its parent
                    height: AppSize.s45,
                    padding: EdgeInsets.all(AppPadding.p5),
                    decoration: BoxDecoration(
                      color: AppColors.loginbutton,
                      // Background color using HEX value
                      borderRadius: BorderRadius.circular(AppMargin.m10), // Rounded corners
                    ),
                    //  #00b3c7
                    child: Center(
                      child: Text(
                        "Post query",
                        style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     String enteredText = _textController.text;
                //     if (enteredText.isNotEmpty) {
                //       print('Submitted: $enteredText');
                //     }
                //     // Perform any action you need on submit
                //    // Navigator.of(context).pop(); // Close the dialog
                //   },
                //   style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Adjust button size
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(15), // Rounded corners for button
                //     ),
                //     backgroundColor: Colors.blue, // Button background color
                //   ),
                //   child: Text(
                //     'Submit',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 14,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/addreimbursement.jpeg', // Replace with your asset image path
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // sucessDialog
  Widget _buildDialogSucces2(BuildContext context,String msg) {
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
            height: 190,
            padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Success',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // call api again
                       // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const ExpenseManagement()),
                        // );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the background color to white
                        foregroundColor: Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/sussess.jpeg', // Replace with your asset image path
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
