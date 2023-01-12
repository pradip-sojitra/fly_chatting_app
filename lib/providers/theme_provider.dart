import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isCheckTheme = false;

  void checkTheme() {
    isCheckTheme = !isCheckTheme;
    setLocal();
    notifyListeners();
  }

  void getLocal() async {
    final pref = await SharedPreferences.getInstance();
    isCheckTheme = pref.getBool('theme')!;
    notifyListeners();
  }

  void setLocal() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('theme', isCheckTheme);
  }
}