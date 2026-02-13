// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/features/menu/application/menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuItem extends StatefulWidget {
  final String path;
  final IconData icon;
  final MenuItems type;
  final bool isCollapsed;
  final AnimationController? animationController;
  final bool isAdmin;

  const MenuItem({
    super.key,
    required this.path,
    required this.icon,
    required this.type,
    required this.isCollapsed,
    this.isAdmin = false,
    this.animationController,
  });

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool itemIsHovered = false;
  Animation<double>? _widthAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animationController != null) {
      _widthAnimation = Tween<double>(
        begin: MenuDimensions.menuOpenWidth,
        end: MenuDimensions.menuCollapsedWidth,
      ).animate(widget.animationController!);
    }
  }

  void hoverOnItem(bool isHovering) => setState(() {
        itemIsHovered = isHovering;
      });

  String getLocalizedMenuItem(AppLocalizations localization) {
    switch (widget.type) {
      case MenuItems.profile:
        return localization.menuitems_profile;
      case MenuItems.dashboard:
        return localization.menuitems_dashboard;
      case MenuItems.recommendations:
        return localization.menuitems_recommendations;
      case MenuItems.recommendationManager:
        return localization.menuitems_recommendation_manager;
      case MenuItems.promoters:
        return localization.menuitems_promoters;
      case MenuItems.landingpage:
        return localization.menuitems_landingpage;
      case MenuItems.adminCompanyRequests:
        return localization.menuitems_company_requests;
      case MenuItems.registrationCodes:
        return localization.menuitems_registration_codes;
      case MenuItems.userFeedback:
        return localization.menuitems_user_feedback;
      case MenuItems.legals:
        return localization.menuitems_legals;
      case MenuItems.templates:
        return localization.menuitems_templates;
      case MenuItems.none:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);

    return BlocBuilder<MenuCubit, MenuState>(
      buildWhen: (previous, current) =>
          current is MenuItemSelectedState &&
              current.selectedMenuItem == widget.type ||
          (previous is MenuItemSelectedState &&
              previous.selectedMenuItem == widget.type),
      builder: (context, state) {
        final isCurrentlySelected = (state is MenuItemSelectedState &&
            state.selectedMenuItem == widget.type);

        return LayoutBuilder(
          builder: (context, constraints) {
            final scaleValue = itemIsHovered ? 1.1 : 1.0;
            final width = constraints.maxWidth;
            const height = 56.0;
            const padding = 12.0;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => hoverOnItem(true),
              onExit: (_) => hoverOnItem(false),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (Scaffold.of(context).isEndDrawerOpen) {
                    navigator.pop();
                  }
                  if (widget.isAdmin) {
                    navigator.navigate(RoutePaths.adminPath + widget.path);
                  } else {
                    navigator.navigate(RoutePaths.homePath + widget.path);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isCurrentlySelected
                            ? (_widthAnimation?.value ?? width)
                            : 0,
                        height: height,
                        curve: const Cubic(0.5, 0.8, 0.4, 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isCurrentlySelected
                              ? themeData.colorScheme.primary
                              : themeData.colorScheme.surface,
                        ),
                      ),
                      // Hier ist die Änderung zu AnimatedBuilder
                      AnimatedBuilder(
                        animation:
                            _widthAnimation ?? AlwaysStoppedAnimation(width),
                        builder: (context, child) {
                          return AnimatedScale(
                            scale: scaleValue,
                            duration: const Duration(milliseconds: 200),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: _widthAnimation?.value ?? width,
                              height: height,
                              curve: const Cubic(0.5, 0.8, 0.4, 1),
                              padding: const EdgeInsets.symmetric(
                                horizontal: padding,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    widget.icon,
                                    color: isCurrentlySelected
                                        ? themeData.colorScheme.surface
                                        : themeData.iconTheme.color,
                                  ),
                                  if (_widthAnimation == null ||
                                      _widthAnimation!.value >=
                                          MenuDimensions.menuOpenWidth) ...[
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        getLocalizedMenuItem(localization),
                                        style: isCurrentlySelected
                                            ? themeData.textTheme.bodyMedium!
                                                .copyWith(
                                                color: themeData
                                                    .colorScheme.surface,
                                              )
                                            : themeData.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
