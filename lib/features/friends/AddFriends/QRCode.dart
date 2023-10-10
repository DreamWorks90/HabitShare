import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';

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
    );
  }
}
