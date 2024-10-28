import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/hrmsAttendanceRepo.dart';
import '../dashboard/dashboard.dart';
import 'dart:convert';

class CustomCalendarScreen extends StatefulWidget {

  @override
  _CustomCalendarScreenState createState() => _CustomCalendarScreenState();
}

class _CustomCalendarScreenState extends State<CustomCalendarScreen> {

  var attendaceResponse;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  late ScrollController _scrollController;
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
  late String selectedMonth;

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

  //
  @override
  void initState() {
    getAttendaceResponse();
    _scrollController = ScrollController();
    selectedMonth = getCurrentMonth();
    selectedMonth = capitalizeFirstLetter(selectedMonth);
    print('----82---$selectedMonth');
    // Scroll to the current month after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
    super.initState();
  }

  getAttendaceResponse() async {
    DateTime now = DateTime.now();
    var currentYear = now.year;
    var selectedMonth = DateFormat('MMM').format(now);
    attendaceResponse = await HrmsAttendanceRepo().attendance(context,selectedMonth);
    print("Attendance response -----106---: $attendaceResponse");
    // Extract the object from the array
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
  // clear list

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
      body: Column(
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
          Container(
            height: 328,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDate,
              calendarFormat: _calendarFormat,
              headerVisible: false,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDate = focusedDay;
                });
                print("Selected Date: $selectedDay");
              },
              calendarBuilders: CalendarBuilders(
                // Customize the day cells
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
                    clearList();
                    setState(() {
                      _onMonthSelected(index);
                      selectedMonth = months[index];
                     getResponseOnListClick(selectedMonth);
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
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.watch_later_rounded, size: 20),
                SizedBox(width: 10),
                Text(
                  'Present : Check In Time (25/Oct/2024 09 :24)',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Table(
              border: TableBorder.all(),
              // Adds a border around the table and cells
              children: List.generate(3, (rowIndex) {
                return TableRow(
                  children: List.generate(3, (columnIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            color: Colors.blue, // Color of the 10x10 box
                          ),
                          SizedBox(height: 8), // Space between Container and Text
                          Text("Present (${rowIndex * 3 + columnIndex + 1})"),
                        ],
                      ),
                    );
                  }),
                );
              }),
            ),
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
