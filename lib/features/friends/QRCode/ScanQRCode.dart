import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result; // Initialize result as nullable
  QRViewController? controller; // Initialize controller as nullable

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Center(
          child: Text(
            'QR Code Scanner',
            style: appbarTextStyle,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'QR Code Result: ${result!.code}',
                      style: const TextStyle(fontSize: 20),
                    )
                  : const Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }

  // Callback when the QR view is created
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        // TODO: Handle the scanned QR code, e.g., add the friend to the list
      });
    });
  }
}
