import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final TextEditingController todaytaskfocus=
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
  var sEmpImage;

  /// SHOW/HIDE THE "TODAY'S WORK STATUS" LIST (hidden by default)
  bool isActivityVisible = false;

  /// SHOW/HIDE THE STAT CARD VALUES (hidden by default, shows '0' until toggled)
  bool isStatValueVisible = false;

  /// DROPDOWN
  String? selectedProject;
  var compleName,Acknowledgement;
  /// STAT CARDS AUTO-SCROLL
  final ScrollController _statScrollController = ScrollController();
  Timer? _statAutoScrollTimer;

  // project API Call
  @override
  void initState() {
    updateProject();
    activityParameterResponse();
    hrmsActivityList();
    getLocaldata();
    currentDate =
        DateFormat('dd-MMM-yyyy')
            .format(DateTime.now());

    print(currentDate);
    _startStatCardAutoScroll();
    super.initState();
  }

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sFirstName = prefs.getString('sFirstName');
    var sLastName = prefs.getString('sLastName');
    sEmpImage = prefs.getString('sEmpImage');
    // sEmpImage
    compleName = "$sFirstName $sLastName";
    setState(() {

    });
    print("-----84--$compleName");
    print("-----85----$sEmpImage");

  }

  @override
  void dispose() {
    _statAutoScrollTimer?.cancel();
    _statScrollController.dispose();
    super.dispose();
  }

  /// AUTO-SCROLL THE TOP STAT CARDS LEFT -> RIGHT, LOOPING BACK TO START
  void _startStatCardAutoScroll() {
    _statAutoScrollTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!_statScrollController.hasClients) return;

      final double maxScroll = _statScrollController.position.maxScrollExtent;
      final double next = _statScrollController.offset + 1.2;

      if (next >= maxScroll) {
        _statScrollController.jumpTo(0);
      } else {
        _statScrollController.jumpTo(next);
      }
    });
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

      activityList = map;

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

    print("Response:----136--xx-- $activityParameter");

    // Wait for 1 second
    await Future.delayed(const Duration(seconds: 1));

    if (activityParameter.isNotEmpty) {
      //  Acknowledgement
      Acknowledgement = activityParameter[0]["Acknowledgement"]?.toString() ?? "";
      print("----157--$Acknowledgement");
    }

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
  /// TOP STAT CARDS DATA
  /// ====================================
  /// Built from activityParameter[0], which the API returns as a single
  /// object holding 3 heading/value pairs, e.g.:
  /// { sHeading1: "...", sValue1: "...", sHeading2: "...", sValue2: "...",
  ///   sHeading3: "...", sValue3: "..." }
  ///
  /// 'title' -> shown in the small top text slot   (bound to sValueN)
  /// 'value' -> shown in the large bottom text slot (bound to sHeadingN)
  /// 'bgColor'    -> main card background (#EAF5FF sample)
  /// 'corner1'    -> bottom-right corner shape, lighter layer  (#CBEFFD sample)
  /// 'corner2'    -> bottom-right corner shape, darker layer   (#A8E1F7 sample)
  /// 'iconColor'  -> color of the icon inside the white circle
  /// 'iconAsset'  -> optional asset image path; when set, replaces the Icon
  ///                 inside the circle (share the assets and this will just work)
  List<Map<String, dynamic>> get statCardList {
    if (activityParameter.isEmpty) return [];

    final Map data = activityParameter[0];

    /// HIDDEN BY DEFAULT -> SHOWS '0' UNTIL THE EYE ICON IS TOGGLED ON
    String maskedValue(dynamic raw) {
      if (!isStatValueVisible) return '0';
      return raw?.toString() ?? '';
    }

    return [
      {
        'icon': Icons.beach_access_rounded,
        'title': maskedValue(data['sValue1']),
        'value': data['sHeading1']?.toString() ?? '',
        'bgColor': Color(0xFFEAF5FF),
        'corner1': Color(0xFFCBEFFD),
        'corner2': Color(0xFFA8E1F7),
        'iconColor': Color(0xFF11998E),
      },
      {
        'icon': Icons.event_available_rounded,
        'title': maskedValue(data['sValue2']),
        'value': data['sHeading2']?.toString() ?? '',
        'bgColor': Color(0xFFE9F8EB),
        'corner1': Color(0xFFD0FFE1),
        'corner2': Color(0xFFBBF2C8),
        'iconColor': Color(0xFF2E9E4F),
      },
      {
        'icon': Icons.currency_rupee_rounded,
        'title': maskedValue(data['sValue3']),
        'value': data['sHeading3']?.toString() ?? '',
        'bgColor': Color(0xFFFFF9F3),
        'corner1': Color(0xFFFFF0E3),
        'corner2': Color(0xFFFFDCC2),
        'iconColor': Color(0xFFEF8C3C),
      },
    ];
  }

  /// ====================================
  /// STAT CARD WIDGET (circle icon + title + value)
  /// ====================================
  Widget buildStatCard(Map<String, dynamic> data) {
    final Color bgColor = data['bgColor'] as Color? ?? const Color(0xFFEAF5FF);
    final Color corner1 = data['corner1'] as Color? ?? const Color(0xFFCBEFFD);
    final Color corner2 = data['corner2'] as Color? ?? const Color(0xFFA8E1F7);
    final Color iconColor = data['iconColor'] as Color? ?? const Color(0xFF12B8C6);
    final String? iconAsset = data['iconAsset'] as String?;

    return Container(
      width: 150,
      height: 140,
      margin: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          color: bgColor,
          child: Stack(
            children: [
              /// BOTTOM-RIGHT TWO-TONE DECORATIVE SHAPE
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 80,
                  child: CustomPaint(
                    size: const Size(180, 80),
                    painter: _CardCornerPainter(
                      color1: corner1,
                      color2: corner2,
                    ),
                  ),
                ),
              ),

              /// CARD CONTENT
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 14,
                  top: 10,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ICON CIRCLE (~46 x 46, white background)
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: iconAsset != null
                          ? ClipOval(
                        child: Image.asset(
                          iconAsset,
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      )
                          : Icon(
                        data['icon'] as IconData,
                        color: iconColor,
                        size: 20,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// TITLE (bound to sValueN)
                    Text(
                      data['title'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF5B6472),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    /// VALUE (bound to sHeadingN)
                    Text(
                      data['value'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1E2230),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// SHOW / HIDE TOGGLE (EYE ICON, LIKE A PASSWORD FIELD)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF12B8C6).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isStatValueVisible = !isStatValueVisible;
                          });
                        },
                        icon: Icon(
                          isStatValueVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: const Color(0xFF12B8C6),
                          size: 26,
                        ),
                        tooltip: isStatValueVisible ? 'Hide values' : 'Show values',
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 170,
                child: ListView.builder(
                  controller: _statScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: statCardList.length,
                  itemBuilder: (context, index) {
                    return buildStatCard(statCardList[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(8),

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
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
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
                            onPressed: () {

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

                              /// ALL VALIDATION SUCCESS -> SHOW THE CONFIRM/REMARKS DIALOG
                              /// (the API is only called from inside that dialog's Submit button)
                              print("All fields are valid");

                              _showRemarksDialog(
                                projectCode: projectCode.toString(),
                                workDetail: workDetail,
                                timeSpent: timeSpent,
                              );
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
              const SizedBox(height: 8),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                    Expanded(
                      child: Column(
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
                      ),
                    ),

                    /// SHOW / HIDE TOGGLE (EYE ICON, LIKE A PASSWORD FIELD)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF12B8C6).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isActivityVisible = !isActivityVisible;
                          });
                        },
                        icon: Icon(
                          isActivityVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: const Color(0xFF12B8C6),
                          size: 26,
                        ),
                        tooltip: isActivityVisible ? 'Hide list' : 'Show list',
                      ),
                    ),
                  ],
                ),
              ),
              /// ====================================
              /// VERTICAL LIST
              /// ====================================

              !isActivityVisible
                  ? Container()

                  : isLoading
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

                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8),

                  child: Container(
                    color: Colors.white,

                    child: ListView.builder(

                      scrollDirection: Axis.vertical,

                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: activityList.length,

                      itemBuilder: (context, index) {

                        var item = activityList[index];

                        return taskCard(item);
                      },
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
              const SizedBox(height: 8),
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
        vertical: isIOS ? 6 : 4,
        horizontal: isIOS ? 2 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
             padding: const EdgeInsets.only(top: 18),
             child: Container(
               height: 40,
               width: 40,

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
                SizedBox(height: isIOS ? 6 : 5),
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
        vertical: 4,
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
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 14,
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
                          item['sProject']?.toString() ?? "",

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
                          item['WorkingHrs']?.toString() ?? "",

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

              ReadMoreText(
                item['Activity']?.toString() ?? "",

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
            ],
          ),
        ),
      ),
    );
  }

  /// ====================================
  /// REMARKS CONFIRMATION DIALOG
  /// (employee image + greeting + acknowledgement + compulsory remarks field)
  /// The API is only called from the Submit button inside this dialog -
  /// the main-screen Submit button just validates and opens this dialog.
  /// ====================================
  void _showRemarksDialog({
    required String projectCode,
    required String workDetail,
    required String timeSpent,
  }) {
    final String? empImage = sEmpImage?.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// EMPLOYEE IMAGE + NAME
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFF12B8C6).withOpacity(0.10),
                        backgroundImage: (empImage != null && empImage.isNotEmpty)
                            ? NetworkImage(empImage)
                            : null,
                        child: (empImage == null || empImage.isEmpty)
                            ? const Icon(
                          Icons.person,
                          color: Color(0xFF12B8C6),
                          size: 28,
                        )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dear $compleName,',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2230),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// ACKNOWLEDGEMENT MESSAGE
                  ReadMoreText(
                    Acknowledgement ?? "",
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Read More',
                    trimExpandedText: ' Read Less',
                    textAlign: TextAlign.justify,
                    style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
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

                  const SizedBox(height: 14),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 8),

                  /// REMARKS LABEL
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Remarks ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// REMARKS INPUT (compulsory)
                  TextFormField(
                    controller: todaytaskfocus,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 4,
                    decoration: inputDecoration('Enter your remarks here...'),
                  ),

                  const SizedBox(height: 20),

                  /// CANCEL / SUBMIT
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF12B8C6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF12B8C6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF12B8C6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 3,
                          ),
                          onPressed: () async {

                            var todayTask = todaytaskfocus.text.trim();

                            /// REMARKS VALIDATION (compulsory)
                            if (todayTask.isEmpty) {
                              displayToast("Please enter your remarks");
                              return;
                            }

                            /// API CALL (only from here, not the main screen)
                            var map = await HrmsDailyActivityNew()
                                .hrmsDailyActivityNew(context, projectCode, workDetail, timeSpent, todayTask);
                            print("-------Daily Activity Response-----686-----");
                            print(map);
                            var result = int.parse(map[0]['Result'].toString());
                            var message = map[0]['Msg'];
                            print("-----result-------$result");
                            print("-----message-------$message");

                            Navigator.of(dialogContext).pop();

                            if (result == 1) {
                              /// CLEAR THE FORM SO THE MAIN SCREEN LOOKS FRESH
                              setState(() {
                                workDetailController.clear();
                                timeSpentController.clear();
                                todaytaskfocus.clear();
                                _dropDownSector = null;
                                _selectedProjectCode = null;
                              });

                              // call Daily Activity list
                              hrmsActivityList();
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    _buildDialogSucces2(context, message),
                              );
                            } else {
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
                ],
              ),
            ),
          ),
        );
      },
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

