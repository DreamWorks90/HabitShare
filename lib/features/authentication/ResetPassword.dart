import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:HabitShare/Constants.dart';
import 'package:realm/realm.dart';
import 'package:HabitShare/Realm/user/user.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _securityQuestionController =
      TextEditingController();
  final TextEditingController _securityAnswerController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

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

  void _resetPassword() async {
    final String enteredEmail = _emailController.text;
    final String securityAnswer = _securityAnswerController.text;
    final String newPassword = _newPasswordController.text;

    final config = Configuration.local([UserModel.schema]);
    final realm = Realm(config);
    final storedUser = realm.query<UserModel>('email == "$enteredEmail"');

    if (storedUser.isNotEmpty) {
      // Fetch and display the security question
      _securityQuestionController.text = storedUser[0].enteredSecurityQuestion;

      if (storedUser[0].enteredSecurityAnswer == securityAnswer) {
        realm.write(() {
          storedUser[0].password = newPassword;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully!'),
          ),
        );
        _emailController.clear();
        _securityQuestionController.clear();
        _securityAnswerController.clear();
        _newPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect security answer. Please try again.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not found. Please enter a valid email address.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Reset Password',
            style: appbarTextStyle,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
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
                  onChanged: (value) {
                    _securityQuestionController.clear();
                    _securityAnswerController.clear();
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _securityQuestionController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Security Question',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _securityAnswerController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Security Answer',
                    hintText: 'Enter your security answer',
                    prefixIcon: Icon(Icons.lock),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Security answer is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _resetPassword();
                    }
                  },
                  child: const Text(
                    'Reset Password',
                    style: buttonTextStyle,
                  ),
                ),
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/images/reset.svg',
                  height: 350,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
