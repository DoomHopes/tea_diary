import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_diary/application/globals.dart';

final snackBarService = Provider<SnackBarService>((ref) => SnackBarService());

class SnackBarService with ChangeNotifier {
  void showError(String title, {String? error}) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          if (null != error)
            Text(
              error,
              style: TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
    snackBarKey.currentState?.showSnackBar(snackBar);
  }

  void showMessage(String title, {String? error}) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          if (null != error)
            Text(
              error,
              style: TextStyle(color: Colors.black),
            ),
        ],
      ),
    );
    snackBarKey.currentState?.showSnackBar(snackBar);
  }

  void showForceUpdate(String title, {String? error}) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.grey,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          if (null != error)
            Text(
              error,
              style: TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
    snackBarKey.currentState?.showSnackBar(snackBar);
  }
}
