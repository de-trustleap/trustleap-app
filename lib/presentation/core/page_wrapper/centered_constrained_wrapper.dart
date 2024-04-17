// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CenteredConstrainedWrapper extends StatelessWidget {
  final Widget child;
  const CenteredConstrainedWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ResponsiveConstraints(conditionalConstraints: const [
      Condition.equals(name: MOBILE, value: BoxConstraints(maxWidth: 600)),
      Condition.equals(name: TABLET, value: BoxConstraints(maxWidth: 800)),
      Condition.largerThan(name: TABLET, value: BoxConstraints(maxWidth: 1280))
    ], child: child));
  }
}
