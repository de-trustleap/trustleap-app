import 'package:finanzbegleiter/presentation/admin_area/admin_side_menu.dart';
import 'package:finanzbegleiter/presentation/core/menu/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);

    if (responsiveValue.largerThan(TABLET)) {
      return Scaffold(
          body: Row(children: [
        const SizedBox(width: 240, child: AdminSideMenu()),
        Container(width: 0.5, color: themeData.textTheme.bodyMedium!.color),
        const Expanded(child: RouterOutlet())
      ]));
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const PreferredSize(
              preferredSize: Size(double.infinity, 44), child: CustomAppBar()),
          backgroundColor: themeData.colorScheme.background,
          body: const RouterOutlet(),
          endDrawer: const SizedBox(
              width: 240, child: Drawer(child: AdminSideMenu())));
    }
  }
}
