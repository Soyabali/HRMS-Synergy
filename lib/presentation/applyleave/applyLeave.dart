import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/getTdMonthRepo.dart';
import '../../data/hrmsLeaveBalaceV2.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';
import 'applyleaveSubmitForm.dart';


class Applyleave extends StatelessWidget {
  const Applyleave({super.key});

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
      home: ApplyLeaveHome(),
    );
  }
}

class ApplyLeaveHome extends StatefulWidget {
  const ApplyLeaveHome({super.key});

  @override
  State<ApplyLeaveHome> createState() => _AttendaceListHomeState();
}

class _AttendaceListHomeState extends State<ApplyLeaveHome> {
  bool _isSwitchOn = false;
  bool isMarked = false;
  int? markedIndex=0;
  Color? containerColor;
  Color? textColor;
  List<dynamic>?  getgetYtdMonth;
  List<dynamic>?  hrmsLeaveBalaceV2List;
  var sLvDescTitle;
  var dDate;
  var sLvDesc;

  // month api call
  getYtdMonth() async {
    getgetYtdMonth = await GetYtdMonthRepo().getYtdMonth();
    dDate =  '${getgetYtdMonth?[0]['dDate']}';
    print('------54---$dDate');
    if(dDate!=null){
       /// TODO REMOVE COMMENT AND CALL API
      print('---call the api---');
      hrmsLeaveBalaceV2(dDate);
    }

  }
  // leave balance api

