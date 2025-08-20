import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/helpers/textfield_decimal_number_formatter.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker.dart';
import 'package:flutter/material.dart';

class PagebuilderShadowControl extends StatefulWidget {
  final String title;
  final PageBuilderShadow? initialShadow;
  final bool showSpreadRadius;
  final Function(PageBuilderShadow?) onSelected;
  const PagebuilderShadowControl(
      {super.key,
      required this.title,
      required this.initialShadow,
      required this.showSpreadRadius,
      required this.onSelected});

  @override
  State<PagebuilderShadowControl> createState() =>
      _PagebuilderTextShadowControlState();
}

class _PagebuilderTextShadowControlState
    extends State<PagebuilderShadowControl> {
  final TextEditingController spreadRadiusController = TextEditingController();
  final TextEditingController blurRadiusController = TextEditingController();
  final TextEditingController xOffsetController = TextEditingController();
  final TextEditingController yOffsetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setInitialShadowTexts();
  }

  @override
  void dispose() {
    spreadRadiusController.dispose();
    blurRadiusController.dispose();
    xOffsetController.dispose();
    yOffsetController.dispose();
    super.dispose();
  }

  void _setInitialShadowTexts() {
    spreadRadiusController.text =
        "${widget.initialShadow?.spreadRadius ?? "0"}";
    blurRadiusController.text = "${widget.initialShadow?.blurRadius ?? "0"}";
    xOffsetController.text = "${widget.initialShadow?.offset?.dx ?? "0"}";
    yOffsetController.text = "${widget.initialShadow?.offset?.dy ?? "0"}";
  }

  PageBuilderShadow? _getShadowFromTextFields() {
    PageBuilderShadow shadow = PageBuilderShadow(
        color: widget.initialShadow?.color,
        spreadRadius: null,
        blurRadius: null,
        offset: null);
    if (spreadRadiusController.text != "0" &&
        spreadRadiusController.text != "") {
      shadow = shadow.copyWith(
          spreadRadius: double.tryParse(spreadRadiusController.text));
    }
    if (blurRadiusController.text != "0" && blurRadiusController.text != "") {
      shadow = shadow.copyWith(
          blurRadius: double.tryParse(blurRadiusController.text));
    }
    if (xOffsetController.text != "0" && xOffsetController.text != "") {
      shadow = shadow.copyWith(
          offset: Offset(double.tryParse(xOffsetController.text) ?? 0, 0));
    }
    if (yOffsetController.text != "0" && yOffsetController.text != "") {
      shadow = shadow.copyWith(
          offset: Offset(double.tryParse(xOffsetController.text) ?? 0,
              double.tryParse(yOffsetController.text) ?? 0));
    }
    if (shadow.spreadRadius != null ||
        shadow.blurRadius != null ||
        shadow.offset != null) {
      return shadow;
    } else {
      return null;
    }
  }

  void _showShadowConfigDialog(BuildContext context, ThemeData themeData,
      AppLocalizations localization, CustomNavigatorBase navigator) {
    _setInitialShadowTexts();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: themeData.colorScheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              contentPadding: const EdgeInsets.all(16.0),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          localization
                              .landingpage_pagebuilder_text_config_shadow_alert_title,
                          style: themeData.textTheme.bodyLarge),
                      IconButton(
                          onPressed: () => navigator.pop(),
                          icon: Icon(Icons.close,
                              size: 24,
                              color: themeData.colorScheme.surfaceTint))
                    ]),
                const SizedBox(height: 20),
                if (widget.showSpreadRadius) ...[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            localization
                                .landingpage_pagebuilder_text_config_shadow_alert_spread_radius,
                            style: themeData.textTheme.bodySmall),
                        const SizedBox(width: 20),
                      ]),
                  const SizedBox(height: 20),
                  FormTextfield(
                      maxWidth: 200,
                      controller: spreadRadiusController,
                      disabled: false,
                      desktopStyle: themeData.textTheme.bodySmall,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        DecimalNumberFormatter(
                            maxIntegerDigits: 3, maxDecimalDigits: 2)
                      ],
                      placeholder: "")
                ],
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          localization
                              .landingpage_pagebuilder_text_config_shadow_alert_blur_radius,
                          style: themeData.textTheme.bodySmall),
                      const SizedBox(width: 20),
                      FormTextfield(
                          maxWidth: 200,
                          controller: blurRadiusController,
                          disabled: false,
                          desktopStyle: themeData.textTheme.bodySmall,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            DecimalNumberFormatter(
                                maxIntegerDigits: 3, maxDecimalDigits: 2)
                          ],
                          placeholder: "")
                    ]),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          localization
                              .landingpage_pagebuilder_text_config_shadow_alert_x_offset,
                          style: themeData.textTheme.bodySmall),
                      const SizedBox(width: 20),
                      FormTextfield(
                          maxWidth: 200,
                          controller: xOffsetController,
                          disabled: false,
                          desktopStyle: themeData.textTheme.bodySmall,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            DecimalNumberFormatter(
                                maxIntegerDigits: 3, maxDecimalDigits: 2)
                          ],
                          placeholder: "")
                    ]),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          localization
                              .landingpage_pagebuilder_text_config_shadow_alert_y_offset,
                          style: themeData.textTheme.bodySmall),
                      const SizedBox(width: 20),
                      FormTextfield(
                          maxWidth: 200,
                          controller: yOffsetController,
                          disabled: false,
                          desktopStyle: themeData.textTheme.bodySmall,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            DecimalNumberFormatter(
                                maxIntegerDigits: 3, maxDecimalDigits: 2)
                          ],
                          placeholder: "")
                    ]),
                const SizedBox(height: 20),
                PrimaryButton(
                    title: localization
                        .landingpage_pagebuilder_text_config_shadow_alert_apply,
                    onTap: () {
                      navigator.pop();
                      widget.onSelected(_getShadowFromTextFields());
                    })
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(widget.title, style: themeData.textTheme.bodySmall),
      Row(children: [
        PagebuilderColorPicker(
            initialColor: widget.initialShadow?.color ?? Colors.black,
            onSelected: (color) {
              widget.onSelected(widget.initialShadow?.copyWith(color: color));
            }),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            _showShadowConfigDialog(
                context, themeData, localization, navigator);
          },
          icon: Icon(Icons.edit,
              color: themeData.colorScheme.secondary, size: 24),
        )
      ])
    ]);
  }
}
