import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/core/menu/menu_item.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSideMenu extends StatelessWidget {
  const AdminSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<MenuCubit>(context),
        child: BlocBuilder<MenuCubit, MenuState>(builder: ((context, state) {
          return ListView(children: [
            const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  MenuItem(
                      path: RoutePaths.companyRequestsPath,
                      icon: Icons.person,
                      type: MenuItems.adminCompanyRequests,
                      isCollapsed: false),
                ])
          ]);
        })));
  }
}
