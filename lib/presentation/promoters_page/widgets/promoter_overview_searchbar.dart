import 'package:flutter/material.dart';

class PromoterOverviewSearchBar extends StatefulWidget {
  const PromoterOverviewSearchBar({super.key});

  @override
  State<PromoterOverviewSearchBar> createState() =>
      _PromoterOverviewSearchBarState();
}

class _PromoterOverviewSearchBarState extends State<PromoterOverviewSearchBar> {
  String query = "";

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return SizedBox(
      height: 50,
      child: TextField(
          onChanged: onQueryChanged,
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
