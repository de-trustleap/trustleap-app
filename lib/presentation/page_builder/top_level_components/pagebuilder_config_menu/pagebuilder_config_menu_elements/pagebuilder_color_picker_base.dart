import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_gradient_tab_bar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_tab.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_gradient_tab.dart';
import 'package:flutter/material.dart';

class PagebuilderColorPickerBase extends StatefulWidget {
  final Color initialColor;
  final PagebuilderGradient? initialGradient;
  final Function(Color) onColorSelected;
  final Function(PagebuilderGradient)? onGradientSelected;
  final bool enableOpacity;
  final bool enableGradients;

  const PagebuilderColorPickerBase({
    super.key,
    required this.initialColor,
    this.initialGradient,
    required this.onColorSelected,
    this.onGradientSelected,
    this.enableOpacity = true,
    this.enableGradients = false,
  });

  @override
  State<PagebuilderColorPickerBase> createState() =>
      _PagebuilderColorPickerBaseState();
}

class _PagebuilderColorPickerBaseState
    extends State<PagebuilderColorPickerBase> {
  late Color _selectedColor;
  late PagebuilderGradient _selectedGradient;
  late bool _isColorMode;
  late bool _isColorTab;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _selectedGradient =
        widget.initialGradient ?? PagebuilderGradient.defaultLinear();

    // Logic for initial state
    if (!widget.enableGradients) {
      _isColorTab = true;
      _isColorMode = true;
    } else {
      _isColorMode = widget.initialGradient == null;
      _isColorTab = widget.initialGradient == null;
    }
  }

  @override
  void didUpdateWidget(PagebuilderColorPickerBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      setState(() {
        _selectedColor = widget.initialColor;
      });
    }
    if (widget.initialGradient != oldWidget.initialGradient) {
      setState(() {
        _selectedGradient =
            widget.initialGradient ?? PagebuilderGradient.defaultLinear();

        if (!widget.enableGradients) {
          _isColorTab = true;
          _isColorMode = true;
        } else {
          _isColorTab = widget.initialGradient == null;
          _isColorMode = widget.initialGradient == null;
        }
      });
    }
  }

  void _showColorPickerDialog(BuildContext context, ThemeData themeData,
      AppLocalizations localization, CustomNavigatorBase navigator) {
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
                        localization.landingpage_pagebuilder_color_picker_title,
                        style: themeData.textTheme.bodyLarge,
                      ),
                      IconButton(
                        onPressed: () => navigator.pop(),
                        icon: Icon(
                          Icons.close,
                          size: 24,
                          color: themeData.colorScheme.surfaceTint,
                        ),
                      ),
                    ],
                  ),
                  if (widget.enableGradients) ...[
                    const SizedBox(height: 16),
                    PagebuilderColorGradientTabBar(
                      isColorMode: _isColorTab,
                      onTabChanged: (bool isColorTab) {
                        setState(() {
                          _isColorTab = isColorTab;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_isColorTab) ...[
                    PagebuilderColorTab(
                      initialColor: _selectedColor,
                      enableOpacity: widget.enableOpacity,
                      isColorMode: _isColorMode,
                      showModeSwitch: widget.enableGradients,
                      onColorChanged: (Color color) {
                        setState(() {
                          _selectedColor = color;
                        });
                        widget.onColorSelected(color);
                      },
                      onModeChanged: (bool isColorMode) {
                        setState(() {
                          _isColorMode = isColorMode;
                        });
                        if (isColorMode) {
                          widget.onColorSelected(_selectedColor);
                        } else {
                          widget.onGradientSelected?.call(_selectedGradient);
                        }
                      },
                    ),
                  ] else ...[
                    PagebuilderGradientTab(
                      initialGradient: _selectedGradient,
                      isColorMode: _isColorMode,
                      showModeSwitch: widget.enableGradients,
                      onGradientChanged: (PagebuilderGradient gradient) {
                        setState(() {
                          _selectedGradient = gradient;
                        });
                        widget.onGradientSelected?.call(gradient);
                      },
                      onModeChanged: (bool isColorMode) {
                        setState(() {
                          _isColorMode = isColorMode;
                        });
                        if (isColorMode) {
                          widget.onColorSelected(_selectedColor);
                        } else {
                          widget.onGradientSelected?.call(_selectedGradient);
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  PrimaryButton(
                    title: localization
                        .landingpage_pagebuilder_color_picker_ok_button,
                    onTap: () => navigator.pop(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);

    return InkWell(
      onTap: () {
        _showColorPickerDialog(context, themeData, localization, navigator);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _isColorMode ? _selectedColor : null,
          gradient:
              !_isColorMode ? _selectedGradient.toFlutterGradient() : null,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}
