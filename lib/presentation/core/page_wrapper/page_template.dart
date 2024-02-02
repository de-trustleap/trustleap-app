// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/menu/appbar.dart';
import 'package:finanzbegleiter/presentation/core/menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class PageTemplate extends StatelessWidget {
  final Widget child;

  const PageTemplate({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);

    if (responsiveValue.largerThan(TABLET)) {
      return Material(
        child: Row(children: [
          const SizedBox(width: 240, child: SideMenu()),
          Container(width: 0.5, color: themeData.textTheme.headlineLarge!.color),
          Expanded(child: child)
        ]),
      );
    } else {
      return Scaffold(
          appBar: const PreferredSize(
              preferredSize: Size(double.infinity, 44), child: CustomAppBar()),
          backgroundColor: themeData.colorScheme.background,
          body: child,
          endDrawer:
              const SizedBox(width: 240, child: Drawer(child: SideMenu())));
    }
  }
}
