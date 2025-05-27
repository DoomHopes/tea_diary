import 'package:flutter/material.dart';
import 'package:tea_diary/application/routes/routes.dart';
import 'package:tea_diary/modules/auth/pages/auth_page.dart';
import 'package:tea_diary/modules/home/pages/home_page.dart';

class TeaDiaryApp extends StatelessWidget {
  const TeaDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: AuthPage(),
      initialRoute: '/auth',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
