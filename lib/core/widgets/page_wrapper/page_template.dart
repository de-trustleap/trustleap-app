// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/menu/presentation/appbar.dart';
import 'package:finanzbegleiter/features/menu/presentation/collapsible_side_menu.dart';
import 'package:finanzbegleiter/features/menu/presentation/side_menu.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/features/feedback/presentation/feedback_floating_action_button.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    super.key,
  });

  Widget getMainContent(BuildContext context) {
    return BlocBuilder<UserObserverCubit, UserObserverState>(
      builder: (context, userState) {
        if (userState is UserObserverFailure) {
          final localization = AppLocalizations.of(context);
          return ErrorView(
            title: "Abrufen des Nutzers fehlgeschlagen",
            message: DatabaseFailureMapper.mapFailureMessage(
                userState.failure, localization),
            callback: () {
              BlocProvider.of<UserObserverCubit>(context).observeUser();
            },
          );
        }
        return const RouterOutlet();
      },
    );
  }

  Widget getResponsiveWidget(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);

    if (responsiveValue.largerThan(TABLET)) {
      return Scaffold(
          body: Row(children: [
            const CollapsibleSideMenu(isAdmin: false),
            Expanded(child: getMainContent(context))
          ]),
          floatingActionButton: const FeedbackFloatingActionButton());
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const PreferredSize(
              preferredSize: Size(double.infinity, 44), child: CustomAppBar()),
          backgroundColor: themeData.colorScheme.surface,
          body: getMainContent(context),
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