  hrmsLeaveBalaceV2(String dDate) async {
    hrmsLeaveBalaceV2List = await Hrmsleavebalacev2Repo().getHrmsleavebalacev2(dDate);
    print(" -----xxxxx-  hrmsLeaveBalaceV2List--63---> $hrmsLeaveBalaceV2List");
    if(hrmsLeaveBalaceV2List!=null){
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getYtdMonth();
    super.initState();
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
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        backgroundColor: Color(0xFF0098a6),
        leading: InkWell(
          onTap: (){
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashBoard()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(Icons.arrow_back_ios, size: 24,color: Colors.white,),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Apply Leave',
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
        children:[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             SizedBox(height: 15),
             Padding(
               padding: const EdgeInsets.only(left: 5.0,right: 5.0),
               child: Row(
                         mainAxisAlignment: MainAxisAlignment.start, // Aligns items to the start
                         children: [
                           // AssetImage inside an Image widget
                           Image.asset(
                'assets/images/ic_expense.png', // Replace with your asset image path
                width: 25, // Set the width of the image
                height: 25, // Set the height of the image
                ),
                           SizedBox(width: 10), // Adds spacing between the image and the text
                           // Text Widget
                           Text(
                'Check Your YTD Entitlement',
                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                           ),
                           SizedBox(width: 10), // Adds spacing between the text and the checkbox
                           // Checkbox Widget
                           Switch(
                value: _isSwitchOn,
                onChanged: (value) {
                  setState(() {
                    _isSwitchOn = value; // Update the switch state
                  });
                },
                 ),
                           // Display the state of the switch
                           Text(
                _isSwitchOn
                    ? 'ON' : 'OFF',
                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                           ),
                         ],
                       ),
             ),
              _isSwitchOn
              ? appleaveSwitchOnCode() //appleaveSwitchOnCode_2()
             :
              //appleaveSwithOffCode_3(),
              appleaveSwithOffCode_2()
            ],
          ),
        ],
      ),
    );
  }
  Widget appleaveSwitchOnCode(){
    return Column(
      children: [
        SizedBox(height: 15),
        SizedBox(
          height: 35, // Set the height for the horizontal list
          child: GestureDetector(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: getgetYtdMonth?.length ?? 0, // Adjust the number of items as needed
              itemBuilder: (context, index) {
                bool isMarked = markedIndex == index;
                // Generate a random color
                final randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
                return GestureDetector(
                  onTap: (){
                    markedIndex = isMarked ? null : index;
                    var dDate = '${getgetYtdMonth?[index]['dDate']}';
                    print('----150----xxx---$dDate');
                    setState(() {

                    });
                    /// TODO CALL A NEXT API
                    hrmsLeaveBalaceV2(dDate);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8), // Add spacing between items
                    height: 35,
                    width: 135, // Width of the container
                    decoration: BoxDecoration(
                      color: randomColor, // Use the randomly generated color
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center, // Center the text within the container
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isMarked)
                          const Positioned(
                            left: 5,
                            top: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.check_circle, // Mark symbol
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        Positioned.fill(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: isMarked ? 35 : 0), // Adjust left padding when icon is present
                              child:  Text('${getgetYtdMonth?[index]['sMonthName']}', // Example month text
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        /// TODO WAP THIS CONTAINER INTO THE LIST
        ///
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0,bottom: 150), // Left and right padding of 5
          child: Container(
             // height: MediaQuery.of(context).size.height-50,
              height: MediaQuery.of(context).size.height-200,
              child: ListView.builder(
                itemCount: hrmsLeaveBalaceV2List?.length ?? 0,
                itemBuilder: (context,index){
                  sLvDesc = '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}';
                  sLvDescTitle = (sLvDesc=="Leave Without Pay")? "Note:-Salary will be deducated for this leave.":"";
                  containerColor;
                  textColor;
                  var note;
                  if(sLvDesc =="Leave Without Pay"){
                    containerColor = Colors.redAccent;
                    textColor = Colors.redAccent;
                    // note="Note : Salary will be deducated for this leave ."
                  }else{
                    containerColor = Color(0xFF0098a6);
                    textColor = Colors.black;
                  }
                  return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    //padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5,top: 5),
                    child:Card(
                        color: Colors.white,
                        elevation: 5.0, // Elevation of the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // Border radius of the card
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           // SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 56, // Height of the first container
                                  width: MediaQuery.of(context).size.width-20, // Width of the first container
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD3D3D3), // Background color of the first container
                                    borderRadius: BorderRadius.circular(0), // Border radius
                                    border: const Border(
                                      left: BorderSide(
                                        color: Colors.green, // Color of the left border
                                        width: 5.0, // Width of the left border
                                      ),
                                    ),
                                  ),
                                  // Center the text within the container
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Leave Type',
                                              style: TextStyle(
                                                  color: Color(0xFF0098a6),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Visibility(
                                          visible: '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}' != "Leave Without Pay",
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 12,right: 15),
                                            child: Container(
                                              height: 30, // Height of the container
                                              width: 110, // Width of the container
                                              //color: Colors.white, // Background color of the container
                                              decoration: BoxDecoration(
                                                color: Colors.white, // Background color of the container
                                                borderRadius: BorderRadius.circular(15), // Border radius
                                              ),
                                              alignment: Alignment.center, // Center the text within the container
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 10,top: 2),
                                                    child: Text(
                                                      'YTD : ', // The text to display
                                                      style: TextStyle(
                                                        color: Colors.black, // Text color
                                                        fontSize: 16, // Text size
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '${hrmsLeaveBalaceV2List?[index]['fYTD']}', // The text to display
                                                    style: const TextStyle(
                                                      color: Colors.black, // Text color
                                                      fontSize: 16, // Text size
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child:Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fOpeningBal']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fEntitlement']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Entitlement', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fAvailed']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Availed', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fClosingBalance']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Balance', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text('$sLvDescTitle',style: TextStyle(
                                      color: Colors.redAccent,fontSize: 10,fontWeight: FontWeight.normal
                                  ),),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10,right: 10),
                                    child: GestureDetector(
                                      onTap: () async{
                                        var sLvTypeCode = '${hrmsLeaveBalaceV2List?[index]['sLvTypeCode']}';
                                        sLvDesc = '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}';
                                        // print('---511---${sLvDesc}');
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        var sFirstName = prefs.getString('sFirstName');// sLvTypeCode
                                        // var sLvTypeCode = prefs.getString('sLvTypeCode');
                                        print('----517--${sFirstName}');
                                        print('----518--${sLvTypeCode}');

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ApplyLeaveSubmitFormHome(sLvDesc,sFirstName,sLvTypeCode)),
                                        );
                                      },
                                      child: Container(
                                        height: 35, // Height of the second container
                                        width: 90, // Width of the second container
                                        decoration: BoxDecoration(
                                          color: containerColor, // Background color of the second container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                            'Apply', // The text to display
                                            style: AppTextStyle.font12OpenSansRegularWhiteTextStyle
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        )
                    ),
                  );
                },
              )
          ),
        ),
      ],
    );
  }
  Widget appleaveSwithOffCode(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0,bottom: 85), // Left and right padding of 5
          child: Container(
              height: MediaQuery.of(context).size.height-50,
              child: ListView.builder(
                itemCount: hrmsLeaveBalaceV2List?.length ?? 0,
                itemBuilder: (context,index){
                  sLvDesc = '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}';
                  sLvDescTitle = (sLvDesc=="Leave Without Pay")? "Note:-Salary will be deducated for this leave.":"";

                  containerColor;
                  textColor;
                  var note;
                  if(sLvDesc =="Leave Without Pay"){
                    containerColor = Colors.redAccent;
                    textColor = Colors.redAccent;
                    // note="Note : Salary will be deducated for this leave ."
                  }else{
                    containerColor = Color(0xFF0098a6);
                    textColor = Colors.black;
                  }
                  return  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10,top: 10),
                    child:Card(
                        color: Colors.white,
                        elevation: 5.0, // Elevation of the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Border radius of the card
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 56, // Height of the first container
                                  width: MediaQuery.of(context).size.width-20, // Width of the first container
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD3D3D3), // Background color of the first container
                                    borderRadius: BorderRadius.circular(0), // Border radius
                                    border: const Border(
                                      left: BorderSide(
                                        color: Colors.green, // Color of the left border
                                        width: 5.0, // Width of the left border
                                      ),
                                    ),
                                  ),
                                  // Center the text within the container
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Leave Type',
                                              style: TextStyle(
                                                  color: Color(0xFF0098a6),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12,right: 15),
                                          child: Container(
                                            height: 30, // Height of the container
                                            width: 110, // Width of the container
                                            //color: Colors.white, // Background color of the container
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Background color of the container
                                              borderRadius: BorderRadius.circular(15), // Border radius
                                            ),
                                            alignment: Alignment.center, // Center the text within the container
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(left: 10,top: 2),
                                                  child: Text(
                                                    'YTD : ', // The text to display
                                                    style: TextStyle(
                                                      color: Colors.black, // Text color
                                                      fontSize: 16, // Text size
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  '${hrmsLeaveBalaceV2List?[index]['fYTD']}', // The text to display
                                                  style: const TextStyle(
                                                    color: Colors.black, // Text color
                                                    fontSize: 16, // Text size
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child:Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fOpeningBal']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fEntitlement']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Entitlement', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fAvailed']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Availed', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fClosingBalance']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Balance', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text('$sLvDescTitle',style: TextStyle(
                                      color: Colors.redAccent,fontSize: 10,fontWeight: FontWeight.normal
                                  ),),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10,right: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        sLvDesc = '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}';
                                        // print('---511---${sLvDesc}');
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        var sFirstName = prefs.getString('sFirstName');// sLvTypeCode
                                        var sLvTypeCode = prefs.getString('sLvTypeCode');
                                        print('----515--${sFirstName}');

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ApplyLeaveSubmitFormHome(sLvDesc,sFirstName,sLvTypeCode)),
                                        );
                                      },
                                      child: Container(
                                        height: 35, // Height of the second container
                                        width: 90, // Width of the second container
                                        decoration: BoxDecoration(
                                          color: containerColor, // Background color of the second container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                            'Apply', // The text to display
                                            style: AppTextStyle.font12OpenSansRegularWhiteTextStyle
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        )
                    ),
                  );
                },
              )
          ),
        ),
      ],
    );
  }

  Widget appleaveSwitchOnCode_2() {
    return Text("Switch is ON - Display this layout");
  }
  Widget appleaveSwithOffCode_3() {
    return Text("Switch is Off - Display this layout");
  }
  Widget appleaveSwithOffCode_2() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0,bottom: 85), // Left and right padding of 5
          child: Container(
              height: MediaQuery.of(context).size.height-150,
              child: ListView.builder(
                itemCount: hrmsLeaveBalaceV2List?.length ?? 0,
                itemBuilder: (context,index){
                  sLvDesc = '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}';
                  sLvDescTitle = (sLvDesc=="Leave Without Pay")? "Note:-Salary will be deducated for this leave.":"";

                  containerColor;
                  textColor;
                  var note;
                  if(sLvDesc =="Leave Without Pay"){
                    containerColor = Colors.redAccent;
                    textColor = Colors.redAccent;
                    // note="Note : Salary will be deducated for this leave ."
                  }else{
                    containerColor = Color(0xFF0098a6);
                    textColor = Colors.black;
                  }
                  return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                   // padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10,top: 10),
                    child:Card(
                        color: Colors.white,
                        elevation: 5.0, // Elevation of the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // Border radius of the card
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          //  SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 56, // Height of the first container
                                  width: MediaQuery.of(context).size.width-20, // Width of the first container
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD3D3D3), // Background color of the first container
                                    borderRadius: BorderRadius.circular(0), // Border radius
                                    border: const Border(
                                      left: BorderSide(
                                        color: Colors.green, // Color of the left border
                                        width: 4.0, // Width of the left border
                                      ),
                                    ),
                                  ),
                                  // Center the text within the container
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Leave Type',
                                              style: TextStyle(
                                                  color: Color(0xFF0098a6),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Visibility(
                                          visible: '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}' != "Leave Without Pay",
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 12,right: 15),
                                            child: Container(
                                              height: 30, // Height of the container
                                              width: 110, // Width of the container
                                              //color: Colors.white, // Background color of the container
                                              decoration: BoxDecoration(
                                                color: Colors.white, // Background color of the container
                                                borderRadius: BorderRadius.circular(15), // Border radius
                                              ),
                                              alignment: Alignment.center, // Center the text within the container
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 10,top: 2),
                                                    child: Text(
                                                      'YTD : ', // The text to display
                                                      style: TextStyle(
                                                        color: Colors.black, // Text color
                                                        fontSize: 16, // Text size
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '${hrmsLeaveBalaceV2List?[index]['fYTD']}', // The text to display
                                                    style: const TextStyle(
                                                      color: Colors.black, // Text color
                                                      fontSize: 16, // Text size
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child:Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fOpeningBal']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Opening', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fEntitlement']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Entitlement', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fAvailed']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Availed', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Material(
                                      elevation: 5, // Elevation of the container
                                      borderRadius: BorderRadius.circular(20), // Border radius
                                      child: Container(
                                        height: 40, // Height of the container
                                        width: 40, // Width of the container
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Background color of the container
                                          border: Border.all(color: Colors.grey, width: 1), // Outer border color and width
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                          '${hrmsLeaveBalaceV2List?[index]['fClosingBalance']}', // The text to display
                                          style: TextStyle(
                                            color: Colors.grey, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Balance', // The text to display
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontSize: 16, // Text size
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text('$sLvDescTitle',style: TextStyle(
                                      color: Colors.redAccent,fontSize: 10,fontWeight: FontWeight.normal
                                  ),),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10,right: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        sLvDesc = '${hrmsLeaveBalaceV2List?[index]['sLvDesc']}';
                                        // print('---511---${sLvDesc}');
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        var sFirstName = prefs.getString('sFirstName');// sLvTypeCode
                                        var sLvTypeCode = prefs.getString('sLvTypeCode');
                                        print('----515--${sFirstName}');

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ApplyLeaveSubmitFormHome(sLvDesc,sFirstName,sLvTypeCode)),
                                        );
                                      },
                                      child: Container(
                                        height: 35, // Height of the second container
                                        width: 90, // Width of the second container
                                        decoration: BoxDecoration(
                                          color: containerColor, // Background color of the second container
                                          borderRadius: BorderRadius.circular(20), // Border radius
                                        ),
                                        alignment: Alignment.center, // Center the text within the container
                                        child: Text(
                                            'Apply', // The text to display
                                            style: AppTextStyle.font12OpenSansRegularWhiteTextStyle
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        )
                    ),
                  );
                },
              )
          ),
        ),
      ],
    );
  }


}
