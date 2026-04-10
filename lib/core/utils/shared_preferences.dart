import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  // --- Singleton setup ---
  static final AppPreference _instance = AppPreference._();
  factory AppPreference() => _instance;
  AppPreference._();

  static AppPreference get instance => _instance;

  late SharedPreferences _prefs;

  /// Must be called once before use (e.g., in main())
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Keys ---
  static String KEY_USER_DETAILS = "KEY_USER_DETAILS";
  static String KEY_TOKEN = "KEY_TOKEN";
  static String KEY_USER_ID = "KEY_USER_ID";
  static String KEY_ATTENDANCE_LOGIN = "KEY_ATTENDANCE_LOGIN";
  static String KEY_USER_ROLE = "KEY_USER_ROLE";
  static String KEY_SELECTED_UID = "KEY_SELECTED_UID";
  static String KEY_USER_FIRST_NAME = "KEY_USER_FIRST_NAME";
  static String KEY_USER_LAST_NAME = "KEY_USER_LAST_NAME";
  static String KEY_USER_TOKEN = "KEY_USER_TOKEN";
  static String KEY_USER_DOB = "KEY_USER_DOB";
  static String KEY_USER_IMAGE = "KEY_USER_IMAGE";
  static String KEY_USER_COMPANY_NAME = "KEY_USER_COMPANY_NAME";
  static String KEY_USER_MOBILE = "KEY_USER_MOBILE";
  static String KEY_USER_WORKLOCATION = "KEY_USER_WORKLOCATION";
  static String KEY_USER_MACHINE = "KEY_USER_MACHINE";
  static String KEY_USER_Email = "KEY_USER_Email";
  static String KEY_INTERNET_STATUS = "KEY_INTERNET_STATUS";
  static String KEY_BLE_MAC = "KEY_BLE_MAC";
  static String KEY_BLE_CONNECTED = "KEY_BLE_CONNECTED";
  static String KEY_BLE_NAME = "KEY_BLE_NAME";
  static String KEY_STEPS = "KEY_STEPS";
  static String KEY_HEARTRATE = "KEY_HEARTRATE";
  static String KEY_O2 = "KEY_O2";
  static String KEY_BATTERY = "KEY_BATTERY";
  static String KEY_CALORIES = "KEY_CALORIES";
  static String KEY_SLEEP_TIME = "KEY_SLEEP_TIME";
  static String KEY_DURATION = "KEY_DURATION";
  static String KEY_DURATION_IN_SECONDS = "KEY_DURATION_IN_SECONDS";
  static String KEY_LAST_SYNC_TIMESTAMP = "KEY_LAST_SYNC_TIMESTAMP";
  static String KEY_LAST_CONNECTED_TIMESTAMP = "KEY_LAST_CONNECTED_TIMESTAMP";
  static String KEY_SELECTED_HEIGHT = "KEY_SELECTED_HEIGHT";
  static String KEY_SELECTED_WEIGHT = "KEY_SELECTED_WEIGHT";
  static String KEY_LOGIN_AS_GUEST = "KEY_LOGIN_AS_GUEST";
  static String KEY_DEVICE_NAME = "KEY_DEVICE_NAME";
  static String KEY_DEVICE_MAC = "KEY_DEVICE_MAC";
  static String KEY_SELECTED_LANGUAGE = "KEY_SELECTED_LANGUAGE";
  static String KEY_DYNAMIC_THEME = "KEY_DYNAMIC_THEME";

  /// `false`  = user registered but hasn't completed onboarding setup yet
  /// `true`   = user has completed setup (added vehicle / done choice selector)
  /// `null`   = key was never written (existing user from before this feature → treat as done)
  static String KEY_SETUP_COMPLETE = "KEY_SETUP_COMPLETE";

  // --- Basic Getters/Setters ---
  Future<String> get({required String key}) async => _prefs.getString(key) ?? "";

  Future<void> set({required String key, required String value}) async =>
      _prefs.setString(key, value);

  Future<bool> getBool({required String key}) async => _prefs.getBool(key) ?? false;

  /// Returns `null` when the key has never been written (distinct from explicit `false`).
  Future<bool?> getBoolNullable({required String key}) async => _prefs.getBool(key);

  Future<void> setBool({required String key, required bool value}) async =>
      _prefs.setBool(key, value);

  Future<int> getInt({required String key}) async => _prefs.getInt(key) ?? 0;

  Future<void> setInt({required String key, required int value}) async =>
      _prefs.setInt(key, value);

  Future<double> getDouble({required String key}) async => _prefs.getDouble(key) ?? 0.0;

  Future<void> setDouble({required String key, required double value}) async =>
      _prefs.setDouble(key, value);

  // --- Clear / Remove ---
  Future<void> clearAll() async {
    final lang = _prefs.getString(KEY_SELECTED_LANGUAGE);
    await _prefs.clear();
    if (lang != null) {
      await _prefs.setString(KEY_SELECTED_LANGUAGE, lang);
    }
  }

  Future<void> clearByKey({required String key}) async => _prefs.remove(key);

  static Future<void> remove({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
