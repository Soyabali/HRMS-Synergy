import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:readmore/readmore.dart';
import '../../data/ActivitiesParametersRepo.dart';
import '../../data/hrmsActivityListRepo.dart';
import '../../data/hrmsDailyActivityNewRepo.dart';
import '../../data/projectemploybase.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';
import 'package:intl/intl.dart';

class WorkDetailNew extends StatefulWidget {
  const WorkDetailNew({super.key});

  @override
  State<WorkDetailNew> createState() =>
      _DailyWorkStatusScreenState();
}

class _DailyWorkStatusScreenState extends State<WorkDetailNew> {

  /// CONTROLLERS
  final TextEditingController workDetailController =
  TextEditingController();

  final TextEditingController timeSpentController =
  TextEditingController();
  List<dynamic>?  baseProjectList;
  List<dynamic> distList = [];
  List<dynamic> activityParameter = [];
  var _dropDownSector;
  final sectorFocus = GlobalKey();
  var _selectedProjectCode;
  List<dynamic> activityList = [];
  String currentDate = "";

  bool isLoading = false;

  /// DROPDOWN
  String? selectedProject;

  // project API Call
  @override
  void initState() {
    updateProject();
    activityParameterResponse();
    hrmsActivityList();
    currentDate =
        DateFormat('dd-MMM-yyyy')
            .format(DateTime.now());

    print(currentDate);
    super.initState();
  }
  void hrmsActivityList() async {

    setState(() {
      isLoading = true;
    });

    var map = await HrmsActivityList()
        .hrmsActivityList(context);

    print("--------50------HRMS Daily Activity--------");
    print(map);

    setState(() {

      activityList = map ?? [];

      isLoading = false;
    });
  }

  // Project List API Call

  updateProject() async {
    distList = await ProjectEmployRepo().projectList();
    print(" -----xxxxx-  projectList--81---> $distList");
    setState(() {});
  }
  // Activity Parameter
  activityParameterResponse() async {
    activityParameter = await ActivitiesParametersRepo().activityparameter();
    print(" -----xxxxx-  ---87---> $activityParameter");
    setState(() {});
  }

