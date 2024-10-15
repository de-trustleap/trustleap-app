// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetContainer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: model.maxWidth ?? double.infinity),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            model.padding?.left ?? 0,
            model.padding?.top ?? 0,
            model.padding?.right ?? 0,
            model.padding?.bottom ?? 0),
        child: Container(
            decoration: BoxDecoration(
                color: model.backgroundColor,
                borderRadius: properties?.borderRadius != null
                    ? BorderRadius.circular(properties!.borderRadius!)
                    : null,
                boxShadow: properties?.shadow != null
                    ? [
                        BoxShadow(
                            color: properties!.shadow!.color ?? Colors.black,
                            spreadRadius: properties!.shadow!.spreadRadius ?? 0,
                            blurRadius: properties!.shadow!.blurRadius ?? 0,
                            offset: properties!.shadow!.offset ??
                                const Offset(0, 0))
                      ]
                    : null),
            child: child),
      ),
    );
  }
}
