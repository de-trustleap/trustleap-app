// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomTabbar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;

  const CustomTabbar({
    Key? key,
    required this.controller,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    return SizedBox(
        width: responsiveValue.largerThan(MOBILE)
            ? responsiveValue.screenWidth * 0.6
            : responsiveValue.screenWidth * 0.9,
        child: TabBar(
          controller: controller,
          tabs: tabs,
        ));
  }
}
