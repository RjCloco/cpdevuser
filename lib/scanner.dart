import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the permission_handler package

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFlashOn = false;
  bool isAutoScanEnabled = true;

  @override
  void initState() {
    super.initState();
    // Request camera permissions before entering the QR scanner view
    _requestCameraPermission(); //Once we install the app it will ask the user about the camera access
  }

  Future<void> _requestCameraPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission not granted')),
        );
      }
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildQrView(context), //the UI for the QR Scan Area
          _buildScanText(), //Displaying what the qr has scanned
          _buildFlashButton(),
          _buildSwitchCameraButton(),
        ],
      ),
    );
  }
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 300 ||
        MediaQuery.of(context).size.height < 600)
        ? 270.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }
  Widget _buildScanText() {
    return Positioned(
      top: 40,
      child: Text(
        'Scan a code',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget _buildFlashButton() {
    return Positioned(
      top: 40,
      right: 20,
      child: GestureDetector(
        onTap: () async {
          await controller?.toggleFlash();
          setState(() {
            isFlashOn = !isFlashOn;
          });
        },
        child: Icon(
          isFlashOn ? Icons.flash_on : Icons.flash_off,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
  Widget _buildSwitchCameraButton() {
    return Positioned(
      bottom: 40,
      left: 20,
      child: GestureDetector(
        onTap: () async {
          await controller?.flipCamera();
          setState(() {});
        },
        child: Icon(
          Icons.cameraswitch_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result != null && isAutoScanEnabled) {
        if (result!.format == BarcodeFormat.qrcode) {
          await _navigateToWebsite(result!.code);
        }
      }
    });
  }

  Future<void> _navigateToWebsite(String? url) async {
    if (url != null) {
      final shouldNavigate = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Navigate to Website?'),
          content: Text('Do you want to navigate to the website:\n$url?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
          ],
        ),
      );

      if (shouldNavigate == true) {
        await launch(url);
      }
    }
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData; //the result that is the id scanned by the scanner will be saved here
  //     });
  //     if (result != null && isAutoScanEnabled) {
  //       // Delay for a moment and then show the scanned data in an alert dialog
  //       Future.delayed(Duration(seconds: 1), () {
  //         if (mounted) {
  //           showDialog(
  //               context: context,
  //               builder: (context) => AlertDialog(
  //                   title: Text('Scanned Data'),
  //                   content: Text('Barcode Type: ${describeEnum(result!.format)}\nData: ${result!.code}'), //This .format prints whether that is in QR format or any other format, .code will print the extracted code from the qr
  //               actions: [
  //                   TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //         child: Text('OK'),
  //         ),
  //         ],
  //         ),
  //         );
  //       }
  //       });
  //     }
  //   });
  // }
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