/// ====================================
/// STAT CARD BOTTOM-RIGHT CORNER PAINTER
/// (ported from the Android VectorDrawable path data,
/// scaled to fit whatever size it's painted into)
/// ====================================
class _CardCornerPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  _CardCornerPainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final double sx = size.width / 180;
    final double sy = size.height / 80;

    // Layer 1 - #CBEFFD
    final Path path1 = Path()
      ..moveTo(65 * sx, 80 * sy)
      ..cubicTo(95 * sx, 72 * sy, 112 * sx, 55 * sy, 132 * sx, 38 * sy)
      ..cubicTo(148 * sx, 25 * sy, 162 * sx, 15 * sy, 180 * sx, 0 * sy)
      ..lineTo(180 * sx, 80 * sy)
      ..close();
    canvas.drawPath(path1, Paint()..color = color1);

    // Layer 2 - #A8E1F7
    final Path path2 = Path()
      ..moveTo(108 * sx, 80 * sy)
      ..cubicTo(128 * sx, 66 * sy, 144 * sx, 52 * sy, 158 * sx, 36 * sy)
      ..cubicTo(168 * sx, 24 * sy, 175 * sx, 15 * sy, 180 * sx, 10 * sy)
      ..lineTo(180 * sx, 80 * sy)
      ..close();
    canvas.drawPath(path2, Paint()..color = color2);
  }

  @override
  bool shouldRepaint(covariant _CardCornerPainter oldDelegate) {
    return oldDelegate.color1 != color1 || oldDelegate.color2 != color2;
  }
}
