import 'package:HabitShare/Realm/user/user.dart';
import 'package:flutter/material.dart';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realm/realm.dart';
import '../../Mongo DB/mongoloid.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final MongoDBService mongoDBService = MongoDBService();
  final TextEditingController _securityQuestionController =
      TextEditingController();
  final TextEditingController _securityAnswerController =
      TextEditingController();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 5) {
      return 'Username must be at least 5 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailPattern = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailPattern.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact number is required';
    }
    if (value.length != 10) {
      return 'Contact number must be 10 digits';
    }
    if (!value.contains(RegExp(r'^[0-9]+$'))) {
      return 'Invalid contact number format';
    }
    return null;
  }

  void _performSignup() async {
    if (_formKey.currentState!.validate()) {
      final enteredName = _usernameController.text;
      final enteredEmail = _emailController.text;
      final enteredPassword = _passwordController.text;
      final enteredContactNumber = _contactNumberController.text;
      final enteredSecurityQuestion = _securityQuestionController.text;
      final enteredSecurityAnswer = _securityAnswerController.text;

      // Add a new user to the Realm.
      final config = Configuration.local([UserModel.schema]);
      final realm = Realm(config);

      // Query the Realm to check if a user with the same email exists
      final storedUser = realm.query<UserModel>('email == "$enteredEmail" ');
      if (storedUser.isEmpty) {
        // Update the password for the user
        UserModel newUser = UserModel(
            ObjectId(),
            enteredName,
            enteredEmail,
            enteredPassword,
            int.parse(enteredContactNumber),
            enteredSecurityQuestion,
            enteredSecurityAnswer);
        realm.write(() {
          realm.add(newUser);
        });

        // Query the Realm to get all users
        final users = realm.all<UserModel>();
        final usersList = users.toList();

        // Query the Realm to check if the user exists
        for (final user in usersList) {
          print(
              'User details added to Realm: ${user.name} ${user.email} ${user.password}');
        }
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Signup Successful!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Push user details to MongoDB
                    pushUserToMongoDB(mongoDBService.db);
                    Navigator.of(dialogContext).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HabitStatus()));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
      // Show a error message
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'User with this email already exists. Please use a different email'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/newlogo.svg',
                    height: 110,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Signup to add your habits &',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: darkblack,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'share it with others',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: darkblack,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 17.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person, color: primaryColor),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(
                        Icons.mail,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(
                        Icons.remove_red_eye_sharp,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _contactNumberController,
                    decoration: const InputDecoration(
                      labelText: 'ContactNumber',
                      hintText: 'Enter your ContactNumber',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: _validateContactNumber,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _securityQuestionController,
                    decoration: const InputDecoration(
                      labelText: 'Security Question',
                      hintText: 'Question?',
                      prefixIcon: Icon(
                        Icons.question_answer,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: _validateSecurityQuestion,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _securityAnswerController,
                    decoration: const InputDecoration(
                      labelText: 'Security Answer',
                      hintText: 'Answer!',
                      prefixIcon: Icon(
                        Icons.question_answer_outlined,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: _validateSecurityAnswer,
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _performSignup,
                    child: const Text(
                      'Sign Up',
                      style: buttonTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  SvgPicture.asset(
                    'assets/images/signinpic.svg',
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? _validateSecurityQuestion(String? value) {
  if (value == null || value.isEmpty) {
    return 'Security question is required';
  }
  // You can add additional validation if needed
  return null;
}

// Validation function for security answer
String? _validateSecurityAnswer(String? value) {
  if (value == null || value.isEmpty) {
    return 'Security answer is required';
  }
  // You can add additional validation if needed
  return null;
}
