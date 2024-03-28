import 'package:flutter/material.dart';

class PromoterOverviewSearchBar extends StatelessWidget {
  const PromoterOverviewSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return SizedBox(
      height: 50,
      child: TextField(
          cursorHeight: 20,
          decoration: InputDecoration(
              labelText: "Suche...",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeData.colorScheme.surfaceTint.withOpacity(0.5),
                      width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeData.colorScheme.surfaceTint.withOpacity(0.5),
                      width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeData.colorScheme.surfaceTint.withOpacity(0.5),
                      width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              prefixIcon: const Icon(Icons.search))),
    );
  }
}
