
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/baseProjectRepo.dart';
import '../../data/hrmsTimeScheduleRepo.dart';
import '../dashboard/dashboard.dart';
import '../resources/app_text_style.dart';


class WorkDetail extends StatelessWidget {

  const WorkDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WorkDetailPage(),
    );
  }
}

class WorkDetailPage extends StatefulWidget {

  const WorkDetailPage({super.key});

  @override
  State<WorkDetailPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WorkDetailPage> {

  // ----

  final List<TextEditingController> _controllers = [];
  List<String> projectNames = [];
  List<String> workDetails = [];
  final _formKey = GlobalKey<FormState>();



  final TextEditingController _controller = TextEditingController();

  List<dynamic>?  baseProjectList;
  List<dynamic>?  hrmsTimeScheduleList;

  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  //
  baseProject() async {
    baseProjectList = await HrmsBaseProjectRepo().baseProjectList(context);
    print(" -----57---  baseProjectList--59---> $baseProjectList");
    setState(() {});
  }
  // timeSchedule Response
  hrmsTimeSchedule() async {
    hrmsTimeScheduleList = await HrmsTimeScheduleRepo().timeScheduleList(context);
    print(" -----67---  hrmsTimeScheduleList--67---> $hrmsTimeScheduleList");
    setState(() {});
  }

  @override
  void initState() {
    baseProject();
    hrmsTimeSchedule();
    super.initState();

    if (baseProjectList != null) {
      for (int i = 0; i < baseProjectList!.length; i++) {
        _controllers.add(TextEditingController());
      }


      // Initialize the controllers with an arbitrary number of items (replace 2 with your dynamic item count)

    }
  }

  @override
  void dispose() {
    // dispose all Controller
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  // submit Form

  void _submitForm() {
    workDetails.clear();
    projectNames.clear();
    bool isAtLeastOneFieldFilled = false; // Track if at least one field is filled

    // Check if baseProjectList exists and has elements
    if (baseProjectList != null && baseProjectList!.isNotEmpty) {
      // Ensure that _controllers has the same length as baseProjectList
      if (_controllers.length != baseProjectList!.length) {
        // Initialize controllers if they haven't been set up yet
        _controllers.clear();
        for (int i = 0; i < baseProjectList!.length; i++) {
          _controllers.add(TextEditingController());
        }
      }

      // Iterate over the baseProjectList and corresponding controllers
      for (int i = 0; i < baseProjectList!.length; i++) {
        projectNames.add(baseProjectList![i]['sProjectName'] ?? ''); // Collect project names
        String workDetail = _controllers[i].text.trim();

        // Check if the field is not empty
        if (workDetail.isNotEmpty) {
          isAtLeastOneFieldFilled = true; // At least one field is filled
          workDetails.add(workDetail); // Collect TextFormField values
        }
      }
      // If at least one field is filled, proceed with the submission
      if (isAtLeastOneFieldFilled) {
        // Proceed with the form submission logic
        print('Project Names: $projectNames');
        print('Work Details: $workDetails');
        // You can now pass these lists to your API
        /// todo Api send thes above list.

      } else {
        // Show a notification if all fields are empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in at least one field'),
            backgroundColor: Colors.black45,
          ),
        );
      }
    } else {
      // Show a notification if there are no projects to fill
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No projects to fill in'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color  // 2a697b
          statusBarColor: Color(0xFF2a697b),
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
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
            'Work Detail',
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
     //
      body: Column(
       mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 10),
          child: SizedBox(
            height: 150, // Height of the container
            width: MediaQuery.of(context).size.width,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/deshboardtop.jpeg',
                fit: BoxFit.fill, // Adjust the image fit to cover the container
              ),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
              itemCount: baseProjectList?.length ?? 0,
              itemBuilder: (context,index){
                // Make sure the _controllers list is initialized properly
                if (_controllers.length < baseProjectList!.length)
                {
                  _controllers.add(TextEditingController());
                }

                return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5,bottom: 5),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        decoration: BoxDecoration(
                            color: Colors.white, // Background color of the container
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Color of the shadow
                                spreadRadius: 5, // Spread radius
                                blurRadius: 7, // Blur radius
                                offset: Offset(0, 3), // Offset of the shadow
                              ),
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Form(
                               // key: _formKey,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: DottedBorder(
                                                    color: Colors.grey,
                                                    strokeWidth: 1.0,
                                                    dashPattern: [4, 2],
                                                    borderType: BorderType.RRect,
                                                    radius: const Radius.circular(5.0),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // This ensures the Row only takes up as much space as needed
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              size: 25),
                                                          SizedBox(width: 5),
                                                          Flexible(
                                                            child: Text(
                                                              '${baseProjectList?[index]['sProjectName']}',
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlack45TextStyle,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                Container(
                                                  height: 65,
                                                  color: Color(0xFFf2f3f5),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0),
                                                    child: TextFormField(
                                                      focusNode: FocusNode(),
                                                      controller: _controllers[index],
                                                      textInputAction: TextInputAction.next,
                                                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                                      maxLines:
                                                          null, // Allows multiple lines
                                                      expands:
                                                          true, // Makes the TextFormField fill the height
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Enter work detail",
                                                        labelStyle: AppTextStyle
                                                            .font14OpenSansRegularBlack45TextStyle,
                                                        border: const OutlineInputBorder(),
                                                        contentPadding: const EdgeInsets.symmetric(
                                                          vertical: 10, // Adjust vertical padding as needed
                                                          horizontal: 10,
                                                        ),
                                                      ),
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]
                                    )
                                )
                            )
                        )
                    )
                );

              }),
        ),
        SizedBox(height: 10),
        Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10), // Adjust padding as necessary
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0098a6), // Green color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
        ]
      ),
    );
  }
}
