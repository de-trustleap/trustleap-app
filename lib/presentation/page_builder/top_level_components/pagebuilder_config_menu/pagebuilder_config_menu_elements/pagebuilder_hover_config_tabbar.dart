import 'package:flutter/material.dart';

class PagebuilderHoverConfigTabBar<T> extends StatefulWidget {
  final T properties;
  final T? hoverProperties;
  final bool hoverEnabled;
  final void Function(bool hoverEnabled) onHoverEnabledChanged;
  final void Function(T? updated, bool isHover) onChanged;
  final Widget Function(
    T? props,
    bool disabled,
    void Function(T? updated) onChangedLocal,
  ) configBuilder;

  const PagebuilderHoverConfigTabBar({
    super.key,
    required this.properties,
    required this.hoverProperties,
    required this.hoverEnabled,
    required this.onHoverEnabledChanged,
    required this.onChanged,
    required this.configBuilder,
  });

  @override
  State<PagebuilderHoverConfigTabBar<T>> createState() =>
      _PagebuilderHoverConfigTabBarState<T>();
}

class _PagebuilderHoverConfigTabBarState<T>
    extends State<PagebuilderHoverConfigTabBar<T>> {
  int selectedTabIndex = 0;

  bool get isHover => selectedTabIndex == 1;

  void _handleChanged(T? updated) {
    widget.onChanged(updated, isHover);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomTabBar(themeData),
        const SizedBox(height: 12),
        if (isHover)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Hover aktivieren"),
              Switch(
                value: widget.hoverEnabled,
                onChanged: widget.onHoverEnabledChanged,
              ),
            ],
          ),
        const SizedBox(height: 12),
        if (selectedTabIndex == 0)
          widget.configBuilder(widget.properties, false, _handleChanged)
        else if (widget.hoverProperties != null && widget.hoverEnabled)
          widget.configBuilder(
              widget.hoverProperties as T, false, _handleChanged)
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildCustomTabBar(ThemeData themeData) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab("Normal", 0, themeData),
          _buildTab("Hover", 1, themeData),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, ThemeData themeData) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
        child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? themeData.colorScheme.secondary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? themeData.colorScheme.secondary
                  : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ));
  }
}
