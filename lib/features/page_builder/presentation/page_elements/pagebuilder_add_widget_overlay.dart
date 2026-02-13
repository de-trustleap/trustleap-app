import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget_templates.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';

class PagebuilderAddWidgetOverlay extends StatelessWidget {
  final void Function(PageBuilderWidgetType widgetType) onWidgetSelected;

  const PagebuilderAddWidgetOverlay({
    super.key,
    required this.onWidgetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeData.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.pagebuilder_page_menu_title,
            style: themeData.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 400,
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
                final localizedName = template.getName(localization);

                return InkWell(
                  onTap: () => onWidgetSelected(template.widgetType),
                  borderRadius: BorderRadius.circular(16),
                  child: CardContainer(
                    maxWidth: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          template.icon,
                          size: 28,
                          color: themeData.colorScheme.secondary,
                        ),
                        const SizedBox(height: 6),
                        Flexible(
                          child: Text(
                            localizedName,
                            style: themeData.textTheme.bodySmall
                                ?.copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
