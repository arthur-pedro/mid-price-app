import 'package:flutter/material.dart';

enum ViewSnackbarStatus {
  error,
  success,
  info,
  warning,
}

Map<ViewSnackbarStatus, MaterialColor> _mapStatusValues = {
  ViewSnackbarStatus.error: Colors.deepOrange,
  ViewSnackbarStatus.success: Colors.teal,
  ViewSnackbarStatus.info: Colors.lightBlue,
  ViewSnackbarStatus.warning: Colors.amber,
};

abstract class ViewSnackbar {
  static void show(
      BuildContext context, String text, ViewSnackbarStatus status) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
          textColor: Colors.white,
          disabledTextColor: Colors.grey,
        ),
        backgroundColor: _mapStatusValues[status],
        duration: const Duration(seconds: 5),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        behavior: SnackBarBehavior.floating,
        content: Text(text)));
  }
}
