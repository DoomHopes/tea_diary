import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_diary/app_widget.dart';
import 'package:tea_diary/application/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.initialize();

  runApp(ProviderScope(child: const TeaDiaryApp()));
}
