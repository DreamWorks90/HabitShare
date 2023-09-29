import 'package:flutter/material.dart';
import 'package:habitshare_dw/Constants/Constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final GlobalKey globalKey = GlobalKey();
  String qrData = "https://www.google.com/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: Text("My QRCode", style: appbarTextStyle),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: qrData.isEmpty
                        ? Text("Enter data to genarate QR Code",
                            style: buttonTextStyle)
                        : QrImageView(
                            data:
                                qrData, // Use widget.data to access the data property
                            version: QrVersions.auto,
                            size: 200.0, // Adjust the size as needed
                          ),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              /*SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Data",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      qrData = value;
                    });
                  },
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
