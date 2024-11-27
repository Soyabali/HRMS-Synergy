import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/generalFunction.dart';
import '../../../data/AppRejctReimbursementByApproverRepo.dart';
import '../../../data/district_repo.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../../data/shopTypeRepo.dart';
import '../../../domain/GetPendingForApprovalReimModel.dart';
import '../../../domain/GetPendingForApprovalReimRepo.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';
import '../expense_management.dart';
import '../reimbursementStatus/consumableItem.dart';
import '../reimbursementStatus/reimbursementlog.dart';
import 'duplicateExpenseEntry.dart';

class PendingTeamReimbPage extends StatefulWidget {

  const PendingTeamReimbPage({super.key});

  @override
  State<PendingTeamReimbPage> createState() => _MyHomePageState();

}
class _MyHomePageState extends State<PendingTeamReimbPage> {

  List<Map<String, dynamic>>? pendingSchedulepointList;

  TextEditingController _searchController = TextEditingController();
  //  _takeAction
  TextEditingController _takeAction = TextEditingController();
  double? lat;
  double? long;
  GeneralFunction generalfunction = GeneralFunction();
  DateTime? _date;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _date = selectedDate;
      });
    }
    print('------67---${_date?.toLocal().toString()}'.split(' ')[0]);
  }

  List stateList = [];
  List distList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

   // DialogBox Code
  Dialog showTakeActionDialog(BuildContext context, String sTranCode) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update Status',
                      style: AppTextStyle.font16OpenSansRegularRedTextStyle,
                    ),
                    SizedBox(height: 10),
                    // Radio buttons for the decision options
                    RadioListTile<String>(
                      title: Text('Approved'),
                      value: 'Approved',
                      groupValue: _selectedDecision,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedDecision = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Rejected'),
                      value: 'Rejected',
                      groupValue: _selectedDecision,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedDecision = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Clarification Required'),
                      value: 'Clarification Required',
                      groupValue: _selectedDecision,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedDecision = value;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: TextFormField(
                        controller: _takeAction,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          fillColor: Color(0xFFf2f3f5),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    SizedBox(height: 15),
                    // Submit button
                    InkWell(
                      onTap: () async {
                        var iStatus;
                        var sRemarks = _takeAction.text.trim();
                        print('-----155--$sRemarks');
                        print('-----158--$sTranCode');
                        print('-----158----$_selectedDecision');

                        // Set iStatus based on selected decision
                        if (_selectedDecision == "Approved") {
                          iStatus = "8"; // Approved
                        } else if (_selectedDecision == "Rejected") {
                          iStatus = "9"; // Rejected
                        } else {
                          iStatus = "5"; // Clarification Required
                        }
                        print('-----167-----$iStatus');

                        // Validate iStatus and remarks before API call
                        if (iStatus == null || iStatus == '') {
                          displayToast('Select a value');
                          return;
                        }

                        if (iStatus == "8") {
                          // If Approved, proceed directly to API call
                          print('------170----Call API for Approved-----');
                          await _callApi(sTranCode, iStatus, sRemarks, context);
                        } else {
                          // If not Approved, check if remarks are entered
                          if (sRemarks.isEmpty) {
                            displayToast('Remarks are required');
                            return;
                          }
                          // Call the API for Rejected or Clarification
                          print('------170----Call API for Rejected or Clarification-----');
                          await _callApi(sTranCode, iStatus, sRemarks, context);
                        }
                      },
                      child: Container(
                        height: AppSize.s45,
                        padding: EdgeInsets.all(AppPadding.p5),
                        decoration: BoxDecoration(
                          color: AppColors.loginbutton,
                          borderRadius: BorderRadius.circular(AppMargin.m10),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -30,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/addreimbursement.jpeg',
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _callApi(String sTranCode, String iStatus, String sRemarks, BuildContext context) async {
    var apprejreim = await ApprejctreimbursementbyapproverrepoRepo().apprejectReim(context, sTranCode, iStatus, sRemarks);
    print('------174--xx--$apprejreim');
    var result = "${apprejreim[0]['Result']}";
    var msg = "${apprejreim[0]['Msg']}";

    if (result == "1") {
      // close the dialog
      Navigator.pop(context);
      // Success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
         // return _buildDialogSucces2(context, msg);
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
                      Text('Success',
                          style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
                              setState(() {
                                hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                              });
                              // Main Api call again

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              // Set the background color to white
                              foregroundColor: Colors.black, // Set the text color to black
                            ),
                            child: Text('Ok', style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
                        'assets/images/sussess.jpeg',
                        // Replace with your asset image path
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
        },
      );
    } else {
      displayToast('API call failed');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  updatedSector() async {
    distList = await ProjectRepo().projectList();
    print(" -----xxxxx-  list Data--65---> $distList");
    setState(() {});
  }

  shopType() async {
    shopTypeList = await ShopTypeRepo().getShopType();
    print(" -----xxxxx-  shopTypeList--- Data--65---> $shopTypeList");
    setState(() {});
  }

  // postImage
  postimage() async {
    print('----ImageFile----$_imageFile');
    var postimageResponse =
        await PostImageRepo().postImage(context, _imageFile);
    print(" -----xxxxx-  --72---> $postimageResponse");
    setState(() {});
  }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  //
  FocusNode _shopfocus = FocusNode();
  FocusNode _owenerfocus = FocusNode();
  FocusNode _contactfocus = FocusNode();
  FocusNode _landMarkfocus = FocusNode();
  FocusNode _addressfocus = FocusNode();

  // FocusNode descriptionfocus = FocusNode();
  String? todayDate;
  List? data;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final sectorFocus = GlobalKey();
  File? _imageFile;
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  String? firstOfMonthDay;
  String? lastDayOfCurrentMonth;
  var sTranCode;
  var duplicate;
  String? _selectedDecision;

  // Uplode Id Proof with gallary
  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------135----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // multifilepath
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

  // image code
  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest('POST',
          Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));

      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body);

      // Print the response data
      print(responseData);
      hideLoader();
      print('---------172---$responseData');
      uplodedImage = "${responseData['Data'][0]['sImagePath']}";
      print('----174---$uplodedImage');
    } catch (error) {
      showLoader();
      print('Error uploading image: $error');
    }
  }

  multipartProdecudre() async {
    print('----139--$image');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token---$sToken');

    var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));
    request.body = json.encode({"sImagePath": "$image"});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    print('---155----$responseData');
  }

  // datepicker
  // InitState
  getCurrentdate() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    firstOfMonthDay = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    // last day of the current month
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    lastDayOfCurrentMonth = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);
    setState(() {});
    if (firstDayOfNextMonth != null && lastDayOfCurrentMonth != null) {
      print('You should call api');
      //reimbursementStatusV3 = (await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay!,lastDayOfCurrentMonth!)) as Future<List<Hrmsreimbursementstatusv3model>>;
      //print('---255--$reimbursementStatusV3');
      /// reimbursementStatusList = await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay!,lastDayOfCurrentMonth!);
      // _filteredData = List<Map<String, dynamic>>.from(reimbursementStatusList ?? []);
      // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
    } else {
      print('You should  not call api');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    updatedSector();
    getCurrentdate();
    hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
    shopType();
    print("---------424--------xxxx--");
   // _takeAction = TextEditingController();
    super.initState();
    _shopfocus = FocusNode();
    _owenerfocus = FocusNode();
    _contactfocus = FocusNode();
    _landMarkfocus = FocusNode();
    _addressfocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _shopfocus.dispose();
    _owenerfocus.dispose();
    _contactfocus.dispose();
    _landMarkfocus.dispose();
    _addressfocus.dispose();
    _takeAction.dispose();
  }

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

  late Future<List<GetPendingForApprovalReimmodel>> getPendingApprovalReim;
  List<GetPendingForApprovalReimmodel> _allData = []; // Holds original data
  List<GetPendingForApprovalReimmodel> _filteredData = [];

  hrmsReimbursementStatus(String firstOfMonthDay, String lastDayOfCurrentMonth) async {
    getPendingApprovalReim = GetPendingforApprovalReimRepo().getPendingApprovalReim(context, firstOfMonthDay, lastDayOfCurrentMonth);

    getPendingApprovalReim.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
  }

  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData; // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sProjectName
                  .toLowerCase()
                  .contains(query.toLowerCase()) || // Filter by project name
              item.sExpHeadName.toLowerCase().contains(query.toLowerCase()) ||
              item.sEmpName.toLowerCase().contains(query.toLowerCase());
          // Filter by employee name
        }).toList();
      }
    });
  }
  // currentDate

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
                MaterialPageRoute(builder: (context) => const ExpenseManagement()),
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
              'Pending Team Reimb',
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
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 45,
                color: Color(0xFF2a697b),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 4),
                    Icon(Icons.calendar_month, size: 15, color: Colors.white),
                    const SizedBox(width: 4),
                    const Text(
                      'From',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        /// TODO Open Date picke and get a date
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        // Check if a date was picked
                        if (pickedDate != null) {
                          // Format the picked date
                          String formattedDate =
                              DateFormat('dd/MMM/yyyy').format(pickedDate);
                          // Update the state with the picked date
                          setState(() {
                            firstOfMonthDay = formattedDate;
                            // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          });

                          /// todo call api here to change date to that that is reflect
                          ///
                          // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          // reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                          //print('--FirstDayOfCurrentMonth----$firstOfMonthDay');
                          // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          //print('---formPicker--$firstOfMonthDay');
                          // Call API
                          //hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          // print('---formPicker--$firstOfMonthDay');

                          // Display the selected date as a toast
                          //displayToast(dExpDate.toString());
                        } else {
                          // Handle case where no date was selected
                          //displayToast("No date selected");
                        }
                      },
                      child: Container(
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 14.0),
                        // Optional: Adjust padding for horizontal space
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // Change this to your preferred color
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            '$firstOfMonthDay',
                            style: TextStyle(
                              color: Colors.grey,
                              // Change this to your preferred text color
                              fontSize: 12.0, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      height: 32,
                      width: 32,
                      child: Image.asset(
                        "assets/images/reimicon_2.png",
                        fit: BoxFit
                            .contain, // or BoxFit.cover depending on the desired effect
                      ),
                    ),
                    //Icon(Icons.arrow_back_ios,size: 16,color: Colors.white),
                    SizedBox(width: 8),
                    Icon(Icons.calendar_month, size: 16, color: Colors.white),
                    SizedBox(width: 5),
                    const Text(
                      'To',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        // Check if a date was picked
                        if (pickedDate != null) {
                          // Format the picked date
                          String formattedDate =
                              DateFormat('dd/MMM/yyyy').format(pickedDate);
                          // Update the state with the picked date
                          setState(() {
                            lastDayOfCurrentMonth = formattedDate;
                            // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          });

                          /// todo call api here such that live data reflected
                          //hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          //reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                          // print('--LastDayOfCurrentMonth----$lastDayOfCurrentMonth');
                        } else {}
                      },
                      child: Container(
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 14.0),
                        // Optional: Adjust padding for horizontal space
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // Change this to your preferred color
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            '$lastDayOfCurrentMonth',
                            style: TextStyle(
                              color: Colors.grey,
                              // Change this to your preferred text color
                              fontSize: 12.0, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  // child: SearchBar(),
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.grey, // Outline border color
                        width: 0.2, // Outline border width
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _searchController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Keywords',
                                  prefixIcon: Icon(Icons.search),
                                  hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  border: InputBorder.none,
                                ),
                                onChanged: (query) {
                                  filterData(
                                      query); // Call the filter function on text input change
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
              child: Container(
              child: FutureBuilder<List<GetPendingForApprovalReimmodel>>(
                              future: getPendingApprovalReim,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('No data available'));
                                } else {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length ?? 0,
                                      itemBuilder: (context, index) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                            child: Text('No data available'),
                                          );
                                        } else {
                                          final leaveData = _filteredData[index];
                                          var sExpHeadCode = leaveData.sExpHeadCode;

                                          duplicate = leaveData.sDuplicate;
                                          var textColor;
                                          if (duplicate == "Cross Check") {
                                            textColor = Colors.red;
                                          } else if (duplicate == "Single") {
                                            textColor = Colors.green;
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: Card(
                                              elevation: 1,
                                              color: Colors.white,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(5.0),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    // Outline border color
                                                    width: 0.2, // Outline border width
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      left: 8,
                                                      right: 8,
                                                      top: 8),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Container(
                                                              width: 30.0,
                                                              height: 30.0,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    15.0),
                                                                border: Border
                                                                    .all(
                                                                  color: Color(
                                                                      0xFF255899),
                                                                  width: 0.5, // Outline border width
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "${1+index}",
                                                                  style: AppTextStyle
                                                                      .font14OpenSansRegularBlackTextStyle,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            // Wrap the column in Flexible to prevent overflow
                                                            Flexible(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    leaveData
                                                                        .sExpHeadName,
                                                                    //leaveData.sExpHeadName,
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle,
                                                                    maxLines: 2,
                                                                    // Limits the text to 2 lines
                                                                    overflow: TextOverflow
                                                                        .ellipsis, // Truncates with an ellipsis if too long
                                                                  ),
                                                                  SizedBox(
                                                                      height: 4),
                                                                  // Add spacing between texts if needed
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right: 10),
                                                                    child: Text(
                                                                      // leaveData.sProjectName,
                                                                      "Project Name : ${leaveData
                                                                          .sProjectName}",
                                                                      style: AppTextStyle
                                                                          .font12OpenSansRegularBlackTextStyle,
                                                                      maxLines: 2,
                                                                      // Limits the text to 2 lines
                                                                      overflow: TextOverflow
                                                                          .ellipsis, // Truncates with an ellipsis if too long
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            /// todo here you should add a icon on a right hand side
                                                            Spacer(),
                                                            sExpHeadCode =="3521182900" ?
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  top: 10),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  print(
                                                                      '----print----');
                                                                   var sTranCode =  leaveData.sTranCode;
                                                                  print("----670----$sTranCode");

                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            ConsumableItemPage(sTranCode: sTranCode)),
                                                                  );
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .end,
                                                                  // Aligns the child to the right
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/aadhar.jpeg",
                                                                      width: 20,
                                                                      height: 20,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                            : Container(),

                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15),
                                                          child: Container(
                                                            height: 0.5,
                                                            color: Color(
                                                                0xff3f617d),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 10.0,
                                                              width: 10.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                // Change this to your preferred color
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            //  '‣ Sector',
                                                            Text(
                                                                'Employee Name',
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 15),
                                                          child: Text(
                                                              leaveData
                                                                  .sEmpName,
                                                              //item['dExpDate'] ??'',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 10.0,
                                                              width: 10.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                // Change this to your preferred color
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text('Bill Date',
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(left: 15),
                                                          child: Text(leaveData
                                                              .dExpDate,
                                                              // item['dEntryAt'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 10.0,
                                                              width: 10.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                // Change this to your preferred color
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text('Enter At',
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 15),
                                                          child: Text(
                                                              leaveData
                                                                  .dEntryAt,
                                                              // item['sExpDetails'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
                                                        ),
                                                        SizedBox(height: 10),
                                                        // cross Check
                                                        GestureDetector(
                                                          onTap: () {
                                                            print(
                                                                '-----Press------');
                                                            // DuplicatExpensEntry
                                                            var sTranCode = leaveData
                                                                .sTranCode;
                                                            print(
                                                                '---TRANCODE---$sTranCode');
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (
                                                                      context) =>
                                                                      DuplicatExpensEntry(sTranCode)),
                                                            );
                                                          },

                                                          child: Row(
                                                            children: [
                                                              // Container with black background
                                                              Container(
                                                                width: 10,
                                                                height: 10,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      5),
                                                                ),
                                                              ),
                                                              // Spacer between container and column
                                                              SizedBox(
                                                                  width: 10),
                                                              // Column with two text widgets
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                        'Cross Check',
                                                                        // First text widget
                                                                        style: AppTextStyle
                                                                            .font12OpenSansRegularBlackTextStyle),
                                                                    Text(
                                                                      leaveData
                                                                          .sDuplicate,
                                                                      // Second text widget
                                                                      style: TextStyle(
                                                                          color: textColor,
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight
                                                                              .normal
                                                                      ),
                                                                      // style: AppTextStyle.font12OpenSansRegularBlackTextStyle)
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 16,
                                                                  color: duplicate ==
                                                                      "Cross Check"
                                                                      ? Colors
                                                                      .red
                                                                      : duplicate ==
                                                                      "Single"
                                                                      ? Colors
                                                                      .green
                                                                      : Colors
                                                                      .grey, // Default to grey if no match
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        //
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 10.0,
                                                              width: 10.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                // Change this to your preferred color
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                                'Expense Details',
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 15),
                                                          child: Text(
                                                              leaveData
                                                                  .sExpDetails,
                                                              // item['sExpDetails'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
                                                        ),
                                                        SizedBox(height: 10),
                                                        // bottom
                                                        Container(
                                                          height: 1,
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width - 40,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(height: 10),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(left: 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              Icon(Icons
                                                                  .speaker_notes,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .black),
                                                              SizedBox(
                                                                  width: 10),
                                                              Text('Status',
                                                                  style: AppTextStyle
                                                                      .font12OpenSansRegularBlackTextStyle),
                                                              SizedBox(
                                                                  width: 5),
                                                              const Text(
                                                                ':',
                                                                style: TextStyle(
                                                                  color: Color(
                                                                      0xFF0098a6),
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight
                                                                      .normal,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  leaveData
                                                                      .sStatus,
                                                                  // item['sStatusName'] ?? '',
                                                                  style: AppTextStyle
                                                                      .font12OpenSansRegularBlackTextStyle,
                                                                  maxLines: 2,
                                                                  // Allows up to 2 lines for the text
                                                                  overflow: TextOverflow
                                                                      .ellipsis, // Adds an ellipsis if the text overflows
                                                                ),
                                                              ),
                                                              // Spacer(),
                                                              Container(
                                                                height: 30,
                                                                padding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                    horizontal: 16.0),
                                                                decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xFF0098a6),
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      15),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    '₹ ${leaveData
                                                                        .fAmount}',
                                                                    // item['fAmount'] ?? '',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: 14.0,
                                                                    ),
                                                                    maxLines: 1,
                                                                    // Allows up to 2 lines for the text
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            // Space between the two columns
                                                            children: [
                                                              // First Column
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Container(
                                                                      height: 40,
                                                                      decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xFF0098a6),
                                                                        // Change this to your preferred color
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                      ),
                                                                      child: GestureDetector(
                                                                        onTap: (){
                                                                          print('-----832---View Image---');
                                                                          List<String> images = [
                                                                            leaveData.sExpBillPhoto,
                                                                            leaveData.sExpBillPhoto2,
                                                                            leaveData.sExpBillPhoto3,
                                                                            leaveData.sExpBillPhoto4,
                                                                          ].where((image) => image != null && image.isNotEmpty).toList(); // Filter out null/empty images

                                                                          var dExpDate = leaveData.dExpDate;
                                                                          var billDate = 'Bill Date : $dExpDate';
                                                                          openFullScreenDialog(context, images, billDate);
                                                                        },
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Text(
                                                                                'View Image',
                                                                                style: AppTextStyle
                                                                                    .font14OpenSansRegularWhiteTextStyle),
                                                                            Icon(
                                                                              Icons
                                                                                  .arrow_forward_ios,
                                                                              color: Colors
                                                                                  .white,
                                                                              size: 16,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2),
                                                              // if(leaveData.iStatus=="0")
                                                              // remove
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Container(
                                                                      height: 40,
                                                                      decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xFFE4B9AB),
                                                                        // Change this to your preferred color
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                      ),
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          print("----Action Dialog---");
                                                                          /// todo here open dialog
                                                                          var sTranCode =  '${leaveData.sTranCode}';
                                                                          var isActionBT =
                                                                          print('-----1310---$sTranCode');

                                                                          showDialog(
                                                                            context: context,
                                                                           // builder: (context) => showTakeActionDialog(context,sTranCode),
                                                                            builder: (context) =>Dialog(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(20),
                                                                              ),
                                                                              elevation: 0,
                                                                              backgroundColor: Colors.transparent,
                                                                              child: StatefulBuilder(
                                                                                builder: (BuildContext context, StateSetter setState) {
                                                                                  return Stack(
                                                                                    clipBehavior: Clip.none,
                                                                                    alignment: Alignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.white,
                                                                                          borderRadius: BorderRadius.circular(20),
                                                                                        ),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Update Status',
                                                                                              style: AppTextStyle.font16OpenSansRegularRedTextStyle,
                                                                                            ),
                                                                                            SizedBox(height: 10),
                                                                                            // Radio buttons for the decision options
                                                                                            RadioListTile<String>(
                                                                                              title: Text('Approved'),
                                                                                              value: 'Approved',
                                                                                              groupValue: _selectedDecision,
                                                                                              onChanged: (String? value) {
                                                                                                setState(() {
                                                                                                  _selectedDecision = value;
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                            RadioListTile<String>(
                                                                                              title: Text('Rejected'),
                                                                                              value: 'Rejected',
                                                                                              groupValue: _selectedDecision,
                                                                                              onChanged: (String? value) {
                                                                                                setState(() {
                                                                                                  _selectedDecision = value;
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                            RadioListTile<String>(
                                                                                              title: Text('Clarification Required'),
                                                                                              value: 'Clarification Required',
                                                                                              groupValue: _selectedDecision,
                                                                                              onChanged: (String? value) {
                                                                                                setState(() {
                                                                                                  _selectedDecision = value;
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(left: 0),
                                                                                              child: TextFormField(
                                                                                                controller: _takeAction,
                                                                                                textInputAction: TextInputAction.next,
                                                                                                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                                                                                decoration: const InputDecoration(
                                                                                                  border: OutlineInputBorder(),
                                                                                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                                                  filled: true,
                                                                                                  fillColor: Color(0xFFf2f3f5),
                                                                                                ),
                                                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(height: 15),
                                                                                            // Submit button
                                                                                            InkWell(
                                                                                              onTap: () async {
                                                                                                var iStatus;
                                                                                                var sRemarks = _takeAction.text.trim();
                                                                                                print('-----155--$sRemarks');
                                                                                                print('-----158--$sTranCode');
                                                                                                print('-----158----$_selectedDecision');

                                                                                                // Set iStatus based on selected decision
                                                                                                if (_selectedDecision == "Approved") {
                                                                                                  iStatus = "8"; // Approved
                                                                                                } else if (_selectedDecision == "Rejected") {
                                                                                                  iStatus = "9"; // Rejected
                                                                                                } else {
                                                                                                  iStatus = "5"; // Clarification Required
                                                                                                }
                                                                                                print('-----167-----$iStatus');

                                                                                                // Validate iStatus and remarks before API call
                                                                                                if (iStatus == null || iStatus == '') {
                                                                                                  displayToast('Select a value');
                                                                                                  return;
                                                                                                }

                                                                                                if (iStatus == "8") {
                                                                                                  // If Approved, proceed directly to API call
                                                                                                  print('------170----Call API for Approved-----');
                                                                                                  await _callApi(sTranCode, iStatus, sRemarks, context);
                                                                                                } else {
                                                                                                  // If not Approved, check if remarks are entered
                                                                                                  if (sRemarks.isEmpty) {
                                                                                                    displayToast('Remarks are required');
                                                                                                    return;
                                                                                                  }
                                                                                                  // Call the API for Rejected or Clarification
                                                                                                  print('------170----Call API for Rejected or Clarification-----');
                                                                                                  await _callApi(sTranCode, iStatus, sRemarks, context);
                                                                                                }
                                                                                              },
                                                                                              child: Container(
                                                                                                height: AppSize.s45,
                                                                                                padding: EdgeInsets.all(AppPadding.p5),
                                                                                                decoration: BoxDecoration(
                                                                                                  color: AppColors.loginbutton,
                                                                                                  borderRadius: BorderRadius.circular(AppMargin.m10),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    "Submit",
                                                                                                    style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Positioned(
                                                                                        top: -30,
                                                                                        child: CircleAvatar(
                                                                                          radius: 30,
                                                                                          backgroundColor: Colors.blueAccent,
                                                                                          child: ClipOval(
                                                                                            child: Image.asset(
                                                                                              'assets/images/addreimbursement.jpeg',
                                                                                              fit: BoxFit.cover,
                                                                                              width: 60,
                                                                                              height: 60,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              ),
                                                                            )

                                                                          );



                                                                        },
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Text('Action',
                                                                                style: AppTextStyle
                                                                                    .font14OpenSansRegularWhiteTextStyle),
                                                                            Icon(
                                                                                Icons
                                                                                    .arrow_forward_ios,
                                                                                color: Colors
                                                                                    .white,
                                                                                size: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2),
                                                              // if 1 to 11 then show log
                                                              // if(leaveData.iStatus=="1"
                                                              //     || leaveData.iStatus=="2"
                                                              //     || leaveData.iStatus=="3"
                                                              //     || leaveData.iStatus=="4"
                                                              //     || leaveData.iStatus=="5"
                                                              //     || leaveData.iStatus=="6"
                                                              //     || leaveData.iStatus=="7"
                                                              //     || leaveData.iStatus=="8"
                                                              //     || leaveData.iStatus=="9"
                                                              //     || leaveData.iStatus=="10"
                                                              //     || leaveData.iStatus=="11")
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        var project = leaveData.sProjectName;
                                                                        var sTranCode = leaveData.sTranCode;
                                                                        print("----1236----$sTranCode");
                                                                        // Navigator.push(
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => ReimbursementLogPage(project,sTranCode)),
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                        height: 40,
                                                                        decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xFF6a94e3),
                                                                          // Change this to your preferred color
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                              10),
                                                                        ),
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            // var projact =  item['sProjectName'] ??'';
                                                                            var sTranCode = leaveData.sTranCode;
                                                                            var project = leaveData.sProjectName;
                                                                            print("----1257----$sTranCode");
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => ReimbursementLogPage(project,sTranCode)),
                                                                            );

                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Text(
                                                                                  'Log', style: AppTextStyle
                                                                                      .font14OpenSansRegularWhiteTextStyle),
                                                                              SizedBox(
                                                                                  width: 10),
                                                                              Icon(
                                                                                Icons
                                                                                    .arrow_forward_ios,
                                                                                color: Colors
                                                                                    .white,
                                                                                size: 18,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                  );
                                }
                              }))

              )
            ]
              ));
  }
}

// OpenDialogo
void openFullScreenDialog(
    BuildContext context, List<String> imageUrls, String billDate) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Makes the dialog full screen
        insetPadding: EdgeInsets.all(0),
        child: Stack(
          children: [
            // Fullscreen PageView for multiple images
            Positioned.fill(
              child: PageView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover, // Adjust the image to fill the dialog
                  );
                },
              ),
            ),
            // White container with Bill Date at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      billDate,
                      style: AppTextStyle.font16OpenSansRegularBlackTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            // Close button in the bottom-right corner
            Positioned(
              right: 16,
              bottom: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                  padding: EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// sucessDialog
Widget _buildDialogSucces2(BuildContext context, String msg) {
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
              Text('Success',
                  style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
                      // Main Api call again


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // Set the background color to white
                      foregroundColor: Colors.black, // Set the text color to black
                    ),
                    child: Text('Ok', style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
                'assets/images/sussess.jpeg',
                // Replace with your asset image path
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
