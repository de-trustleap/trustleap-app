import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String title;
  const CustomTab({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Text(title, style: Theme.of(context).textTheme.headlineLarge));
  }
}
