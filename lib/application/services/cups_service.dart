import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_diary/application/services/api_service.dart';
import 'package:tea_diary/application/services/snack_bar_service.dart';

final cupsService = ChangeNotifierProvider<CupsService>((ref) => CupsService(ref: ref));

final cupsProvider = Provider<int>((ref) {
  return ref.watch(cupsService).theNumberOfCups;
});

class CupsService extends ChangeNotifier {
  final Ref ref;

  CupsService({required this.ref});

  int _theNumberOfCups = 0;

  int get theNumberOfCups => _theNumberOfCups;

  void testMessage() async {
    final data = await ref.read(apiService).getRequest('hello', {}, tokenRequired: false);

    if (data != null) {
      ref.read(snackBarService).showMessage(data['message']);
    }
  }

  void add(int cups) {
    _theNumberOfCups += cups;
    notifyListeners();
  }

  void remove(int cups) {
    _theNumberOfCups -= cups;
    notifyListeners();
  }

  void clear(int cups) {
    _theNumberOfCups = 0;
    notifyListeners();
  }
}
