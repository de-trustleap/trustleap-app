import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class PagebuilderColorPicker extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onSelected;
  const PagebuilderColorPicker(
      {super.key, required this.initialColor, required this.onSelected});

  @override
  State<PagebuilderColorPicker> createState() =>
      _PagebuilderColorControlState();
}

class _PagebuilderColorControlState extends State<PagebuilderColorPicker> {
  late Color _selectedColor;
  Color _hexTextfieldHoverColor = Colors.transparent;
  final TextEditingController _hexTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _hexTextFieldController.text = _colorToHex(_selectedColor);
  }

  @override
  void didUpdateWidget(PagebuilderColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      setState(() {
        _selectedColor = widget.initialColor;
      });
    }
  }

  String _colorToHex(Color color) {
    try {
      String hex = color.toARGB32().toRadixString(16).toUpperCase();
      return "#${hex.padLeft(8, '0')}";
    } catch (e) {
      return "#00000000";
    }
  }

  Color _hexToColor(String hex) {
    try {
      hex = hex.replaceAll("#", "");
      if (hex.isEmpty || (hex.length != 6 && hex.length != 8)) {
        return Colors.transparent;
      }
      if (hex.length == 6) {
        hex = "FF$hex";
      }
      return Color(int.parse("0x$hex"));
    } catch (e) {
      return Colors.transparent;
    }
  }

  void _showColorPickerDialog(BuildContext context, ThemeData themeData,
      AppLocalizations localization) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeData.colorScheme.onPrimaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          contentPadding: const EdgeInsets.all(16.0),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          localization
                              .landingpage_pagebuilder_color_picker_title,
                          style: themeData.textTheme.bodyLarge),
                      IconButton(
                          onPressed: () => CustomNavigator.pop(),
                          icon: Icon(Icons.close,
                              size: 24,
                              color: themeData.colorScheme.surfaceTint))
                    ]),
                ColorPicker(
                  color: _selectedColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      _selectedColor = color;
                      _hexTextFieldController.text =
                          _colorToHex(_selectedColor);
                      widget.onSelected(_selectedColor);
                    });
                  },
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.primary: false,
                    ColorPickerType.accent: false,
                    ColorPickerType.wheel: true,
                  },
                  showRecentColors: false,
                  enableOpacity: true,
                  enableShadesSelection: false,
                  showColorCode: false,
                  focusedEditHasNoColor: true,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _hexTextfieldHoverColor = themeData.colorScheme.surface;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _hexTextfieldHoverColor = Colors.transparent;
                      });
                    },
                    child: Container(
                      color: _hexTextfieldHoverColor,
                      child: TextField(
                        controller: _hexTextFieldController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _selectedColor = _hexToColor(value);
                              widget.onSelected(_selectedColor);
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: localization
                              .landingpage_pagebuilder_color_picker_hex_textfield,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                    title: localization
                        .landingpage_pagebuilder_color_picker_ok_button,
                    onTap: () => CustomNavigator.pop())
              ],
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return InkWell(
        onTap: () {
          _showColorPickerDialog(context, themeData, localization);
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _selectedColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
        ));
  }
}
