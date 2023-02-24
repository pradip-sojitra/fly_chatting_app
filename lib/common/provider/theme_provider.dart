import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isChangeTheme = false;

  void changeTheme() {
    isChangeTheme = !isChangeTheme;
    setLocal();
    notifyListeners();
  }

  void getLocal() async {
    final pref = await SharedPreferences.getInstance();
    isChangeTheme = pref.getBool('theme')!;
    notifyListeners();
  }

  void setLocal() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('theme', isChangeTheme);
  }
}