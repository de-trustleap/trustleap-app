import 'package:finanzbegleiter/core/refresh/native_refresh_notifier.dart';
import 'package:flutter/material.dart';

class RefreshScope extends InheritedWidget {
  final NativeRefreshNotifier notifier;

  const RefreshScope({
    super.key,
    required this.notifier,
    required super.child,
  });

  static NativeRefreshNotifier? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RefreshScope>()
        ?.notifier;
  }

  @override
  bool updateShouldNotify(RefreshScope oldWidget) =>
      notifier != oldWidget.notifier;
}
