import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DataStore {
  static late SharedPreferences _prefs;

  DataStore._privateConstructor();

  static final DataStore _instance = DataStore._privateConstructor();

  static Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  factory DataStore() {
    initPrefs();
    return _instance;
  }

  SharedPreferences get prefs => _prefs;

  read(String key) async {
    return prefs.getString(key);
  }

  save(String key, value) async {
    prefs.setString(key, value);
  }

  remove(String key) async {
    prefs.remove(key);
  }
}
