// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazza/user/authentication/login_screen.dart';
import 'package:magazza/user/fragments/dashboard_of_fragments.dart';
import 'package:magazza/user/userPreferences/user_preferences.dart';
//import 'package:magazza/user/authentication/signup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Magazza App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: RememberUsersPrefs.readUserInfo(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.data == null) {
              return LoginScreen();
            } else {
              return DashboardOfFragments();
            }
          }),
    );
  }
}
