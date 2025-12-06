import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:finanzbegleiter/presentation/page_builder/widgets/pagebuilder_height_resize_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PageBuilderHeightView extends StatefulWidget {
  final PageBuilderWidget model;

  const PageBuilderHeightView({
    super.key,
    required this.model,
  });

  @override
  State<PageBuilderHeightView> createState() => _PageBuilderHeightViewState();
}

class _PageBuilderHeightViewState extends State<PageBuilderHeightView> {
  bool _isResizing = false;
  double _resizeDelta = 0.0;
  double _startHeight = 0.0;

  @override
  void didUpdateWidget(PageBuilderHeightView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldProperties =
        oldWidget.model.properties as PageBuilderHeightProperties;
    final newProperties =
        widget.model.properties as PageBuilderHeightProperties;

    // Clear resize state when height property changes
    if (oldProperties.height != newProperties.height && _isResizing) {
      setState(() {
        _isResizing = false;
        _resizeDelta = 0.0;
        _startHeight = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final properties = widget.model.properties as PageBuilderHeightProperties;

    return LandingPageBuilderWidgetContainer(
      model: widget.model,
      child: BlocBuilder<PagebuilderResponsiveBreakpointCubit,
          PagebuilderResponsiveBreakpoint>(
        bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
        builder: (context, breakpoint) {
          final height =
              (properties.height?.getValueForBreakpoint(breakpoint) ?? 40)
                  .toDouble();
          final baseHeight = _isResizing ? _startHeight : height;

          return PageBuilderHeightResizeOverlay(
            model: widget.model,
            breakpoint: breakpoint,
            currentHeight: baseHeight,
            isResizing: _isResizing,
            resizeDelta: _resizeDelta,
            onResizeStateChange: ({
              required bool isResizing,
              required double resizeDelta,
              required double startHeight,
            }) {
              setState(() {
                _isResizing = isResizing;
                _resizeDelta = resizeDelta;
                _startHeight = startHeight;
              });
            },
          );
        },
      ),
    );
  }
}
