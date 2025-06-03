import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart' as Fluttertoast;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/presentation/setpin/payslip.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../app/generalFunction.dart';


class PaySlipPdf extends StatefulWidget {

  var pdfFile;

  PaySlipPdf({super.key, this.pdfFile});

  @override
  State<PaySlipPdf> createState() => _PolicydocScreenState();
}

class _PolicydocScreenState extends State<PaySlipPdf> {

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  double _currentZoomLevel = 1.0;

  late GeneralFunction generalFunction;

  @override
  void initState() {
    // TODO: implement initState
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
              MaterialPageRoute(builder: (context) => const PaySlip()),
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
        ),
        // Removes shadow under the AppBar
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download, // Use any download icon
              color: Colors.white,
            ),
            onPressed: () {
              downloadPDF();
             // downlodeFile();
              // Action to download PDF
             // downloadPDF();
            },
          ),
        ],

      ),

      body: SfPdfViewer.network(
        '${widget.pdfFile}',
        key: _pdfViewerKey,
        enableDoubleTapZooming: true,
      ),
      // body: SfPdfViewer.network(
      //   'http://49.50.76.136/HRMS/Policies/04132024041329.pdf',
      //   key: _pdfViewerKey,
      //   enableDoubleTapZooming: true,
      // ),
    );
  }
  // pdf downllode file  code
  Future<void> downloadPDF() async {
    const pdfUrl = 'http://49.50.76.136/HRMS/Policies/04132024041329.pdf';
    final fileName = pdfUrl.split('/').last;

    // Check and request permission for storage (Android only)
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Permission Denied!");
        return;
      }
    }

    // Get the Downloads directory
    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDirectory = await getApplicationDocumentsDirectory();
    }

    if (downloadsDirectory != null) {
      final savePath = '${downloadsDirectory.path}/$fileName';
      try {
        Dio dio = Dio();

        await dio.download(
          pdfUrl,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              // Calculate download progress percentage
              double progress = received / total;
              // Show progress bar in console
              showProgressBar(progress);
            }
          },
        );
        displayToast(savePath);

        print('\nFile downloaded to: $savePath');
      } catch (e) {
        displayToast('Error downloding file : $e');
        print('Error downloading file: $e');
      }
    }
  }

  // Future<void> downloadPDF() async {
  //   const pdfUrl = 'http://49.50.76.136/HRMS/Policies/04132024041329.pdf';
  //   final fileName = pdfUrl.split('/').last;
  //
  //   // Check and request permission for storage (Android only)
  //   if (Platform.isAndroid) {
  //     final status = await Permission.storage.request();
  //     if (!status.isGranted) {
  //       print("Permission Denied!");
  //       return;
  //     }
  //   }
  //
  //   // Get the Downloads directory
  //   Directory? downloadsDirectory;
  //   if (Platform.isAndroid) {
  //     downloadsDirectory = Directory('/storage/emulated/0/Download');
  //   } else if (Platform.isIOS) {
  //     downloadsDirectory = await getApplicationDocumentsDirectory();
  //   }
  //
  //   if (downloadsDirectory != null) {
  //     final savePath = '${downloadsDirectory.path}/$fileName';
  //     try {
  //       Dio dio = Dio();
  //       await dio.download(
  //         pdfUrl,
  //         savePath,
  //         onReceiveProgress: (received, total) {
  //           if (total != -1) {
  //             print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
  //           }
  //         },
  //       );
  //        // generalFunction.displayToast(savePath);
  //       displayToast(savePath);
  //       print('File downloaded to: $savePath');
  //     } catch (e) {
  //       print('Error downloading file: $e');
  //     }
  //   }
  // }




  // downlode file
  void downlodeFile() async{
    var dio = Dio();
    Directory directory = await getApplicationDocumentsDirectory();
    var response = await dio.download("http://49.50.76.136/HRMS/Policies/04132024041329.pdf",
        '${directory.path}/file.pdf');
    print(response.statusCode);
    print(response);
    print('xxxxxxxxxxxxxx......');
  }
  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
      msg,
      duration: Duration(seconds: 1),
      position: Fluttertoast.ToastPosition.center,
      backgroundColor: Colors.black45,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }
  // void displayToast(String msg) {
  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 2,
  //       backgroundColor: Colors.black45,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }
  // show prograssbar logic
  void showProgressBar(double progress) {
    int progressBarLength = 50; // Total length of progress bar
    int filledLength = (progressBarLength * progress).round(); // Filled length based on progress
    String bar = '=' * filledLength + '-' * (progressBarLength - filledLength); // Bar construction

    stdout.write('\r[$bar] ${(progress * 100).toStringAsFixed(0)}%');
  }
}

