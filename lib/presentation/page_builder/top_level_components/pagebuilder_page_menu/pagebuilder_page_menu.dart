import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget_templates.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_page_menu/pagebuilder_global_styles_menu_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_page_menu/pagebuilder_widget_template_card.dart';
import 'package:flutter/material.dart';

class PagebuilderPageMenu extends StatefulWidget {
  final double menuWidth;

  const PagebuilderPageMenu({
    super.key,
    required this.menuWidth,
  });

  @override
  State<PagebuilderPageMenu> createState() => _PagebuilderPageMenuState();
}

class _PagebuilderPageMenuState extends State<PagebuilderPageMenu> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      width: widget.menuWidth,
      color: themeData.colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                localization.pagebuilder_page_menu_title,
                style: themeData.textTheme.titleLarge,
              ),
            ),
          ),
          _buildCustomTabBar(themeData),
          Expanded(
            child: selectedTabIndex == 0
                ? _WidgetsTab(menuWidth: widget.menuWidth)
                : const PagebuilderGlobalStylesMenuConfig(menuWidth: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar(ThemeData themeData) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab("Widgets", 0, themeData),
          _buildTab("Globale Styles", 1, themeData),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, ThemeData themeData) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
        child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? themeData.colorScheme.secondary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? themeData.colorScheme.secondary
                  : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ));
  }
}

class _WidgetsTab extends StatelessWidget {
  final double menuWidth;

  const _WidgetsTab({required this.menuWidth});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: PagebuilderWidgetTemplates.templates.length,
        itemBuilder: (context, index) {
          final template = PagebuilderWidgetTemplates.templates[index];
          return PagebuilderWidgetTemplateCard(
            template: template,
            themeData: themeData,
          );
        },
      ),
    );
  }
}
