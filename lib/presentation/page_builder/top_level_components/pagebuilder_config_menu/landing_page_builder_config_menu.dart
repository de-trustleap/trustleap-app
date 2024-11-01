import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu_header.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenu extends StatefulWidget {
  final bool isOpen;
  final Function closeMenu;
  const LandingPageBuilderConfigMenu(
      {super.key, required this.isOpen, required this.closeMenu});

  @override
  State<LandingPageBuilderConfigMenu> createState() =>
      _LandingPageBuilderConfigMenuState();
}

class _LandingPageBuilderConfigMenuState
    extends State<LandingPageBuilderConfigMenu> {
  final menuWidth = 300.0;
  int _selectedTabIndex = 0;

  void _selectTab(int index) {
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
          child: Center(
              child: Text(title, style: themeData.textTheme.headlineSmall)),
        ),
      ),
    );
  }
  // TODO: Konfiguration Text tauschen gegen den Widget Typ. Hierzu noch Klasse erstellen die das Name Mapping übernimmt.
  // TODO: Gibt noch kleinen Bug, dass das Menu nach dem Schließen nicht mehr geöffnet werden kann, wenn ich es über das gleiche Widget öffnen möchte.

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.isOpen ? menuWidth : 0,
        color: themeData.colorScheme.surface,
        child: widget.isOpen
            ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                LandingPageBuilderConfigMenuHeader(
                    closePressed: () => widget.closeMenu()),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _tabButton("Tab 1", 0),
                        _tabButton("Tab 2", 1),
                      ],
                    ),
                    // Animierter Strich
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left: _selectedTabIndex == 0 ? 0 : 150,
                      bottom: 0,
                      child: Container(
                        height: 2,
                        width: menuWidth / 2,
                        color: themeData.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: _selectedTabIndex == 0
                      ? Center(child: Text("Inhalt für Tab 1"))
                      : Center(child: Text("Inhalt für Tab 2")),
                ),
              ])
            : SizedBox.shrink());
  }
}
