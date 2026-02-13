import 'package:finanzbegleiter/features/admin/presentation/admin_side_menu.dart';
import 'package:finanzbegleiter/features/menu/presentation/appbar.dart';
import 'package:finanzbegleiter/features/menu/presentation/collapsible_side_menu.dart';
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
      return const Scaffold(
          body: Row(children: [
        CollapsibleSideMenu(isAdmin: true),
        Expanded(child: RouterOutlet())
      ]));
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const PreferredSize(
              preferredSize: Size(double.infinity, 44), child: CustomAppBar()),
          backgroundColor: themeData.colorScheme.surface,
          body: const RouterOutlet(),
          endDrawer: const SizedBox(
              width: 240, child: Drawer(child: AdminSideMenu())));
    }
  }
}
