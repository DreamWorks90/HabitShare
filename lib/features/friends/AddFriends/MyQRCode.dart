import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});
  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: Text("My QRCode", style: appbarTextStyle),
        ),
      ),
    );
  }
}
