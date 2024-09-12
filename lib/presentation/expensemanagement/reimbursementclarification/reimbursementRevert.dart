import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/expensemanagement/reimbursementclarification/reimbursementclarification.dart';
import '../../../data/baseurl.dart';
import '../../../data/district_repo.dart';
import '../../../data/expensecategory_repo.dart';
import '../../../data/hrmsPopUpWarning_repo.dart';
import '../../../data/hrmspostreimbursement.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../../data/shopTypeRepo.dart';
import '../../dashboard/dashboard.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';
import 'dart:math';

import '../expense_management.dart';

// class Reimbursementrevert extends StatelessWidget {
//   const Reimbursementrevert({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         appBarTheme: const AppBarTheme(
//           iconTheme: IconThemeData(
//             color: Colors.white, // Change the color of the drawer icon here
//           ),
//         ),
//       ),
//
//       home: ReimbursementrevertPage(),
//     );
//   }
// }

class ReimbursementrevertPage extends StatefulWidget {
  final sProjectName,sExpHeadName,dEntryAt,fAmount,sExpDetails,sExpBillPhoto;
  ReimbursementrevertPage(this.sProjectName, this.sExpHeadName,this.dEntryAt, this.fAmount,this.sExpDetails, this.sExpBillPhoto, {super.key});

