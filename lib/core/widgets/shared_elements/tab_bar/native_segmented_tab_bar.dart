import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_tabbar.dart';

class NativeSegmentedTabBar extends StatefulWidget {
  final List<CustomTabItem> tabs;

  const NativeSegmentedTabBar({super.key, required this.tabs});

  @override
  State<NativeSegmentedTabBar> createState() => _NativeSegmentedTabBarState();
}

class _NativeSegmentedTabBarState extends State<NativeSegmentedTabBar> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<double> _intrinsicWidths = [];
  static const double _chipGap = 8.0;
  static const double _chipHorizontalPadding = 28.0; // 14 * 2
  static const double _horizontalPadding = 16.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _measureTextWidth(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }

  void _scrollToChip(int index) {
    if (!_scrollController.hasClients || _intrinsicWidths.isEmpty) return;

    double offset = 0;
    for (int i = 0; i < index; i++) {
      offset += _intrinsicWidths[i] + _chipGap;
    }
    final chipWidth = _intrinsicWidths[index];
    final viewportWidth = _scrollController.position.viewportDimension;
    final maxScroll = _scrollController.position.maxScrollExtent;

    final targetScroll = offset + chipWidth / 2 - viewportWidth / 2;
    _scrollController.animateTo(
      targetScroll.clamp(0.0, maxScroll),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding, vertical: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final textStyle =
                  Theme.of(context).textTheme.bodySmall ?? const TextStyle();
              final gaps = (widget.tabs.length - 1) * _chipGap;
              _intrinsicWidths = widget.tabs
                  .map((t) =>
                      _measureTextWidth(t.title, textStyle) +
                      _chipHorizontalPadding)
                  .toList();
              final chipEqualWidth =
                  (constraints.maxWidth - gaps) / widget.tabs.length;
              final maxIntrinsicWidth = _intrinsicWidths.reduce(max);

              if (maxIntrinsicWidth <= chipEqualWidth) {
                return Row(children: _buildExpandedChips());
              } else {
                return SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(children: _buildNaturalChips()),
                );
              }
            },
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: child,
            ),
            child: SizedBox(
              key: ValueKey(_selectedIndex),
              child: widget.tabs[_selectedIndex].content ??
                  const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildExpandedChips() {
    final chips = <Widget>[];
    for (int i = 0; i < widget.tabs.length; i++) {
      chips.add(Expanded(
        child: _SegmentChip(
          label: widget.tabs[i].title,
          isSelected: _selectedIndex == i,
          onTap: () => setState(() => _selectedIndex = i),
        ),
      ));
      if (i < widget.tabs.length - 1) {
        chips.add(const SizedBox(width: _chipGap));
      }
    }
    return chips;
  }

  List<Widget> _buildNaturalChips() {
    final chips = <Widget>[];
    for (int i = 0; i < widget.tabs.length; i++) {
      chips.add(SizedBox(
        width: _intrinsicWidths[i],
        child: _SegmentChip(
          label: widget.tabs[i].title,
          isSelected: _selectedIndex == i,
          onTap: () {
            setState(() => _selectedIndex = i);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToChip(i);
            });
          },
        ),
      ));
      if (i < widget.tabs.length - 1) {
        chips.add(const SizedBox(width: _chipGap));
      }
    }
    return chips;
  }
}

class _SegmentChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? theme.colorScheme.surface
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// TODO: APPCHECK MOBILE EINRICHTEN
// TODO: RECOMMENDATION MANAGER FÜR MOBILE NEU DESIGNEN
// TODO: APP ICON
