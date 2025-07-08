import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkAttendanceScreen extends StatefulWidget {

  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mark Attendance",style: TextStyle(
          color: Colors.white,
          fontSize: 14
        ),),
        backgroundColor: const Color(0xFF00B3C6),
      ),
      body: SingleChildScrollView(

        //padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌈 Gradient Card with Overlapping Info Card
            Stack(
              children: [
                // 🔲 Background White Container (acts as base)
                Container(
                  height: 340, // outer container
                  color: Colors.white,
                ),
                // 🎨 Inner Gradient Container
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 280,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00B3C6), Color(0xFF2A687C)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Column(
                     // mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/ravi_yadav.jpg'), // Replace with your image
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Ravi Yadav",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                                (index) => Icon(Icons.star, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 📦 Overlapping Bottom Container
                Positioned(
                  top: 230, // overflows above the 400 height container
                  left: 10,
                  right: 10,
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.grey.shade50,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          // 📱 Left Side
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  child: Image.asset(
                                    'assets/images/ic_profile_phone.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("9871950881",style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10
                                    ),),
                                    Text("Mobile No", style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 8
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // 🟨 Vertical Divider
                          Container(
                            width: 1,
                            height: 35,
                            color: Colors.grey,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Image.asset(
                                    'assets/images/ic_designation_profile.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                // 👆 This Expanded wraps the Column
                                // 👇 No need for an extra Container
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Team Lead - Android",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 10,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                      Text(
                                        "Designation",
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey.shade50,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 🟩 Left half
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(left: 10, top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attendance Time',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '12:00:35',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 🧱 Divider
                        Container(
                          width: 1,
                          height: 65,
                          color: Colors.grey.shade400,
                        ),
                        // ⬛ Right half
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/images/ic_my_detail_profile.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey.shade50,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 🟩 Left half
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: double.infinity, // Gives full available width
                                  child: Text(
                                    'A6, Bishanpura Rd, Block A, Sector 57, Noida, Uttar Pradesh',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black38,
                                      fontSize: 8,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),

                        // 🧱 Divider
                        Container(
                          width: 1,
                          height: 65,
                          color: Colors.grey.shade400,
                        ),

                        // ⬛ Right half
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/images/ic_google_map_location.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey.shade50,
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 🟩 Left half
                        Expanded(
                          child: Container(
                            color: Colors.white,
                           // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            //padding: const EdgeInsets.only(left: 10, top: 10),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Agra Smart City Limited',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 10
                                  ),
                                  ),
                                  SizedBox(height: 0),
                                  Row(
                                    children: [
                                      // ✅ Checkbox with green checkmark
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked = value!;
                                          });
                                        },
                                        activeColor: Colors.white,
                                        checkColor: Colors.green, // green check on white box
                                      ),
                                      const SizedBox(width: 0), // 🔁 Controls spacing exactly
                                      // 📝 Text label
                                      Container(
                                       // width: double.infinity,
                                        child: Text(
                                          "With in 100 meters",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black38,
                                            fontSize: 8,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.visible, // Or .ellipsis if truncation is okay
                                        ),
                                      )

                                    ],
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),

                        // 🧱 Divider
                        Container(
                          width: 1,
                          height: 65,
                          color: Colors.grey.shade400,
                        ),

                        // ⬛ Right half
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/images/ic_total_points.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // 🧠 Add your action here
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.blue, // You can customize the color
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
