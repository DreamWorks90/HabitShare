import 'package:HabitShare/features/authentication/ResetPassword.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:HabitShare/features/authentication/AuthPage.dart';
import 'package:HabitShare/features/splash/SplashPage.dart';
import 'package:HabitShare/features/addhabit/AddHabit.dart';
import 'package:HabitShare/features/friends/Friends.dart';
import 'package:HabitShare/features/habits/Habits.dart';
import 'package:HabitShare/features/reports/Reports.dart';
import 'package:HabitShare/features/settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:HabitShare/features/authentication/SignIn.dart';
import 'package:HabitShare/features/authentication/SignUp.dart';

const Color primaryColor = Color(0xff1855f4);
const Icon arrowBackIcon = Icon(Icons.arrow_back);

const Widget signInWidget = SignIn();
const Widget signUpWidget = SignUp();
const Widget resetPasswordWidget = ResetPassword();
const Widget habitStatusWidget = HabitShareTabs();
const Widget splashPageWidget = SplashPage();
const Widget authPageWidget = AuthPage();
const Widget habitsTabWidget = HabitsTab();
const Widget friendsTabWidget = FriendsTab();
const Widget reportsTabWidget = ReportsTab();
const Widget settingsTabWidget = SettingsTab();
const Widget addHabitsWidget = AddHabits();

const Widget signUpText = Text('Sign Up');

const TextStyle appbarTextStyle =
    TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white);
const TextStyle buttonTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);
