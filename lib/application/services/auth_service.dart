import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tea_diary/application/app_config.dart';
import 'package:tea_diary/application/services/api_service.dart';
import 'package:tea_diary/application/services/snack_bar_service.dart';

final authService = ChangeNotifierProvider<AuthService>((ref) => AuthService(ref: ref));

class AuthService with ChangeNotifier {
  String? _token;

  final Ref ref;

  bool isProcessing = false;
  bool isInit = false;
  bool tokenRetrievalAttempted = false;

  AuthService({required this.ref}) {
    init();
  }

  void init() {
    SharedPreferences localStorage = AppConfig.getLocalStorageInstance();
    if (!localStorage.containsKey('token')) {
      return;
    }

    _token = localStorage.getString('token');
  }

  bool emailValidate(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  Future<Map> authorizeUsingEmail({required String email, required String password}) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      isProcessing = true;

      final uri = Uri(scheme: AppConfig.get('api_scheme'), host: AppConfig.get('api_host'), path: AppConfig.get('api_prefix') + '/login');

      try {
        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String?>{
            'email': email,
            'password': password,
          }),
        );
        final data = json.decode(response.body) as Map<String, dynamic>;

        bool status = data['status'];
        List messages = [];

        if (status && data['data']['token'] != null) {
          _token = data['data']['token'];

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', _token!);
          prefs.setString('userId', data['data']['user']['id'].toString());

          ref.read(apiService).init();
        } else {
          if (null != data['errors']) {
            List<dynamic> errorsList = data['errors'];
            List errorMessages = [];

            for (String message in errorsList) {
              errorMessages.add(message);
            }

            messages = errorMessages;
          }
        }

        isProcessing = false;

        return {'status': status, 'messages': messages};
      } catch (error) {
        ref.read(snackBarService).showError("API error", error: error.toString());
      }
    }

    return {
      'status': false,
      'messages': ['email and password are required'],
    };
  }

  Future<Map> sendResetPasswordEmail({required String email}) async {
    if (email.isNotEmpty) {
      final uri =
          Uri(scheme: AppConfig.get('api_scheme'), host: AppConfig.get('api_host'), path: AppConfig.get('api_prefix') + '/password/reset/send');

      try {
        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String?>{
            'email': email,
            'type': 'code',
          }),
        );
        final data = json.decode(response.body) as Map<String, dynamic>;

        List messages = [];

        if (data.containsKey('status') && data['status'] == true) {
          messages.add(data['message']);
          return {'status': data['status'], 'messages': messages};
        } else {
          if (null != data['errors']) {
            List<dynamic> errorsList = data['errors'];
            List errorMessages = [];

            for (String message in errorsList) {
              errorMessages.add(message);
            }

            messages = errorMessages;
          }
          return {'status': false, 'messages': messages};
        }
      } catch (error) {
        ref.read(snackBarService).showError("API error", error: error.toString());
      }
    }

    return {
      'status': false,
      'messages': ['email is required'],
    };
  }

  Future<Map> validateResetPasswordCode({required String code}) async {
    if (code.isNotEmpty) {
      isProcessing = true;

      final uri =
          Uri(scheme: AppConfig.get('api_scheme'), host: AppConfig.get('api_host'), path: AppConfig.get('api_prefix') + '/password/reset/validate');

      try {
        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String?>{
            'code': code,
          }),
        );
        final data = json.decode(response.body) as Map<String, dynamic>;

        List messages = [];

        if (data.containsKey('status') && data['status'] == true) {
          messages.add(data['message']);
          return {'status': data['status'], 'messages': messages};
        } else {
          if (null != data['errors']) {
            List<dynamic> errorsList = data['errors'];
            List errorMessages = [];

            for (String message in errorsList) {
              errorMessages.add(message);
            }

            messages = errorMessages;
          }
          return {'status': false, 'messages': messages};
        }
      } catch (error) {
        ref.read(snackBarService).showError("API error", error: error.toString());
      }
    }

    return {
      'status': false,
      'messages': ['code is required'],
    };
  }

  Future<Map> resetPasswordCode({required String code, required String password}) async {
    if (code.isNotEmpty && password.isNotEmpty) {
      isProcessing = true;

      final uri = Uri(scheme: AppConfig.get('api_scheme'), host: AppConfig.get('api_host'), path: AppConfig.get('api_prefix') + '/password/reset');

      try {
        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String?>{'code': code, 'password': password}),
        );
        final data = json.decode(response.body) as Map<String, dynamic>;

        List messages = [];

        if (data.containsKey('status') && data['status'] == true) {
          messages.add(data['message']);
          return {'status': data['status'], 'messages': messages};
        } else {
          if (null != data['errors']) {
            List<dynamic> errorsList = data['errors'];
            List errorMessages = [];

            for (String message in errorsList) {
              errorMessages.add(message);
            }

            messages = errorMessages;
          }
          return {'status': false, 'messages': messages};
        }
      } catch (error) {
        ref.read(snackBarService).showError("API error", error: error.toString());
      }
    }

    return {
      'status': false,
      'messages': ['code and password are required'],
    };
  }

  Future<Map> registration({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String name,
  }) async {
    Map<String, dynamic> queryParameters = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    final uri = Uri(
      scheme: AppConfig.get('api_scheme'),
      host: AppConfig.get('api_host'),
      path: AppConfig.get('api_prefix') + '/register',
      queryParameters: queryParameters,
    );

    bool status = false;
    List messages = [];

    try {
      var request = http.MultipartRequest(
        "POST",
        uri,
      );

      var response = await request.send();

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      final data = json.decode(responseString) as Map<String, dynamic>;
      status = data['status'];

      if (status && data['data']['token'] != null) {
        _token = data['data']['token'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _token!);
        prefs.setString('userId', data['data']['user']['id'].toString());

        ref.read(apiService).init();
      } else {
        if (null != data['errors']) {
          List<dynamic> errorsMap = data['errors'];

          for (var value in errorsMap) {
            messages.add(value);
          }
        }
      }

      isProcessing = false;
    } catch (error) {
      ref.read(snackBarService).showError("API error", error: error.toString());
    }

    return {'status': status, 'messages': messages};
  }

  bool get isAuth {
    if (null == token && false == tokenRetrievalAttempted) {
      tokenRetrievalAttempted = true;
      SharedPreferences localStorage = AppConfig.getLocalStorageInstance();
      if (!localStorage.containsKey('token')) {
        return false;
      }

      final retrievedToken = localStorage.getString('token');
      _token = retrievedToken;

      return true;
    }

    return null != token;
  }

  String? get token {
    return _token;
  }

  Future<void> logOut() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');

    ref.read(apiService).resetToken();
    notifyListeners();
  }
}
