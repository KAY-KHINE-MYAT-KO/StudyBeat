import 'package:hive_flutter/hive_flutter.dart';

class SessionService {
  static const _boxName = 'session';
  static const _keyIsLoggedIn = 'isLoggedIn';

  static Future<void> init() async {
    // Hive.initFlutter() is called in main.dart before this
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static bool get isLoggedIn =>
      _box.get(_keyIsLoggedIn, defaultValue: false) as bool;

  static Future<void> setLoggedIn(bool value) async {
    await _box.put(_keyIsLoggedIn, value);
  }

  static Future<void> clear() async {
    await _box.clear();
  }
}
