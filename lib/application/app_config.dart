import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  Map<String, dynamic> _variables = {};
  late SharedPreferences _prefs;
  String _currentEnv = 'dev';
  static const String _envKey = 'selected_env';
  final ValueNotifier<String> _envNotifier = ValueNotifier('dev');

  AppConfig._internal();

  static final AppConfig _instance = AppConfig._internal();

  static Future<void> initialize() async {
    await _instance._loadPreferences();
    await _instance._loadEnvVariables(env: _instance._currentEnv);
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _currentEnv = _prefs.getString(_envKey) ?? 'dev';
    _envNotifier.value = _currentEnv;
  }

  Future<void> _loadEnvVariables({required String env}) async {
    try {
      final String loadedVariables = await rootBundle.loadString(
        'assets/config/$env.json',
      );
      _variables = jsonDecode(loadedVariables) ?? {};
    } catch (e) {
      _variables = {};
      if (kDebugMode) {
        print('Error loading $env.json: $e');
      }
    }
  }

  static Future<void> switchEnvironment(String newEnv) async {
    if (_instance._currentEnv == newEnv) return;

    await _instance._prefs.setString(_envKey, newEnv);
    _instance._currentEnv = newEnv;
    _instance._envNotifier.value = newEnv;
    await _instance._loadEnvVariables(env: newEnv);
  }

  static String get currentEnvironment => _instance._currentEnv;

  /// ---------------------------
  /// Слушатель изменений окружения
  /// ---------------------------
  ///
  /// Используйте этот виджет, чтобы автоматически обновлять UI при смене окружения:
  ///
  /// ```
  /// ValueListenableBuilder<String>(
  ///   valueListenable: AppConfig.envNotifier,
  ///   builder: (context, env, _) {
  ///     return Text('Текущее окружение: $env');
  ///   },
  /// )
  /// ```
  ///
  /// При вызове [AppConfig.switchEnvironment('dev')] или другого окружения,
  /// UI обновится автоматически.
  ///
  /// Пример:
  /// ```
  /// ElevatedButton(
  ///   onPressed: () async {
  ///     await AppConfig.switchEnvironment('dev');
  ///   },
  ///   child: Text('Переключить на DEV'),
  /// )
  /// ```

  static ValueNotifier<String> get envNotifier => _instance._envNotifier;

  static dynamic get(String key) => _instance._variables[key];

  static dynamic getLocalStorageInstance() {
    return _instance._prefs;
  }

  static Map<String, dynamic> get variables => Map<String, dynamic>.from(_instance._variables);
}
