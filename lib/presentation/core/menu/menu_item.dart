// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MenuItem extends StatefulWidget {
  final String path;
  final IconData icon;
  final MenuItems type;
  final bool isURLMatching;
  final bool isCollapsed;
  final AnimationController? animationController;

  const MenuItem(
      {super.key,
      required this.path,
      required this.icon,
      required this.type,
      required this.isURLMatching,
      required this.isCollapsed,
      this.animationController});

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
              end: MenuDimensions.menuCollapsedWidth)
          .animate(widget.animationController!);
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
      case MenuItems.promoters:
        return localization.menuitems_promoters;
      case MenuItems.landingpage:
        return localization.menuitems_landingpage;
      case MenuItems.activities:
        return localization.menuitems_activities;
      case MenuItems.adminCompanyRequests:
        return localization.menuitems_company_requests;
      case MenuItems.none:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      final hoveredTransform = Matrix4.identity()..scale(1.1);
      final transform = itemIsHovered ? hoveredTransform : Matrix4.identity();
      final width = constraints.maxWidth;
      const height = 56.0;
      const padding = 12.0;

      return BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => hoverOnItem(true),
            onExit: (_) => hoverOnItem(false),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                BlocProvider.of<MenuCubit>(context).selectMenu(widget.type);
                Modular.to.navigate(RoutePaths.homePath + widget.path);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.isURLMatching
                        ? _widthAnimation?.value ?? width
                        : 0,
                    height: height,
                    curve: const Cubic(0.5, 0.8, 0.4, 1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: widget.isURLMatching
                            ? themeData.colorScheme.primary
                            : themeData.colorScheme.surface),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: transform,
                    width: _widthAnimation?.value ?? width,
                    height: height,
                    curve: const Cubic(0.5, 0.8, 0.4, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: padding, vertical: 16),
                    child: Row(children: [
                      Icon(widget.icon,
                          color: widget.isURLMatching
                              ? themeData.colorScheme.surface
                              : themeData.iconTheme.color),
                      // when animation controller is given then it should be desktop size and the
                      // text is shown depending on animation value. If it is null then the text should
                      // show up normally.
                      if (widget.animationController != null) ...[
                        if (_widthAnimation != null &&
                            _widthAnimation!.value >=
                                MenuDimensions.menuOpenWidth) ...[
                          const SizedBox(width: 12),
                          Text(getLocalizedMenuItem(localization),
                              style: widget.isURLMatching
                                  ? themeData.textTheme.bodyMedium!.copyWith(
                                      color: themeData.colorScheme.surface)
                                  : themeData.textTheme.bodyMedium),
                        ]
                      ] else ...[
                        const SizedBox(width: 12),
                        Text(getLocalizedMenuItem(localization),
                            style: widget.isURLMatching
                                ? themeData.textTheme.bodyMedium!.copyWith(
                                    color: themeData.colorScheme.surface)
                                : themeData.textTheme.bodyMedium)
                      ]
                    ]),
                  ),
                ]),
              ),
            ),
          );
        },
      );
    });
  }
}
