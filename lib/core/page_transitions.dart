import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PageTransitions {
  static final fadePageTransition = CustomTransition(
    transitionDuration: const Duration(milliseconds: 250),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
        )),
        child: child,
      );
    },
  );
}
