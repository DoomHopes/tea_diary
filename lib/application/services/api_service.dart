import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tea_diary/application/app_config.dart';
import 'package:tea_diary/application/services/auth_service.dart';
import 'package:tea_diary/application/services/snack_bar_service.dart';

final apiService = ChangeNotifierProvider<ApiService>((ref) {
  return ApiService(ref: ref);
});

class ApiService extends ChangeNotifier {
  final Ref ref;

  String? _token;
  ApiService({required this.ref}) {
    init();
  }

  void init() {
    SharedPreferences localStorage = AppConfig.getLocalStorageInstance();
    Uri uri = Uri(scheme: AppConfig.get('api_scheme'), host: AppConfig.get('api_host'), path: AppConfig.get('api_prefix'));

    localStorage.setString('api_url', uri.toString());
  }

  Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup(AppConfig.get('api_host'));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  void resetToken() {
    _token = null;
  }

  String? retrieveToken() {
    SharedPreferences localStorage = AppConfig.getLocalStorageInstance();
    if (localStorage.containsKey('token')) {
      final retrievedToken = localStorage.getString('token');
      _token = retrievedToken;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getRequest(String endpoint, Map<String, dynamic> queryParameters,
      {Map<String, String>? headers, bool tokenRequired = true}) async {
    if (await hasInternetAccess() == false) {
      return null;
    }

    if (tokenRequired) {
      final auth = ref.read(authService);
      if (!auth.isAuth) {
        return null;
      }

      if (null == _token) {
        retrieveToken();
      }
    }

    if (tokenRequired) {
      headers ??= {
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };
    }

    Uri uri = Uri(
      scheme: AppConfig.get('api_scheme'),
      host: AppConfig.get('api_host'),
      path: AppConfig.get('api_prefix') + endpoint,
      queryParameters: queryParameters,
    );

    if (kDebugMode) {
      print(['request to uri', uri, endpoint]);
      debugPrint(_token);
    }

    try {
      http.Response response = await http.get(uri, headers: headers);
      if (kDebugMode) {
        print(['response', response]);
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data.containsKey('exception')) {
        ref.read(snackBarService).showMessage("API error.", error: "An error occurred while requesting data");
      } else if (data.containsKey('message') && data['message'] == "Unauthenticated.") {
        if (tokenRequired) {
          ref.read(snackBarService).showMessage("Unauthenticated.");
        }
      }

      return data;
    } catch (error) {
      ref.read(snackBarService).showMessage("Sync failed. Try again");
    }

    return null;
  }

  Future<Map<String, dynamic>?> patchRequest(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers, bool tokenRequired = true}) async {
    if (await hasInternetAccess() == false) {
      return null;
    }

    if (tokenRequired) {
      final auth = ref.read(authService);
      if (!auth.isAuth) {
        return null;
      }

      if (null == _token) {
        retrieveToken();
      }
    }

    headers ??= {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    Uri uri = Uri(
      scheme: AppConfig.get('api_scheme'),
      host: AppConfig.get('api_host'),
      path: AppConfig.get('api_prefix') + endpoint,
    );

    if (kDebugMode) {
      print(['request to uri', uri, endpoint]);
      print(['request params', body]);
    }

    try {
      http.Response response = await http.patch(uri, headers: headers, body: jsonEncode(body));

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data.containsKey('exception')) {
        ref.read(snackBarService).showMessage("API error.", error: "An error occurred while requesting data");
      } else if (data.containsKey('message') && data['message'] == "Unauthenticated.") {
        ref.read(snackBarService).showMessage("Unauthenticated.");
        Future.delayed(const Duration(seconds: 2)).then((value) {
          ref.read(authService).logOut();
        });
      }

      return data;
    } catch (error) {
      ref.read(snackBarService).showMessage("Sync failed. Try again");
    }

    return null;
  }

  Future<Map<String, dynamic>?> putRequest(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers, bool tokenRequired = true}) async {
    if (await hasInternetAccess() == false) {
      return null;
    }

    if (tokenRequired) {
      final auth = ref.read(authService);
      if (!auth.isAuth) {
        return null;
      }

      if (null == _token) {
        retrieveToken();
      }
    }

    headers ??= {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    Uri uri = Uri(
      scheme: AppConfig.get('api_scheme'),
      host: AppConfig.get('api_host'),
      path: AppConfig.get('api_prefix') + endpoint,
    );

    if (kDebugMode) {
      print(['request to uri', uri, endpoint]);
      print(['request params', body]);
    }

    try {
      http.Response response = await http.put(uri, headers: headers, body: jsonEncode(body));
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data;
    } catch (error) {
      ref.read(snackBarService).showMessage("Sync failed. Try again");
    }
    return null;
  }

  Future<Map<String, dynamic>?> optionsRequest(String endpoint,
      {Map<String, String>? headers, bool tokenRequired = true}) async {
    if (await hasInternetAccess() == false) {
      return null;
    }

    if (tokenRequired) {
      final auth = ref.read(authService);
      if (!auth.isAuth) {
        return null;
      }

      if (null == _token) {
        retrieveToken();
      }
    }

    Uri uri = Uri(scheme: AppConfig.get('api_scheme'), host: AppConfig.get('api_host'), path: AppConfig.get('api_prefix') + endpoint);

    if (kDebugMode) {
      print(['options request to uri', uri, endpoint]);
      debugPrint(_token);
    }

    try {
      final client = http.Client();
      final request = http.Request('OPTIONS', uri)
        ..headers[HttpHeaders.contentTypeHeader] = 'application/json; charset=UTF-8'
        ..headers[HttpHeaders.authorizationHeader] = 'Bearer $_token';
      final streamedResponse = await client.send(request);
      http.Response response = await http.Response.fromStream(streamedResponse);
      if (kDebugMode) {
        print(['response', response]);
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data.containsKey('exception')) {
        ref.read(snackBarService).showMessage("API error.", error: "An error occurred while requesting data");
      } else if (data.containsKey('message') && data['message'] == "Unauthenticated.") {
        ref.read(snackBarService).showMessage("Unauthenticated.");
        Future.delayed(const Duration(seconds: 2)).then((value) {
          ref.read(authService).logOut();
        });
      }

      return data;
    } catch (error) {
      ref.read(snackBarService).showMessage("Sync failed. Try again");
    }

    return null;
  }

  Future<Map<String, dynamic>?> postRequest(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers, bool tokenRequired = true, bool shishhh = false}) async {
    if (await hasInternetAccess() == false) {
      return null;
    }

    if (tokenRequired) {
      final auth = ref.read(authService);
      if (!auth.isAuth) {
        return null;
      }

      if (null == _token) {
        retrieveToken();
      }
    }

    if (tokenRequired) {
      headers ??= {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };
    }

    Uri uri = Uri(
      scheme: AppConfig.get('api_scheme'),
      host: AppConfig.get('api_host'),
      path: AppConfig.get('api_prefix') + endpoint,
    );

    if (kDebugMode) {
      print(['request to uri', uri, endpoint]);
      print(['request params', body]);
    }

    try {
      http.Response response = await http.post(uri, headers: headers, body: jsonEncode(body));
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data.containsKey('exception')) {
        if (!shishhh) {
          ref.read(snackBarService).showMessage("API error.", error: "An error occurred while requesting data");
        }
      } else if (data.containsKey('message') && data['message'] == "Unauthenticated.") {
        if (tokenRequired) {
          if (!shishhh) {
            ref.read(snackBarService).showMessage("Unauthenticated.");
          }
        }
      }

      return data;
    } catch (error) {
      if (!shishhh) {
        ref.read(snackBarService).showMessage("Sync failed. Try again");
      }
    }

    return null;
  }

  Future<Map<String, dynamic>?> deleteRequest(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers, bool tokenRequired = true}) async {
    if (await hasInternetAccess() == false) {
      return null;
    }

    if (tokenRequired) {
      final auth = ref.read(authService);
      if (!auth.isAuth) {
        return null;
      }

      if (null == _token) {
        retrieveToken();
      }
    }

    headers ??= {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    Uri uri = Uri(
      scheme: AppConfig.get('api_scheme'),
      host: AppConfig.get('api_host'),
      path: AppConfig.get('api_prefix') + endpoint,
    );

    if (kDebugMode) {
      print(['request to uri', uri, endpoint]);
    }

    try {
      http.Response response = await http.delete(uri, headers: headers, body: jsonEncode(body));
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data.containsKey('exception')) {
        ref.read(snackBarService).showMessage("API error.", error: "An error occurred while requesting data");
      } else if (data.containsKey('message') && data['message'] == "Unauthenticated.") {
        ref.read(snackBarService).showMessage("Unauthenticated.");
      }

      return data;
    } catch (error) {
      ref.read(snackBarService).showError("API error", error: error.toString());
    }

    return null;
  }
}
