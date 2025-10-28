import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../app/generalFunction.dart';
import '../../../data/approvedTeamReimbursementRepo.dart';
import '../../../data/teamEmpListRepo.dart';
import '../../../domain/ApprovedTeamReimbursementModel.dart';
import '../../resources/app_text_style.dart';
import '../expense_management.dart';
import '../pendingteamreimb/duplicateExpenseEntry.dart';
import '../reimbursementStatus/reimbursementlog.dart';

class TeamReimStatus extends StatelessWidget {

  const TeamReimStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  TeamReimStatusPage(),
    );
  }
}

class TeamReimStatusPage extends StatefulWidget {

  const TeamReimStatusPage({super.key});

  @override
  State<TeamReimStatusPage> createState() => _MyLeaveStatusPageState();
}

class _MyLeaveStatusPageState extends State<TeamReimStatusPage> {

// with SingleTickerProviderStateMixin {

  var result, msg;
  late Future<List<ApprovedTeamReimbursementModel>> hrmsLeaveStatus;

  GeneralFunction generalFunction = new GeneralFunction();
  String? tempDate;
  String? formDate;
  String? toDate;
  List<dynamic> empList = [];
  var _dropDownValueBindReimType;
  var empCode;
  String selectedButton = 'Approved';
  var iStatus;

