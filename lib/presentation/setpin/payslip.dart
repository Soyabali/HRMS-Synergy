
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/presentation/setpin/payslippdf.dart';
import '../../data/pinslip_repo.dart';
import '../../domain/pinSlipModel.dart';
import '../resources/app_text_style.dart';
import 'setpin.dart';

class PaySlip extends StatelessWidget {

  const PaySlip({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaySlipPage(),
    );
  }
}
class PaySlipPage extends StatefulWidget {

  const PaySlipPage({super.key});

  @override
  State<PaySlipPage> createState() => _PaySlipPageState();
}

class _PaySlipPageState extends State<PaySlipPage> {

  late Future<List<PinSlipModel>> reimbursementStatusV3;
  List<PinSlipModel> _allData = []; // Holds original data
  List<PinSlipModel> _filteredData = []; // Ho

  paySlipResponse() async {
    reimbursementStatusV3 = PinSlipRepo().pinslip(context);
    print("--37------$reimbursementStatusV3");

    reimbursementStatusV3.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
  }
  //
  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData; // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sMonthName
              .toLowerCase()
              .contains(query.toLowerCase()) ; // Filter by project name
             // item.sDsgName.toLowerCase().contains(query.toLowerCase()) ||
              //item.sContactNo.toLowerCase().contains(query.toLowerCase());
          // Filter by employee name
        }).toList();
      }
    });
  }


   @override
  void initState() {
    // TODO: implement initState
     paySlipResponse();
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              MaterialPageRoute(builder: (context) => const Setpin()),
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
            'Pay Slip',
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
      child: Container(
        color: Colors.white,
      child: FutureBuilder<List<PinSlipModel>>(
      future: reimbursementStatusV3,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: _filteredData.length ?? 0,
            itemBuilder: (context, index) {
              final leaveStatus = _filteredData[index];
      
              return
                Container(
                  child: Card(
                    color: Colors.white, // Set background color of the Card to white
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners for the Card
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduce padding to control height
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0), // Control inner padding
                        leading: Icon(Icons.picture_as_pdf, color: Color(0xFF0098a6)), // Set a custom icon color
                        title: Text(
                          leaveStatus.sMonthName,
                          style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                        ),
                        trailing: InkWell(
                          onTap: () {
                            var pdfFile = "${leaveStatus.sPaySlip}";
                            print("----pdfSlip ----$pdfFile");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PaySlipPdf(pdfFile: pdfFile)),
                            );
                          },
                          child: Container(
                            height: 30, // Set a reduced height for the trailing button
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xFF0098a6),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0), // Reduced border radius
                            ),
                            child: Center(
                              child: Text(
                                "PAY SLIP",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0, // Slightly reduced font size
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );

              // Container(
                //   child: Card(
                //     elevation: 5,
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                //       child: ListTile(
                //           leading: Icon(Icons.picture_as_pdf),
                //           title: Text(leaveStatus.sMonthName,
                //             style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                //           ),
                //           trailing: Padding(
                //               padding: const EdgeInsets.only(right: 5),
                //               child: InkWell(
                //                 onTap: (){
                //                 var pdfFile =   "${leaveStatus.sPaySlip}";
                //                 print("----pdfSlip ----$pdfFile");
                //                 Navigator.push(
                //                   context,
                //                   MaterialPageRoute(builder: (context) => PaySlipPdf(pdfFile:pdfFile)),
                //                 );
                //
                //                 },
                //                 child: Container(
                //                   height: 35, // Set the height of the container
                //                   width: 100,
                //                   decoration: BoxDecoration(
                //                     color: Colors.white,
                //                     // Background color of the container
                //                     border: Border.all(
                //                       color: Color(0xFF0098a6), // Border color
                //                       width: 1.0, // Border width
                //                     ),
                //                     borderRadius: BorderRadius.circular(
                //                         16.0), // Rounded corners
                //                   ),
                //                   child: Center( // Center the text inside the container
                //                     child: Text(
                //                       "PAY SLIP",
                //                       style: TextStyle(
                //                         color: Colors.black, // Text color
                //                         fontSize: 14.0, // Font size
                //                         fontWeight: FontWeight
                //                             .w500, // Optional: adjust text weight
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               )
                //           )
                //       ),
                //     ),
                //   ),
                // );
            }
        );
      }
        )
      ),
    )


            // trailing: Container(
            //   height: 55,
            //     decoration: BoxDecoration(
            //       color: Colors.white, // Background color of the container
            //       border: Border.all(
            //         color: Colors.black, // Border color
            //         width: 1.0, // Border width
            //       ),
            //       borderRadius: BorderRadius.circular(16.0), // Optional: to make the border rounded
            //     ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Text('Pay Slip',style: TextStyle(
            //       color: Colors.black45,fontSize: 14
            //     ),),
            //   ),
            // ),
            // trailing: Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white, // Background color of the container
            //     border: Border.all(
            //       color: Colors.black, // Border color
            //       width: 1.0, // Border width
            //     ),
            //     borderRadius: BorderRadius.circular(8.0), // Optional: to make the border rounded
            //   ),
            //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding inside the container
            //   child: const Center(
            //     child: Text(
            //       'Pay Slip',
            //       style: TextStyle(
            //         fontSize: 16.0, // Adjust font size
            //         fontWeight: FontWeight.bold, // Optional: make text bold
            //         color: Colors.black, // Text color
            //       ),
            //     ),
            //   ),
            // ),


        ],
      ),
    );
  }
}

