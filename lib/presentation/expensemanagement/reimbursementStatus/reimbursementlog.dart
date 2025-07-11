import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import '../../../app/generalFunction.dart';
import '../../../data/hrmsreimbursementlog.dart';
import '../../resources/app_text_style.dart';

class ReimbursementLogPage extends StatefulWidget {
  
  var projact;
  var sTranCode;
  
   ReimbursementLogPage(this.projact, this.sTranCode, {super.key});
   
   @override
  State<ReimbursementLogPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ReimbursementLogPage> {

  List<Map<String, dynamic>>? pendingScheduleLogList;
  
  double? lat;
  double? long;
  GeneralFunction generalfunction = GeneralFunction();

  List reimbursementStatusLog = [];
  List distList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;
  
  //List<Map<String, dynamic>>? reimbursementStatusLog;

  // Distic List

  hrmsReimbursementLog() async {
    reimbursementStatusLog = await HrmsreimbursementLogRepo().hrmsReimbursementLog(context,'${widget.sTranCode}');
    print(" -----xxxxx-  hrmsReimbursement-----> $reimbursementStatusLog");
    setState(() {});
  }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();
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

  // toast
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
  // void displayToast(String msg) {
  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }
  // InitState
  @override
  void initState() {
    // TODO: implement initState
    hrmsReimbursementLog();
    print('----113--${widget.projact}');
    print('-----114---${widget.sTranCode}');
    super.initState();

  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

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
                 Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Reimbursementstatus()),
                // );
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
                'Reimbursement Log ',
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
      Expanded(
        child: ListView.builder(
        itemCount: reimbursementStatusLog?.length ?? 0,
        itemBuilder: (context, index) {
          var remarks = '${reimbursementStatusLog?[index]['sRemarks']}';
          return
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.grey, // Outline border color
                        width: 0.2, // Outline border width
                      ),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(15.0),
                                      border: Border.all(
                                        color: Color(0xFF255899),
                                        // Outline border color
                                        width:
                                        0.5, // Outline border width
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                        child: Icon(Icons.light_mode_rounded,
                                          color: Colors.redAccent,)
                                    )),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Text(
                                          '${widget.projact}', style: AppTextStyle
                                          .font12OpenSansRegularBlackTextStyle,
                                        maxLines: 2, // Allows up to 2 lines for the text
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15),
                            child: Container(
                              height: 0.5,
                              color: Color(0xff3f617d),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  // Change this to your preferred color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              SizedBox(width: 5),
                              //  '‣ Sector',
                              Text('Amount',style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                                '${reimbursementStatusLog?[index]['fAmount']}',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlack45TextStyle
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  // Change this to your preferred color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                  'Expense Details',
                                  style: AppTextStyle
                                      .font12OpenSansRegularBlackTextStyle
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                                '${reimbursementStatusLog?[index]['sExpDetails']}',
                                style: AppTextStyle.font12OpenSansRegularBlack45TextStyle
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  // Change this to your preferred color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text('Status',style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                                '${reimbursementStatusLog?[index]['sStatusName']}',
                                style: AppTextStyle
                                    .font12OpenSansRegularBlack45TextStyle
                            ),
                          ),
                         // remarks
                          remarks!=null ?
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 10.0,
                                    width: 10.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      // Change this to your preferred color
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Remarks',style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                    '${reimbursementStatusLog?[index]['sRemarks']}',
                                    style: AppTextStyle
                                        .font12OpenSansRegularBlack45TextStyle
                                ),
                              ),
                            ],
                          ):
                          Container(),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2, right: 2),
                            child: Container(
                              height: 0.5,
                             color: Colors.grey,
                             // color: Color(0xff3f617d),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Action At',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle
                                      ),
                                      SizedBox(height: 4),
                                      // Add some spacing between texts
                                      Text(
                                        '${reimbursementStatusLog?[index]['dActionAt']}',
                                        style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                // divider
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                       Text(
                                        'Action By',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle
                                      ),
                                      SizedBox(height: 4),
                                      // Add some spacing between texts
                                      Text(
                                        '${reimbursementStatusLog?[index]['sActionBy']}',
                                        style: AppTextStyle
                                            .font12OpenSansRegularBlackTextStyle,
                                        maxLines: 1, // Allows up to 2 lines for the text
                                        overflow: TextOverflow.ellipsis,
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
                )
            );
        }
        ),
      )
      ]
      )),
    );
  }
}
