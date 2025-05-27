import 'package:flutter/material.dart';
import 'package:tea_diary/modules/auth/pages/auth_page.dart';
import 'package:tea_diary/modules/auth/pages/registration_page.dart';
import 'package:tea_diary/modules/auth/pages/reset_password.dart';
import 'package:tea_diary/modules/errors/error_404_page.dart';
import 'package:tea_diary/modules/home/pages/home_page.dart';

Route<Function(RouteSettings)> onGenerateRoute(RouteSettings settings) {
  if (settings.name != null) {
    Uri uri = Uri.parse(settings.name ?? "");
    Map<String, dynamic> params = {};
    uri.queryParameters.forEach((key, value) {
      params[key] = int.tryParse(value) ?? value;
    });

    if (settings.name == '/home') {
      return MaterialPageRoute(settings: settings, builder: (context) => HomePage());
    }

    if (settings.name == '/auth') {
      return MaterialPageRoute(settings: settings, builder: (context) => AuthPage());
    }

    if (settings.name == '/registration') {
      return MaterialPageRoute(settings: settings, builder: (context) => RegistrationPage());
    }

    if (settings.name == '/resetpassword') {
      return MaterialPageRoute(settings: settings, builder: (context) => ResetPasswordPage());
    }

    return MaterialPageRoute(builder: (context) => Error404Screen());
  }

  return MaterialPageRoute(builder: (context) => Error404Screen());
}
