import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String title;
  final IconData icon;
  const CustomTab({required this.title, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.8)),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
      ],
    ));
  }
}
