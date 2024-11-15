import 'package:flutter/material.dart';
// snack bar function. the below line is needed for the page to use said function
// import 'snackbar_helper.dart';
class SnackbarHelper {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );

    // Display the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}