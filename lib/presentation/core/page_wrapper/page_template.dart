// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/core/menu/appbar.dart';
import 'package:finanzbegleiter/presentation/core/menu/collapsible_side_menu.dart';
import 'package:finanzbegleiter/presentation/core/menu/side_menu.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/feedback/feedback_floating_action_button.dart';
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
      return const Scaffold(
          body: Row(children: [
            CollapsibleSideMenu(isAdmin: false),
            Expanded(child: RouterOutlet())
          ]),
          floatingActionButton: FeedbackFloatingActionButton());
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const PreferredSize(
              preferredSize: Size(double.infinity, 44), child: CustomAppBar()),
          backgroundColor: themeData.colorScheme.surface,
          body: const RouterOutlet(),
          endDrawer: const SizedBox(
              width: MenuDimensions.menuOpenWidth,
              child: Drawer(child: SideMenu())),
          floatingActionButton: const FeedbackFloatingActionButton());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
      builder: (context, state) {
        if (state is PermissionSuccessState) {
          return getResponsiveWidget(context);
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}
