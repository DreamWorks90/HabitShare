import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController controller = TextEditingController();
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Add Habbit',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          body: Center(
            child: Card(
              color: Colors.white70,
              elevation: 20,
              shadowColor: Colors.grey,
              margin: EdgeInsets.all(10),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Habit Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xff1855f4),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                backgroundColor: const Color(0xff20a901),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            onPressed: () {},
                            child: Text(
                              'Build',
                              style: TextStyle(fontSize: 20),
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                backgroundColor: const Color(0xffe80505),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            onPressed: () {},
                            child: Text(
                              'Quit',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Habit Name :',
                        labelStyle: TextStyle(
                            fontSize: 20,
                            color: Color(0xff1855f4),
                            fontWeight: FontWeight.bold),
                        hintText: 'ex: Walking',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.sports_martial_arts),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Habit Description :',
                        labelStyle: TextStyle(
                            color: Color(0xff1855f4),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 380,
                      height: 67,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xff1855f4)),
                      child:
                          TextButton(onPressed: () {}, child: DropdownList()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 380,
                      height: 67,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xff1855f4)),
                      child: TextButton(
                          onPressed: () {}, child: TimeDropdownList()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Term :',
                        labelStyle: TextStyle(
                            fontSize: 20,
                            color: Color(0xff1855f4),
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'FINISH',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class DropdownList extends StatefulWidget {
  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String selectedOption = 'None'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Row(
            children: [
              Container(
                child: Center(
                  child: Text(
                    'Frequency :   ',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                child: Text(
                  ' ' + selectedOption,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                child: DropdownButton<String>(
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                  items: <String>[
                    'None',
                    'Daily',
                    'Weekly',
                    'Monthly',
                    'Custom'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class TimeDropdownList extends StatefulWidget {
  @override
  _TimeDropdownListState createState() => _TimeDropdownListState();
}

class _TimeDropdownListState extends State<TimeDropdownList> {
  String selectedOption = 'None'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Row(
            children: [
              Container(
                child: Center(
                  child: Text(
                    'Time :            ',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                child: Text(
                  ' ' + selectedOption,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                child: DropdownButton<String>(
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                  items: <String>[
                    'None',
                    'Morning',
                    'Evening',
                    'Night',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