  // update Project DreopDown
  Widget _bindProject() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          //color: Colors.grey.shade400, // SAME OUTLINE
           color: Color(0xFF12B8C6),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _dropDownSector,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Select Project",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
          ),

          icon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.keyboard_arrow_down),
          ),

          onTap: () {
            FocusScope.of(context).unfocus();
          },

          onChanged: (newValue) {
            setState(() {
              _dropDownSector = newValue;

              distList.forEach((element) {
                if (element["sProjectName"] == _dropDownSector) {
                  _selectedProjectCode = element['sProjectCode'];
                }
              });
              print("--------94-----projectCODE--$_selectedProjectCode");

            });
          },

          items: distList.map<DropdownMenuItem<String>>((dynamic item) {
            return DropdownMenuItem<String>(
              value: item["sProjectName"].toString(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  item['sProjectName'].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  /// ====================================
  /// TOP STAT CARDS DATA (bind your real values here)
  /// ====================================
  final List<Map<String, dynamic>> statCardList = [
    {
      'icon': Icons.currency_rupee_rounded,
      'title': 'Monthly Salary',
      'value': '₹338',
      'gradient': [Color(0xFF11998E), Color(0xFF38EF7D)],
    },
    {
      'icon': Icons.event_available_rounded,
      'title': 'Present Days',
      'value': '24',
      'gradient': [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    },
    {
      'icon': Icons.event_busy_rounded,
      'title': 'Absent Days',
      'value': '2',
      'gradient': [Color(0xFFFF5F6D), Color(0xFFFFC371)],
    },
    {
      'icon': Icons.access_time_filled_rounded,
      'title': 'Total Hours',
      'value': '186h',
      'gradient': [Color(0xFF7F00FF), Color(0xFFE100FF)],
    },
    {
      'icon': Icons.beach_access_rounded,
      'title': 'Leave Balance',
      'value': '8',
      'gradient': [Color(0xFFF7971E), Color(0xFFFFD200)],
    },
    {
      'icon': Icons.timer_outlined,
      'title': 'Overtime',
      'value': '12h',
      'gradient': [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
    {
      'icon': Icons.watch_later_outlined,
      'title': 'Late Marks',
      'value': '3',
      'gradient': [Color(0xFFEE0979), Color(0xFFFF6A00)],
    },
    {
      'icon': Icons.pending_actions_rounded,
      'title': 'Half Day',
      'value': '1',
      'gradient': [Color(0xFF56CCF2), Color(0xFF2F80ED)],
    },
  ];

  /// ====================================
  /// STAT CARD WIDGET (icon + title + value)
  /// ====================================
  Widget buildStatCard(Map<String, dynamic> data) {
    final List<Color> gradient = data['gradient'] as List<Color>;

    return Container(
      width: 158,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// DECORATIVE FAINT BACKGROUND ICON
          Positioned(
            right: -22,
            bottom: -22,
            child: Icon(
              data['icon'] as IconData,
              size: 100,
              color: Colors.white.withOpacity(0.12),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ICON BADGE
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  data['icon'] as IconData,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const Spacer(),

              /// TITLE
              Text(
                data['title'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 6),

              /// VALUE
              Text(
                data['value'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // here you take TextFormField as a plaform


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
       // backgroundColor: const Color(0xFFF7F9FC),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF12B8C6),
          elevation: 0,
          centerTitle: true,

          title: const Text(
            'Daily Work Status',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
             // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashBoard()),
              );
            },
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ====================================
              /// TOP STAT CARDS (HORIZONTAL LIST)
              /// ====================================

              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: statCardList.length,
                  itemBuilder: (context, index) {
                    return buildStatCard(statCardList[index]);
                  },
                ),
              ),

              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        /// PROJECT NAME
                        buildInputRow(
                            icon: Icons.work_outline_rounded,
                            title: "Project Name",
                            child: _bindProject()
                        ),
                        const SizedBox(height: 10),
                        /// WORK DETAIL
                        buildInputRow(
                            icon: Icons.file_copy_outlined,
                            title: "Work Detail",
                            child: TextFormField(
                              controller: workDetailController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: null,
                              decoration: inputDecoration(
                                'Enter work detail',
                              ),
                            )
                        ),
                        const SizedBox(height: 10),
                        /// TIME SPENT
                        buildInputRow(
                            icon: Icons.watch_later_rounded,
                            title: "Time Spent (Minutes)",
                            child: TextFormField(
                              controller: timeSpentController,

                              keyboardType: TextInputType.number,

                              inputFormatters: [

                                /// ONLY INTEGER
                                FilteringTextInputFormatter.digitsOnly,

                                /// MAX 3 DIGITS
                                LengthLimitingTextInputFormatter(3),
                              ],

                              decoration: inputDecoration(
                                'Enter Minutes',
                              ),
                            )
                        ),
                        // const SizedBox(height: 10),
                        /// SUBMIT BUTTON
                        SizedBox(
                          width: size.width * .55,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF12B8C6),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(40),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () async {

                              print("-------xxxx----");

                              var projectCode = _selectedProjectCode;
                              var workDetail = workDetailController.text.trim();
                              var timeSpent = timeSpentController.text.trim();

                              print("-------projectCode--------$projectCode");
                              print("-------workDetail--------$workDetail");
                              print("-------timeSpent--------$timeSpent");

                              /// PROJECT VALIDATION
                              if (projectCode == null || projectCode.toString().isEmpty) {
                                displayToast("Please select a project");

                                return;
                              }

                              /// WORK DETAIL VALIDATION
                              if (workDetail.isEmpty) {

                                displayToast("Please enter work detail");
                                return;
                              }

                              /// TIME SPENT VALIDATION
                              if (timeSpent.isEmpty) {

                                displayToast("Please enter time spent");

                                return;
                              }
                              /// ALL VALIDATION SUCCESS
                              print("All fields are valid");

                              /// TODO API CALL
                              var map = await HrmsDailyActivityNew()
                                  .hrmsDailyActivityNew(context,projectCode,workDetail,timeSpent);
                              print("-------Daily Activity Response--------");
                              print(map);
                              var result = int.parse(map[0]['Result'].toString()); //map[0]['Result'];
                              var message = map[0]['Msg'];
                              print("-----result-------$result");
                              print("-----message-------$message");
                              if(result==1){
                                // call Daily Activity list
                                hrmsActivityList();
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _buildDialogSucces2(context, message),
                                );

                              }else{
                                // info Dialog
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _buildDialogInfo(context, message),
                                );
                              }
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              /// ====================================
              /// TODAY STATUS TITLE
              /// ====================================
              isLoading
                  ? SizedBox(
                height: 320,
                child: Container(),
                // child: Center(
                //   child: CircularProgressIndicator(),
                // ),
              )

                  : activityList.isEmpty

                  ? Container()
              :
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children:[
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
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Work Status",
                          style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                        ),
                        SizedBox(height: 5),
                        Text('$currentDate',style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF12B8C6),
                        ),)
                      ],
                    )
                  ],
                ),
              ),
              /// ====================================
              /// HORIZONTAL LIST
              /// ====================================

              isLoading
                  ? const SizedBox(
                height: 320,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )

                  : activityList.isEmpty

                  ? Container()
                 : Card(
                elevation: 5,

                color: Colors.white,

                margin: const EdgeInsets.all(10),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(10),

                  child: Container(
                    color: Colors.white,

                    child: SizedBox(
                      height: 260,

                      child: ListView.builder(

                        scrollDirection: Axis.horizontal,

                        physics: const BouncingScrollPhysics(),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),

                        itemCount: activityList.length,

                        itemBuilder: (context, index) {

                          var item = activityList[index];

                          return taskCard(item);
                        },
                      ),
                    ),
                  ),
                ),
              ),

              //     : Container(
              //    color: Colors.white,
              //
              //   child: SizedBox(
              //     height: 290,
              //
              //     child: ListView.builder(
              //
              //       scrollDirection: Axis.horizontal,
              //
              //       physics: const BouncingScrollPhysics(),
              //
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 16,
              //       ),
              //
              //       itemCount: activityList.length,
              //
              //       itemBuilder: (context, index) {
              //
              //         var item = activityList[index];
              //
              //         return taskCard(item);
              //       },
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// ====================================
  /// INPUT ROW WIDGET
  /// ====================================

  Widget buildInputRow({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final bool isIOS = Platform.isIOS;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isIOS ? 10 : 8,
        horizontal: isIOS ? 2 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
             padding: const EdgeInsets.only(top: 27),
             child: Container(
               height: 45,
               width: 45,

               decoration: BoxDecoration(
                 color: const Color(0xFF12B8C6).withOpacity(0.10),
                 borderRadius: BorderRadius.circular(12),
               ),

               child: Center(
                 child: Icon(
                   icon,
                   color: const Color(0xFF12B8C6),
                   size: 25,
                 ),
               ),
             ),
             // child: Container(
             //   height: 45,
             //   width: 45,
             //   child: Center(
             //     child: Icon(icon,
             //      color: Color(0xFF12B8C6),
             //      size: 25,
             //     ),
             //   ),
             // ),
           ),

          SizedBox(width: isIOS ? 5 : 6),
          /// TEXT + FIELD SECTION
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  title,
                  style: Platform.isIOS

                  /// IOS STYLE
                      ? const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    height: 1.3,
                    //color: Color(0xFF1E2230),
                    color: Colors.black
                  )

                  /// ANDROID MATERIAL STYLE
                      : const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                    height: 1.4,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: isIOS ? 10 : 8),
                /// INPUT CHILD
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ====================================
  /// INPUT DECORATION
  /// ====================================

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 5,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: const BorderSide(
          color: Color(0xFF12B8C6),
          width: 1.5,
        ),
      ),
    );
  }

  /// ====================================
  /// TASK CARD
  /// ====================================
  Widget taskCard(item) {

    return Container(
      width: 340,

      margin: const EdgeInsets.only(
        right: 14,
        bottom: 10,
      ),

      child: Card(

        color: Colors.white, // TOTAL WHITE

        elevation: 3,

        shadowColor: Colors.black12,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// TOP HEADER
              Row(
                children: [

                  /// IMAGE BOX
                  Padding(
                    padding: const EdgeInsets.only(top: 27),
                    child: Container(
                      height: 45,
                      width: 45,

                      decoration: BoxDecoration(
                        color: const Color(0xFF12B8C6).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Center(
                        child: Icon(
                          Icons.work_outline_rounded,
                          color: const Color(0xFF12B8C6),
                          size: 25,
                        ),
                      ),
                    ),
                    // child: Container(
                    //   height: 45,
                    //   width: 45,
                    //   child: Center(
                    //     child: Icon(icon,
                    //      color: Color(0xFF12B8C6),
                    //      size: 25,
                    //     ),
                    //   ),
                    // ),
                  ),
                  // Container(
                  //   height: 50,
                  //   width: 50,
                  //
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFF2FCFD),
                  //
                  //     borderRadius:
                  //     BorderRadius.circular(18),
                  //
                  //     border: Border.all(
                  //       color: const Color(0xFF12B8C6)
                  //           .withOpacity(.25),
                  //     ),
                  //   ),
                  //
                  //   child: const Padding(
                  //     padding: EdgeInsets.all(16),
                  //
                  //     child: Icon(
                  //       Icons.work_outline_rounded,
                  //       color: Color(0xFF12B8C6),
                  //       size: 25,
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          item['sProject'] ?? "",

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Project Name",

                          maxLines: 1,

                          overflow:
                          TextOverflow.ellipsis,

                          style: AppTextStyle
                              .font14OpenSansRegularBlackTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Divider(
                color: Colors.grey.shade200,
                thickness: 1,
              ),

              const SizedBox(height: 0),

              /// TASK DETAIL ROW
              Row(
                children: [

                  Expanded(
                    child: Row(
                      children: [

                        const Icon(
                          Icons.menu_open_rounded,
                          size: 20,
                          color: Colors.black54,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "Task Details",

                          style: AppTextStyle
                              .font14OpenSansRegularBlackTextStyle,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color:
                      Colors.red.withOpacity(.08),

                      borderRadius:
                      BorderRadius.circular(30),
                    ),

                    child: Row(
                      children: [

                        const Icon(
                          Icons.watch_later_rounded,
                          size: 16,
                          color: Colors.red,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          item['WorkingHrs'] ?? "",

                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ReadMoreText(
                  item['Activity'] ?? "",

                  trimLines: 3,

                  trimMode: TrimMode.Line,

                  trimCollapsedText: ' Read More',

                  trimExpandedText: ' Read Less',

                  style: AppTextStyle
                      .font14OpenSansRegularBlackTextStyle,

                  moreStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF12B8C6),
                  ),

                  lessStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF12B8C6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
  // Sucess and info Dialog

  // ---build dialog sucess
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
            height: 210,
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
                SingleChildScrollView(
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.justify, // Justify the text
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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

  // dialoginfo
  Widget _buildDialogInfo(BuildContext context, String msg) {
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
            height: 210,
            padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text('Information',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                SizedBox(height: 10),
                SingleChildScrollView(
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.justify, // Justify the text
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                  'assets/images/information.jpeg',
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
}
