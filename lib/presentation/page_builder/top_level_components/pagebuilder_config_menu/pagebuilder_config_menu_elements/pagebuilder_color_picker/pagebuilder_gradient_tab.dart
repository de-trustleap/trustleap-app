import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_global_colors_palette.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class PagebuilderGradientTab extends StatefulWidget {
  final PagebuilderGradient initialGradient;
  final bool isColorMode;
  final Function(PagebuilderGradient) onGradientChanged;
  final Function(bool) onModeChanged;
  final bool showModeSwitch;
  final PageBuilderGlobalColors? globalColors;

  const PagebuilderGradientTab({
    super.key,
    required this.initialGradient,
    required this.isColorMode,
    required this.onGradientChanged,
    required this.onModeChanged,
    this.showModeSwitch = true,
    this.globalColors,
  });

  @override
  State<PagebuilderGradientTab> createState() => _PagebuilderGradientTabState();
}

class _PagebuilderGradientTabState extends State<PagebuilderGradientTab> {
  late PagebuilderGradient _selectedGradient;

  @override
  void initState() {
    super.initState();
    _selectedGradient = widget.initialGradient;
  }

  @override
  void didUpdateWidget(PagebuilderGradientTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialGradient != oldWidget.initialGradient) {
      setState(() {
        _selectedGradient = widget.initialGradient;
      });
    }
  }

  void _showColorPicker(BuildContext context, ThemeData themeData,
      AppLocalizations localization, int stopIndex) {
    final stop = _selectedGradient.stops[stopIndex];
    Color tempColor = stop.color;
    String? tempToken = stop.globalColorToken;
    final hexTextFieldController = TextEditingController(
        text: ColorUtility.colorToHex(tempColor, includeHashPrefix: true));
    Color hexTextfieldHoverColor = Colors.transparent;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeData.colorScheme.onPrimaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          contentPadding: const EdgeInsets.all(16.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setColorState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(localization.pagebuilder_gradient_color_select,
                          style: themeData.textTheme.bodyLarge),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close,
                            size: 24, color: themeData.colorScheme.surfaceTint),
                      ),
                    ],
                  ),
                  // Global Colors Palette
                  if (widget.globalColors != null)
                    PagebuilderGlobalColorsPalette(
                      globalColors: widget.globalColors,
                      selectedToken: tempToken,
                      onGlobalColorSelected: (String token, Color color) {
                        setColorState(() {
                          tempColor = color;
                          tempToken = token;
                          hexTextFieldController.text =
                              ColorUtility.colorToHex(color, includeHashPrefix: true);
                        });
                      },
                    ),
                  ColorPicker(
                    color: tempColor,
                    onColorChanged: (Color color) {
                      setColorState(() {
                        tempColor = color;
                        tempToken = null; // Clear token when manually selecting color
                        hexTextFieldController.text = ColorUtility.colorToHex(
                            tempColor,
                            includeHashPrefix: true);
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
                        setColorState(() {
                          hexTextfieldHoverColor = themeData.colorScheme.surface;
                        });
                      },
                      onExit: (_) {
                        setColorState(() {
                          hexTextfieldHoverColor = Colors.transparent;
                        });
                      },
                      child: Container(
                        color: hexTextfieldHoverColor,
                        child: TextField(
                          controller: hexTextFieldController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setColorState(() {
                                tempColor = ColorUtility.hexToColor(value);
                                tempToken = null; // Clear token when manually entering hex
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
                              borderSide:
                                  const BorderSide(color: Colors.black, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide:
                                  const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    title: localization.pagebuilder_ok,
                    onTap: () {
                      setState(() {
                        final newStops = List<PagebuilderGradientStop>.from(
                            _selectedGradient.stops);
                        newStops[stopIndex] = stop.copyWith(
                          color: tempColor,
                          globalColorToken: tempToken,
                          removeGlobalColorToken: tempToken == null,
                        );
                        _selectedGradient =
                            _selectedGradient.copyWith(stops: newStops);
                      });
                      widget.onGradientChanged(_selectedGradient);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _getGradientTypeName(PagebuilderGradientType type, AppLocalizations localization) {
    switch (type) {
      case PagebuilderGradientType.linear:
        return localization.pagebuilder_gradient_type_linear;
      case PagebuilderGradientType.radial:
        return localization.pagebuilder_gradient_type_radial;
      case PagebuilderGradientType.sweep:
        return localization.pagebuilder_gradient_type_sweep;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final isActive = !widget.isColorMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showModeSwitch) ...[
          PagebuilderSwitchControl(
            title: localization.pagebuilder_gradient_select,
            isActive: isActive,
            onSelected: (bool isSelected) {
              widget.onModeChanged(!isSelected);
            },
          ),
          const SizedBox(height: 16),
        ],
        Opacity(
          opacity: isActive ? 1.0 : 0.5,
          child: IgnorePointer(
            ignoring: !isActive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: _selectedGradient.toFlutterGradient(),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(localization.pagebuilder_gradient_type_label, style: themeData.textTheme.bodyMedium),
                    const SizedBox(width: 8),
                    DropdownButton<PagebuilderGradientType>(
                      value: _selectedGradient.type,
                      onChanged: isActive
                          ? (PagebuilderGradientType? newType) {
                              if (newType != null) {
                                setState(() {
                                  _selectedGradient =
                                      _selectedGradient.copyWith(type: newType);
                                });
                                widget.onGradientChanged(_selectedGradient);
                              }
                            }
                          : null,
                      items: PagebuilderGradientType.values.map((type) {
                        return DropdownMenuItem<PagebuilderGradientType>(
                          value: type,
                          child: Text(_getGradientTypeName(type, localization)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(localization.pagebuilder_gradient_colors_label, style: themeData.textTheme.bodyMedium),
                const SizedBox(height: 8),
                ...List.generate(_selectedGradient.stops.length, (index) {
                  final stop = _selectedGradient.stops[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: isActive
                              ? () => _showColorPicker(
                                  context, themeData, localization, index)
                              : null,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: stop.color,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.3)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: stop.position,
                            min: 0.0,
                            max: 1.0,
                            divisions: 100,
                            label: "${(stop.position * 100).round()}%",
                            onChanged: isActive
                                ? (double value) {
                                    setState(() {
                                      final newStops =
                                          List<PagebuilderGradientStop>.from(
                                              _selectedGradient.stops);
                                      newStops[index] =
                                          stop.copyWith(position: value);
                                      _selectedGradient = _selectedGradient
                                          .copyWith(stops: newStops);
                                    });
                                    widget.onGradientChanged(_selectedGradient);
                                  }
                                : null,
                          ),
                        ),
                        if (_selectedGradient.stops.length > 2)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: isActive
                                ? () {
                                    setState(() {
                                      final newStops =
                                          List<PagebuilderGradientStop>.from(
                                              _selectedGradient.stops);
                                      newStops.removeAt(index);
                                      _selectedGradient = _selectedGradient
                                          .copyWith(stops: newStops);
                                    });
                                    widget.onGradientChanged(_selectedGradient);
                                  }
                                : null,
                          ),
                      ],
                    ),
                  );
                }),
                if (_selectedGradient.stops.length < 5)
                  TextButton.icon(
                    onPressed: isActive
                        ? () {
                            setState(() {
                              final newStops =
                                  List<PagebuilderGradientStop>.from(
                                      _selectedGradient.stops);
                              newStops.add(PagebuilderGradientStop(
                                  color: themeData.colorScheme.secondary,
                                  position: 0.5,
                                  globalColorToken: null));
                              newStops.sort(
                                  (a, b) => a.position.compareTo(b.position));
                              _selectedGradient =
                                  _selectedGradient.copyWith(stops: newStops);
                            });
                            widget.onGradientChanged(_selectedGradient);
                          }
                        : null,
                    icon: const Icon(Icons.add),
                    label: Text(localization.pagebuilder_gradient_add_color,
                        style: themeData.textTheme.bodyMedium),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
