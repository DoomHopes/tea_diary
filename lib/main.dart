import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_diary/app_widget.dart';

void main() {
  runApp(ProviderScope(child: const TeaDiaryApp()));
}
