import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class PagebuilderGradientTab extends StatefulWidget {
  final PagebuilderGradient initialGradient;
  final bool isColorMode;
  final Function(PagebuilderGradient) onGradientChanged;
  final Function(bool) onModeChanged;

  const PagebuilderGradientTab({
    super.key,
    required this.initialGradient,
    required this.isColorMode,
    required this.onGradientChanged,
    required this.onModeChanged,
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
                      Text("Farbe auswählen",
                          style: themeData.textTheme.bodyLarge),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close,
                            size: 24, color: themeData.colorScheme.surfaceTint),
                      ),
                    ],
                  ),
                  ColorPicker(
                    color: tempColor,
                    onColorChanged: (Color color) {
                      setColorState(() {
                        tempColor = color;
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
                  const SizedBox(height: 16),
                  PrimaryButton(
                    title: "OK",
                    onTap: () {
                      setState(() {
                        final newStops = List<PagebuilderGradientStop>.from(
                            _selectedGradient.stops);
                        newStops[stopIndex] = stop.copyWith(color: tempColor);
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

  String _getGradientTypeName(PagebuilderGradientType type) {
    switch (type) {
      case PagebuilderGradientType.linear:
        return "Linear";
      case PagebuilderGradientType.radial:
        return "Radial";
      case PagebuilderGradientType.sweep:
        return "Sweep";
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
        // Switch Control
        PagebuilderSwitchControl(
          title: "Gradient auswählen",
          isActive: isActive,
          onSelected: (bool isSelected) {
            widget.onModeChanged(
                !isSelected); // Invert because this is the gradient switch
          },
        ),
        const SizedBox(height: 16),
        // Gradient Picker - grayed out when inactive
        Opacity(
          opacity: isActive ? 1.0 : 0.5,
          child: IgnorePointer(
            ignoring: !isActive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gradient Preview
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
                // Gradient Type Selection
                Row(
                  children: [
                    Text("Typ: ", style: themeData.textTheme.bodyMedium),
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
                          child: Text(_getGradientTypeName(type)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Color Stops
                Text("Farben:", style: themeData.textTheme.bodyMedium),
                const SizedBox(height: 8),
                ...List.generate(_selectedGradient.stops.length, (index) {
                  final stop = _selectedGradient.stops[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        // Color preview
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
                        // Position slider
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
                        // Remove button
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
                // Add color button
                if (_selectedGradient.stops.length < 5)
                  TextButton.icon(
                    onPressed: isActive
                        ? () {
                            setState(() {
                              final newStops =
                                  List<PagebuilderGradientStop>.from(
                                      _selectedGradient.stops);
                              newStops.add(const PagebuilderGradientStop(
                                  color: Colors.green, position: 0.5));
                              newStops.sort((a, b) => a.position.compareTo(b.position));
                              _selectedGradient =
                                  _selectedGradient.copyWith(stops: newStops);
                            });
                            widget.onGradientChanged(_selectedGradient);
                          }
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text("Farbe hinzufügen"),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
