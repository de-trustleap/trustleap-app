import 'package:flutter/material.dart';

class ContactInformation extends StatelessWidget {
  const ContactInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: themeData.colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: Column(
          children: [Text("Hallöchen")],
        ));
  }
}
