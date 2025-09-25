import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class PagebuilderColorTab extends StatefulWidget {
  final Color initialColor;
  final bool enableOpacity;
  final bool isColorMode;
  final Function(Color) onColorChanged;
  final Function(bool) onModeChanged;

  const PagebuilderColorTab({
    super.key,
    required this.initialColor,
    required this.enableOpacity,
    required this.isColorMode,
    required this.onColorChanged,
    required this.onModeChanged,
  });

  @override
  State<PagebuilderColorTab> createState() => _PagebuilderColorTabState();
}

class _PagebuilderColorTabState extends State<PagebuilderColorTab> {
  late Color _selectedColor;
  Color _hexTextfieldHoverColor = Colors.transparent;
  final TextEditingController _hexTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _hexTextFieldController.text = ColorUtility.colorToHex(_selectedColor, includeHashPrefix: true);
  }

  @override
  void didUpdateWidget(PagebuilderColorTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      setState(() {
        _selectedColor = widget.initialColor;
        _hexTextFieldController.text = ColorUtility.colorToHex(_selectedColor, includeHashPrefix: true);
      });
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

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Switch Control
        PagebuilderSwitchControl(
          title: "Farbe auswählen",
          isActive: widget.isColorMode,
          onSelected: (bool isSelected) {
            widget.onModeChanged(isSelected);
          },
        ),
        const SizedBox(height: 16),
        // Color Picker - grayed out when inactive
        Opacity(
          opacity: widget.isColorMode ? 1.0 : 0.5,
          child: IgnorePointer(
            ignoring: !widget.isColorMode,
            child: ColorPicker(
              color: _selectedColor,
              onColorChanged: (Color color) {
                if (widget.isColorMode) {
                  setState(() {
                    _selectedColor = color;
                    _hexTextFieldController.text =
                        ColorUtility.colorToHex(_selectedColor, includeHashPrefix: true);
                  });
                  widget.onColorChanged(color);
                }
              },
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.wheel: true,
              },
              showRecentColors: false,
              enableOpacity: widget.enableOpacity,
              enableShadesSelection: false,
              showColorCode: false,
              focusedEditHasNoColor: true,
            ),
          ),
        ),
        // Hex Input Field - also grayed out when inactive
        Opacity(
          opacity: widget.isColorMode ? 1.0 : 0.5,
          child: IgnorePointer(
            ignoring: !widget.isColorMode,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: MouseRegion(
                onEnter: (_) {
                  if (widget.isColorMode) {
                    setState(() {
                      _hexTextfieldHoverColor = themeData.colorScheme.surface;
                    });
                  }
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
                      if (widget.isColorMode && value.isNotEmpty) {
                        setState(() {
                          _selectedColor = _hexToColor(value);
                        });
                        widget.onColorChanged(_selectedColor);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: localization.landingpage_pagebuilder_color_picker_hex_textfield,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}