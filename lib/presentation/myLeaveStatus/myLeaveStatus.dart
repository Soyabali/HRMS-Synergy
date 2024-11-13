import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:untitled/presentation/myLeaveStatus/pending.dart';
import 'package:untitled/presentation/myLeaveStatus/rejected.dart';
import 'package:untitled/presentation/myLeaveStatus/sanctioned.dart';
import '../../app/generalFunction.dart';
import '../../domain/leaveStatusModel.dart';
import '../dashboard/dashboard.dart';
import 'all.dart';

class Myleavestatus extends StatelessWidget {

  const Myleavestatus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyLeaveStatusPage(),
    );
  }
}

class MyLeaveStatusPage extends StatefulWidget {

  const MyLeaveStatusPage({super.key});

  @override
  State<MyLeaveStatusPage> createState() => _MyLeaveStatusPageState();
}

class _MyLeaveStatusPageState extends State<MyLeaveStatusPage> with TickerProviderStateMixin {
// with SingleTickerProviderStateMixin {
  //
  late Future<List<HrmsLeaveStatusModel>> hrmsLeaveStatus;
  String status = 'P';

  GeneralFunction generalFunction = new GeneralFunction();
  TabController? tabController;
  String? tempDate;
  String? formDate;
  String? toDate;

  getACurrentDate() {

    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    formDate = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    setState(() {
    });

    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    toDate = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);
    setState(() {
    });
  }

  void _handleTabSelection() {
    tabController = TabController(vsync: this, length: 4);
    tabController?.addListener(() {
      if (tabController!.indexIsChanging) {
        print('Tab ${tabController!.index + 1} is open');
        switch(tabController!.index){
          case 0:
            setState(() {
              PendingPage(formDate:formDate,toDate:toDate);
            });
            break;
          case 1:
            setState(() {
              SanctionedPage(formDate:formDate,toDate:toDate);
            });
            break;
          case 2:
            setState(() {
              RejectedPage(formDate:formDate,toDate:toDate);
            });
            break;
          case 3:
            setState(() {
              AllPage(formDate:formDate,toDate:toDate);
            });
            break;
        }
      }
    });
  }
  // to Date SelectedLogic

  void toDateSelectLogic() {
    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    DateTime? fromDate2 = dateFormat.parse(formDate!);
    DateTime? toDate2 = dateFormat.parse(toDate!);

    if (toDate2.isBefore(fromDate2)) {
      setState(() {
        toDate = tempDate;
      });
      generalFunction.displayToast("To Date can not be less than From Date");
    }else{
      _handleTabSelection();
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
    }else{
      //here apply logic to change tab and update date
      _handleTabSelection();
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    getACurrentDate();
    tabController = TabController(length: 4, vsync: this);
    tabController?.addListener(_handleTabSelection);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController?.removeListener(_handleTabSelection);
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
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
                  'My Leave Status',
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
                          color: Color(0xFF0098a6)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                    size: 15,
                                    color: Colors.white),
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
                                      String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                      setState(() {
                                        tempDate = formDate; // Save the current formDate before updating
                                        formDate = formattedDate;
                                        // --
                                        tabController = TabController(vsync: this, length: 4);
                                        tabController?.addListener(() {
                                          if (tabController!.indexIsChanging) {
                                            print('Tab ${tabController!.index + 1} is open');
                                            switch(tabController!.index){
                                              case 0:
                                                print('------282------0----index---');
                                                setState(() {
                                                  PendingPage(formDate:formDate,toDate:toDate);
                                                });
                                                break;
                                              case 1:
                                                print('------288------1----index---');
                                                setState(() {
                                                  SanctionedPage(formDate:formDate,toDate:toDate);
                                                });
                                                break;
                                              case 2:
                                                print('------294------2----index---');
                                                setState(() {
                                                  RejectedPage(formDate:formDate,toDate:toDate);
                                                });
                                                break;
                                              case 3:
                                                print('------300------3----index---');
                                                setState(() {
                                                  AllPage(formDate:formDate,toDate:toDate);
                                                });
                                                break;
                                            }
                                          }
                                        });

                                      });
                                      print("-----237---$formDate");

                                    //  hrmsLeaveStatus = HrmsLeaveStatusRepo().hrmsLeveStatusList(context, "${formDate}", "${toDate}",status);
                                      fromDateSelectLogic();
                                    }
                                  },
                                  child: Container(
                                    height: 35,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14.0), // Optional: Adjust padding for horizontal space
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Change this to your preferred color
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$formDate',
                                        style: const TextStyle(
                                          color: Colors.grey, // Change this to your preferred text color
                                          fontSize: 12.0, // Adjust font size as needed
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
                                    fit: BoxFit.contain, // or BoxFit.cover depending on the desired effect
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
                                      String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
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
                                        horizontal:
                                            14.0), // Optional: Adjust padding for horizontal space
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Change this to your preferred color
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$toDate',
                                        style: const TextStyle(
                                          color: Colors
                                              .grey, // Change this to your preferred text color
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
                            height: 35,
                            width: MediaQuery.of(context).size.width - 10,
                            //color: Color(0xFF255899),
                            decoration: const BoxDecoration(
                              //  color: Color(0xFF3375af), // Container background color
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(0), // Adjust this value as per your preference
                                right: Radius.circular(0), // Adjust this value as per your preference
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, bottom: 2, left: 2, right: 2),
                              child: TabBar(
                                controller: tabController,
                                indicatorColor: Color(0xFF0098a6),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorWeight: 0,
                                labelPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                unselectedLabelColor: Color(0xFF0098a6),
                                labelColor: Colors.white,
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFF0098a6),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 0,
                                    )),
                                tabs: <Widget>[
                                  _buildTab('Pending', context),
                                  _buildTab('Sanctioned', context),
                                  _buildTab('Rejected', context),
                                  _buildTab('All', context),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 0, top: 8),
                              child: Container(
                                height: MediaQuery.of(context).size.height - 300.0,
                                // height: 400,
                                child: TabBarView(
                                  controller: tabController,
                                  children: <Widget>[
                                    PendingPage(formDate:formDate,toDate:toDate),
                                    SanctionedPage(formDate:formDate,toDate:toDate),
                                    RejectedPage(formDate:formDate,toDate:toDate),
                                    AllPage(formDate:formDate,toDate:toDate)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              )
            ])));
  }

  // build
  Widget _buildTab(String text, BuildContext context) {
    return Container(
      height: 30,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              // color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
