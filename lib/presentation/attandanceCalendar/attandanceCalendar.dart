import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {

  DateTime selectedDate = DateTime.now();
  List<DateTime> daysInMonth = [];

  @override
  void initState() {
    super.initState();
    generateCalendarDays(selectedDate);
  }

  // Generate days for the calendar month
  void generateCalendarDays(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday;
    final totalDays = lastDayOfMonth.day;

    // Adjusting days before the start of the month (for proper alignment)
    List<DateTime> days = [];
    for (int i = firstDayOfWeek - 1; i > 0; i--) {
      days.add(firstDayOfMonth.subtract(Duration(days: i)));
    }

    // Adding days of the current month
    for (int i = 0; i < totalDays; i++) {
      days.add(firstDayOfMonth.add(Duration(days: i)));
    }

    setState(() {
      daysInMonth = days;
    });
  }

  // For navigating between months
  void goToNextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      generateCalendarDays(selectedDate);
    });
  }

  void goToPreviousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      generateCalendarDays(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: goToPreviousMonth,
            ),
            Text(
              DateFormat.yMMMM().format(selectedDate),  // Month and year
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: goToNextMonth,
            ),
          ],
        ),

        // Day labels (Mon, Tue, etc.)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((day) => Expanded(
            child: Center(
              child: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ))
              .toList(),
        ),

        // Calendar days
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 days per week
            ),
            itemCount: daysInMonth.length,
            itemBuilder: (context, index) {
              DateTime day = daysInMonth[index];
              bool isCurrentMonth = day.month == selectedDate.month;

              return GestureDetector(
                onTap: () {
                  // Handle day tap
                  setState(() {
                    selectedDate = day;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isCurrentMonth
                        ? (day.day == selectedDate.day
                        ? Colors.blue
                        : Colors.transparent)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isCurrentMonth ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
