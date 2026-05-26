import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:readmore/readmore.dart';
import '../../data/district_repo.dart';
import '../../data/hrmsActivityListRepo.dart';
import '../../data/hrmsDailyActivityNewRepo.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class WorkDetailNew extends StatefulWidget {
  const WorkDetailNew({super.key});

  @override
  State<WorkDetailNew> createState() =>
      _DailyWorkStatusScreenState();
}

class _DailyWorkStatusScreenState
    extends State<WorkDetailNew> {

  /// CONTROLLERS
  final TextEditingController workDetailController =
  TextEditingController();

  final TextEditingController timeSpentController =
  TextEditingController();
  List<dynamic>?  baseProjectList;
  List<dynamic> distList = [];
  var _dropDownSector;
  final sectorFocus = GlobalKey();
  var _selectedProjectCode;
  List<dynamic> activityList = [];

  bool isLoading = false;

  /// DROPDOWN
  String? selectedProject;

  // project API Call
  @override
  void initState() {
    updateProject();
    hrmsActivityList();
    super.initState();
  }

  // HrmsActivityList
  //   void hrmsActivityList() async {
  //     var map = await HrmsActivityList()
  //         .hrmsActivityList(context);
  //     print("--------50------HRMS Daily Activity--------");
  //     print(map);
  // }

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
    distList = await ProjectRepo().projectList();
    print(" -----xxxxx-  projectList--46---> $distList");
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
  // widget
  Widget buildPlatformImageCard({
    required String imagePath,
    double height = 150,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Platform.isIOS
            ? CupertinoColors.white
            : Colors.white,
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
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
              /// TOP IMAGE
              /// ====================================

              buildPlatformImageCard(
                imagePath: 'assets/images/workstatus3.jpeg',
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
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
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: null,
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
              const SizedBox(height: 10),
              /// ====================================
              /// TODAY STATUS TITLE
              /// ====================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    Text(
                      "Today's Work Status",
                      style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              /// ====================================
              /// HORIZONTAL LIST
              /// ====================================

              isLoading
                  ? const SizedBox(
                height: 290,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )

                  : activityList.isEmpty

                  ? Container()

                  : Container(
                color: Colors.white,

                child: SizedBox(
                  height: 290,

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
              // Container(
              //   color: Colors.white,
              //   child: SizedBox(
              //     height: 290,
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       physics: const BouncingScrollPhysics(),
              //
              //       padding:
              //       const EdgeInsets.symmetric(horizontal: 16),
              //
              //       itemCount: 5,
              //
              //       itemBuilder: (context, index) {
              //         return taskCard();
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
               child: Center(
                 child: Icon(icon,
                  color: Color(0xFF12B8C6),
                  size: 25,
                 ),
               ),
             ),
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
      color: Colors.white,
      margin: const EdgeInsets.only(right: 14, bottom: 10),

      child: Card(
        elevation: 5,
        //shadowColor: Colors.black12,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP HEADER
                Row(
                  children: [
                    /// IMAGE BOX
                    Container(
                      height: 50,
                      width: 50,
                      //color: Colors.white,

                      decoration: BoxDecoration(
                        color: const Color(0xFFF2FCFD),
                        borderRadius: BorderRadius.circular(18),

                        border: Border.all(
                          color: const Color(0xFF12B8C6)
                              .withOpacity(.25),
                        ),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Image.asset(
                          'assets/images/tripicon.jpeg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// TITLE
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children:[

                          Text(
                            item['sProject'] ?? "",
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

                          SizedBox(height: 6),

                          Text(
                            "Project Name",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.font14OpenSansRegularBlackTextStyle,

                            // style: TextStyle(
                            //   fontSize: 14,
                            //   color: Colors.black54,
                            // ),
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

                const SizedBox(height: 10),

                /// TASK DETAIL ROW
                Row(
                  children: [

                    Expanded(
                      child: Row(
                        children:[

                          Icon(
                            Icons.menu_open_rounded,
                            size: 20,
                            color: Colors.black54,
                          ),

                          SizedBox(width: 6),

                          Text(
                            "Task Details",
                            style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                          ),
                        ],
                      ),
                    ),

                    /// TIME CONTAINER
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(.08),
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: Row(
                        children: [

                          Icon(
                            Icons.watch_later_rounded,
                            size: 16,
                            color: Colors.red,
                          ),

                          SizedBox(width: 5),

                          Text(
                            item['WorkingHrs'] ?? "",
                            style: TextStyle(
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

                /// DESCRIPTION
                Expanded(
                  child: ReadMoreText(
                    item['Activity'] ?? "",

                    trimLines: 3,
                    trimMode: TrimMode.Line,

                    trimCollapsedText: ' Read More',
                    trimExpandedText: ' Read Less',

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
                ),
              ],
            ),
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
