import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String
  static Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Bool
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // Int
  static Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  // JSON Object
  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    return await _prefs?.setString(key, jsonString) ?? false;
  }

  static Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  // JSON List
  static Future<bool> setList(String key, List<dynamic> value) async {
    final jsonString = jsonEncode(value);
    return await _prefs?.setString(key, jsonString) ?? false;
  }

  static List<dynamic>? getList(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as List<dynamic>;
  }

  // Remove
  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  // Clear All
  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}