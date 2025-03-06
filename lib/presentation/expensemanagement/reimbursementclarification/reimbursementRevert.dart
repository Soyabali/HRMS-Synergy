import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/expensemanagement/reimbursementclarification/reimbursementclarification.dart';
import '../../../data/baseurl.dart';
import '../../../data/bindReimUoMRepo.dart';
import '../../../data/consuamableItemRepo2.dart';
import '../../../data/district_repo.dart';
import '../../../data/expensecategory_repo.dart';
import '../../../data/hrmsPopUpWarning_repo.dart';
import '../../../data/hrmspostreimbursement.dart';
import '../../../data/loader_helper.dart';
import '../../../data/postimagerepo.dart';
import '../../../data/shopTypeRepo.dart';
import '../../../domain/GetConsumablesReimbItem_Model.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';
import 'dart:math';
import 'dart:convert';

class ReimbursementrevertPage extends StatefulWidget {

  final sProjectName,
      sExpHeadName,
      dEntryAt,
      fAmount,
      sExpDetails,
      sExpBillPhoto,
      sProjectCode,
      sExpHeadCode,
      sExpBillPhoto2,
      sExpBillPhoto3,
      sExpBillPhoto4,
      sTranCode,
      dExpDate,
      sRemarks;

  ReimbursementrevertPage(
      this.sProjectName,
      this.sExpHeadName,
      this.dEntryAt,
      this.fAmount,
      this.sExpDetails,
      this.sExpBillPhoto,
      this.sProjectCode,
      this.sExpHeadCode,
      this.sExpBillPhoto2,
      this.sExpBillPhoto3,
      this.sExpBillPhoto4,
      this.sTranCode,
      this.dExpDate,
      this.sRemarks,
      {super.key});

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
  int count = 0;

  // Distic List
  updatedSector() async {
    distList = await ProjectRepo().projectList();
    setState(() {});
  }

  expenseCategory() async {
    expenseList = await ExpenseRepo().expenseList();
    setState(() {});
  }

