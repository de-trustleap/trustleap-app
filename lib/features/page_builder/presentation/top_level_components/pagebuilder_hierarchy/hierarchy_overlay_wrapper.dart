import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_helper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_overlay.dart';
import 'package:flutter/material.dart';

class HierarchyOverlayWrapper extends StatefulWidget {
  final PageBuilderPage page;
  final bool isInitiallyOpen;

  const HierarchyOverlayWrapper({
    super.key,
    required this.page,
    this.isInitiallyOpen = true,
  });

  @override
  State<HierarchyOverlayWrapper> createState() => HierarchyOverlayWrapperState();
}

class HierarchyOverlayWrapperState extends State<HierarchyOverlayWrapper> {
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.isInitiallyOpen;
  }

  void toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void open() {
    if (!_isOpen) {
      setState(() {
        _isOpen = true;
      });
    }
  }

  void close() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOpen) {
      return const SizedBox.shrink();
    }

    return LandingPageBuilderHierarchyOverlay(
      page: widget.page,
      onClose: close,
      onItemSelected: (widgetId, isSection) {
        final hierarchyHelper = LandingPageBuilderHierarchyHelper(
          page: widget.page,
        );
        hierarchyHelper.onHierarchyItemSelected(widgetId, isSection);
      },
    );
  }
}
