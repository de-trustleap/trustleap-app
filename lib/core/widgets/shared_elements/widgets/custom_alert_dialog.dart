// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/native_alert_dialog.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/web_alert_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget? messageWidget;
  final bool isLoading;
  final String actionButtonTitle;
  final String? cancelButtonTitle;
  final bool cancelButtonDisabled;
  final bool actionButtonDisabled;
  final Function actionButtonAction;
  final Function? cancelButtonAction;
  final IconData? icon;
  final bool isDestructive;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.isLoading = false,
    this.messageWidget,
    required this.actionButtonTitle,
    required this.actionButtonAction,
    this.cancelButtonDisabled = false,
    this.actionButtonDisabled = false,
    this.cancelButtonTitle,
    this.cancelButtonAction,
    this.icon,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebAlertDialog(
        title: title,
        message: message,
        messageWidget: messageWidget,
        isLoading: isLoading,
        actionButtonTitle: actionButtonTitle,
        actionButtonAction: actionButtonAction,
        cancelButtonDisabled: cancelButtonDisabled,
        actionButtonDisabled: actionButtonDisabled,
        cancelButtonTitle: cancelButtonTitle,
        cancelButtonAction: cancelButtonAction,
      );
    }
    return NativeAlertDialog(
      title: title,
      message: message,
      messageWidget: messageWidget,
      isLoading: isLoading,
      actionButtonTitle: actionButtonTitle,
      actionButtonAction: actionButtonAction,
      cancelButtonDisabled: cancelButtonDisabled,
      actionButtonDisabled: actionButtonDisabled,
      cancelButtonTitle: cancelButtonTitle,
      cancelButtonAction: cancelButtonAction,
      icon: icon,
      isDestructive: isDestructive,
    );
  }
}
