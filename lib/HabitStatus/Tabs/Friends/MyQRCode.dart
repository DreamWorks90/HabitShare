import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQRCode extends StatefulWidget {
  const MyQRCode({
    super.key,
  });
  //required this.data});
  //final String data; // This is the data you want to encode in the QR code.
  @override
  State<MyQRCode> createState() => _MyQRCodeState();
}

class _MyQRCodeState extends State<MyQRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Center(
            child: Text("My QRCode", style: appbarTextStyle),
          )),
      /*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: data,
              version: QrVersions.auto,
              size: 200.0, // Adjust the size as needed
            ),
            SizedBox(height: 16.0),
            Text(
              "Scan this QR code",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),*/
    );
  }
}
