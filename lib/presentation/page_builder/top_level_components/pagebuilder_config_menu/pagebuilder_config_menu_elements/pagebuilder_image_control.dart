import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/image_view.dart';
import 'package:flutter/material.dart';

class PagebuilderImageControl extends StatefulWidget {
  final PageBuilderImageProperties properties;
  final PageBuilderWidget? widgetModel;
  final bool showPromoterSwitch;
  final Function(PageBuilderImageProperties) onSelected;
  final Function? onDelete;
  const PagebuilderImageControl(
      {super.key,
      required this.properties,
      required this.widgetModel,
      required this.showPromoterSwitch,
      required this.onSelected,
      this.onDelete});

  @override
  State<PagebuilderImageControl> createState() =>
      _PagebuilderImageControlState();
}

class _PagebuilderImageControlState extends State<PagebuilderImageControl> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showPromoterSwitch) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization
                      .landingpage_pagebuilder_layout_menu_image_control_switch,
                  style: themeData.textTheme.bodyMedium,
                ),
                Switch(
                  value: widget.properties.showPromoterImage ?? false,
                  onChanged: (value) {
                    final updatedProperties = widget.properties.copyWith(
                      showPromoterImage: value,
                    );
                    widget.onSelected(updatedProperties);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Text(
              (widget.properties.showPromoterImage ?? false)
                  ? localization
                      .landingpage_pagebuilder_layout_menu_image_control_title_promoter
                  : localization
                      .landingpage_pagebuilder_layout_menu_image_control_title,
              style: themeData.textTheme.bodySmall),
          const SizedBox(height: 16),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageBuilderImageView(
                    properties: widget.properties,
                    widgetModel: widget.widgetModel,
                    isConfigMenu: true,
                    onSelectedInConfigMenu: (properties) =>
                        widget.onSelected(properties)),
                if (widget.onDelete != null) ...[
                  const SizedBox(width: 16),
                  IconButton(
                      onPressed: () =>
                          widget.onDelete != null ? widget.onDelete!() : {},
                      icon: Icon(Icons.delete,
                          size: 24, color: themeData.colorScheme.secondary))
                ]
              ])
        ]);
  }
}
