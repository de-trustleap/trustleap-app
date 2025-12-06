import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_content.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_page_menu/pagebuilder_page_menu.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenu extends StatefulWidget {
  final bool isOpen;
  final PagebuilderConfigMenuState menuState;
  final PageBuilderWidget? model;
  final PageBuilderSection? section;
  final List<PageBuilderSection>? allSections;
  final Function closeMenu;
  final LandingPage? landingPage;

  const LandingPageBuilderConfigMenu({
    super.key,
    required this.isOpen,
    required this.menuState,
    required this.model,
    required this.section,
    this.allSections,
    required this.closeMenu,
    required this.landingPage,
  });

  @override
  State<LandingPageBuilderConfigMenu> createState() =>
      _LandingPageBuilderConfigMenuState();
}

class _LandingPageBuilderConfigMenuState
    extends State<LandingPageBuilderConfigMenu> {
  final menuWidth = 400.0;
  final animationDuration = 100;

  bool _shouldShowOnlyDesignTab() {
    switch (widget.model?.elementType) {
      case PageBuilderWidgetType.container ||
            PageBuilderWidgetType.column ||
            PageBuilderWidgetType.row ||
            PageBuilderWidgetType.footer:
        return true;
      default:
        return false;
    }
  }

  bool _shouldShowOnlyContentTab() {
    switch (widget.model?.elementType) {
      case PageBuilderWidgetType.height:
        return true;
      default:
        return false;
    }
  }

  Widget _getMenuContent() {
    if (widget.menuState is PageBuilderPageMenuOpenedState) {
      return PagebuilderPageMenu(
        key: ValueKey((widget.menuState as PageBuilderPageMenuOpenedState).id),
        menuWidth: menuWidth,
      );
    } else if (widget.menuState is PageBuilderConfigMenuOpenedState ||
        widget.menuState is PageBuilderSectionConfigMenuOpenedState) {
      return LandingPageBuilderConfigMenuContent(
        key: widget.model != null
            ? ValueKey("${widget.model?.id}+1")
            : ValueKey("${widget.section?.id}+1"),
        animationDuration: animationDuration,
        menuWidth: menuWidth,
        model: widget.model,
        section: widget.section,
        allSections: widget.allSections ?? [],
        showOnlyDesignTab: _shouldShowOnlyDesignTab(),
        showOnlyContentTab: _shouldShowOnlyContentTab(),
        closeMenu: widget.closeMenu,
        landingPage: widget.landingPage,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return AnimatedSwitcher(
      duration: Duration(milliseconds: animationDuration),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          axis: Axis.horizontal,
          sizeFactor: animation,
          child: child,
        );
      },
      child: widget.isOpen
          ? Container(
              key: ValueKey<bool>(widget.isOpen),
              width: menuWidth,
              color: themeData.colorScheme.surface,
              child: _getMenuContent(),
            )
          : SizedBox.shrink(
              key: ValueKey<bool>(widget.isOpen),
            ),
    );
  }
}
