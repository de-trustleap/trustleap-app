import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget_templates.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/drag_data/widget_library_drag_data.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderWidgetTemplateCard extends StatelessWidget {
  final PagebuilderWidgetTemplate template;
  final ThemeData themeData;

  const PagebuilderWidgetTemplateCard({
    super.key,
    required this.template,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final localizedName = template.getName(localization);

    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Draggable<WidgetLibraryDragData>(
        data: WidgetLibraryDragData(template.widgetType),
        onDragStarted: () {
          Modular.get<PagebuilderDragCubit>().setDragging(true);
        },
        onDragEnd: (_) {
          Modular.get<PagebuilderDragCubit>().setDragging(false);
        },
        onDraggableCanceled: (_, __) {
          Modular.get<PagebuilderDragCubit>().setDragging(false);
        },
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
          child: Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeData.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  template.icon,
                  size: 20,
                  color: themeData.colorScheme.secondary,
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    localizedName,
                    style: themeData.textTheme.bodySmall?.copyWith(fontSize: 8),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: CardContainer(
            maxWidth: double.infinity,
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
                    style: themeData.textTheme.bodySmall?.copyWith(fontSize: 11),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: CardContainer(
          maxWidth: double.infinity,
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
                  style: themeData.textTheme.bodySmall?.copyWith(fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
