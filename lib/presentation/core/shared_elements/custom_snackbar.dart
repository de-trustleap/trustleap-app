// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

enum SnackBarType {
  success,
  failure
}

class CustomSnackBar {
  BuildContext context;

  CustomSnackBar.of(this.context);

  void showCustomSnackBar(String message, [SnackBarType type = SnackBarType.success]) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          backgroundColor: type == SnackBarType.success ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
          content: InkWell(
              onTap: () =>
                  {ScaffoldMessenger.of(context).removeCurrentSnackBar()},
              child: Center(child: Text(message)))));
  }
}
