import 'package:flutter/material.dart';

class CollapsibleTile extends StatefulWidget {
  final String? title;
  final List<Widget> children;
  final Duration animationDuration;
  final Curve animationCurve;
  final Widget? titleWidget;
  final Color? backgroundColor;
  final bool showDivider;
  final Function(bool)? onExpansionChanged;
  final Widget? backgroundOverlay;

  const CollapsibleTile(
      {super.key,
      this.title,
      required this.children,
      this.animationDuration = const Duration(milliseconds: 300),
      this.animationCurve = Curves.easeInOut,
      this.titleWidget,
      this.backgroundColor,
      this.showDivider = true,
      this.onExpansionChanged,
      this.backgroundOverlay});

  @override
  State<CollapsibleTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CollapsibleTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconRotation;
  late Animation<double> _opacity;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );

    _opacity = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ?? themeData.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Stack(
        children: [
          if (widget.backgroundOverlay != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.backgroundOverlay!,
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: widget.titleWidget ??
                    Text(
                      widget.title ?? "",
                      style: themeData.textTheme.bodyMedium,
                    ),
                trailing: RotationTransition(
                  turns: _iconRotation,
                  child: Icon(
                    Icons.expand_more,
                    color: themeData.colorScheme.secondary,
                  ),
                ),
                onTap: _toggleExpansion,
              ),
              ClipRect(
                child: AnimatedBuilder(
                  animation: _heightFactor,
                  builder: (context, child) {
                    return Align(
                      heightFactor: _heightFactor.value,
                      alignment: Alignment.topCenter,
                      child: child,
                    );
                  },
                  child: _isExpanded ||
                          _controller.status != AnimationStatus.dismissed
                      ? FadeTransition(
                          opacity: _opacity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.showDivider) ...[
                                Container(
                                  height: 0.8,
                                  color: themeData.textTheme.bodyMedium?.color
                                      ?.withValues(alpha: 0.5),
                                )
                              ],
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: widget.children,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
