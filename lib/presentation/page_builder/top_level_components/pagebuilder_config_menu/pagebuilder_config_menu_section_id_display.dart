import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagebuilderConfigMenuSectionIDDisplay extends StatelessWidget {
  final String sectionID;
  const PagebuilderConfigMenuSectionIDDisplay(
      {super.key, required this.sectionID});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localization.pagebuilder_section_id,
              style: themeData.textTheme.bodyLarge),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: sectionID,
                    style: themeData.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: sectionID));
                      },
                      icon: const Icon(Icons.copy),
                      iconSize: 20,
                      padding: const EdgeInsets.all(4),
                      tooltip: localization.pagebuilder_section_copy_id_tooltip,
                      color: themeData.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
