import 'package:HabitShare/features/friends/addfriends/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:HabitShare/features/Authentication/SignUp.dart';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/Authentication/ResetPassword.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:flutter_svg/svg.dart';

import 'package:HabitShare/Realm/user/user.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../../Mongo DB/mongoloid.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MongoDBService mongoDBService = MongoDBService();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/newlogo.svg',
                      height: 100,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
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
                        prefixIcon: Icon(Icons.remove_red_eye_sharp),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
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
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPassword()));
                      },
                      style: const ButtonStyle(
                        alignment: Alignment.centerRight,
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 18, color: primaryColor),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          performSignIn(context, _emailController.text,
                              _passwordController.text);
                        }
                      },
                      child: const Text('Sign In', style: buttonTextStyle),
                    ),
                    const SizedBox(height: 30.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Or',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Continue with',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pushUserToMongoDB(mongoDBService.db);
                            // Handle Google sign-in logic here
                          },
                          child: SvgPicture.asset(
                            'assets/images/google.svg',
                            height: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle Facebook sign-in logic here
                          },
                          child: SvgPicture.asset(
                            'assets/images/fb.svg',
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text(
                      'Dont have an account',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: primaryColor),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: const Text('Sign up',
                          style: TextStyle(color: primaryColor, fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> performSignIn(
      BuildContext context, String enteredEmail, String enteredPassword) async {
    final config = Configuration.local([UserModel.schema]);
    try {
      final readRealm = Realm(config);
      var storedEmail = readRealm.query<UserModel>('email == "$enteredEmail"');
      if (storedEmail.isNotEmpty) {
        var user = storedEmail[0];
        // Check if the entered password matches the stored password
        if (user.password == enteredPassword) {
          readRealm.write(() {
            user.loggedIn = true;
          });
          final currentUserProvider =
              Provider.of<CurrentUserProvider>(context, listen: false);
          currentUserProvider.setCurrentUser(user.id.hexString, user.name);
          readRealm.close();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HabitStatus()),
          );
          return;
        }
      }
      readRealm.close();
    } catch (e) {
      print('Error occurred: $e');
    }

    // If no user found or password doesn't match, show sign-in failed dialog
    showSignInFailedDialog();
  }

  void showSignInFailedDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign-In Failed'),
          content: const Text('Invalid email or password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
