import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_content_tab.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_design_tab.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_header.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuContent extends StatefulWidget {
  final int animationDuration;
  final double menuWidth;
  final PageBuilderWidget model;
  final Function closeMenu;
  const LandingPageBuilderConfigMenuContent(
      {super.key,
      required this.animationDuration,
      required this.menuWidth,
      required this.model,
      required this.closeMenu});

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
                title: widget.model.getWidgetTitle(localization),
                closePressed: () => widget.closeMenu()),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tabButton("Inhalt", 0),
                    _tabButton("Design", 1),
                  ],
                ),
                // Animated Indicator
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
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _selectedTabIndex == 0
                      ? LandingPageBuilderConfigMenuContentTab(
                          model: widget.model)
                      : LandingPageBuilderConfigMenuDesignTab(
                          model: widget.model)),
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
