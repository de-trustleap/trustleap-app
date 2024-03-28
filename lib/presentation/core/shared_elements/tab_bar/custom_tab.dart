import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomTab extends StatelessWidget {
  final String title;
  final IconData icon;
  const CustomTab({required this.title, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return SizedBox(
      width: responsiveValue.isMobile ? 200 : 400,
      child: Tab(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,
              color:
                  Theme.of(context).colorScheme.surfaceTint.withOpacity(0.8)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(title,
                style: Theme.of(context).textTheme.headlineLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          )
        ],
      )),
    );
  }
}
