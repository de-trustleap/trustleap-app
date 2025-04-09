import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/core/menu/menu_item.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSideMenu extends StatelessWidget {
  final bool collapsed;
  final AnimationController? animationController;
  const AdminSideMenu(
      {super.key, this.collapsed = false, this.animationController});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<MenuCubit>(context),
        child: BlocBuilder<MenuCubit, MenuState>(builder: ((context, state) {
          return ListView(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 40),
              MenuItem(
                  path: RoutePaths.companyRequestsPath,
                  icon: Icons.person,
                  type: MenuItems.adminCompanyRequests,
                  isCollapsed: collapsed,
                  animationController: animationController,
                  isAdmin: true),
              const SizedBox(height: 20),
              MenuItem(
                  path: RoutePaths.registrationCodes,
                  icon: Icons.code,
                  type: MenuItems.registrationCodes,
                  isCollapsed: collapsed,
                  animationController: animationController,
                  isAdmin: true)
            ])
          ]);
        })));
  }
}
