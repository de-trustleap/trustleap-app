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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildTabButton("Normal", 0),
            _buildTabButton("Hover", 1),
          ],
        ),
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
        IndexedStack(
          index: selectedTabIndex,
          children: [
            widget.configBuilder(widget.properties, false, _handleChanged),
            if (widget.hoverProperties != null)
              widget.configBuilder(
                  widget.hoverProperties as T, false, _handleChanged)
            else
              const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: TextButton(
        onPressed: () => setState(() => selectedTabIndex = index),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue.shade100 : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
