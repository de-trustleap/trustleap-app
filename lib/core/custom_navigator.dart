import 'package:flutter/widgets.dart';
import 'navigation/custom_navigator_base.dart';
import 'navigation/custom_navigator_web.dart'
    if (dart.library.io) 'navigation/custom_navigator_mobile.dart';

class CustomNavigator extends InheritedWidget {
  const CustomNavigator({
    super.key,
    required super.child,
    required this.navigator,
  });

  final CustomNavigatorBase navigator;

  static CustomNavigatorBase of(BuildContext context) {
    final CustomNavigator? result =
        context.dependOnInheritedWidgetOfExactType<CustomNavigator>();
    assert(result != null, 'No CustomNavigator found in context');
    return result!.navigator;
  }

  factory CustomNavigator.create({Key? key, required Widget child}) {
    final navigator = CustomNavigatorImplementation();
    return CustomNavigator(
      key: key,
      navigator: navigator,
      child: child,
    );
  }

  @override
  bool updateShouldNotify(CustomNavigator oldWidget) {
    return navigator != oldWidget.navigator;
  }
}
