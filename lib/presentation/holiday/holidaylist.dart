import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/data/holidaylist.dart';
import '../../domain/holidaylist_model.dart';
import '../dashboard/dashboard.dart';

class Holidaylist extends StatelessWidget {

  const Holidaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HolidaylistScreen(),
    );
  }
}

class HolidaylistScreen extends StatefulWidget {

  const HolidaylistScreen({super.key});

  @override
  State<HolidaylistScreen> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<HolidaylistScreen> {

  // month name list
  late Future<List<HolidayListModel>> holidayList;
  List<HolidayListModel> filteredHolidayList = [];
// Default month
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


  final List<Color> colorList = [
    Color(0xFF4DB6AC),
    Color(0xFFE1A245),
    Color(0xFFC888D3),
    Color(0xFFE88989),
    Color(0xFFA6A869),
    Color(0xFF379BF3),
  ];
  var randomColor;
  late String selectedMonth ;
  late ScrollController _scrollController;


  /// TODO  get the current Month -- selectedMonth
  ///
  String getCurrentMonth() {
    DateTime now = DateTime.now(); // Get the current date and time
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
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
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  // convet month name
  String capitalizeFirstLetter(String month) {
    // Convert the first letter to uppercase and the rest to lowercase
    return month[0].toUpperCase() + month.substring(1).toLowerCase();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    holidayList = HolidayListRepo().holidayList(context);
     selectedMonth = getCurrentMonth();
    capitalizeFirstLetter(selectedMonth);
    selectedMonth = capitalizeFirstLetter(selectedMonth);
    print('----82---$selectedMonth');
    holidayList.then((holidays) {
      filterByMonth(holidays, selectedMonth);
    });


    // Initialize the scroll controller
    _scrollController = ScrollController();

    // Scroll to the current month after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });

  }
  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the scroll controller
    super.dispose();
  }

  // Function to filter the holidays based on the selected month
  void filterByMonth(List<HolidayListModel> holidays, String month) {
    setState(() {
      filteredHolidayList =
          holidays.where((holiday) => holiday.getMonth() == month).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar
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
                'Holiday List',
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
              // Horizontal Month ListView
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: months.length,
                    itemBuilder: (context, index) {
                      String month = months[index];
                      bool isSelectedMonth = month == selectedMonth;

                      return InkWell(
                        onTap: () {

                          setState(() {
                            selectedMonth = month;
                            print('----177--$selectedMonth');
                          });
                          // Scroll to the newly selected month
                          _scrollToCurrentMonth();

                          // Fetch filtered holiday list for the selected month
                          holidayList.then((holidays) {
                            filterByMonth(holidays, month);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            decoration: BoxDecoration(
                              color: isSelectedMonth
                                  ? Color(0xFF0098a6)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              month,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black45),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15),
                child: Container(
                  height: 0.5,
                  color: Color(0xff3f617d),
                ),
              ),

              // Vertical Holiday ListView
              Expanded(
                child: FutureBuilder<List<HolidayListModel>>(
                  future: holidayList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (filteredHolidayList.isEmpty) {
                      return Center(
                          child: Text('No holidays lies in this month!'));
                    }

                    return ListView.builder(
                      itemCount: filteredHolidayList.length,
                      itemBuilder: (context, index) {
                        final holiday = filteredHolidayList[index];
                        final randomColor = colorList[index % colorList.length];


                        return Container(
                         // margin: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, top: 5, bottom: 5),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                          color:randomColor,
                                          width: 4),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        holiday.sDate,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Container(height: 50, width: 1, color: Colors.grey),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      holiday.sDayName,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    Text(
                                      holiday.sHolidayName,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
