import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_text/pagebuilder_text_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PagebuilderTextPlaceholderPicker extends StatefulWidget {
  final Function(String) onSelected;

  const PagebuilderTextPlaceholderPicker({super.key, required this.onSelected});

  @override
  State<PagebuilderTextPlaceholderPicker> createState() =>
      _PagebuilderTextPlaceholderPickerState();
}

class _PagebuilderTextPlaceholderPickerState
    extends State<PagebuilderTextPlaceholderPicker> {
  List<PopupMenuItem<String>> menuItems = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        menuItems = createDropdownEntries(AppLocalizations.of(context));
      });
    });
  }

  List<PopupMenuItem<String>> createDropdownEntries(
      AppLocalizations localization) {
    List<PopupMenuItem<String>> entries = [
      PopupMenuItem<String>(
          value: PagebuilderTextPlaceholder.recommendationName,
          child: Text(
              localization.pagebuilder_text_placeholder_recommendation_name)),
      PopupMenuItem<String>(
          value: PagebuilderTextPlaceholder.promoterName,
          child: Text(localization.pagebuilder_text_placeholder_promoter_name))
    ];
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) {
          return menuItems;
        },
        onSelected: (value) {
          widget.onSelected(value);
        },
        child: Text(localization.pagebuilder_text_placeholder_picker,
            style: themeData.textTheme.bodyMedium!.copyWith(
                fontSize: responsiveValue.isMobile ? 14 : 16,
                decoration: TextDecoration.underline,
                decorationColor: themeData.colorScheme.secondary,
                color: themeData.colorScheme.secondary)));
  }
}
