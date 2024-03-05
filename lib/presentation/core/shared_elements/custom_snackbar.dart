// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomSnackBar {
  BuildContext context;

  CustomSnackBar.of(this.context);

  void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: InkWell(
              onTap: () =>
                  {ScaffoldMessenger.of(context).removeCurrentSnackBar()},
              child: Center(child: Text(message)))));
  }
}
