
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:untitled/data/hrmsTimeScheduleRepo.dart';
import 'package:untitled/presentation/workdetail/workdetailComponent/buildCupertinoProjectCard.dart';
import 'package:untitled/presentation/workdetail/workdetailComponent/buildMaterialProjectCard.dart';
import '../../data/baseProjectRepo.dart';
import '../../data/hrmsWorkEntryNewRepo.dart';
import '../dashboard/dashboard.dart';
import 'dart:convert';
import '../resources/app_text_style.dart';
import 'dart:io';


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

  final List<Map<String, dynamic>> staticWorkingHours = [
    {"fWorkingHrs": "0.5", "sWorkingHrsName": "Half Hour"},
    {"fWorkingHrs": "1", "sWorkingHrsName": "1 Hour"},
    {"fWorkingHrs": "1.5", "sWorkingHrsName": "1.5 Hour"},
    {"fWorkingHrs": "2", "sWorkingHrsName": "2 Hour"},
    {"fWorkingHrs": "2.5", "sWorkingHrsName": "2.5 Hour"},
    {"fWorkingHrs": "3", "sWorkingHrsName": "3 Hour"},
    {"fWorkingHrs": "3.5", "sWorkingHrsName": "3.5 Hour"},
    {"fWorkingHrs": "4", "sWorkingHrsName": "4 Hour"},
    {"fWorkingHrs": "4.5", "sWorkingHrsName": "4.5 Hour"},
    {"fWorkingHrs": "5", "sWorkingHrsName": "5 Hour"},
    {"fWorkingHrs": "5.5", "sWorkingHrsName": "5.5 Hour"},
    {"fWorkingHrs": "6", "sWorkingHrsName": "6 Hour"},
    {"fWorkingHrs": "6.5", "sWorkingHrsName": "6.5 Hour"},
    {"fWorkingHrs": "7", "sWorkingHrsName": "7 Hour"},
    {"fWorkingHrs": "7.5", "sWorkingHrsName": "7.5 Hour"},
    {"fWorkingHrs": "8", "sWorkingHrsName": "8 Hour"},
    {"fWorkingHrs": "8.5", "sWorkingHrsName": "8.5 Hour"},
    {"fWorkingHrs": "9", "sWorkingHrsName": "9 Hour"},
    {"fWorkingHrs": "9.5", "sWorkingHrsName": "9.5 Hour"},
    {"fWorkingHrs": "10", "sWorkingHrsName": "10 Hour"},
    {"fWorkingHrs": "10.5", "sWorkingHrsName": "10.5 Hour"},
    {"fWorkingHrs": "11", "sWorkingHrsName": "11 Hour"},
    {"fWorkingHrs": "11.5", "sWorkingHrsName": "11.5 Hour"},
    {"fWorkingHrs": "12", "sWorkingHrsName": "12 Hour"},
    {"fWorkingHrs": "12.5", "sWorkingHrsName": "12.5 Hour"},
    {"fWorkingHrs": "13", "sWorkingHrsName": "13 Hour"},
    {"fWorkingHrs": "13.5", "sWorkingHrsName": "13.5 Hour"},
    {"fWorkingHrs": "14", "sWorkingHrsName": "14 Hour"},
    {"fWorkingHrs": "14.5", "sWorkingHrsName": "14.5 Hour"},
    {"fWorkingHrs": "15", "sWorkingHrsName": "15 Hour"},
    {"fWorkingHrs": "15.5", "sWorkingHrsName": "15.5 Hour"},
    {"fWorkingHrs": "16", "sWorkingHrsName": "16 Hour"},
    {"fWorkingHrs": "16.5", "sWorkingHrsName": "16.5 Hour"},
    {"fWorkingHrs": "17", "sWorkingHrsName": "17 Hour"},
    {"fWorkingHrs": "17.5", "sWorkingHrsName": "17.5 Hour"},
    {"fWorkingHrs": "18", "sWorkingHrsName": "18 Hour"},
    {"fWorkingHrs": "18.5", "sWorkingHrsName": "18.5 Hour"},
    {"fWorkingHrs": "19", "sWorkingHrsName": "19 Hour"},
    {"fWorkingHrs": "19.5", "sWorkingHrsName": "19.5 Hour"},
    {"fWorkingHrs": "20", "sWorkingHrsName": "20 Hour"}
  ];

  FocusNode workDetailfocus = FocusNode();

  List<TextEditingController> _controllers = [];
  List<String> projectNames = [];
  List<String> workDetails = [];
  List<dynamic>?  baseProjectList;
 // List<dynamic> selectedHourCodes = [];
  var _dropDownSector;
  final sectorFocus = GlobalKey();
  var _selectedSectorId;
  var _selectHoursTime;
  List<String?> _selectedDropDownValues = [];
  //List<String> _selectedHourCodes = [];
  List<Map<String, dynamic>> _selectedHourCodes = [];

  //
  // List<Map<String, String>> hrmsTimeScheduleList = [

  List<Map<String, dynamic>>? hrmsTimeScheduleList2;


  void displayToast(String msg) {
    Fluttertoast.showToast(
      msg,
      duration: Duration(seconds: 1),
      position: Fluttertoast.ToastPosition.center,
      backgroundColor: Colors.black45,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }

  baseProject() async {
    baseProjectList = await HrmsBaseProjectRepo().baseProjectList(context);
    print(" -----Project List---84---> $baseProjectList");
    setState(() {});
  }
  // hrmsTimeSchedule
  hrmsTimeSchedule() async {
    hrmsTimeScheduleList2 = await HrmsTimeScheduleRepo().timeScheduleList(context);
    print(" -----Hrsms time Schedule---137---> $hrmsTimeScheduleList2");
    setState(() {});
  }

  Future<void> toCallApiInitState() async {

    baseProjectList = await HrmsBaseProjectRepo().baseProjectList(context);

    if (baseProjectList != null) {
      _controllers = List.generate(
          baseProjectList!.length, (_) => TextEditingController());

      _selectedDropDownValues = List.generate(
          baseProjectList!.length, (_) => null);
      setState(() {});
    }
  }
  // projectCard
  Widget buildCard(BuildContext context, int index) {
    final projectName = baseProjectList?[index]['sProjectName'] ?? '';

    return Platform.isIOS
        ? buildCupertinoProjectCard(context, projectName)
        : buildMaterialProjectCard(context, projectName); // Your original widget
  }

  @override
  void initState() {
    toCallApiInitState();
    hrmsTimeSchedule();
    super.initState();

    if (baseProjectList != null) {
      for (int i = 0; i < baseProjectList!.length; i++) {
        _controllers.add(TextEditingController());
        if (_selectedDropDownValues.length != baseProjectList?.length) {
          _selectedDropDownValues = List.generate(baseProjectList!.length, (_) => null);
        }

      }
      }
  }

  sendCurrentWorkNew(String combinedList) async {
    var workEntryNew = await HrmsWorkEntryNewRepo().hrmsWorkEntryNew(context, combinedList);
    print('-----111---$workEntryNew');
    var result = "${workEntryNew[0]["Result"]}";
    var msg = "${workEntryNew[0]["Msg"]}";
    print("----Result ---115--$result");

    if(result=="1")
    {
    // print("---msg--$msg");
      showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return _buildDialogSucces2(context,msg);
        },
      );

      print("----117---");
      print('-------------118--------');
    }else{
      //print("---msg--$msg");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildDialogInformation(context,msg);
        },
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused)
    {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }
  // DropDown
  Widget _bindSector(int index) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: 42,
        color: Color(0xFFf2f3f5),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              isDense: true,
              isExpanded: true,
              onTap: () => FocusScope.of(context).unfocus(),
              hint: Text(
                "Working Hours",
                style: AppTextStyle.font16OpenSansRegularBlack45TextStyle,
              ),
              value: _selectedDropDownValues[index],
                onChanged: (newValue) {
                  setState(() {
                    _selectedDropDownValues[index] = newValue;

                    final selectedItem = staticWorkingHours.firstWhere(
                          (element) => element['sWorkingHrsName'] == newValue,
                      orElse: () => {},
                    );

                    _selectHoursTime =
                        selectedItem['fWorkingHrs']?.toString() ?? '';

                    if (_selectHoursTime.isNotEmpty) {

                      if (_selectedHourCodes.length <= index) {
                        _selectedHourCodes.addAll(
                          List.generate(index - _selectedHourCodes.length + 1, (_) => {}),
                        );
                      }
                      _selectedHourCodes[index] = {
                        'fWorkingHrs': _selectHoursTime,
                      };

                    }
                  });
                },

              items: staticWorkingHours.map<DropdownMenuItem<String>>((item) {
                final name = item['sWorkingHrsName'].toString();

                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
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
  // this is a  topBar images codes

  // submit Form
  void _submitForm() {
    workDetails.clear();
    projectNames.clear();
    List<Map<String, dynamic>> combinedList = [];
    bool isAtLeastOneFieldFilled = false;   // Track if at least one field is filled
    // Check if baseProjectList exists and has elements

    if (baseProjectList != null && baseProjectList!.isNotEmpty) {
      // Ensure that _controllers has the same length as baseProjectList
      if (_controllers.length != baseProjectList!.length) {
        _controllers.clear();
        for (int i = 0; i < baseProjectList!.length; i++) {
          _controllers.add(TextEditingController());
        }
      }
      // Iterate over the baseProjectList and corresponding controllers
      for (int i = 0; i < baseProjectList!.length; i++) {
        String workDetail = _controllers[i].text.trim();
        // Check if the field is not empty
        if (workDetail.isNotEmpty) {
          isAtLeastOneFieldFilled = true; // At least one field is filled
          // Collect project code and work detail for filled fields only
          String projectCode = baseProjectList![i]['sProjectCode'] ?? '';
          workDetails.add(workDetail);
          projectNames.add(projectCode);
          // Also add to the combined list here if hrmsTimeScheduleList has corresponding entries
          final hourCode = _selectedHourCodes.length > i ? _selectedHourCodes[i] : null;

          if (staticWorkingHours != null && i < staticWorkingHours.length && workDetails!=null && workDetail.isNotEmpty) {
            combinedList.add({
              'sProjectName': projectCode,
              'sEmpWorkStatus': workDetail,
              'sHourCode': hrmsTimeScheduleList2![i]['sHourCode'],
              'fWorkingHrs': (_selectedHourCodes.length > i && _selectedHourCodes[i] != null)
                  ? _selectedHourCodes[i]['fWorkingHrs']
                  : '',           // 'fWorkingHrs': _selectedHourCodes[i]['fWorkingHrs'],            //'sHourCode': staticWorkingHours[i]['fWorkingHrs'],
            });
          }
        }
      }
      // If at least one field is filled, proceed with the submission

      if (isAtLeastOneFieldFilled) {
        // Proceed with the form submission logic
        print("Filtered ProjectNames: $projectNames");
        print("Filtered WorkDetails: $workDetails");
        print("Combined List: $combinedList");

        String jsonString = jsonEncode(combinedList);
        print("JSON Payload: $jsonString");

        // Send data to API
        sendCurrentWorkNew(jsonString);
      } else {
        // Show a notification if all fields are empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kindly enter your work detail!'),
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
  // willPopScope

  // load svg or png

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
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

                GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child:
                    SizedBox(
                      height: 150,
                     // width: double.infinity,
                      width: MediaQuery.of(context).size.width-10,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/workstatus3.jpeg',
                          fit: BoxFit.fill, // or BoxFit.fill / contain / fitWidth
                        ),
                      ),
                    ),
                  ),
                ),
                //  pre mages name :  ic_work_sheet_header.png'
                Expanded(
                  child: ListView.builder(
                      itemCount: baseProjectList?.length ?? 0,
                      itemBuilder: (context,index) {
                        // Make sure the _controllers list is initialized properly
                        if (_controllers.length < baseProjectList!.length)
                        {
                          _controllers.add(TextEditingController());
                        }
                        return Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5,bottom: 5,top: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width - 10,
                                decoration: BoxDecoration(
                                    color: Colors.white, // Background color of the container
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5), // Color of the shadow
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
                                                        // card as a project aname
                                                        buildCard(context,index),

                                                        // Container(
                                                        //   alignment: Alignment.centerLeft,
                                                        //   child: DottedBorder(
                                                        //     color: Colors.grey,
                                                        //     strokeWidth: 1.0,
                                                        //     dashPattern: [4, 2],
                                                        //     borderType: BorderType.RRect,
                                                        //     radius: const Radius.circular(5.0),
                                                        //     child: Padding(
                                                        //       padding: EdgeInsets.all(8.0),
                                                        //       child: Row(
                                                        //         mainAxisSize: MainAxisSize.min, // This ensures the Row only takes up as much space as needed
                                                        //         children: [
                                                        //           Image.asset('assets/images/workdetail.jpeg',
                                                        //             height: 25,
                                                        //             width: 25,
                                                        //             fit: BoxFit.fill,
                                                        //           ),
                                                        //           // const Icon(Icons.camera_alt_outlined,
                                                        //           //     size: 25),
                                                        //           SizedBox(width: 5),
                                                        //           Flexible(
                                                        //             child: Text(
                                                        //               '${baseProjectList?[index]['sProjectName']}',
                                                        //               style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                                        //               overflow: TextOverflow.ellipsis,
                                                        //             ),
                                                        //
                                                        //           ),
                                                        //         ],
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        SizedBox(height: 15),
                                                        _bindSector(index),
                                                       // _bindSector(),
                                                        SizedBox(height: 15),
                                                        Platform.isIOS
                                                        ? Container(
                                                          //color: const Color(0xFFf2f3f5),
                                                          //padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                                          child: CupertinoTextField(
                                                            controller: _controllers[index],
                                                            placeholder: "Enter work detail",
                                                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                                                            maxLines: null,
                                                            keyboardType: TextInputType.multiline,
                                                            textInputAction: TextInputAction.next,
                                                            onEditingComplete: () => FocusScope.of(context).nextFocus(),

                                                            // ✅ Native iOS-style font
                                                            style: const TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.w400,
                                                              color: CupertinoColors.black,
                                                              fontFamily: '.SF Pro Text', // Native iOS font
                                                            ),

                                                            // ✅ Native-style placeholder
                                                            placeholderStyle: const TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.w400,
                                                              color: CupertinoColors.placeholderText,
                                                              fontFamily: '.SF Pro Text',
                                                            ),

                                                            // ✅ iOS-style border
                                                            decoration: BoxDecoration(
                                                              color: CupertinoColors.white,
                                                              border: Border.all(color: CupertinoColors.systemGrey4, width: 1.0),
                                                              borderRadius: BorderRadius.circular(8.0), // Rounded corners as per iOS
                                                            ),
                                                          ),
                                                        )
                                                        :
                                                        Container(
                                                          //  height: 65,
                                                          color: Color(0xFFf2f3f5),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 0),
                                                            child: TextFormField(
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
                Platform.isIOS ?
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 20,left: 15,right: 15),
                  child: SizedBox(
                    width: double.infinity, // Full-width button
                    child: CupertinoButton(
                     // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      color: const Color(0xFF0098a6), // Custom iOS-like teal color
                      borderRadius: BorderRadius.circular(8),
                      onPressed: _submitForm,
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.white, // iOS white color
                          fontFamily: '.SF Pro Text', // Native iOS font
                        ),
                      ),
                    ),
                  ),
                )
                :
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 10), // Adjust padding as necessary
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
        ),
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

                       if(msg=="Work status has been submitted"){

                         Navigator.pushAndRemoveUntil(
                           context,
                           MaterialPageRoute(builder: (context) => const DashBoard()),
                               (Route<dynamic> route) => false, // Remove all previous routes
                         );
                       }else{
                         Navigator.pop(context);
                       }
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
  Widget _buildDialogInformation(BuildContext context,String msg) {
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
                    'Information',
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

                        if(msg=="Work status has been submitted"){

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const DashBoard()),
                                (Route<dynamic> route) => false, // Remove all previous routes
                          );
                        }else{
                          Navigator.pop(context);
                        }
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
                  'assets/images/information.jpeg', // Replace with your asset image path
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
