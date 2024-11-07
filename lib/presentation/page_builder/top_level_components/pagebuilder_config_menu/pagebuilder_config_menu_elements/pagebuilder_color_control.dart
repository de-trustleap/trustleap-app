import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class PagebuilderColorControl extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onSelected;
  const PagebuilderColorControl(
      {super.key, required this.initialColor, required this.onSelected});

  @override
  State<PagebuilderColorControl> createState() =>
      _PagebuilderColorControlState();
}

class _PagebuilderColorControlState extends State<PagebuilderColorControl> {
  late Color _selectedColor;
  Color _hexTextfieldHoverColor = Colors.transparent;
  final TextEditingController _hexTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _hexTextFieldController.text = _colorToHex(_selectedColor);
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  void _showColorPickerDialog(context, ThemeData themeData) {
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
                      Text("Farbe auswählen",
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
                          labelText: "Hex-Code",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              // Handle Copy
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("Schriftfarbe", style: themeData.textTheme.bodySmall),
      InkWell(
          onTap: () {
            _showColorPickerDialog(context, themeData);
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
          ))
    ]);
  }
}
