// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MenuToggleButton extends StatelessWidget {
  final bool collapsed;
  final AnimationController animationController;
  final Function(bool) toggleCollapseButtonOnTap;

  const MenuToggleButton({
    super.key,
    required this.collapsed,
    required this.animationController,
    required this.toggleCollapseButtonOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
      child: IconButton(
          onPressed: () => toggleCollapseButtonOnTap(collapsed),
          icon: Icon(collapsed ? Icons.chevron_right : Icons.chevron_left,
              size: 28)),
    );
  }
}