  shopType() async {
    shopTypeList = await ShopTypeRepo().getShopType();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  // postImage
  postimage() async {
    var postimageResponse = await PostImageRepo().postImage(context, _imageFile);
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

  TextEditingController _itemDescriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _amountController2 = TextEditingController();

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
  File? image, image2, image3, image4;
  var uplodedImage;
  var uplodedImage2;
  var uplodedImage3;
  var uplodedImage4;
  double? lat, long;
  String? consumableList;
  String? consumableItemString;

  List<dynamic>? consuambleItemList;
  var sTranCode;
  var sTranCode2;

  //var dExpDate;
  String? dExpDate;
  var billPhoto;
  var remarks;
  List<dynamic> bindreimouList = [];
  var _dropDownValueBindReimType;

  // var dExpDate2;

  late Future<List<GetConsumableSreimbitemModel>> consumableItem;

  Future<void> monthAttendance(String stranCode) async {
    // Clear the list and update UI immediately
    setState(() {
     // consuambleItemList = [];
    });

    try {
      // Fetch the new data and assign it to the list
      final newItems = await ConsuamableItemRepo_2().consuambleItem(context, stranCode);

      setState(() {
        consuambleItemList = newItems;
      });
      consumableItemString = jsonEncode(consuambleItemList);
      // convert list dynamic to String
      // consItemList_2 = consuambleItemList?.map((item) => item.toString()).toList();
      print("=========-------191----list: $consuambleItemList");
    } catch (e) {
      print("Error fetching consumable items: $e");
    }
  }

  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

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

  // uplode image 2
  Future pickImage2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image2 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        uploadImage2(sToken!, image2!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // pickimage 3
  Future pickImage3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image3 = File(pickFileid.path);
        setState(() {});
        // multipartProdecudre();
        uploadImage3(sToken!, image3!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // pickimage 4
  Future pickImage4() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image4 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        uploadImage4(sToken!, image4!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // pick image from a Gallery 1
  Future pickImageGallery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

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

  // pick Imge gallery 2
  Future pickImageGallery2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 65);
      if (pickFileid != null) {
        image2 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image2');
        // multipartProdecudre();
        uploadImage2(sToken!, image2!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // pick image gallery 3
  Future pickImageGallery3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 65);
      if (pickFileid != null) {
        image3 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image3');
        // multipartProdecudre();
        uploadImage3(sToken!, image3!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // pick image Gallery 4
  Future pickImageGallery4() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 65);
      if (pickFileid != null) {
        image4 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image4');
        // multipartProdecudre();
        uploadImage4(sToken!, image4!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // submit Form  Reusable ITem
  List<Map<String, dynamic>> _itemsList = [];

  void _onFormSubmit() {
    count++;
    // Retrieve values from controllers and dropdown
    var itemDescription = _itemDescriptionController.text.trim();
    var quantity = _quantityController.text.trim();
    var amount = _amountController2.text.trim();
    var selectedReimType = _dropDownValueBindReimType;
    // Check each field and display an error if any are empty
    if (itemDescription.isEmpty) {
      displayToast("Please enter Item Description");
      return;
    }
    if (selectedReimType == null || selectedReimType.isEmpty) {
      displayToast("Please choose a reimbursement type");
      return;
    }
    if (quantity.isEmpty) {
      displayToast("Please enter Quantity");
      return;
    }
    if (amount.isEmpty) {
      displayToast("Please enter Amount");
      return;
    }

    // Add the item as a map in the consumable item list
    setState(() {
      consuambleItemList ??= []; // Initialize the list if it's null
      consuambleItemList!.add({
        'SrNo': count,
        'sItemName': itemDescription,
        'fQty': quantity,
        'fAmount': amount,
        'sUoM': selectedReimType,
      });
    });

    // Optionally encode to JSON if needed
    consumableList = jsonEncode(consuambleItemList);

    // Clear form fields after adding
    _itemDescriptionController.clear();
    _quantityController.clear();
    _amountController2.clear();
    _dropDownValueBindReimType = null;

    // Display success message and print data for verification
    displayToast("Item added successfully.");

  }
  // delete the data on a list

  Widget _deleteItemDialog(BuildContext context, int index) {
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
            height: 160,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text('Delete',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                SizedBox(height: 10),
                Text(
                  "Do you want to Delete ?",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Container(
                  height: 35,
                  // Reduced height to 35
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    border: Border.all(color: Colors.grey), // Border color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            setState(() {
                              /// TODO HERE TO GET A LIST INDEX AND AFTER THAT REMOVE VALUE FROM A INDEX
                              setState(() {
                                consuambleItemList!.removeAt(index); // Remove item at index
                               //
                                consumableList = jsonEncode(consuambleItemList);
                                // Clear form fields after adding
                                _itemDescriptionController.clear();
                                _quantityController.clear();
                                _amountController2.clear();
                                _dropDownValueBindReimType = null;

                              });
                              Navigator.of(context).pop();
                              //consuambleItemList[index];

                              // _notificationList = NotificationRepo().notificationList(context);
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // Remove default padding
                            minimumSize: Size(0, 0),
                            // Remove minimum size constraints
                            backgroundColor: Colors.white,
                            // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              color: Colors.green,
                              // Text color for "Yes"
                              fontSize: 12,
                              // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey, // Divider color
                        width: 20, // Space between buttons
                        thickness: 1, // Thickness of the divider
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // Remove default padding
                            minimumSize: Size(0, 0),
                            // Remove minimum size constraints
                            backgroundColor: Colors.white,
                            // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              color: Colors.red,
                              // Text color for "No"
                              fontSize: 12,
                              // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
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
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/delete.jpeg',
                  // Replace with your asset image path
                  fit: BoxFit.fill,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        'sImagePath',
        imageFile.path,
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

  // uplodeImage-2
  Future<void> uploadImage2(String token, File imageFile) async {
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
        'sImagePath',
        imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      List<dynamic> responseData = json.decode(response.body);

      // Extracting the image path
      setState(() {
        uplodedImage2 = responseData[0]['Data'][0]['sImagePath'];
      });

      //print('Uploaded Image Path----245--: $uplodedImage');

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  // uplodeiMAGE 3
  Future<void> uploadImage3(String token, File imageFile) async {
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
        'sImagePath',
        imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      List<dynamic> responseData = json.decode(response.body);

      // Extracting the image path
      setState(() {
        uplodedImage3 = responseData[0]['Data'][0]['sImagePath'];
      });

      //print('Uploaded Image Path----245--: $uplodedImage');

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  // iuplode image 4
  Future<void> uploadImage4(String token, File imageFile) async {
    var baseURL = BaseRepo().baseurl;
    var endPoint = "UploadTrackingImage/UploadTrackingImage";
    var uplodeImageApi = "$baseURL$endPoint";
    try {
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
        'sImagePath',
        imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      List<dynamic> responseData = json.decode(response.body);

      // Extracting the image path
      setState(() {
        uplodedImage4 = responseData[0]['Data'][0]['sImagePath'];
      });

      //print('Uploaded Image Path----245--: $uplodedImage');

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  bindreimUom() async {
    bindreimouList = await BindreimuomRepo().bindReimouList();
    setState(() {});
  }

  multipartProdecudre() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));
    request.body = json.encode({"sImagePath": "$image"});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

  }

  // dropdown
  Widget _bindReimout() {
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
                  text: "UOM",
                  style: AppTextStyle.font16OpenSansRegularBlack45TextStyle,
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
              value: _dropDownValueBindReimType,
              // key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueBindReimType = newValue;
                  bindreimouList.forEach((element) {
                    if (element["sUoM"] == _dropDownValueShopeType) {
                      setState(() {
                       });
                      if (_selectedShopId != null) {
                        // updatedBlock();
                      } else {
                        print('-------');
                      }
                       }
                  });
                });
              },
              items: bindreimouList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sUoM'].toString(),
                      style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                  value: item["sUoM"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
  // build dialog sucess
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
                        // Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReimbursementClarification()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // Set the background color to white
                        foregroundColor:
                            Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',
                          style:
                              AppTextStyle.font16OpenSansRegularBlackTextStyle),
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

  // datepicker
  // InitState
  @override
  void initState() {
    // TODO: implement initState
    sTranCode2 = '${widget.sTranCode}';
    monthAttendance(sTranCode2);
    updatedSector();
    shopType();
    expenseCategory();
    super.initState();
    bindreimUom();
    _dropDownValueShopeType="${widget.sExpHeadName}";
    dExpDate = '${widget.dExpDate}';
    _selectedSectorId = '${widget.sProjectCode}';
    _selectedShopId = '${widget.sExpHeadCode}';
     sTranCode = '${widget.sTranCode}';

     print("------922----$sTranCode");


    // widget.dEntryAt}
    _shopfocus = FocusNode();
    _owenerfocus = FocusNode();
    _contactfocus = FocusNode();
    _landMarkfocus = FocusNode();
    _addressfocus = FocusNode();
    _amountController = TextEditingController(text: widget.fAmount);
    _expenseController = TextEditingController(text: widget.sExpDetails);
    _remarkController = TextEditingController();
    _itemDescriptionController = TextEditingController();
    _quantityController = TextEditingController();
    _amountController2 = TextEditingController();
    uplodedImage = "${widget.sExpBillPhoto}";
    uplodedImage2 = "${widget.sExpBillPhoto2}";
    uplodedImage3 = "${widget.sExpBillPhoto3}";
    uplodedImage4 = "${widget.sExpBillPhoto4}";
    print('---360--$billPhoto');
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
    _itemDescriptionController.dispose();
    _quantityController.dispose();
    _amountController2.dispose();
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
              isDense: true,
              // Helps to control the vertical size of the button
              isExpanded: true,
              // Allows the DropdownButton to take full width
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: TextSpan(
                    text: "${widget.sProjectName}",
                    style: AppTextStyle.font16OpenSansRegularBlack45TextStyle
                    ),
              ),
              // value: _dropDownSector,
              value: _dropDownSector ?? widget.sProjectName,
              key: sectorFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownSector = newValue ?? widget.sProjectName;
                  _selectedSectorId = distList.firstWhere(
                    (element) => element["sProjectName"] == _dropDownSector,
                    orElse: () => {"sProjectCode": widget.sProjectCode},
                  )["sProjectCode"];
                  print("-------xxx----$_selectedSectorId");
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
                          style:
                              AppTextStyle.font16OpenSansRegularBlackTextStyle,
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
                  style: AppTextStyle.font16OpenSansRegularBlack45TextStyle,
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
                  expenseList.forEach((element) {
                    if (element["sExpHeadName"] == _dropDownValueShopeType) {
                      setState(() {
                        _selectedShopId = element['sExpHeadCode'];
                       });
                      //print('-----Point id----241---$_selectedShopId');
                      if (_selectedShopId != null) {
                        // updatedBlock();
                      } else {
                        print('-------');
                      }
                    }
                  });
                });
              },
              items: expenseList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sExpHeadName'].toString(),
                      style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
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
            statusBarIconBrightness: Brightness.dark,
            // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          // backgroundColor: Colors.blu
          backgroundColor: Color(0xFF0098a6),
          leading: InkWell(
            onTap: () {
              // Navigator.pop(context);

              var projectName = Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReimbursementClarification()),
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
                      fit: BoxFit
                          .cover, // Adjust the image fit to cover the container
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
                          color: Colors.grey.withOpacity(0.5),
                          // Color of the shadow
                          spreadRadius: 5,
                          // Spread radius
                          blurRadius: 7,
                          // Blur radius
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
                                  firstDate: DateTime(2000),
                                  // Adjust this to your desired start date
                                  lastDate: DateTime
                                      .now(), // Restrict selection to today or past dates
                                );
                                // Check if a date was picked
                                if (pickedDate != null) {
                                  // Format the picked date
                                  String formattedDate =
                                      DateFormat('dd/MMM/yyyy')
                                          .format(pickedDate);
                                  // Update the state with the picked date
                                  setState(() {
                                    dExpDate = formattedDate;
                                  });
                                  print('----1344---x--$dExpDate');
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
                                  color: Colors.grey,
                                  // Color of the dotted line
                                  strokeWidth: 1.0,
                                  // Width of the dotted line
                                  dashPattern: [4, 2],
                                  // Dash pattern for the dotted line
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(5.0),
                                  // Optional: rounded corners
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    // Equal padding on all sides
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
                                              ? '${widget.dExpDate}'
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
                                      margin:
                                          EdgeInsets.only(left: 0, right: 2),
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 0),
                              child: Container(
                                height: 70,
                                // Increased height to accommodate error message without resizing
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
                                          onEditingComplete: () =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(
                                                  r'^\d{0,5}(\.\d{0,2})?$'), // Allow up to 5 digits before decimal and 2 digits after decimal
                                            ),
                                            //FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // Allow up to 2 decimal places
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                            filled: true,
                                            // Enable background color
                                            fillColor: Color(
                                                0xFFf2f3f5), // Set your desired background color here
                                          ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a value';
                                            }
                                            final doubleValue =
                                                double.tryParse(value);
                                            if (doubleValue == null ||
                                                doubleValue <= 0) {
                                              return 'Enter an amount greater than 0';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '',
                                            // Placeholder for error message space
                                            style: TextStyle(
                                                fontSize:
                                                    0), // Keeps the size unchanged when no error
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
                                      margin:
                                          EdgeInsets.only(left: 0, right: 2),
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 0),
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
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      filled: true, // Enable background color
                                      fillColor: Color(
                                          0xFFf2f3f5), // Set your desired background color here
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
                                      margin:
                                          EdgeInsets.only(left: 0, right: 2),
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 0),
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
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      filled: true, // Enable background color
                                      fillColor: Color(
                                          0xFFf2f3f5), // Set your desired background color here
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
                            /// todo here we add a custom list according to cosumabnleItem
                            if (consuambleItemList!.isNotEmpty)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/workdetail.jpeg',
                                        height: 25,
                                        width: 25,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Consumable Item List',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),],
                                  ),

                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: consuambleItemList?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final item = consuambleItemList![index];
                                      return GestureDetector(
                                        onLongPress: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return _deleteItemDialog(context,index);
                                                    },
                                                  );
                                          // setState(() {
                                          //   consuambleItemList!.removeAt(index); // Remove item at index
                                          // });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    width: 25,
                                                    child: Image.asset(
                                                      'assets/images/aadhar.jpeg',
                                                      fit: BoxFit.fill,
                                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                        return Icon(Icons.error, size: 25);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(item['sItemName'], style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                      Text('Item Description', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text('Quantity: ${item['fQty']}', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                ],
                                              ),
                                              Divider(),
                                              Container(
                                                height: 45,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 25),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                height: 14,
                                                                width: 14,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black,
                                                                  borderRadius: BorderRadius.circular(7),
                                                                ),
                                                              ),
                                                              SizedBox(width: 5),
                                                              Text(item['sUoM'], style: AppTextStyle.font14OpenSansRegularBlackTextStyle),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 15),
                                                            child: Text('UOM', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      color: Color(0xFF0098a6),
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      child: Text(
                                                        '₹ ${item['fAmount']}',
                                                        style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )

                                  // ListView.builder(
                                  //   shrinkWrap: true,
                                  //   // Makes ListView take up only the needed height
                                  //   physics: NeverScrollableScrollPhysics(),
                                  //   // Disable ListView scrolling if the outer widget scrolls
                                  //   itemCount: consuambleItemList?.length ?? 0,
                                  //   itemBuilder: (context, index) {
                                  //     final item = consuambleItemList![index];
                                  //     return GestureDetector(
                                  //       onLongPress: () {
                                  //         setState(() {
                                  //           // iTranId = notificationData.iTranId;
                                  //         });
                                  //         /// todo this is dialog code after debug open the code
                                  //         // showDialog(
                                  //         //   context: context,
                                  //         //   builder: (BuildContext context) {
                                  //         //     return _deleteItemDialog(context);
                                  //         //   },
                                  //         // );
                                  //       },
                                  //       child: Container(
                                  //         margin: const EdgeInsets.symmetric(
                                  //             vertical: 8.0, horizontal: 10.0),
                                  //         padding: const EdgeInsets.all(16.0),
                                  //         decoration: BoxDecoration(
                                  //           color: Colors.white,
                                  //           borderRadius:
                                  //               BorderRadius.circular(5),
                                  //           boxShadow: [
                                  //             BoxShadow(
                                  //               color: Colors.grey,
                                  //               spreadRadius: 1,
                                  //               blurRadius: 3,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         child: Column(
                                  //           crossAxisAlignment: CrossAxisAlignment.start,
                                  //           children: [
                                  //             Row(
                                  //               children: [
                                  //                 Container(
                                  //                   height: 25,
                                  //                   width: 25,
                                  //                   child: Image.asset(
                                  //                     'assets/images/aadhar.jpeg',
                                  //                     fit: BoxFit.fill,
                                  //                     errorBuilder:
                                  //                         (BuildContext context,
                                  //                             Object exception,
                                  //                             StackTrace?
                                  //                                 stackTrace) {
                                  //                       return Icon(Icons.error,
                                  //                           size: 25);
                                  //                     },
                                  //                   ),
                                  //                 ),
                                  //                 SizedBox(width: 10),
                                  //                 Column(
                                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                                  //                   children: [
                                  //                     Text(item['sItemName'], style: AppTextStyle
                                  //                             .font14OpenSansRegularBlack45TextStyle),
                                  //                     Text('Item Description',
                                  //                         style: AppTextStyle
                                  //                             .font14OpenSansRegularBlack45TextStyle),
                                  //                   ],
                                  //                 ),
                                  //                 Spacer(),
                                  //                 Text(
                                  //                     'Quantity: ${item['fQty']}',
                                  //                     style: AppTextStyle
                                  //                         .font14OpenSansRegularBlack45TextStyle),
                                  //               ],
                                  //             ),
                                  //             Divider(),
                                  //             Container(
                                  //               height: 45,
                                  //               child: Row(
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.only(left: 25),
                                  //                     child: Column(
                                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                                  //                       children: [
                                  //                         Row(
                                  //                           children: [
                                  //                             Container(
                                  //                               height: 14,
                                  //                               width: 14,
                                  //                               decoration:
                                  //                                   BoxDecoration(
                                  //                                 color: Colors.black,
                                  //                                 borderRadius: BorderRadius.circular(7),
                                  //                               ),
                                  //                             ),
                                  //                             SizedBox(
                                  //                                 width: 5),
                                  //                             Text(item['sUoM'],
                                  //                                 style: AppTextStyle
                                  //                                     .font14OpenSansRegularBlackTextStyle),
                                  //                           ],
                                  //                         ),
                                  //                         Padding(
                                  //                           padding:
                                  //                               const EdgeInsets.only(left: 15),
                                  //                           child: Text('UOM',
                                  //                               style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                   ),
                                  //                   Spacer(),
                                  //                   Container(
                                  //                     color: Color(0xFF0098a6),
                                  //                     padding: const EdgeInsets
                                  //                         .symmetric(
                                  //                         horizontal: 10,
                                  //                         vertical: 10),
                                  //                     child: Text(
                                  //                       '₹ ${item['fAmount']}',
                                  //                       style: AppTextStyle
                                  //                           .font14OpenSansRegularWhiteTextStyle,
                                  //                       textAlign:
                                  //                           TextAlign.center,
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),


                                ],
                              ),

                            SizedBox(height: 10),
                            if (_dropDownValueShopeType ==
                                "Consumable/Material Purchase")
                              Container(
                                margin: const EdgeInsets.only(top: 16.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.9),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Image.asset("assets/images/uplodeConsum.jpeg",
                                        // width: 20,
                                        // height: 20,
                                        // fit: BoxFit.fill,
                                        // ),
                                        Icon(Icons.shopping_cart,
                                            color: Colors.blue),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                            child: Text(
                                                "Uploaded Consumable Item ",
                                                style: AppTextStyle
                                                    .font16OpenSansRegularBlack45TextStyle)),
                                        Icon(Icons.arrow_forward_ios,
                                            color: Colors.grey),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      height: 45,
                                      child: TextFormField(
                                        controller: _itemDescriptionController,
                                        decoration: InputDecoration(
                                          labelText: "Item Description",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    _bindReimout(),
                                    SizedBox(height: 10.0),
                                    Container(
                                      height: 45,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _quantityController,
                                              decoration: InputDecoration(
                                                labelText: "Quantity",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                          SizedBox(width: 16.0),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _amountController2,

                                              decoration: InputDecoration(
                                                labelText: "Amount",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    InkWell(
                                      onTap: _onFormSubmit,
                                      child: Container(
                                        width: double.infinity,
                                        // Make container fill the width of its parent
                                        height: AppSize.s45,
                                        padding: EdgeInsets.all(AppPadding.p5),
                                        decoration: BoxDecoration(
                                          color: AppColors.loginbutton,
                                          // Background color using HEX value
                                          borderRadius: BorderRadius.circular(
                                              AppMargin.m10), // Rounded corners
                                        ),
                                        //  #00b3c7
                                        child: Center(
                                          child: Text(
                                            "Add Item",
                                            style: AppTextStyle
                                                .font16OpenSansRegularWhiteTextStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // heding
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 0, right: 2),
                                      child: const Icon(
                                        Icons.forward_sharp,
                                        size: 12,
                                        color: Colors.black54,
                                      )),
                                  const Text('Supporting Documents - 1',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            // todo implement image seto on a imageView
                            Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    uplodedImage != null && uplodedImage!=""
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
                                                  color:
                                                      Colors.lightGreenAccent,
                                                  height: 120,
                                                  width: 100,
                                                  child: Image.network(
                                                    '$uplodedImage',
                                                    fit: BoxFit.fill,
                                                  ),
                                                  // child: Image.file(
                                                  //   image!,
                                                  //   fit: BoxFit.fill,
                                                  // )
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 80,
                                                  left: 60,
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
                                            style: TextStyle(
                                                color: Colors.red[700]),
                                          )
                                  ]),
                            ),
                            SizedBox(height: 10),
                            // DottedBorder
                            Center(
                              child: DottedBorder(
                                color: Colors.grey,
                                // Color of the dotted line
                                strokeWidth: 1.0,
                                // Width of the dotted line
                                dashPattern: [4, 2],
                                // Dash pattern for the dotted line
                                borderType: BorderType.RRect,
                                radius: Radius.circular(5.0),
                                // Optional: rounded corners
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  // Equal padding on all sides
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  Icon(
                                                      Icons.camera_alt_outlined,
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
                                              onTap: () {
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
                            // image - 2
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 0, right: 2),
                                      child: const Icon(
                                        Icons.forward_sharp,
                                        size: 12,
                                        color: Colors.black54,
                                      )),
                                  const Text('Supporting Documents - 2',
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
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    uplodedImage2 != null && uplodedImage2!=""
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
                                                  color:
                                                      Colors.lightGreenAccent,
                                                  height: 120,
                                                  width: 100,
                                                  child: Image.network(
                                                    '$uplodedImage2',
                                                    fit: BoxFit.fill,
                                                  ),
                                                  // child: Image.file(
                                                  //   image!,
                                                  //   fit: BoxFit.fill,
                                                  // )
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 80,
                                                  left: 60,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      uplodedImage2 = null;
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
                                            style: TextStyle(
                                                color: Colors.red[700]),
                                          )
                                  ]),
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
                                radius: Radius.circular(5.0),
                                // Optional: rounded corners
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  // Equal padding on all sides
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                pickImage2();
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                      Icons.camera_alt_outlined,
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
                                              onTap: () {
                                                print('--pick a Gallery---');
                                                pickImageGallery2();
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
                            // image - 3
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 0, right: 2),
                                      child: const Icon(
                                        Icons.forward_sharp,
                                        size: 12,
                                        color: Colors.black54,
                                      )),
                                  const Text('Supporting Documents - 3',
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
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    uplodedImage3 != null && uplodedImage3!=""
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
                                                  height: 120,
                                                  width: 100,
                                                  child: Image.network(
                                                    '$uplodedImage3',
                                                    fit: BoxFit.fill,
                                                  ),
                                                  // child: Image.file(
                                                  //   image!,
                                                  //   fit: BoxFit.fill,
                                                  // )
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 80,
                                                  left: 60,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      uplodedImage3 = null;
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
                                            style: TextStyle(
                                                color: Colors.red[700]),
                                          )
                                  ]),
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
                                radius: Radius.circular(5.0),
                                // Optional: rounded corners
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  // Equal padding on all sides
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                pickImage3();
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                      Icons.camera_alt_outlined,
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
                                              onTap: () {
                                                print('--pick a Gallery---');
                                                pickImageGallery3();
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
                            // image -4
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 0, right: 2),
                                      child: const Icon(
                                        Icons.forward_sharp,
                                        size: 12,
                                        color: Colors.black54,
                                      )),
                                  const Text('Supporting Documents - 4',
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
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    uplodedImage4 != null && uplodedImage4!=""
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
                                                  height: 120,
                                                  width: 100,
                                                  child: Image.network(
                                                    '$uplodedImage4',
                                                    fit: BoxFit.fill,
                                                  ),
                                                  // child: Image.file(
                                                  //   image!,
                                                  //   fit: BoxFit.fill,
                                                  // )
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 80,
                                                  left: 60,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      uplodedImage4 = null;
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
                                            style: TextStyle(
                                                color: Colors.red[700]),
                                          )
                                  ]),
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
                                radius: Radius.circular(5.0),
                                // Optional: rounded corners
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  // Equal padding on all sides
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // Center the row contents
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                // Your onTap logic here
                                                print('--pick a Camra pick---');
                                                pickImage4();
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                      Icons.camera_alt_outlined,
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
                                              onTap: () {
                                                print('--pick a Gallery---');
                                                pickImageGallery4();
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

                            InkWell(
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String? sEmpCode = prefs.getString('sEmpCode');
                                String? sContactNo = prefs.getString('sContactNo');

                                var amount = _amountController.text.trim();
                                var expenseDetails = _expenseController.text.trim();
                                var remarks = _remarkController.text.trim(); // Trimmed to remove extra spaces

                                // Validation for remarks field
                                if (remarks.isEmpty) {
                                  displayToast('Please enter remarks');
                                  return; // Stop execution if remarks are empty
                                }

                                if (_formKey.currentState!.validate() &&
                                    sEmpCode != null &&
                                    _selectedSectorId != null &&
                                    _selectedShopId != null &&
                                    amount.isNotEmpty &&
                                    expenseDetails.isNotEmpty &&
                                    (uplodedImage != null || uplodedImage2 != null || uplodedImage3 != null || uplodedImage4 != null) &&
                                    sContactNo != null) {

                                  // Call API
                                  print('---Calling API---');

                                  var hrmsPostReimbursement = await HrmsPostReimbursementRepo()
                                      .hrmsPostReimbursement(
                                      context,
                                      sTranCode2,
                                      sEmpCode,
                                      _selectedSectorId,
                                      _selectedShopId,
                                      dExpDate,
                                      amount,
                                      expenseDetails,
                                      uplodedImage,
                                      sContactNo,
                                      result,
                                      remarks,
                                      uplodedImage2,
                                      uplodedImage3,
                                      uplodedImage4,
                                      consumableList,
                                      consumableItemString
                                  );

                                  result = "${hrmsPostReimbursement[0]['Result']}";
                                  msg = "${hrmsPostReimbursement[0]['Msg']}";

                                  if (result == "1") {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return _buildDialogSucces2(context, msg);
                                      },
                                    );
                                  }
                                } else {
                                  if (sTranCode == null) {
                                    displayToast('Generate Random Number');
                                  } else if (sEmpCode == null) {
                                    displayToast('Enter sEmpCode');
                                  } else if (_selectedSectorId == null) {
                                    displayToast('Please Select Project');
                                  } else if (_selectedShopId == null) {
                                    displayToast('Please Select Expense Category');
                                  } else if (dExpDate == null) {
                                    displayToast('Select Expense Date');
                                  } else if (amount.isEmpty) {
                                    displayToast('Please Enter Amount');
                                  } else if (expenseDetails.isEmpty) {
                                    displayToast('Please Enter Remarks');
                                  } else if (uplodedImage == null && uplodedImage2 == null && uplodedImage3 == null && uplodedImage4 == null) {
                                    displayToast('Please pick a photo');
                                  } else if (sContactNo == null) {
                                    displayToast('Please get a contact number');
                                  }
                                }
                              },

                              // onTap: () async {
                              //   SharedPreferences prefs = await SharedPreferences.getInstance();
                              //   String? sEmpCode = prefs.getString('sEmpCode');
                              //   String? sContactNo = prefs.getString('sContactNo');
                              //
                              //   var amount = '${_amountController.text}';
                              //   var expenseDetails = '${_expenseController.text}';
                              //   remarks = '${_remarkController.text}';
                              //
                              //   // print('-----sTranCode-----XX--$sTranCode2');
                              //   // print('-----sEmpCode-----XX--$sEmpCode');
                              //   // print('-----_selectedSectorId---XX---$_selectedSectorId');
                              //   // print('-----_selectedShopId-----XXX-$_selectedShopId');
                              //   // print('-----amount------XXX----$amount');
                              //   // print('-----expenseDetails-----XX----$expenseDetails');
                              //   // print('-----uplodedImage-----XX----$uplodedImage');
                              //   // print('-----sContactNo-----XX-----$sContactNo');
                              //   // print("-------R----$remarks");
                              //
                              //   if (_formKey.currentState!.validate() &&
                              //       sEmpCode != null &&
                              //       _selectedSectorId != null &&
                              //       _selectedShopId != null &&
                              //       amount != null &&
                              //       expenseDetails != null &&
                              //       remarks!="" &&
                              //       uplodedImage!=null || uplodedImage2!=null || uplodedImage3!=null || uplodedImage4!=null &&
                              //       sContactNo != null &&
                              //       _remarkController!=null
                              //   ) {
                              //     // Call Api
                              //     print('---call Api---');
                              //     print('-----2507---list----$consumableList');// consuambleItemList
                              //     print('-----2508---list----$consuambleItemList');
                              //     // consumableItemString
                              //     print('------2516----$consumableItemString');
                              //     var hrmsPostReimbursement =
                              //     await HrmsPostReimbursementRepo()
                              //         .hrmsPostReimbursement(
                              //         context,
                              //         sTranCode2,
                              //         sEmpCode,
                              //         _selectedSectorId,
                              //         _selectedShopId,
                              //         dExpDate,
                              //         amount,
                              //         expenseDetails,
                              //         uplodedImage,
                              //         sContactNo,
                              //         result,
                              //         remarks,
                              //         uplodedImage2,
                              //         uplodedImage3,
                              //         uplodedImage4,
                              //         consumableList,
                              //         consumableItemString
                              //     );
                              //
                              //     print('---1050--$hrmsPostReimbursement');
                              //
                              //     result = "${hrmsPostReimbursement[0]['Result']}";
                              //     msg = "${hrmsPostReimbursement[0]['Msg']}";
                              //
                              //     print("----2532----msg---$msg");
                              //     print("----2532----result---$result");
                              //
                              //     if(result=="1"){
                              //         showDialog(
                              //           context: context,
                              //           builder: (BuildContext context) {
                              //             return _buildDialogSucces2(context, msg);
                              //           },
                              //         );
                              //     }
                              //
                              //   } else {
                              //     if (sTranCode == null) {
                              //       displayToast('Genrate Random Number');
                              //     } else if (sEmpCode == null) {
                              //       displayToast('Enter sEmpCode');
                              //     } else if (_selectedSectorId == null) {
                              //       displayToast('Please Select Project');
                              //     } else if (_selectedShopId == null) {
                              //       displayToast(
                              //           'Please Select Expense Category');
                              //     } else if (dExpDate == null) {
                              //       displayToast('Select Expense Date');
                              //     } else if (amount == null || amount == '') {
                              //       displayToast('Please Enter Amount');
                              //     } else if (expenseDetails == null ||
                              //         expenseDetails == '') {
                              //       displayToast('Please Enter Expense Details');
                              //     }else if(remarks==""){
                              //       displayToast('Please Enter Remarks');
                              //     }
                              //     else if (uplodedImage == null || uplodedImage2==null || uplodedImage3==null || uplodedImage4==null) {
                              //       displayToast('Please pick a photo');
                              //     } else if (sContactNo == null) {
                              //       displayToast('Please get a contact number');
                              //     }
                              //   } // condition to fetch a response form a api
                              //   // if (result == "0") {
                              //   //
                              //   //   // CALL API HRMS Reimbursement
                              //   //   print("---sTranCode2-----$sTranCode2");
                              //   //   print("---sEmpCode-----$sEmpCode");
                              //   //   print("---_selectedSectorId-----$_selectedSectorId");
                              //   //   print("---_selectedShopId-----$_selectedShopId");
                              //   //   print("---dExpDate-----$dExpDate");
                              //   //   print("---amount-----$amount");
                              //   //   print("---expenseDetails-----$expenseDetails");
                              //   //   print("---uplodedImage-----$uplodedImage");
                              //   //   print("---sContactNo-----$sContactNo");
                              //   //   print("---result-----$result");
                              //   //   print("---remarks-----$remarks");
                              //   //   print("---uplodedImage2-----$uplodedImage2");
                              //   //   print("---uplodedImage3-----$uplodedImage3");
                              //   //   print("---uplodedImage4-----$uplodedImage4");
                              //   //   print("---consumableList-----$consumableList");
                              //   //
                              //   //   var hrmsPostReimbursement =
                              //   //       await HrmsPostReimbursementRepo()
                              //   //           .hrmsPostReimbursement(
                              //   //               context,
                              //   //                sTranCode2,
                              //   //               sEmpCode,
                              //   //               _selectedSectorId,
                              //   //               _selectedShopId,
                              //   //               dExpDate,
                              //   //               amount,
                              //   //               expenseDetails,
                              //   //               uplodedImage,
                              //   //               sContactNo,
                              //   //               result,
                              //   //               remarks,
                              //   //               uplodedImage2,
                              //   //               uplodedImage3,
                              //   //               uplodedImage4,
                              //   //               consumableList);
                              //   //
                              //   //  print('---1050--$hrmsPostReimbursement');
                              //   //
                              //   //  result = "${hrmsPostReimbursement[0]['Result']}";
                              //   //  msg = "${hrmsPostReimbursement[0]['Msg']}";
                              //   //
                              //   //   // displayToast(msg);
                              //   //   /// todo here to show the dialog sucess
                              //   //   showDialog(
                              //   //     context: context,
                              //   //     builder: (BuildContext context) {
                              //   //       return _buildDialogSucces2(context, msg);
                              //   //     },
                              //   //   );
                              //   // } else {
                              //   //   showCustomDialog(context, msg);
                              //   //   //displayToast(msg);
                              //   //   print('---diaplay dialog --');
                              //   // }
                              // },

                              child: Container(
                                width: double.infinity,
                                // Make container fill the width of its parent
                                height: AppSize.s45,
                                padding: EdgeInsets.all(AppPadding.p5),
                                decoration: BoxDecoration(
                                  color: AppColors.loginbutton,
                                  // Background color using HEX value
                                  borderRadius: BorderRadius.circular(
                                      AppMargin.m10), // Rounded corners
                                ),
                                //  #00b3c7
                                child: Center(
                                  child: Text(
                                    "Send Reimbursement",
                                    style: AppTextStyle
                                        .font16OpenSansRegularWhiteTextStyle,
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
                  Text('Duplicate Entry',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? sEmpCode = prefs.getString('sEmpCode');
                    String? sContactNo = prefs.getString('sContactNo');

                    /// TODO GET A RANDOM NUMBER
                   // Random random = Random();
                    //int sTranCode = 10000000 + random.nextInt(90000000);
                    var amount = '${_amountController.text}';
                    var expenseDetails = '${_expenseController.text}';
                    remarks = '${_remarkController.text}';

                    //---------

                    print('----sTranCode--15---$sTranCode2');
                    print('----sEmpCode--15---$sEmpCode');
                    print('----selectedSectorId--15---$_selectedSectorId');
                    print('----selectedShopId--15---$_selectedShopId');
                    print('----dExpDate--15---$dExpDate');
                    print('----amount--15---$amount');
                    print('----expenseDetails--15---$expenseDetails');
                    print('----uplodedImage--15---$uplodedImage');
                    print('----sContactNo--15---$sContactNo');
                    print('----sRemarks--15---${remarks}');
                    print('----result--15---$result');
                    print('----uplode image 2--44---$uplodedImage2');
                    print('----uplode image 3--45---$uplodedImage3');
                    print('----uplode image 4--46---$uplodedImage4');
                    print('----ConsumaleList --46---$consumableList');

                   //  var hrmsPostReimbursement =
                   //      await HrmsPostReimbursementRepo().hrmsPostReimbursement(
                   //          context,
                   //          sTranCode2,
                   //          sEmpCode,
                   //          _selectedSectorId!,
                   //          _selectedShopId!,
                   //          dExpDate!,
                   //          amount,
                   //          expenseDetails,
                   //          uplodedImage,
                   //          sContactNo!,
                   //          result,
                   //          remarks,
                   //          uplodedImage2,
                   //          uplodedImage3,
                   //          uplodedImage4,
                   //          consumableList);
                   // print('---1050--$hrmsPostReimbursement');
                   //  result = "${hrmsPostReimbursement[0]['Result']}";
                   //  msg = "${hrmsPostReimbursement[0]['Msg']}";
                    // displayToast(msg);
                    // Dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildDialogSucces2(context, msg);
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
