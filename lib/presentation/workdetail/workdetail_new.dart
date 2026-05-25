import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

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

  /// DROPDOWN
  String? selectedProject;

  final List<String> projects = [
    "HRMS Project",
    "Visitor Management",
    "Employee Tracker",
  ];

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

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
            Navigator.pop(context);
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

            Container(
              height: 220,
              width: double.infinity,
              color: Colors.white,

              child: Image.asset(
                'assets/images/workstatus3.jpeg',
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 14),

            /// ====================================
            /// FORM CARD
            /// ====================================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),

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
                      child: DropdownButtonFormField<String>(
                        value: selectedProject,
                        isExpanded: true,

                        decoration:
                        inputDecoration('Select Project'),

                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),

                        items: projects.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            selectedProject = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// WORK DETAIL
                    buildInputRow(
                      icon: Icons.file_copy_outlined,
                      title: "Work Detail",

                      child: TextFormField(
                        controller: workDetailController,

                        decoration:
                        inputDecoration('Enter work detail'),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TIME SPENT
                    buildInputRow(
                      icon: Icons.watch_later_rounded,
                      title: "Time Spent (Minutes)",

                      child: TextFormField(
                        controller: timeSpentController,
                        keyboardType: TextInputType.number,

                        decoration:
                        inputDecoration('Enter minutes'),
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// SUBMIT BUTTON
                    SizedBox(
                      width: size.width * .55,
                      height: 52,

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

                        onPressed: () {},

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

            const SizedBox(height: 28),

            /// ====================================
            /// TODAY STATUS TITLE
            /// ====================================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                children: const [

                  Icon(
                    Icons.widgets_rounded,
                    color: Color(0xFF12B8C6),
                    size: 28,
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Today's Work Status",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// ====================================
            /// HORIZONTAL LIST
            /// ====================================

            SizedBox(
              height: 290,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),

                padding:
                const EdgeInsets.symmetric(horizontal: 16),

                itemCount: 5,

                itemBuilder: (context, index) {
                  return taskCard();
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        /// ICON BOX
        Container(
          height: 65,
          width: 65,

          decoration: BoxDecoration(
            color: const Color(0xFFF2FCFD),
            borderRadius: BorderRadius.circular(18),
          ),

          child: Icon(
            icon,
            color: const Color(0xFF12B8C6),
            size: 30,
          ),
        ),

        const SizedBox(width: 14),

        /// INPUT FIELD
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E2230),
                ),
              ),

              const SizedBox(height: 10),

              child,
            ],
          ),
        ),
      ],
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
        horizontal: 18,
        vertical: 16,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

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

  Widget taskCard() {

    return Container(
      width: 340,
      margin: const EdgeInsets.only(right: 14, bottom: 10),

      child: Card(
        elevation: 5,
        shadowColor: Colors.black12,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
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
                  Container(
                    height: 72,
                    width: 72,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF2FCFD),
                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(
                        color: const Color(0xFF12B8C6)
                            .withOpacity(.25),
                      ),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(14),

                      child: Image.asset(
                        'assets/images/appicon.jpeg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// TITLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: const [

                        Text(
                          "Head Office",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Project Name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Divider(
                color: Colors.grey.shade200,
                thickness: 1,
              ),

              const SizedBox(height: 12),

              /// TASK DETAIL ROW
              Row(
                children: [

                  Expanded(
                    child: Row(
                      children: const [

                        Icon(
                          Icons.menu_open_rounded,
                          size: 20,
                          color: Colors.black54,
                        ),

                        SizedBox(width: 6),

                        Text(
                          "Task Details",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
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
                      children: const [

                        Icon(
                          Icons.watch_later_rounded,
                          size: 16,
                          color: Colors.red,
                        ),

                        SizedBox(width: 5),

                        Text(
                          "2 Hr 30 Min",
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

              const SizedBox(height: 16),

              /// DESCRIPTION
              Expanded(
                child: ReadMoreText(
                  '''
Testing of VMS design test case, maintain test cases in excel sheet, perform black box testing and regression testing for daily workflow and reporting.
                  ''',

                  trimLines: 3,
                  trimMode: TrimMode.Line,

                  trimCollapsedText: ' Read More',
                  trimExpandedText: ' Read Less',

                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF5B6475),
                  ),

                  moreStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF12B8C6),
                  ),

                  lessStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:lottie/lottie.dart';
// import 'package:readmore/readmore.dart';
//
// class WorkDetailNew extends StatefulWidget {
//   const WorkDetailNew({super.key});
//
//   @override
//   State<WorkDetailNew> createState() => _DailyWorkStatusScreenState();
// }
//
// class _DailyWorkStatusScreenState extends State<WorkDetailNew> with SingleTickerProviderStateMixin {
//
//   late final AnimationController _controller;
//
//   final List<String> projects = [
//     'Project Alpha',
//     'Project Beta',
//     'Project Gamma',
//     'Project Delta',
//   ];
//
//   String? selectedProject;
//   final TextEditingController workDetailController = TextEditingController();
//   final TextEditingController timeSpentController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     selectedProject = projects.first;
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     workDetailController.dispose();
//     timeSpentController.dispose();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(18),
//         borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(18),
//         borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(18),
//         borderSide: const BorderSide(color: Color(0xFF12B8C6), width: 1.5),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F9FC),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF12B8C6),
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Daily Work Status',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 200,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             clipBehavior: Clip.antiAlias,
//             child: Image.asset(
//               'assets/images/workstatus3.jpeg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(height: 10),
//           SizedBox(
//             height: size.height * 0.44,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(28),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                   border: Border.all(
//                     color: const Color(0xFFE8EEF5),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 39),
//                           child: Icon(
//                             Icons.work_outline_rounded,
//                             size: 35,
//                             color: const Color(0xFF12B8C6),
//                           ),
//                         ),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(top: 12),
//                         //   child: _projectHeader(),
//                         // ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 'Project Name',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1E2230),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               DropdownButtonFormField<String>(
//                                 value: selectedProject,
//                                 isExpanded: true,
//                                 decoration: _inputDecoration('Select Project'),
//                                 icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                                 items: projects
//                                     .map(
//                                       (item) => DropdownMenuItem<String>(
//                                     value: item,
//                                     child: Text(item),
//                                   ),
//                                 )
//                                     .toList(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedProject = value;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 39),
//                           child: Icon(
//                             Icons.file_copy,
//                             size: 35,
//                             color: const Color(0xFF12B8C6),
//                           ),
//                         ),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(top: 12),
//                         //   child: _projectHeaderWork(),
//                         // ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 'Work Detail',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1E2230),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               TextFormField(
//                                 controller: workDetailController,
//                                 decoration: _inputDecoration('Enter work detail'),
//                                 maxLines: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 39),
//                           child: Icon(
//                             Icons.watch_later_rounded,
//                             size: 35,
//                             color: const Color(0xFF12B8C6),
//                           ),
//                         ),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(top: 12),
//                         //   child: _projectHeaderTime(),
//                         // ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 'Time Spent (Minutes)',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1E2230),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               TextFormField(
//                                 controller: timeSpentController,
//                                 keyboardType: TextInputType.number,
//                                 decoration: _inputDecoration('Enter minutes'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Center(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF12B8C6),
//                         ),
//                         onPressed: () {},
//                         child: const Text(
//                           'Submit',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 0),
//           Expanded(
//             child: Container(
//               color: Colors.grey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.widgets,color: Color(0xFF12B8C6),
//                       size:35,
//                       ),
//                       SizedBox(width: 14),
//                       Text("Today Work's Status",style: TextStyle(
//                         color: Colors.black45,
//                         fontSize: 22
//                       ),)
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   // ListView.builder(
//                   //   scrollDirection: Axis.horizontal,
//                   //   itemCount: 2,
//                   //   itemBuilder: (context, index) {
//                   //     return taskCard();
//                   //   },
//                   // ),
//                  // ListView.builder(
//                  //      scrollDirection: Axis.horizontal,
//                  //      itemCount: 2,
//                  //      itemBuilder: (context, index) {
//                  //        return taskCard();
//                  //      },
//                  //    ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       )
//     );
//   }
//   // list card
//   /// CARD FUNCTION
//   Widget taskCard() {
//     return Container(
//       width: 320,
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//
//       child: Card(
//         elevation: 4,
//         shadowColor: Colors.black12,
//
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//
//             children: [
//
//               /// TOP ROW
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//
//                 children: [
//                   Container(
//                     height: 65,
//                     width: 65,
//                     margin: const EdgeInsets.all(8),
//
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//
//                       border: Border.all(
//                         color: const Color(0xFF12B8C6),
//                         width: 1,
//                       ),
//                     ),
//
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//
//                         child: Image.asset(
//                           'assets/images/appicon.jpeg',
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 10),
//
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//
//                     children: const [
//                       Text(
//                         "Head Office",
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//
//                       SizedBox(height: 5),
//
//                       Text(
//                         "Project Name",
//                         style: TextStyle(
//                           color: Colors.black45,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//
//               /// SECOND ROW
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//
//                 child: Row(
//                   children: [
//
//                     /// LEFT SIDE
//                     Row(
//                       children: const [
//                         Icon(
//                           Icons.menu_open_rounded,
//                           size: 20,
//                           color: Colors.black45,
//                         ),
//
//                         SizedBox(width: 5),
//
//                         Text(
//                           "Task Details",
//                           style: TextStyle(
//                             color: Colors.black45,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const Spacer(),
//
//                     /// RIGHT SIDE
//                     Row(
//                       children: const [
//                         Icon(
//                           Icons.watch_later_rounded,
//                           size: 20,
//                           color: Colors.red,
//                         ),
//
//                         SizedBox(width: 5),
//
//                         Text(
//                           "Pending",
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               /// DESCRIPTION
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//
//                   child: ReadMoreText(
//                     '''
// Lorem Ipsum is simply dummy text of the printing and typesetting industry.
// Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.
//
// It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.
//                     ''',
//
//                     trimLines: 3,
//                     trimMode: TrimMode.Line,
//
//                     trimCollapsedText: ' Read More',
//                     trimExpandedText: ' Read Less',
//
//                     moreStyle: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF12B8C6),
//                     ),
//
//                     lessStyle: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red,
//                     ),
//
//                     style: const TextStyle(
//                       fontSize: 15,
//                       height: 1.5,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