  @override
  State<ReimbursementrevertPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ReimbursementrevertPage> {
  DateTime? _date;
  DateTime? _selectedDate;

  List stateList = [];
  List<dynamic> distList = [];
  List<dynamic> expenseList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  // Distic List
  updatedSector() async {
    distList = await ProjectRepo().projectList();
    print(" -----xxxxx-  projectList--76---> $distList");
    setState(() {});
  }

  expenseCategory() async {
    expenseList = await ExpenseRepo().expenseList();
    print(" -----xxxxx-  expenseList--84---> $expenseList");
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
    var postimageResponse = await PostImageRepo().postImage(context, _imageFile);
    print(" -----xxxxx-  --72---> $postimageResponse");
    setState(() {});
  }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();

  // focus
  // FocusNode locationfocus = FocusNode();
  FocusNode _shopfocus = FocusNode();
  FocusNode _owenerfocus = FocusNode();
  FocusNode _contactfocus = FocusNode();
  FocusNode _remarkfocus = FocusNode();
  FocusNode _landMarkfocus = FocusNode();
  FocusNode _addressfocus = FocusNode();

  // FocusNode descriptionfocus = FocusNode();
  String? todayDate;

  List? data;
  var _dropDownValueDistric;
  var _dropDownValueShopeType;
  var _dropDownSector;
  var _dropDownSector2gi;

  var _dropDownValue;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final sectorFocus = GlobalKey();
  File? _imageFile;
  var _selectedShopId;
  var _selectedBlockId;
  var _selectedSectorId;
  final _formKey = GlobalKey<FormState>();
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  double? lat, long;
  //var dExpDate;
  String? dExpDate;
  var billPhoto;


  // Uplode Id Proof with gallary

  // pick image from a Camera
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
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // pick image from a Gallery
  Future pickImageGallery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image');
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

  Future<void> uploadImage(String token, File imageFile) async {
    var baseURL = BaseRepo().baseurl;
    var endPoint = "UploadTrackingImage/UploadTrackingImage";
    var uplodeImageApi = "$baseURL$endPoint";
    try {
      print('-----xx-x----214----');
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$uplodeImageApi'),
      );

      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'sImagePath', imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      List<dynamic> responseData = json.decode(response.body);

      // Extracting the image path
      setState(() {
        uplodedImage = responseData[0]['Data'][0]['sImagePath'];
      });

      //print('Uploaded Image Path----245--: $uplodedImage');

      hideLoader();
    } catch (error) {
      hideLoader();
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
  // build dialog sucess
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
                        // Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReimbursementClarification()),
                        );

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

  // datepicker
  // InitState
  @override
  void initState() {
    // TODO: implement initState
    updatedSector();
    shopType();
    getLocation();
    expenseCategory();
    super.initState();
    print('xxxx---351--${widget.sProjectName}');
    _shopfocus = FocusNode();
    _owenerfocus = FocusNode();
    _contactfocus = FocusNode();
    _landMarkfocus = FocusNode();
    _addressfocus = FocusNode();
    _amountController = TextEditingController(text: widget.fAmount);
    _expenseController = TextEditingController(text: widget.sExpDetails);
    uplodedImage = "${widget.sExpBillPhoto}";
    print('---360--$billPhoto');
  }
  // location
  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });

    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
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
    _amountController.dispose();
    _expenseController.dispose();
    _remarkController.dispose();
  }

  // Todo bind sector code
  Widget _bindSector() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 42,
        color: Color(0xFFf2f3f5),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              isDense: true, // Helps to control the vertical size of the button
              isExpanded: true, // Allows the DropdownButton to take full width
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text:TextSpan(
                    text: "${widget.sProjectName}",
                    style: AppTextStyle.font16OpenSansRegularBlack45TextStyle
                  // style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.normal),
                ),
              ),
              value: _dropDownSector,
              key: sectorFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownSector = newValue ;
                  distList.forEach((element) {
                    if (element["sProjectName"] == _dropDownSector) {
                      _selectedSectorId = element['sProjectCode'];
                      setState(() {});
                    }
                  });
                });
              },
              items: distList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['sProjectName'].toString(),
                          overflow: TextOverflow.ellipsis, // Handles long text
                          style:AppTextStyle.font16OpenSansRegularBlackTextStyle,
                          // style: TextStyle(
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.normal,
                          // ),
                        ),
                      ),
                    ],
                  ),
                  value: item["sProjectName"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Todo same way you should bind point Type data.
  Widget _bindExpenseCategory() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 42,
        color: Color(0xFFf2f3f5),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: TextSpan(
                  text: "${widget.sExpHeadName}",
                  style:  AppTextStyle.font16OpenSansRegularBlack45TextStyle,
                  // style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.normal),
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Not necessary for Option 1
              value: _dropDownValueShopeType,
              // key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueShopeType = newValue;
                  print('---333-------$_dropDownValueShopeType');
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  expenseList.forEach((element) {
                    if (element["sExpHeadName"] == _dropDownValueShopeType) {
                      setState(() {
                        _selectedShopId = element['sExpHeadCode'];
                        print(
                            '----349--sExpHeadCode id ------$_selectedShopId');
                      });
                      //print('-----Point id----241---$_selectedShopId');
                      if (_selectedShopId != null) {
                        // updatedBlock();
                      } else {
                        print('-------');
                      }
                      // print("Distic Id value xxxxx.... $_selectedDisticId");
                      print("Distic Name xxxxxxx.... $_dropDownValueDistric");
                      print("Block list Ali xxxxxxxxx.... $blockList");
                    }
                  });
                });
              },
              items: expenseList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sExpHeadName'].toString(),style:AppTextStyle.font16OpenSansRegularBlackTextStyle),
                  value: item["sExpHeadName"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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

              var projectName =
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReimbursementClarification()),
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
              'Reimbursement',
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  height: 150, // Height of the container
                  width: 200, // Width of the container
                  child: Opacity(
                    opacity: 0.9,
                    //step3.jpg
                    child: Image.asset(
                      'assets/images/addreimbursement.jpeg',
                      // Replace 'image_name.png' with your asset image path
                      fit: BoxFit.cover, // Adjust the image fit to cover the container
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
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
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10),
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
                            _bindSector(),
                            SizedBox(height: 10),
                            // BIND Expense Category
                            _bindExpenseCategory(),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () async {
                                print('---pick a date---');
                                // Show date picker and store the picked date
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),  // Adjust this to your desired start date
                                  lastDate: DateTime.now(),   // Restrict selection to today or past dates
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
                                  // Display the selected date as a toast (optional)
                                  //displayToast(dExpDate.toString());
                                } else {
                                  print('---no date is selected----');
                                  // Handle case where no date was selected
                                  //displayToast("No date selected");
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
                                              ? '${widget.dEntryAt}'
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
                                  const Text('Amount',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            // this is my TextFormFoield
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 0),
                              child: Container(
                                height: 70, // Increased height to accommodate error message without resizing
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          focusNode: _shopfocus,
                                          controller: _amountController,
                                          textInputAction: TextInputAction.next,
                                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d{0,5}(\.\d{0,2})?$'), // Allow up to 5 digits before decimal and 2 digits after decimal
                                            ),
                                            //FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // Allow up to 2 decimal places
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                            filled: true, // Enable background color
                                            fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                          ),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a value';
                                            }
                                            final doubleValue = double.tryParse(value);
                                            if (doubleValue == null || doubleValue <= 0) {
                                              return 'Enter an amount greater than 0';
                                            }
                                            return null;
                                          },
                                        ),

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '', // Placeholder for error message space
                                            style: TextStyle(fontSize: 0), // Keeps the size unchanged when no error
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                                  const Text('Expense Details',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
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
                            // remark
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
                                  const Text('Remarks',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 0),
                              child: Container(
                                height: 42,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: TextFormField(
                                    focusNode: _remarkfocus,
                                    controller: _remarkController,
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
                                  const Text('Supporting Documents',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: DottedBorder(
                                color: Colors.grey,
                                // Color of the dotted line
                                strokeWidth: 1.0,
                                // Width of the dotted line
                                dashPattern: [4, 2],
                                // Dash pattern for the dotted line
                                borderType: BorderType.RRect,
                                radius:  Radius.circular(5.0),
                                // Optional: rounded corners
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  // Equal padding on all sides
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      // Center the row contents
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                // Your onTap logic here
                                                print('--pick a Camra pick---');
                                                pickImage();
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.camera_alt_outlined,
                                                      size: 25),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    'Click Photo',
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 16),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: (){
                                                print('--pick a Gallery---');
                                                pickImageGallery();
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                      Icons
                                                          .photo_camera_back_outlined,
                                                      size: 25),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    'Select Photo',
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 16),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // todo implement image seto on a imageView
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  uplodedImage != null
                                      ? Stack(
                                    children: [
                                      GestureDetector(
                                        behavior:
                                        HitTestBehavior.translucent,
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             FullScreenPage(
                                          //               child: image!,
                                          //               dark: true,
                                          //             )));
                                        },
                                        child: Container(
                                            color: Colors.lightGreenAccent,
                                            height: 100,
                                            width: 70,
                                            child: Image.network('$uplodedImage',
                                                  fit: BoxFit.fill,
                                            ),
                                            // child: Image.file(
                                            //   image!,
                                            //   fit: BoxFit.fill,
                                            // )

                                        ),
                                      ),
                                      Positioned(
                                          bottom: 65,
                                          left: 35,
                                          child: IconButton(
                                            onPressed: () {
                                              uplodedImage = null;
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                          ))
                                    ],
                                  )
                                      : Text(
                                    "",
                                    style:
                                    TextStyle(color: Colors.red[700]),
                                  )
                                ]),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String? sEmpCode = prefs.getString('sEmpCode');
                                String? sContactNo = prefs.getString('sContactNo');
                                print('----sEmpCode--15---$sEmpCode');
                                /// TODO GET A RANDOM NUMBER
                                Random random = Random();
                                int sTranCode = 10000000 + random.nextInt(90000000);

                                print('--1001--sTranCode---$sTranCode');
                                print('--1002--sEmpCode---$sEmpCode');
                                print('--1003--sProjectCode---$_selectedSectorId');
                                print('--1004--sExpHeadCode---$_selectedShopId');
                                print('--1005--dExpDate---$dExpDate');
                                print('--1006--fAmount---${_amountController.text}');
                                print('--1007--sExpDetails---${_expenseController.text}');
                                print('--1008--sExpBillPhoto---$uplodedImage');// sEntryBy
                                print('--1009--sEntryBy---$sContactNo');
                                print('--1010--sRemarks---${'NA'}');
                                print('--1011--sResult---$result');

                                var amount = '${_amountController.text}';
                                var expenseDetails = '${_expenseController.text}';
                                var remarks = '${_remarkController.text}';



                               //   _selectedSectorId!=null && _selectedShopId!=null &&



                                if(_formKey.currentState!.validate() && sTranCode!=null && sEmpCode != null &&
                                    dExpDate!=null && amount !=null && expenseDetails!=null &&
                                    uplodedImage!=null && sContactNo!=null && remarks!=null){

                                  // Call Api

                                  var  hrmsPopWarning = await HrmsPopUpWarningRepo().hrmsPopUpWarnging(context, sEmpCode,dExpDate,amount);
                                  print('---975--$hrmsPopWarning');
                                  result = "${hrmsPopWarning[0]['Result']}";
                                  msg = "${hrmsPopWarning[0]['Msg']}";



                                }else{
                                  if(sTranCode==null){
                                    displayToast('Genrate Random Number');
                                  }else if(sEmpCode==null){
                                    displayToast('Enter sEmpCode');
                                  // }else if(_selectedSectorId==null){
                                  //   displayToast('Please Select Project');
                                  // }else if(_selectedShopId==null){
                                  //   displayToast('Please Select Expense Category');
                                  // }else if(dExpDate==null){
                                  //   displayToast('Select Expense Date');
                                  }else if(amount==null || amount==''){
                                    displayToast('Please Enter Amount');
                                  }
                                  else if(expenseDetails==null || expenseDetails==''){
                                    displayToast('Please Enter Expense Details');
                                  }else if(uplodedImage==null){
                                    displayToast('Please pick a photo');
                                  }else if(sContactNo==null){
                                    displayToast('Please get a contact number');
                                  }else if(remarks==null || remarks==''){
                                    displayToast('Please Remarks');
                                  }
                                } // condition to fetch a response form a api
                                if(result=="0"){
                                  // CALL API HRMS Reimbursement
                                  var  hrmsPostReimbursement = await HrmsPostReimbursementRepo().hrmsPostReimbursement(context,sTranCode,sEmpCode,
                                      _selectedSectorId,_selectedShopId,dExpDate,amount,expenseDetails,uplodedImage,sContactNo,result
                                  );
                                  print('---1050--$hrmsPostReimbursement');
                                  result = "${hrmsPostReimbursement[0]['Result']}";
                                  msg = "${hrmsPostReimbursement[0]['Msg']}";

                                  // displayToast(msg);
                                  /// todo here to show the dialog sucess
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _buildDialogSucces2(context,msg);
                                    },
                                  );

                                }else{
                                  showCustomDialog(context,msg);
                                  //displayToast(msg);
                                  print('---diaplay dialog --');
                                }
                              },

                              child: Container(
                                width: double.infinity,
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
                                    "Send Reimbursement",
                                    style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // alert dialog box
  void showCustomDialog(BuildContext context, String dynamicValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Duplicate Entry', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 16),
              Text(dynamicValue),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? sEmpCode = prefs.getString('sEmpCode');
                    String? sContactNo = prefs.getString('sContactNo');
                    /// TODO GET A RANDOM NUMBER
                    Random random = Random();
                    int sTranCode = 10000000 + random.nextInt(90000000);
                    var amount = '${_amountController.text}';
                    var expenseDetails = '${_expenseController.text}';

                    var  hrmsPostReimbursement = await HrmsPostReimbursementRepo().hrmsPostReimbursement(context,sTranCode,sEmpCode,
                        _selectedSectorId,_selectedShopId,dExpDate,amount,expenseDetails,uplodedImage,sContactNo,result
                    );
                    print('---1050--$hrmsPostReimbursement');
                    result = "${hrmsPostReimbursement[0]['Result']}";
                    msg = "${hrmsPostReimbursement[0]['Msg']}";
                    // displayToast(msg);
                    // Dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildDialogSucces2(context,msg);
                      },
                    );
                    //Navigator.of(context).pop();
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}