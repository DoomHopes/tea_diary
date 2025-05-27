import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cupsService = ChangeNotifierProvider<CupsService>((ref) => CupsService(ref: ref));

final cupsProvider = Provider<int>((ref) {
  return ref.watch(cupsService).theNumberOfCups;
});

class CupsService extends ChangeNotifier {
  final Ref ref;

  CupsService({required this.ref});

  int _theNumberOfCups = 0;

  int get theNumberOfCups => _theNumberOfCups;

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
