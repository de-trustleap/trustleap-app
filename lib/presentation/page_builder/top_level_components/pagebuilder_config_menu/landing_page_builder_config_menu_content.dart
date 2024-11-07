import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_content_tab.dart';
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
  double _opacity = 1.0;

  void _selectTab(int index) async {
    setState(() {
      _opacity = 0.0;
    });
    await Future.delayed(Duration(milliseconds: widget.animationDuration));
    setState(() {
      _selectedTabIndex = index;
      _opacity = 1.0;
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
                id: widget.model.id.value,
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
                child: Stack(children: [
              // AnimatedOpacity for the Tab Content
              AnimatedOpacity(
                duration: Duration(milliseconds: widget.animationDuration),
                opacity: _selectedTabIndex == 0 ? _opacity : 0.0,
                child: Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: LandingPageBuilderConfigMenuContentTab(
                            model: widget.model))),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: widget.animationDuration),
                opacity: _selectedTabIndex == 1 ? _opacity : 0.0,
                child: Expanded(child: Center(child: Text("Design"))),
              ),
            ])),
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
