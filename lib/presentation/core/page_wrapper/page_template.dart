// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/presentation/core/menu/appbar.dart';
import 'package:finanzbegleiter/presentation/core/menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    super.key,
  });

  Widget getResponsiveWidget(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);

    if (responsiveValue.largerThan(TABLET)) {
      return Scaffold(
          body: Row(children: [
        const SizedBox(width: 240, child: SideMenu()),
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
          endDrawer:
              const SizedBox(width: 240, child: Drawer(child: SideMenu())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<AuthCubit, AuthState>(listener: (context, state) {
        if (state is AuthStateUnAuthenticated) {}
      })
    ], child: getResponsiveWidget(context));
  }
}
