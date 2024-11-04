import 'package:flutter/material.dart';

class CollapsibleTile extends StatelessWidget {
  final String title;
  const CollapsibleTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
            color: themeData.colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: Theme(
            data: themeData.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: themeData.colorScheme.surfaceTint,
              collapsedIconColor: themeData.colorScheme.surfaceTint,
              title: Text(title, style: themeData.textTheme.bodyMedium),
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              height: 0.8,
                              color: themeData.textTheme.bodyMedium!.color),
                          SizedBox(height: 16),
                          Text("Das hier ist der zugehörige Text",
                              style: themeData.textTheme.bodySmall),
                          SizedBox(height: 50),
                          Text(
                              "Noch ein Text mit noch mehr Inhalt als der Text davor..",
                              style: themeData.textTheme.bodySmall)
                        ]))
              ],
            )));
  }
}
