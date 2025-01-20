import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final SharedPreferencesAsync _prefs;

  SharedPreferencesHelper(this._prefs);

  // String
  Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  Future<String?> getString(String key) async => _prefs.getString(key);

  // Int
  Future<void> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  Future<int?> getInt(String key) async => _prefs.getInt(key);

  // Double
  Future<void> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  Future<double?> getDouble(String key) async => _prefs.getDouble(key);

  // Bool
  Future<void> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  Future<bool?> getBool(String key) async => _prefs.getBool(key);

  // List<String>
  Future<void> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  Future<List<String>?> getStringList(String key) async =>
      _prefs.getStringList(key);

  // Remove
  Future<void> remove(String key) async => await _prefs.remove(key);

  // Clear all
  Future<void> clear() async => await _prefs.clear();
}
