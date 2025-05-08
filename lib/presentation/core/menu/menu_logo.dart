import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MenuLogo extends StatefulWidget {
  const MenuLogo({super.key});

  @override
  State<MenuLogo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MenuLogo> {
  double _scale = 1.0;

  void _onEnter(PointerEvent event) {
    setState(() {
      _scale = 1.1;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: InkWell(
          onTap: () {
            CustomNavigator.navigate(RoutePaths.dashboardPath);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Center(
            child: Image.asset(
              kDebugMode
                  ? "images/logo/logo.png"
                  : "assets/images/logo/logo.png",
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}
