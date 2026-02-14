import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_content_tab.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_design_tab.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_header.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_section.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuContent extends StatefulWidget {
  final int animationDuration;
  final double menuWidth;
  final PageBuilderWidget? model;
  final PageBuilderSection? section;
  final List<PageBuilderSection> allSections;
  final bool showOnlyDesignTab;
  final bool showOnlyContentTab;
  final Function closeMenu;
  final LandingPage? landingPage;
  final PageBuilderGlobalStyles? globalStyles;

  const LandingPageBuilderConfigMenuContent({
    super.key,
    required this.animationDuration,
    required this.menuWidth,
    required this.model,
    required this.section,
    required this.allSections,
    required this.showOnlyDesignTab,
    required this.showOnlyContentTab,
    required this.closeMenu,
    required this.landingPage,
    this.globalStyles,
  });

  @override
  State<LandingPageBuilderConfigMenuContent> createState() =>
      _LandingPageBuilderConfigMenuContentState();
}

class _LandingPageBuilderConfigMenuContentState
    extends State<LandingPageBuilderConfigMenuContent> {
  final dividerWidth = 0.5;
  int _selectedTabIndex = 0;

  void _selectTab(int index) async {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Widget _tabButton(String title, int index) {
    final themeData = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () => _selectTab(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child:
              Center(child: Text(title, style: themeData.textTheme.bodyLarge)),
        ),
      ),
    );
  }

  Widget _getContent() {
    if (widget.section != null) {
      return LandingPageBuilderConfigMenuSection(
        section: widget.section!,
        allSections: widget.allSections,
      );
    } else if (widget.showOnlyDesignTab && widget.model != null) {
      return LandingPageBuilderConfigMenuDesignTab(
        model: widget.model!,
        landingPage: widget.landingPage,
        globalStyles: widget.globalStyles,
      );
    } else if (widget.showOnlyContentTab && widget.model != null) {
      return LandingPageBuilderConfigMenuContentTab(
        model: widget.model!,
        globalStyles: widget.globalStyles,
      );
    } else if (widget.model != null) {
      if (_selectedTabIndex == 0) {
        return LandingPageBuilderConfigMenuContentTab(
          model: widget.model!,
          globalStyles: widget.globalStyles,
        );
      } else {
        return LandingPageBuilderConfigMenuDesignTab(
          model: widget.model!,
          landingPage: widget.landingPage,
          globalStyles: widget.globalStyles,
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  String _getHeaderTitle(AppLocalizations localization) {
    if (widget.model != null) {
      return widget.model?.getWidgetTitle(localization) ?? "";
    } else if (widget.section != null) {
      return localization.landingpage_pagebuilder_config_menu_section_type;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Row(
      children: [
        SizedBox(
          width: widget.menuWidth - dividerWidth,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            LandingPageBuilderConfigMenuHeader(
                title: _getHeaderTitle(localization),
                closePressed: () => widget.closeMenu()),
            if (!widget.showOnlyDesignTab &&
                !widget.showOnlyContentTab &&
                widget.section == null) ...[
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _tabButton(
                          localization
                              .landingpage_pagebuilder_config_menu_content_tab,
                          0),
                      _tabButton(
                          localization
                              .landingpage_pagebuilder_config_menu_design_tab,
                          1),
                    ],
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    left: _selectedTabIndex == 0 ? 0 : widget.menuWidth / 2,
                    bottom: 0,
                    child: Container(
                      height: 2,
                      width: widget.menuWidth / 2,
                      color: themeData.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _getContent()),
            ),
          ]),
        ),
        Container(
          width: dividerWidth,
          color: themeData.textTheme.bodyMedium!.color,
        ),
      ],
    );
  }
}
