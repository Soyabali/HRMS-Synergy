import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/attendaceStatusRepo.dart';
import '../../data/hrmsAttendanceRepo.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';

class CustomCalendarScreen extends StatefulWidget {

  @override
  _CustomCalendarScreenState createState() => _CustomCalendarScreenState();
}

class _CustomCalendarScreenState extends State<CustomCalendarScreen> {

 late var attendaceResponse;
 late var attendaceResponse2;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  late ScrollController _scrollController;
  var formatDate;
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  List<int>? sPresents;
  late List<int>? sAbsent;
  late List<int>? sLeave;
  late List<int>? sHalfDay;
  late List<int>? sHolidays;
  late List<int>? sLateComing;
  late List<int>? sEarlyGoing;
  late List<int>? sLcEg;
  late List<int>? sOnSite;
  late List<int>? sWeeklyOff;
  //
  String? sPresentsText;
  String? sAbsentText;
  String? sLeaveText;
  String? sHalfDayText;
  String? sHolidaysText;
  String? sLateComingText;
  String? sEarlyGoingText;
  String? sLcEgText;
  String? sOnSiteText;
  String? sWeeklyOffText;

  late String selectedMonth;
  var  hrmsattendancestatu;
  var firstDateOfMonth;
  Color? color;
  Color? txtColor;
  bool isLoading = true;

  // Method to change month on month selection from horizontal list

