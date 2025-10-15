import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/resources/app_colors.dart';
import '../../app/generalFunction.dart';
import '../../data/loginrepo.dart';
import '../dashboard/dashboard.dart';
import '../forgotpassword/forgotPassword.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  var loginProvider;

  // focus
  FocusNode phoneNumberfocus = FocusNode();
  FocusNode passWordfocus = FocusNode();

  bool passwordVisible = false;

  // Visible and Unvisble value
  int selectedId = 0;
  var msg;
  var result;
  var loginMap;
  double? lat, long;
  bool _isChecked = false;
  GeneralFunction generalFunction = GeneralFunction();
  late SharedPreferences prefs;


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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    lat = position.latitude;
    long = position.longitude;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: new Text('Do you want to exit app'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  //  goToHomePage();
                  // exit the app
                  exit(0);
                }, //Navigator.of(context).pop(true), // <-- SEE HERE
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    // TODO: implement initState
    toGetCreditialValue();
    super.initState();
  }
  toGetCreditialValue() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone');
    String? password = prefs.getString('password');
    print("----121-----phone:--$phone");
    print("----122-----password:--$password");
    print("-------------126--------");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }
  // request location permission
  // location Permission
  Future<void> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void clearText() {
    _phoneNumberController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: DurationConstant.d300,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageAssets.logintopheader),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Container(
                                   width: 70,
                                   height: 70,
                                   decoration: BoxDecoration(
                                     image: const DecorationImage(
                                       image: AssetImage(ImageAssets.passwordlogin),
                                       fit: BoxFit.cover,
                                     ),
                                     borderRadius: BorderRadius.circular(AppPadding.p10),
                                     // Rounded corners
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.transparent,
                                         spreadRadius: AppPadding.p5,
                                         blurRadius: AppPadding.p7,
                                         offset: Offset(0, 3),
                                       ),
                                     ],
                                   ),
                                 ),
                                 SizedBox(height: AppPadding.p10),
                                 Text(
                                   AppStrings.txtHrms,
                                   style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                                 ),
                                 SizedBox(height: AppPadding.p10),
                                 Text(AppStrings.txtHrmsTitle,
                                     style: AppTextStyle.font16OpenSansRegularWhiteTextStyle),
                               ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: AppPadding.p15, right:AppPadding.p15),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: AppPadding.p20),
                              TextFormField(
                                focusNode: phoneNumberfocus,
                                controller: _phoneNumberController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  // Limit to 10 digits
                                  //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow digits
                                ],
                                decoration: InputDecoration(
                                  labelText: AppStrings.txtMobile,
                                  labelStyle: AppTextStyle.font16OpenSansRegularBlack45TextStyle,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: AppPadding.p10,
                                    horizontal: AppPadding.p10, // Add horizontal padding
                                  ),
                                  prefixIcon: const Icon(Icons.phone,
                                      color: AppColors.loginbutton),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppStrings.txtMobileValidation;
                                  }
                                  if (value.length > 1 && value.length < 10) {
                                    return AppStrings.txtMobileValidation_2 ;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: AppPadding.p10),
                              TextFormField(
                              obscureText: _isObscured,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: AppStrings.txtPassword,
                                labelStyle: AppTextStyle.font16OpenSansRegularBlack45TextStyle,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p10,
                                  horizontal: AppPadding.p10,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: AppColors.loginbutton,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // 👇 Swapped logic here
                                    _isObscured ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.loginbutton,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscured = !_isObscured;
                                    });
                                  },
                                ),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.txtPasswordValidation;
                                }
                                return null;
                              },
                            ),
                              SizedBox(height: AppPadding.p10),
                              /// LoginButton code and onclik Operation
                              InkWell(
                                onTap: () async {
                                   var phone = _phoneNumberController.text;
                                   var password = passwordController.text;
                                   /// todo here locally store phone and password and get a initState
                                   /// if data is here then set TextFormField and otherWise set a empty.
                                   SharedPreferences prefs2 = await SharedPreferences.getInstance();
                                   prefs2.setString('phone',phone);
                                   prefs2.setString('password',password);


                                   if(_formKey.currentState!.validate() && phone != null && password != null){
                                     // Call Api
                                             loginMap = await LoginRepo().login(context, phone!, password!);
                                             result = "${loginMap[0]['Result']}";
                                             msg = "${loginMap[0]['Msg']}";

                                   }else{
                                     if(_phoneNumberController.text.isEmpty){
                                       phoneNumberfocus.requestFocus();
                                     }else if(passwordController.text.isEmpty){
                                       passWordfocus.requestFocus();
                                     }
                                   } // condition to fetch a response form a api
                                  if(result=="1"){
                                      var sEmpCode = "${loginMap[0]['sEmpCode']}";
                                      var sCompEmpCode = "${loginMap[0]['sCompEmpCode']}";
                                      var sFirstName = "${loginMap[0]['sFirstName']}";
                                      var sLastName = "${loginMap[0]['sLastName']}";
                                      var sContactNo = "${loginMap[0]['sContactNo']}";
                                      var dDOJ = "${loginMap[0]['dDOJ']}";
                                      var dDOB = "${loginMap[0]['dDOB']}";
                                      var sEmergencyContactPerson = "${loginMap[0]['sEmergencyContactPerson']}";
                                      var sEmergencyContactNo = "${loginMap[0]['sEmergencyContactNo']}";
                                      var sEmergencyContactRelation = "${loginMap[0]['sEmergencyContactRelation']}";
                                      var sBloodGroup = "${loginMap[0]['sBloodGroup']}";
                                      var sCategory = "${loginMap[0]['sCategory']}";
                                      var sDsgCode = "${loginMap[0]['sDsgCode']}";
                                      var sDsgName = "${loginMap[0]['sDsgName']}";
                                      var sDeptCode = "${loginMap[0]['sDeptCode']}";
                                      var sDeptName = "${loginMap[0]['sDeptName']}";
                                      var sLocCode = "${loginMap[0]['sLocCode']}";
                                      var sLocName = "${loginMap[0]['sLocName']}";
                                      var sLocation = "${loginMap[0]['sLocation']}";
                                      var sBankName = "${loginMap[0]['sBankName']}";
                                      var sBankAcNo = "${loginMap[0]['sBankAcNo']}";
                                      var sISFCode = "${loginMap[0]['sISFCode']}";
                                      var Entitlement = "${loginMap[0]['Entitlement']}";
                                      var Availed = "${loginMap[0]['Availed']}";
                                      var Balance = "${loginMap[0]['Balance']}";
                                      var sToken = "${loginMap[0]['sToken']}";
                                      var sEmpImage = "${loginMap[0]['sEmpImage']}";
                                      var sCompEmailId = "${loginMap[0]['sCompEmailId']}";
                                      var sMngrName = "${loginMap[0]['sMngrName']}";
                                      var sMngrDesgName = "${loginMap[0]['sMngrDesgName']}";
                                      var Development = "${loginMap[0]['Development']}";
                                      var sMngrContactNo = "${loginMap[0]['sMngrContactNo']}";
                                      var iIsEligibleShLv = "${loginMap[0]['iIsEligibleShLv']}";

                                      // To store value in  a SharedPreference

                                       prefs = await SharedPreferences.getInstance();

                                      prefs.setString('sEmpCode',sEmpCode);
                                      prefs.setString('sCompEmpCode',sCompEmpCode);
                                      prefs.setString('sFirstName',sFirstName);
                                      prefs.setString('sLastName',sLastName);
                                    prefs.setString('sLastName',sLastName);
                                    prefs.setString('sContactNo',sContactNo);
                                    prefs.setString('dDOJ',dDOJ);
                                    prefs.setString('dDOB',dDOB);
                                    prefs.setString('sEmergencyContactPerson',sEmergencyContactPerson);
                                    prefs.setString('sEmergencyContactNo',sEmergencyContactNo);
                                    prefs.setString('sEmergencyContactRelation',sEmergencyContactRelation);
                                    prefs.setString('sBloodGroup',sBloodGroup);
                                    prefs.setString('sCategory',sCategory);
                                    prefs.setString('sDsgCode',sDsgCode);
                                    prefs.setString('sDsgName',sDsgName);
                                    prefs.setString('sDeptCode',sDeptCode);
                                    prefs.setString('sDeptName',sDeptName);
                                    prefs.setString('sLocCode',sLocCode);
                                    prefs.setString('sLocName',sLocName);
                                    prefs.setString('sLocation',sLocation);
                                    prefs.setString('sBankName',sBankName);
                                    prefs.setString('sBankAcNo',sBankAcNo);
                                    prefs.setString('sISFCode',sISFCode);
                                    prefs.setString('Entitlement',Entitlement);
                                    prefs.setString('Availed',Availed);
                                    prefs.setString('Balance',Balance);
                                    prefs.setString('sToken',sToken);
                                    prefs.setString('sEmpImage',sEmpImage);
                                    prefs.setString('sCompEmailId',sCompEmailId);
                                    prefs.setString('sMngrName',sMngrName);
                                    prefs.setString('sMngrDesgName',sMngrDesgName);
                                    prefs.setString('Development',Development);
                                    prefs.setString('sMngrContactNo',sMngrContactNo);
                                    prefs.setString('iIsEligibleShLv',iIsEligibleShLv);

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => DashBoard()),
                                            (Route<dynamic> route) => false, // Remove all previous routes
                                      );
                                  }else{
                                    displayToast(msg);
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
                                      AppStrings.txtLogin,
                                      style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: (){

                                      },
                                    child: Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? value) async {
                                        // 1️⃣ Update checkbox state first (synchronously)
                                        setState(() {
                                          _isChecked = value ?? false;
                                        });
                                        // 2️⃣ Then handle async work outside of setState()
                                        var mobileNo_2 = _phoneNumberController.text;
                                        var password_2 = passwordController.text;

                                        if (mobileNo_2.isNotEmpty && password_2.isNotEmpty) {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();

                                          prefs.setString('mobileNo',mobileNo_2);
                                          prefs.setString('password',password_2);
                                          // get a storedValue
                                          var mobileNo = prefs.getString('mobileNo');
                                          var password = prefs.getString('password');

                                          print("---mobileNo-----xxx----471---$mobileNo");
                                          print("---password----472----$password");
                                          displayToast("Credentials stored.");

                                        }else{
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          var mobileNo = prefs.getString('sContactNo');
                                          var password = prefs.getString('password');

                                          print("---mobileNo-----xxx----483---$mobileNo");
                                          print("---password----484----$password");
                                          if(password !=null){
                                            setState(() {
                                              passwordController.text = password;
                                              _phoneNumberController.text = mobileNo!;
                                            });



                                          }else{
                                            displayToast("Credentials not stored.");
                                          }
                                        }
                                      },
                                    )

                                  ),
                                  Text(
                                    AppStrings.txtStayConnected,
                                    style: AppTextStyle
                                        .font16OpenSansRegularBlack45TextStyle,
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: (){
                                      // Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 14),
                                      child: Text(
                                        AppStrings.txtForgetPassword,
                                        style: AppTextStyle
                                            .font16OpenSansRegularBlack45TextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppPadding.p20),
                              Padding(
                                padding: const EdgeInsets.only(left: AppPadding.p15, right: AppPadding.p15),
                                child: Row(
                                  children: <Widget>[
                                    const Expanded(
                                      child: Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                        endIndent: 10,
                                      ),
                                    ),
                                    Text(
                                      AppStrings.txtPowerdBy,
                                      style: AppTextStyle
                                          .font16OpenSansRegularBlack45TextStyle,
                                    ),
                                    const Expanded(
                                      child: Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                        indent: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppPadding.p50),
                              Container(
                                //width: DurationConstant.d200, // Set width as needed
                                width: 150,
                                height: AppPadding.p50,
                                // Set height as needed
                                child: Image.asset(ImageAssets.companylogoNew,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  // toast code
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
}
