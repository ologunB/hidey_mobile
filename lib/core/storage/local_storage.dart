import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_model.dart';

class AppCache {
  static String kUserBox = 'userBox';
  static final String tokenKey = 'tokenKeyrgewr';
  static final String userKey = 'userKeyrgewr';
  static final String gridKey = 'gridKeywrrgewr';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(kUserBox);
  }

  static Box<dynamic> get _userBox => Hive.box<dynamic>(kUserBox);

  static Future<void> setUser(User a) async {
    await _userBox.put(userKey, a.toJson());
  }

  static User? getUser() {
    return User.fromJson(_userBox.get(userKey));
  }

  static Future<void> setToken(String a) async {
    await _userBox.put(tokenKey, a);
  }

  static String? getToken() {
    return _userBox.get(tokenKey);
  }

  static Future<void> setGridType(bool a) async {
    await _userBox.put(gridKey, a);
  }

  static bool getGridType() {
    return _userBox.get(gridKey, defaultValue: true);
  }

  static Future<void> clear() async {
    await _userBox.clear();
  }

  static void clean(String key) {
    _userBox.delete(key);
  }
}
