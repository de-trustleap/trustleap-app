import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_content.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenu extends StatefulWidget {
  final bool isOpen;
  final PageBuilderWidget model;
  final Function closeMenu;
  const LandingPageBuilderConfigMenu(
      {super.key,
      required this.isOpen,
      required this.model,
      required this.closeMenu});

  @override
  State<LandingPageBuilderConfigMenu> createState() =>
      _LandingPageBuilderConfigMenuState();
}

class _LandingPageBuilderConfigMenuState
    extends State<LandingPageBuilderConfigMenu> {
  final menuWidth = 400.0;
  final animationDuration = 100;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AnimatedContainer(
        duration: Duration(milliseconds: animationDuration),
        width: widget.isOpen ? menuWidth : 0,
        color: themeData.colorScheme.surface,
        child: widget.isOpen
            ? LandingPageBuilderConfigMenuContent(
                animationDuration: animationDuration,
                menuWidth: menuWidth,
                model: widget.model,
                closeMenu: widget.closeMenu)
            : SizedBox.shrink());
  }
}
