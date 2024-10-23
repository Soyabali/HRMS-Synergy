
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/baseProjectRepo.dart';
import '../../data/hrmsWorkEntryNewRepo.dart';
import '../dashboard/dashboard.dart';
import 'dart:convert';
import '../resources/app_text_style.dart';


class WorkDetail extends StatelessWidget {

  const WorkDetail({super.key});

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
      home: WorkDetailPage(),
    );
  }
}

class WorkDetailPage extends StatefulWidget {

  const WorkDetailPage({super.key});

  @override
  State<WorkDetailPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WorkDetailPage> {

  // ----

  List<Map<String, String>> hrmsTimeScheduleList = [
    {'sHourCode': 'H00001', 'sHourDescription': '09:30am-10:30am'},
    {'sHourCode': 'H00002', 'sHourDescription': '10:30am-11:30am'},
    {'sHourCode': 'H00003', 'sHourDescription': '11:30am-12:30pm'},
    {'sHourCode': 'H00004', 'sHourDescription': '12:30pm-01:30pm'},
    {'sHourCode': 'H00005', 'sHourDescription': '01:30pm-02:00pm'},
    {'sHourCode': 'H00006', 'sHourDescription': '02:00pm-03:00pm'},
    {'sHourCode': 'H00007', 'sHourDescription': '03:00pm-04:00pm'},
    {'sHourCode': 'H00008', 'sHourDescription': '04:00pm-05:00pm'},
    {'sHourCode': 'H00009', 'sHourDescription': '05:00pm-06:30pm'}
  ];


  final List<TextEditingController> _controllers = [];
  List<String> projectNames = [];
  List<String> workDetails = [];
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();

  List<dynamic>?  baseProjectList;
  //List<dynamic>?  hrmsTimeScheduleList;

  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  //
  baseProject() async {
    baseProjectList = await HrmsBaseProjectRepo().baseProjectList(context);
    print(" -----57---  baseProjectList--59---> $baseProjectList");
    setState(() {});
  }
  // timeSchedule Response
  // hrmsTimeSchedule() async {
  //   hrmsTimeScheduleList = await HrmsTimeScheduleRepo().timeScheduleList(context);
  //   print(" -----75---  hrmsTimeScheduleList--67---> $hrmsTimeScheduleList");
  //   setState(() {});
  // }

  @override
  void initState() {
    baseProject();
    //hrmsTimeSchedule();
    super.initState();

    if (baseProjectList != null) {
      for (int i = 0; i < baseProjectList!.length; i++) {
        _controllers.add(TextEditingController());
      }
      // Initialize the controllers with an arbitrary number of items (replace 2 with your dynamic item count)
    }
  }

  sendCurrentWorkNew(String combinedList) async{
    var workEntryNew =
        await HrmsWorkEntryNewRepo().hrmsWorkEntryNew(
        context,
        combinedList,
        );
    print('-----111---$workEntryNew');
     var result = "${workEntryNew[0]["Result"]}";
     var msg = "${workEntryNew[0]["Msg"]}";
    print("----Result ---115--$result");
    if(result=="1"){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildDialogSucces2(context,msg);
        },
      );
      print("----117---");
      print('-------------118--------');
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildDialogSucces2(context,msg);
        },
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }


  @override
  void dispose() {
    // dispose all Controller
    for (var controller in _controllers) {
      controller.dispose();
    }
    FocusScope.of(context).unfocus();
    super.dispose();
  }
  // submit Form

  void _submitForm() {
    workDetails.clear();
    projectNames.clear();
    bool isAtLeastOneFieldFilled = false; // Track if at least one field is filled

    // Check if baseProjectList exists and has elements
    if (baseProjectList != null && baseProjectList!.isNotEmpty) {
      // Ensure that _controllers has the same length as baseProjectList
      if (_controllers.length != baseProjectList!.length) {
        // Initialize controllers if they haven't been set up yet
        _controllers.clear();
        for (int i = 0; i < baseProjectList!.length; i++) {
          _controllers.add(TextEditingController());
        }
      }

      // Iterate over the baseProjectList and corresponding controllers
      for (int i = 0; i < baseProjectList!.length; i++) {
        projectNames.add(baseProjectList![i]['sProjectCode'] ?? ''); // Collect project names
        String workDetail = _controllers[i].text.trim();

        // Check if the field is not empty
        if (workDetail.isNotEmpty) {
          isAtLeastOneFieldFilled = true; // At least one field is filled
          workDetails.add(workDetail); // Collect TextFormField values
        }
      }
      // If at least one field is filled, proceed with the submission
      if (isAtLeastOneFieldFilled) {
        // Proceed with the form submission logic
        print("ProjectName: $projectNames");
        print("WorkDetail: $workDetails");
        print("hrmsTimeScheduleList: $hrmsTimeScheduleList");

        print('Project Names--xxx--142--: ${projectNames.length}');
        print('Work Details xxx--143---xx: ${workDetails.length}');
        //  hrmsTimeScheduleList
        print('hrms times schedule lenth xxx--145---xx: ${hrmsTimeScheduleList?.length}');
        // You can now pass these lists to your API
        /// todo Api send thes above list.
        ///
        ///
        int minLength = [
          projectNames.length,
          workDetails.length,
          hrmsTimeScheduleList.length
        ].reduce((curr, next) => curr < next ? curr : next);

        // Combine the lists into one
        List<Map<String, dynamic>> combinedList = [];
        for (int i = 0; i < minLength; i++) {
          combinedList.add({
            'sProjectName': projectNames[i],
            'sEmpWorkStatus': workDetails[i],
            'sHourCode': hrmsTimeScheduleList[i]['sHourCode']
          });
        }
        print("------184----$combinedList");
        String jsonString = jsonEncode(combinedList);
        print("-----185---$jsonString");

        sendCurrentWorkNew(jsonString);

      } else {
        // Show a notification if all fields are empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kindly enter your work detail !'),
            backgroundColor: Colors.black45,
          ),
        );
      }
    } else {
      // Show a notification if there are no projects to fill
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No projects to fill in'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

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
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
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
            'Work Detail',
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
     //
      body: Column(
       mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 10),
          child: SizedBox(
            height: 150, // Height of the container
            width: MediaQuery.of(context).size.width,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/deshboardtop.jpeg',
                fit: BoxFit.fill, // Adjust the image fit to cover the container
              ),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
              itemCount: baseProjectList?.length ?? 0,
              itemBuilder: (context,index){
                // Make sure the _controllers list is initialized properly
                if (_controllers.length < baseProjectList!.length)
                {
                  _controllers.add(TextEditingController());
                }
                return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5,bottom: 5),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        decoration: BoxDecoration(
                            color: Colors.white, // Background color of the container
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Color of the shadow
                                spreadRadius: 5, // Spread radius
                                blurRadius: 7, // Blur radius
                                offset: Offset(0, 3), // Offset of the shadow
                              ),
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Form(
                               // key: _formKey,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: DottedBorder(
                                                    color: Colors.grey,
                                                    strokeWidth: 1.0,
                                                    dashPattern: [4, 2],
                                                    borderType: BorderType.RRect,
                                                    radius: const Radius.circular(5.0),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // This ensures the Row only takes up as much space as needed
                                                        children: [
                                                          Image.asset('assets/images/workdetail.jpeg',
                                                          height: 25,
                                                            width: 25,
                                                            fit: BoxFit.fill,
                                                          ),
                                                          // const Icon(Icons.camera_alt_outlined,
                                                          //     size: 25),
                                                          SizedBox(width: 5),
                                                          Flexible(
                                                            child: Text(
                                                              '${baseProjectList?[index]['sProjectName']}',
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlack45TextStyle,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                Container(
                                                //  height: 65,
                                                  color: Color(0xFFf2f3f5),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0),
                                                    child: TextFormField(
                                                      focusNode: FocusNode(),
                                                      controller: _controllers[index],
                                                      textInputAction: TextInputAction.next,
                                                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                                      maxLines: null, // Allows for multiline input and auto-adjusts height
                                                      keyboardType: TextInputType.multiline, // Enables multiline input from keyboard
                                                      decoration: InputDecoration(
                                                        labelText: "Enter work detail",
                                                        labelStyle: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                                        border: const OutlineInputBorder(),
                                                        contentPadding: const EdgeInsets.symmetric(
                                                          vertical: 10, // Adjust vertical padding for better layout
                                                          horizontal: 10,
                                                        ),
                                                      ),
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    ),

                                                    // child: TextFormField(
                                                    //   focusNode: FocusNode(),
                                                    //   controller: _controllers[index],
                                                    //   textInputAction: TextInputAction.next,
                                                    //   onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                                    //   maxLines:
                                                    //       null, // Allows multiple lines
                                                    //   expands:
                                                    //       true, // Makes the TextFormField fill the height
                                                    //   decoration:
                                                    //       InputDecoration(
                                                    //     labelText:
                                                    //         "Enter work detail",
                                                    //     labelStyle: AppTextStyle
                                                    //         .font14OpenSansRegularBlack45TextStyle,
                                                    //     border: const OutlineInputBorder(),
                                                    //     contentPadding: const EdgeInsets.symmetric(
                                                    //       vertical: 10, // Adjust vertical padding as needed
                                                    //       horizontal: 10,
                                                    //     ),
                                                    //   ),
                                                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    // ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]
                                    )
                                )
                            )
                        )
                    )
                );

              }),
        ),
        SizedBox(height: 10),
        Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10), // Adjust padding as necessary
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0098a6), // Green color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
        ]
      ),
    );
  }
  // dialogSuccess
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

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DashBoard()),
                        );
                        //Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the background color to white
                        foregroundColor: Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     getLocation();
                    //     Navigator.of(context).pop();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white, // Set the background color to white
                    //     foregroundColor: Colors.black, // Set the text color to black
                    //   ),
                    //   child: Text('OK',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    // )
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
