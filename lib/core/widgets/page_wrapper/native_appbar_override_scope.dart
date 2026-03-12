import 'package:flutter/material.dart';

class NativeAppBarOverrideScope extends InheritedWidget {
  final ValueNotifier<String?> titleOverride;
  final ValueNotifier<List<Widget>?> actionsOverride;

  const NativeAppBarOverrideScope({
    super.key,
    required this.titleOverride,
    required this.actionsOverride,
    required super.child,
  });

  static NativeAppBarOverrideScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NativeAppBarOverrideScope>();

  @override
  bool updateShouldNotify(NativeAppBarOverrideScope oldWidget) =>
      titleOverride != oldWidget.titleOverride ||
      actionsOverride != oldWidget.actionsOverride;
}
