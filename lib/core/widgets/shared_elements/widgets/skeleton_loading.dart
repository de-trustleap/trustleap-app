import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonLoading extends StatelessWidget {
  final Widget child;

  const SkeletonLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: child,
    );
  }
}
