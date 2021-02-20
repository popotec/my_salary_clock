import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    print('sharedPreference is created');
    return _prefsInstance;
  }

  static SharedPreferences getObject() {
    return _prefsInstance;
  }

  static String getString(String key) {
    return _prefsInstance.getString(key) ?? '';
  }

  static Future<bool> setString(String key, String value) async {
    //var prefs = await _instance;
    return _prefsInstance?.setString(key, value) ?? Future.value(false);
  }

  static Future<bool> deleteKey(String key) async {
    //var prefs = await _instance;
    return _prefsInstance?.remove(key) ?? Future.value(false);
  }
}
