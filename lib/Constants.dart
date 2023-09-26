import 'package:HabitShare/Authentication/ResetPassword.dart';
import 'package:HabitShare/HabitStatus/HabitStatus.dart';
import 'package:HabitShare/HomePage/HomePage.dart';
import 'package:HabitShare/HomePage/SplashPage.dart';
import 'package:HabitShare/HabitStatus/Tabs/AddHabit.dart';
import 'package:HabitShare/HabitStatus/Tabs/Friends/Friends.dart';
import 'package:HabitShare/HabitStatus/Tabs/Habits.dart';
import 'package:HabitShare/HabitStatus/Tabs/Reports.dart';
import 'package:HabitShare/HabitStatus/Tabs/Settings.dart';
import 'package:flutter/material.dart';
import 'Authentication/SignIn.dart';
import 'Authentication/SignUp.dart';

const Color primaryColor = Color(0xff1855f4);
const Icon arrowBackIcon = Icon(Icons.arrow_back);
const Widget signInWidget = SignIn();
const Widget signUpWidget = SignUp();
const Widget resetPasswordWidget = ResetPassword();
const Widget habitStatusWidget = HabitStatus();
const Widget splashPageWidget = SplashPage();
const Widget homePageWidget = HomePage();
const Widget habitsTabWidget = HabitsTab();
const Widget friendsTabWidget = FriendsTab();
const Widget reportsTabWidget = ReportsTab();
const Widget settingsTabWidget = SettingsTab();
const Widget addHabitsWidget = AddHabits();

const appbarTextStyle =
    TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white);
const buttonTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);
