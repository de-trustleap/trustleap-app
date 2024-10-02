// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetContainer extends StatelessWidget {
  final PageBuilderWidget model;
  final Widget child;

  const LandingPageBuilderWidgetContainer({
    super.key,
    required this.model,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          model.padding?.left ?? 0,
          model.padding?.top ?? 0,
          model.padding?.right ?? 0,
          model.padding?.bottom ?? 0),
      child: Container(color: model.backgroundColor, child: child),
    );
  }
}