  void _onMonthSelected(int monthIndex) {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, monthIndex + 1);
      print('-------48----$_focusedDate');
    });
  }
  String getCurrentMonth() {
    DateTime now = DateTime.now(); // Get the current date and time
    return months[now.month - 1]; // Return the current month as a string
  }
  void _scrollToCurrentMonth() {
    int selectedIndex = months.indexOf(selectedMonth);
    // Assuming each item is approximately 80 pixels wide, adjust based on actual width
    double offset = selectedIndex * 80.0;
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  // String getCurrentMonthFirstDate() {
  //   DateTime now = DateTime.now();
  //   DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
  //   return DateFormat("d/MMM/yyyy").format(firstDayOfMonth);
  // }

  String getCurrentMonthFirstDate() {
    DateTime now = DateTime.now();
    return DateFormat("d/MMM/yyyy").format(now);
  }


  @override
  void initState() {
    getCurrentMonthFirstDate();
    getAttendaceResponse();
    _scrollController = ScrollController();
    selectedMonth = getCurrentMonth();
    selectedMonth = capitalizeFirstLetter(selectedMonth);
    print('----82---$selectedMonth');
    // Scroll to the current month after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
    responseStatus(formatDate);
    super.initState();
  }

  getAttendaceResponse() async {
    setState(() {
      isLoading = true; // Show loading
    });

    DateTime now = DateTime.now();
    var currentYear = now.year;
    var selectedMonth = DateFormat('MMM').format(now);
    try {
      attendaceResponse = await HrmsAttendanceRepo().attendance(context, selectedMonth);
      Map<String, dynamic> attendanceData = attendaceResponse[0];

      List<int> parseToList(String? value) {
        if (value != null && value.isNotEmpty) {
          return value.split(',').map(int.parse).toList();
        } else {
          return [];
        }
      }

      setState(() {
        sPresents = parseToList(attendanceData['sPresents']);
        sAbsent = parseToList(attendanceData['sAbsent']);
        sLeave = parseToList(attendanceData['sLeave']);
        sHalfDay = parseToList(attendanceData['sHalfDay']);
        sHolidays = parseToList(attendanceData['sHolidays']);
        sLateComing = parseToList(attendanceData['sLateComing']);
        sEarlyGoing = parseToList(attendanceData['sEarlyGoing']);
        sLcEg = parseToList(attendanceData['sLcEg']);
        sOnSite = parseToList(attendanceData['sOnSite']);
        sWeeklyOff = parseToList(attendanceData['sWeeklyOff']);

        sPresentsText = sPresents!.join(", ");
        sAbsentText = sAbsent!.join(", ");
        sLeaveText = sLeave!.join(", ");
        sHalfDayText = sHalfDay!.join(", ");
        sHolidaysText = sHolidays!.join(", ");
        sLateComingText = sLateComing!.join(", ");
        sEarlyGoingText = sEarlyGoing!.join(", ");
        sLcEgText = sLcEg!.join(", ");
        sOnSiteText = sOnSite!.join(", ");
        sWeeklyOffText = sWeeklyOff!.join(", ");

        // Hide loading
        setState(() {
          isLoading = false;
        });
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Hide loading on error
      });
      // Optionally, display an error message
      print("Error fetching attendance data: $error");
    }
  }

  void clearList() {
    setState(() {
      sPresents?.clear();
      sAbsent?.clear();
      sLeave?.clear();
      sHalfDay?.clear();
      sHolidays?.clear();
      sLateComing?.clear();
      sEarlyGoing?.clear();
      sLcEg?.clear();
      sOnSite?.clear();
      sWeeklyOff?.clear();
    });
  }

  String capitalizeFirstLetter(String month) {
    // Convert the first letter to uppercase and the rest to lowercase
    return month[0].toUpperCase() + month.substring(1).toLowerCase();
  }
  // getAresponse on a listClick
  getResponseOnListClick(String selectedMonth) async {
   // DateTime now = DateTime.now();
    //var currentYear = now.year;
    print('---203--SelectedMonth---$selectedMonth');
    attendaceResponse = await HrmsAttendanceRepo().attendance(context,selectedMonth);
    print("Attendance response----146--- : $attendaceResponse");
    Map<String, dynamic> attendanceData = attendaceResponse[0];
    // Function to convert the string to a list of integers

    List<int> parseToList(String? value) {
      if (value != null && value.isNotEmpty) {
        return value.split(',').map(int.parse).toList();
      } else {
        return [];
      }
    }
    // Convert each key to a list of integers

    setState(() {
      sPresents = (parseToList(attendanceData['sPresents']));
      sAbsent = (parseToList(attendanceData['sAbsent']));
      sLeave = (parseToList(attendanceData['sLeave']));
      sHalfDay = (parseToList(attendanceData['sHalfDay']));
      sHolidays = (parseToList(attendanceData['sHolidays']));
      sLateComing = (parseToList(attendanceData['sLateComing']));
      sEarlyGoing = (parseToList(attendanceData['sEarlyGoing']));
      sLcEg = (parseToList(attendanceData['sLcEg']));
      sOnSite = (parseToList(attendanceData['sOnSite']));
      sWeeklyOff = (parseToList(attendanceData['sWeeklyOff']));
    });

    sPresentsText = sPresents!.join(", ");
    sAbsentText = sAbsent!.join(", ");
    sLeaveText = sLeave!.join(", ");
    sHalfDayText = sHalfDay!.join(", ");
    sHolidaysText = sHolidays!.join(", ");
    sLateComingText = sLateComing!.join(", ");
    sEarlyGoingText = sEarlyGoing!.join(", ");
    sLcEgText = sLcEg!.join(", ");
    sOnSiteText = sOnSite!.join(", ");
    sWeeklyOffText = sWeeklyOff!.join(", ");
    // Print results
    print("sPresents: $sPresents");
    print("sAbsent: $sAbsent");
    print("sLeave: $sLeave");
    print("sHalfDay: $sHalfDay");
    print("sHolidays: $sHolidays");
    print("sLateComing: $sLateComing");
    print("sEarlyGoing: $sEarlyGoing");
    print("sLcEg: $sLcEg");
    print("sOnSite: $sOnSite");
    print("sWeeklyOff: $sWeeklyOff");
  }
  // clear list data
  // dateFormatChange
  String getFormattedDate(DateTime date) {
    return DateFormat("dd/MMM/yyyy").format(date);
  }

  Future<void> responseStatus(String? selectedDate) async {
    // If selectedDate is null, use the first date of the current month
    String dateToUse = selectedDate ?? getCurrentMonthFirstDate();
     print('-----234---$dateToUse');
    var responseStatus = await AttendanceStatusRepo().attendanceStatus(context, dateToUse);

    if (responseStatus != null && responseStatus != "") {
      setState(() {
        hrmsattendancestatu = "${responseStatus[0]['sAttendanceStatus']}";
      });
      print('-----241----$hrmsattendancestatu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF2a697b),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        backgroundColor: Color(0xFF0098a6),
        leading: InkWell(
          onTap: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashBoard()),
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
            'Attendance',
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
      body:isLoading
          ? Center(child: CircularProgressIndicator()) :
      SingleChildScrollView(
        child: Column(
          children: [
            // Row with month name and year
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    months[_focusedDate.month - 1].toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _focusedDate.year.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Calendar Widget
            if(isLoading)
              Center(
                child: CircularProgressIndicator(), // Show loader when isLoading is true
              )else
        Container(
        height: 328,
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDate,
          calendarFormat: _calendarFormat,
          headerVisible: false,
          availableGestures: AvailableGestures.none, // Disable all scrolling gestures
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              _focusedDate = focusedDay;
            });
            formatDate = getFormattedDate(selectedDay);
            print("Selected Date: xxxx $selectedDay");
            print("----289---" + formatDate);
            /// todo call api here
            responseStatus(formatDate);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              if (sPresents!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFF689F38));
              } else if (sAbsent!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFF7C0A02));
              } else if (sLeave!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFF1157C3));
              } else if (sHalfDay!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFFCFB203));
              } else if (sHolidays!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFF0097A7));
              } else if (sLateComing!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFFFFA000));
              } else if (sEarlyGoing!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFFd93124));
              } else if (sLcEg!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFFF57C00));
              } else if (sOnSite!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFF006064));
              } else if (sWeeklyOff!.contains(day.day)) {
                return _buildCalendarDay(day, Color(0xFF006064));
              }
              return _buildCalendarDay(day, null);
            },
          ),
        ),
      ),

            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: months.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                   // onTap: ()=>_onMonthSelected(index),
                    onTap: () {
                      // currect date
                      clearList();
                      // to pick a current date
                      DateTime now = DateTime.now();
                      // Store the current date in a variable
                      String currentDate = DateFormat("d/MMM/yyyy").format(now);
                     // responseStatus(currentDate);
                      setState(() {
                        _onMonthSelected(index);
                        selectedMonth = months[index];
                       getResponseOnListClick(selectedMonth);
                        responseStatus(formatDate);
                      });
                      },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        label: Text(
                          months[index],
                          style: TextStyle(
                                color: index + 1 == _focusedDate.month
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        backgroundColor: index + 1 == _focusedDate.month
                            ? Color(0xFF0098a6)
                            : Colors.grey[200],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.watch_later_rounded, size: 20),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '${hrmsattendancestatu}',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                      maxLines: 1, // Limits to a single line
                      overflow: TextOverflow.ellipsis, // Adds "..." if the text overflows
                      softWrap: false, // Prevents wrapping to a new line
                    ),
                  ),
                  // Text('${hrmsattendancestatu}',
                  //   style: TextStyle(
                  //     color: Colors.black45,
                  //     fontSize: 14,
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      cellContent("Present (${sPresents?.length})"),
                      cellContent("Absent (${sAbsent?.length})"),
                      cellContent("Leave (${sLeave?.length})"),
                    ],
                  ),
                  TableRow(
                    children: [
                      cellContent("Late Entry (${sLateComing?.length})"),
                      cellContent("Early Exit (${sEarlyGoing?.length})"),
                      cellContent("Holiday (${sHolidays?.length})"),
                    ],
                  ),
                  TableRow(
                    children: [
                      cellContent("Half Day (${sHalfDay?.length})"),
                      cellContent("Weekly Off (${sWeeklyOff?.length})"),
                     // cellContent("Late Entry + Early Exit (${sLcEg?.length})"),
                      //
                      Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 16,
                  height: 16,
                  color: Color(0xFF7B1FA2),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  "Late Entry + Early Exit (${sLcEg?.length})",
                  style: TextStyle(
                    color: Color(0xFF7B1FA2),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center, // Centers the text horizontally
                  softWrap: true, // Allows text to wrap if too long
                ),
              ),
            ],
          ),
        ),
      ),

                    ],
                  ),
                ],
        
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFF689F38),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Present",
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFF689F38),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sPresentsText == null || sPresentsText == "0") ? "There is no Present in this month." : sPresentsText!,
                          style: TextStyle(
                            color: Color(0xFF689F38),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 3, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
                        ),
                      ),
                      // Flexible(
                      //   child: Text(
                      //     sPresentsText!,
                      //     style: TextStyle(
                      //       color: Color(0xFF689F38),
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.normal
                      //     ),
                      //     maxLines: 2, // Limits to 2 lines
                      //     overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                      //     softWrap: true, // Allows text to wrap to the next line
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFF7C0A02),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Absent",
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFF7C0A02),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sAbsent == null || sAbsent == "0" || sAbsent!.isEmpty) ? "There is no absent in this month." : sAbsentText!,
                          style: TextStyle(
                            color: Color(0xFF7C0A02),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFF1157C3),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Leave",
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFF1157C3),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sLeave == null || sLeave == "0" || sLeave!.isEmpty) ? "There is no Leave in this month." : sLeaveText!,
                          style: TextStyle(
                            color:Color(0xFF1157C3),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFA000),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Late Entry",
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFFFFA000),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sLateComing == null || sLateComing == "0" || sLateComing!.isEmpty) ? "There is no Late Entry in this month." : sLateComingText!,
                          style: TextStyle(
                            color: Color(0xFFFFA000),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFFd93124),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Early Exit",
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFFd93124),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sEarlyGoing == null || sEarlyGoing == "0" || sEarlyGoing!.isEmpty) ? "There is no Early Exit in this month." : sEarlyGoingText!,
                          style: TextStyle(
                            color: Color(0xFFd93124),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFF0097A7),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Holiday",
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFF0097A7),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sHolidays == null || sHolidays == "0" || sHolidays!.isEmpty) ? "There is Holiday in this month." : sHolidaysText!,
                          style: TextStyle(
                            color: Color(0xFF0097A7),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFFCFB203),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Half Day",
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFFCFB203),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sHalfDay == null || sHalfDay == "0" || sHalfDay!.isEmpty) ? "There is no Half Day in this month." : sHalfDayText!,
                          style: TextStyle(
                            color: Color(0xFF0097A7),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFF006064),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Weekly Off",
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFF006064),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sWeeklyOff == null || sWeeklyOff == "0" || sWeeklyOff!.isEmpty) ? "There is no Weekly Off Day in this month." : sWeeklyOffText!,
                          style: TextStyle(
                            color: Color(0xFF006064),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5,
                color: Colors.white, // Set the background color as needed
                borderRadius: BorderRadius.circular(5), // Optional: rounded corners for the whole container
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10), // Padding for top-right and bottom-right
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFF7B1FA2),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25), // Top-right radius of 25
                              bottomRight: Radius.circular(25), // Bottom-right radius of 25
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Late Entry + Early Exit",
                              style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color:Color(0xFF7B1FA2),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          (sLcEg == null || sLcEg == "0" || sLcEg!.isEmpty) ? "There is no Late Entry + Early Exit in this month." : sLcEgText!,
                          style: TextStyle(
                            color: Color(0xFF7B1FA2),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                          softWrap: true, // Allows text to wrap to the next line
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
    );
  }
  Widget cellContent(String textValue) {
    // Color color = textValue.contains("Present") ?? Colors.green
    //     ?? textValue.contains("Absent") Colors.red;
     color;
     if(textValue.contains("Present")){
       color = Color(0xFF689F38);
       txtColor = Color(0xFF689F38);
     }else if(textValue.contains("Absent")){
       color = Color(0xFF7C0A02);
       txtColor = Color(0xFF7C0A02);
     }else if(textValue.contains("Leave")){
       color = Color(0xFF1157C3);
       txtColor = Color(0xFF1157C3);
     }else if(textValue.contains("Late Entry")){
       color = Color(0xFFFFA000);
       txtColor = Color(0xFFFFA000);
     }else if(textValue.contains("Early Exit")){
       color =Color(0xFFd93124);
       txtColor = Color(0xFFd93124);
     }else if(textValue.contains("Holiday")){
       color = Color(0xFF0097A7);
       txtColor =Color(0xFF0097A7);
     }else if(textValue.contains("Half Day")){
       color = Color(0xFFCFB203);
       txtColor = Color(0xFFCFB203);
     }else if(textValue.contains("Weekly Off")){
       color = Color(0xFF006064);
       txtColor = Color(0xFF006064);
     }else if(textValue.contains("Late Entry + Early Exit")){
       color = Color(0xFF7B1FA2);
       txtColor =Color(0xFF7B1FA2);
     }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Border radius of 5
            child: Container(
              width: 16,
              height: 16,
              color: color, // Color of the 10x10 box
            ),
          ),
          SizedBox(height: 8), // Space between Container and Text
          Center(
            child: Text(textValue,style: TextStyle(
              color: txtColor,
              fontSize: 14,
            ),),
          ),
        ],
      ),
    );
  }

  // Widget to build calendar day with color circles
  Widget _buildCalendarDay(DateTime day, Color? color) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: color != null ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
