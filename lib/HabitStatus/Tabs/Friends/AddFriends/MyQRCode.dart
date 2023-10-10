import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final GlobalKey globalKey = GlobalKey();
  String userName = "";
  String userEmail = "";
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? "";
      userEmail = prefs.getString('email') ?? "";
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: Text("My QRCode", style: appbarTextStyle),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RepaintBoundary(
              key: globalKey,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Visibility(
                    visible: userEmail
                        .isEmpty, // Show the text if userEmail is empty
                    child: Text(
                      "Enter data to generate QR Code",
                    ),
                    replacement: QrImageView(
                      data:
                          userEmail, // Use widget.data to access the data property
                      version: QrVersions.auto,
                      size: 300.0, // Adjust the size as needed
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100.0),
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
                print("User Name: $userName");
                print("User Email: $userEmail");
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LinkShare()));*/
              },
              child: Text(
                "Finish",
                style: buttonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
