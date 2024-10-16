// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetContainer extends StatefulWidget {
  final PageBuilderContainerProperties? properties;
  final PageBuilderWidget model;
  final Widget child;

  const LandingPageBuilderWidgetContainer({
    super.key,
    this.properties,
    required this.model,
    required this.child,
  });

  @override
  State<LandingPageBuilderWidgetContainer> createState() =>
      _LandingPageBuilderWidgetContainerState();
}

class _LandingPageBuilderWidgetContainerState
    extends State<LandingPageBuilderWidgetContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
      }),
      child: Container(
        constraints:
            BoxConstraints(maxWidth: widget.model.maxWidth ?? double.infinity),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              widget.model.padding?.left ?? 0,
              widget.model.padding?.top ?? 0,
              widget.model.padding?.right ?? 0,
              widget.model.padding?.bottom ?? 0),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isHovered
                        ? themeData.colorScheme.primary
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: Container(
                    decoration: BoxDecoration(
                        color: widget.model.backgroundColor,
                        borderRadius: widget.properties?.borderRadius != null
                            ? BorderRadius.circular(
                                widget.properties!.borderRadius!)
                            : null,
                        boxShadow: widget.properties?.shadow != null
                            ? [
                                BoxShadow(
                                    color: widget.properties!.shadow!.color ??
                                        Colors.black,
                                    spreadRadius: widget
                                            .properties!.shadow!.spreadRadius ??
                                        0,
                                    blurRadius:
                                        widget.properties!.shadow!.blurRadius ??
                                            0,
                                    offset: widget.properties!.shadow!.offset ??
                                        const Offset(0, 0))
                              ]
                            : null),
                    child: widget.child),
              ),
              if (_isHovered) ...[
                Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                        onPressed: () {
                          print("PRESSED2");
                        },
                        icon: Icon(Icons.edit,
                            color: themeData.colorScheme.secondary, size: 20)))
              ]
            ],
          ),
        ),
      ),
    );
  }
}