  getACurrentDate() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    formDate = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    setState(() {});

    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    toDate = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);
    setState(() {});
  }
  // to Date SelectedLogic

  void toDateSelectLogic() {
    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    DateTime? fromDate2 = dateFormat.parse(formDate!);
    DateTime? toDate2 = dateFormat.parse(toDate!);

    if (toDate2.isBefore(fromDate2)) {
      setState(() {
        toDate = tempDate;
        // call api
      });
      generalFunction.displayToast("To Date can not be less than From Date");
    } else {
      hrmsLeaveStatus = ApprovedTeamReimbursementRepo().approvedTeamReimbursementList(
          context, formDate!,toDate!,iStatus,empCode);
      /// here you change a tab and update date on a ispecific tab
    }
  }

  void fromDateSelectLogic() {

    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    DateTime? fromDate2 = dateFormat.parse(formDate!);
    DateTime? toDate2 = dateFormat.parse(toDate!);

    if (fromDate2.isAfter(toDate2)) {
      setState(() {
        formDate = tempDate;
      });
      generalFunction.displayToast("From date can not be greater than To Date");
    } else {
      hrmsLeaveStatus = ApprovedTeamReimbursementRepo().approvedTeamReimbursementList(
          context, formDate!,toDate!,iStatus,empCode);
      //here apply logic to change tab and update date
    }
  }

  // dropdown
  empListReim() async {
    empList = await TeampEmpListRepo().empList();
    print(" -----xxxxx-  empList--135--xxx---> $empList");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    iStatus = "8";
    getACurrentDate();
    empListReim();
    if (empList.isNotEmpty) {
      _dropDownValueBindReimType = empList[0]["sEmpName"];
      empCode = empList[0]["sEmpCode"];
    }
    // api call
    hrmsLeaveStatus = ApprovedTeamReimbursementRepo().approvedTeamReimbursementList(
        context, formDate!,toDate!,iStatus,empCode);
  }

  // dropDown
  Widget empListDropDown() {
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
                  text: "Emp List",
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
              value: _dropDownValueBindReimType,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueBindReimType = newValue;
                  empList.forEach((element) {
                    if (element["sEmpName"] == _dropDownValueBindReimType) {
                      empCode = element['sEmpCode'];
                      if (empCode != null) {
                        print('------EmpCode-----$empCode');
                        // Call your API here if needed
                        setState(() {
                          hrmsLeaveStatus = ApprovedTeamReimbursementRepo().approvedTeamReimbursementList(
                              context, formDate!,toDate!,iStatus,empCode);
                        });
                        //print('---159----$hrmsLeaveStatus');
                      }
                    }
                  });
                });
              },
              items: empList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sEmpName'].toString(),
                      style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                  value: item["sEmpName"].toString(),
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
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                  'Team Reimb Status',
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
                children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                  child: Container(
                      height: MediaQuery.of(context).size.height - 115,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: Color(0xFFFFFFFF)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                         Container(
                           height: 160,
                           //color: Colors.grey,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(0),
                               color: Color(0xFF0098a6)),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Divider(
                                 height: 2,
                                 //color: Color(0xFF0098a6),
                                 color: Colors.grey,
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(top: 10),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     const SizedBox(width: 4),
                                     Icon(Icons.calendar_month,
                                         size: 15, color: Colors.white),
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
                                         if (pickedDate != null) {
                                           String formattedDate =
                                           DateFormat('dd/MMM/yyyy').format(pickedDate);
                                           setState(() {
                                             tempDate =
                                                 formDate; // Save the current formDate before updating
                                             formDate = formattedDate;
                                           });
                                           print("-----237---$formDate");

                                           //  hrmsLeaveStatus = HrmsLeaveStatusRepo().hrmsLeveStatusList(context, "${formDate}", "${toDate}",status);
                                           fromDateSelectLogic();
                                         }
                                       },
                                       child: Container(
                                         height: 35,
                                         padding:
                                         EdgeInsets.symmetric(horizontal: 14.0),
                                         // Optional: Adjust padding for horizontal space
                                         decoration: BoxDecoration(
                                           color: Colors.white,
                                           // Change this to your preferred color
                                           borderRadius: BorderRadius.circular(15),
                                         ),
                                         child: Center(
                                           child: Text(
                                             '$formDate',
                                             style: const TextStyle(
                                               color: Colors.grey,
                                               // Change this to your preferred text color
                                               fontSize:
                                               12.0, // Adjust font size as needed
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
                                     const Icon(Icons.calendar_month,
                                         size: 16, color: Colors.white),
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
                                         if (pickedDate != null) {
                                           String formattedDate =
                                           DateFormat('dd/MMM/yyyy')
                                               .format(pickedDate);
                                           setState(() {
                                             tempDate = toDate; // Save the current toDate before updating
                                             toDate = formattedDate;
                                             // calculateTotalDays();
                                           });
                                           //
                                           print("-------300----$toDate");
                                           // hrmsLeaveStatus = HrmsLeaveStatusRepo().hrmsLeveStatusList(context, "${formDate}", "${toDate}",status);
                                           toDateSelectLogic();
                                         }
                                       },
                                       child: Container(
                                         height: 35,
                                         padding: const EdgeInsets.symmetric(
                                             horizontal: 14.0),
                                         // Optional: Adjust padding for horizontal space
                                         decoration: BoxDecoration(
                                           color: Colors.white,
                                           // Change this to your preferred color
                                           borderRadius: BorderRadius.circular(15),
                                         ),
                                         child: Center(
                                           child: Text(
                                             '$toDate',
                                             style: const TextStyle(
                                               color: Colors.grey,
                                               // Change this to your preferred text color
                                               fontSize:
                                               12.0, // Adjust font size as needed
                                             ),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                               SizedBox(height: 10),
                               Container(
                                 height: 40,
                                 width: MediaQuery.of(context).size.width - 10,
                                 decoration: const BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.horizontal(
                                     left: Radius.circular(0),
                                     right: Radius.circular(0),
                                   ),
                                 ),
                                 child: Padding(
                                   padding: const EdgeInsets.all(2.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                     children: [
                                       _buildTextButton('Approved'),
                                       _buildTextButton('Rejected'),
                                       _buildTextButton('Clarification'),
                                     ],
                                   ),
                                 ),
                               ),
                               SizedBox(height: 10),
                               empListDropDown(),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                          /// todo here you should bind the list
                          Expanded(
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: FutureBuilder<List<ApprovedTeamReimbursementModel>>(
                                    future: hrmsLeaveStatus,
                                    builder: (context, snapshot) {
                                      // Check if the snapshot has data and is not null
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Show a loading indicator while waiting for data
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        // Handle error scenario
                                        return Center(child: Text('No Data'));
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        // Handle the case where the data is empty or null
                                        return Center(child: Text('No Data'));
                                      }
                                      final polocyDocList = snapshot.data!;    // Access the resolved data
                                      return ListView.builder(
                                          itemCount: polocyDocList.length,
                                          itemBuilder: (context, index) {
                                            final empinfo = polocyDocList[index];
                                            //final randomColor = colorList[index % colorList.length];
                            
                                            return Card(
                                              elevation: 1,
                                              color: Colors.white,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    // Outline border color
                                                    width: 0.2, // Outline border width
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8, right: 8, top: 8),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Container(
                                                              width: 30.0,
                                                              height: 30.0,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(15.0),
                                                                border: Border.all(
                                                                  color: Color(0xFF255899),
                                                                  width:
                                                                  0.5, // Outline border width
                                                                ),
                                                                color: Colors.white,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "${1 + index}",
                                                                  style: AppTextStyle
                                                                      .font14OpenSansRegularBlackTextStyle,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            // Wrap the column in Flexible to prevent overflow
                                                            Flexible(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    '${empinfo.sExpHeadName}',
                                                                    style: AppTextStyle
                                                                        .font12OpenSansRegularBlackTextStyle,
                                                                    maxLines: 2,
                                                                    // Limits the text to 2 lines
                                                                    overflow: TextOverflow.ellipsis, // Truncates with an ellipsis if too long
                                                                  ),
                                                                  SizedBox(height: 4),
                                                                  // Add spacing between texts if needed
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10),
                                                                    child: Text(
                                                                      "Project Name : ${empinfo.sProjectName}",
                                                                      style: AppTextStyle
                                                                          .font12OpenSansRegularBlackTextStyle,
                                                                      maxLines: 2,
                                                                      // Limits the text to 2 lines
                                                                      overflow: TextOverflow.ellipsis, // Truncates with an ellipsis if too long
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                            
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
                                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                            Text('Employee Name',
                                                                style: AppTextStyle.font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 15),
                                                          child: Text(empinfo.sEmpName,
                                                              //item['dExpDate'] ??'',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 10.0,
                                                              width: 10.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors.black,
                                                                // Change this to your preferred color
                                                                borderRadius:
                                                                BorderRadius.circular(5.0),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text('Bill Date',
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 15),
                                                          child: Text(empinfo.dExpDate,
                                                              // item['dEntryAt'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
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
                                                                borderRadius:
                                                                BorderRadius.circular(5.0),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text('Enter At',
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 15),
                                                          child: Text(empinfo.dEntryAt,
                                                              // item['sExpDetails'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
                                                        ),
                                                        // cross Check
                                                        SizedBox(height: 10),
                                                        //
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
                                                                borderRadius:
                                                                BorderRadius.circular(5.0),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text('Manager Action At',
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 15),
                                                          child: Text(empinfo.dActionEntryAt,
                                                              // item['sExpDetails'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
                                                        ),
                                                        SizedBox(height: 10),
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
                                                                borderRadius:
                                                                BorderRadius.circular(5.0),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text('Expense Details',
                                                                style: AppTextStyle
                                                                    .font12OpenSansRegularBlackTextStyle)
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 15),
                                                          child: Text(empinfo.sExpDetails,
                                                              // item['sExpDetails'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle),
                                                        ),
                                                        SizedBox(height: 10),
                            
                                                        // bottom
                                                        Container(
                                                          height: 1,
                                                          width: MediaQuery.of(context).size.width -
                                                              40,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(height: 10),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            children: [
                                                              Icon(Icons.speaker_notes,
                                                                  size: 20, color: Colors.black),
                                                              SizedBox(width: 10),
                                                              Text('Status',
                                                                  style: AppTextStyle
                                                                      .font12OpenSansRegularBlackTextStyle),
                                                              SizedBox(width: 5),
                                                              const Text(
                                                                ':',
                                                                style: TextStyle(
                                                                  color: Color(0xFF0098a6),
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.normal,
                                                                ),
                                                              ),
                                                              SizedBox(width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  empinfo.sStatusName,
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
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal: 16.0),
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFF0098a6),
                                                                  borderRadius:
                                                                  BorderRadius.circular(15),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    '₹ ${empinfo.fAmount}',
                                                                    // item['fAmount'] ?? '',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 14.0,
                                                                    ),
                                                                    maxLines: 1,
                                                                    // Allows up to 2 lines for the text
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                            // Space between the two columns
                                                            children: [
                                                              // First Column
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: 40,
                                                                      decoration: BoxDecoration(
                                                                        color: Color(0xFF0098a6),
                                                                        // Change this to your preferred color
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                      ),
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          print(
                                                                              '-----832---View Image---');
                                                                          List<String> images = [
                                                                            empinfo.sExpBillPhoto,
                                                                            empinfo.sExpBillPhoto2,
                                                                            empinfo.sExpBillPhoto3,
                                                                            empinfo.sExpBillPhoto4,
                                                                          ]
                                                                              .where((image) =>
                                                                          image != null &&
                                                                              image.isNotEmpty)
                                                                              .toList(); // Filter out null/empty images
                                                                          var dExpDate =
                                                                              empinfo.dExpDate;
                                                                          var billDate =
                                                                              'Bill Date : $dExpDate';
                                                                          openFullScreenDialog(
                                                                              context,
                                                                              images,
                                                                              billDate);
                                                                        },
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Text('View Image',
                                                                                style: AppTextStyle
                                                                                    .font14OpenSansRegularWhiteTextStyle),
                                                                            Icon(
                                                                              Icons
                                                                                  .arrow_forward_ios,
                                                                              color: Colors.white,
                                                                              size: 16,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 2),
                                                              // if(leaveData.iStatus=="0")
                                                              // remove
                            
                                                              SizedBox(width: 2),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                      },
                                                                      child: Container(
                                                                        height: 40,
                                                                        decoration: BoxDecoration(
                                                                          color: Color(0xFF6a94e3),
                                                                          // Change this to your preferred color
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                        ),
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            //var projact =  item['sProjectName'] ??'';
                                                                            var sTranCode =
                                                                                empinfo.sTranCode;
                                                                            var project = empinfo
                                                                                .sProjectName;
                                                                            print(
                                                                                "----1257----$sTranCode");
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) =>
                                                                                      ReimbursementLogPage(
                                                                                          project,
                                                                                          sTranCode)),
                                                                            );
                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Text('Log',
                                                                                  style: AppTextStyle
                                                                                      .font14OpenSansRegularWhiteTextStyle),
                                                                              SizedBox(width: 10),
                                                                              Icon(
                                                                                Icons
                                                                                    .arrow_forward_ios,
                                                                                color: Colors.white,
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
                                            );
                            
                                          });
                                    })),
                          )


                        ],
                      )),
                ),
              )
            ]
            )
        )
    );
  }

  Widget _buildTextButton(String text) {
    final bool isSelected = text == selectedButton;

    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected ? Color(0xFF0098a6) : Colors.white,
          ),
          foregroundColor: MaterialStateProperty.all(
            isSelected ? Colors.white : Color(0xFF0098a6),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.blue, width: 0),
            ),
          ),
        ),
        onPressed: () {

          setState(() {
            selectedButton = text;
          });

          // to apply logic to get a code accoding to selected value
          iStatus;
          if(selectedButton=="Approved"){
            iStatus="8";
          }else if(selectedButton=="Rejected"){
            iStatus="9";
          }else{
            iStatus="5";
          }
          print('-----474---$iStatus');

          // call api
          hrmsLeaveStatus = ApprovedTeamReimbursementRepo().approvedTeamReimbursementList(
              context, formDate!,toDate!,iStatus,empCode);
        },
        child: Center(child: Text(text)),
      ),
    );
  }
}
