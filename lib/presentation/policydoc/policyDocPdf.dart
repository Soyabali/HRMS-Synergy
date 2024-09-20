import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/presentation/policydoc/policydoc.dart';
import '../dashboard/dashboard.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PolicydocPdfScreen extends StatefulWidget {

  var pdfFile;

  PolicydocPdfScreen({super.key, this.pdfFile});

  @override
  State<PolicydocPdfScreen> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<PolicydocPdfScreen> {

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  double _currentZoomLevel = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   print('${widget.pdfFile}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                MaterialPageRoute(builder: (context) => const PolicyDoc()),
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
              'Policy Doc',
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

        body: SfPdfViewer.network(
          '${widget.pdfFile}',
          key: _pdfViewerKey,
          enableDoubleTapZooming: true,
        ),
    );
  }
}

