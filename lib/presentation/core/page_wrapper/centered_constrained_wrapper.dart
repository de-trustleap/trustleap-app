// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
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
    final responsiveData = ResponsiveHelper.of(context);

    BoxConstraints constraints;
    if (responsiveData.breakpoint.name == MOBILE) {
      constraints = const BoxConstraints(maxWidth: 600);
    } else if (responsiveData.breakpoint.name == TABLET) {
      constraints = const BoxConstraints(maxWidth: 800);
    } else {
      constraints = const BoxConstraints(maxWidth: 1280);
    }

    return Center(
      child: ConstrainedBox(
        constraints: constraints,
        child: child,
      ),
    );
  }
}
