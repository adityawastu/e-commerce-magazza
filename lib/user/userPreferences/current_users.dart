// ignore_for_file: unused_import, prefer_final_fields

import 'dart:convert';
import 'package:magazza/user/model/user.dart';
import 'package:get/get.dart';
import 'package:magazza/user/userPreferences/user_preferences.dart';

class CurrentUser extends GetxController {
  Rx<User> _currentUser = User(0, '', '', '', '').obs;
  User get user => _currentUser.value;

  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUsersPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}
