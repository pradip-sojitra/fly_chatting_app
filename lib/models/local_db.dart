import 'package:shared_preferences/shared_preferences.dart';

final sharedPref = SharedPrefs();

class SharedPrefs {
  SharedPrefs._internal();

  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() {
    return _instance;
  }

  static SharedPreferences? _sharedPreferences;

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  set uid(String value) => _sharedPreferences!.setString('uid', value);
  String get uid => _sharedPreferences!.getString('uid')!;

  set fullName(String value) =>
      _sharedPreferences!.setString('fullName', value);

  String get fullName => _sharedPreferences!.getString('fullName')!;

  set phoneNumber(String value) =>
      _sharedPreferences!.setString('phoneNumber', value);

  String get phoneNumber => _sharedPreferences!.getString('phoneNumber')!;

  set profilePicture(String value) =>
      _sharedPreferences!.setString('profilePicture', value);

  String get profilePicture => _sharedPreferences!.getString('profilePicture')!;

  set about(String value) => _sharedPreferences!.setString('about', value);

  String get about => _sharedPreferences!.getString('about')!;
}
