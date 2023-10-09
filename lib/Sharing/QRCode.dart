import 'package:flutter/material.dart';
import 'package:habitshare/Constants/Constants.dart';
import 'package:habitshare/Friends/MyQRCode.dart';

class QRCode extends StatefulWidget {
  const QRCode({super.key});
  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Center(
            child: Text("QRCode", style: appbarTextStyle),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRCodeGenerator()));
                },
                child: Text(
                  "View My QR Code",
                  style: buttonTextStyle,
                ),
              ),
              SizedBox(height: 30.0), // Add some spacing between buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRCodeGenerator()));
                },
                child: Text(
                  "Scan QR Code",
                  style: buttonTextStyle,
                ),
              ),
              SizedBox(height: 30.0), // Add some spacing between buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRCodeGenerator()));
                },
                child: Text(
                  "My Gallery",
                  style: buttonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
