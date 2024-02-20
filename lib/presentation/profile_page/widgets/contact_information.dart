import 'package:finanzbegleiter/presentation/core/shared_elements/card_container.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ContactInformation extends StatefulWidget {
  @override
  State<ContactInformation> createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final streetTextController = TextEditingController();
  final postcodeTextController = TextEditingController();
  final placeTextController = TextEditingController();

  @override
  void dispose() {
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    streetTextController.dispose();
    postcodeTextController.dispose();
    placeTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    const double textFieldSpacing = 20;

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Kontaktinformationen",
              style: themeData.textTheme.headlineLarge!
                  .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ResponsiveRowColumn(
              columnMainAxisSize: MainAxisSize.min,
              layout: responsiveValue.isMobile
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: [
                ResponsiveRowColumnItem(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("Vorname",
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      SizedBox(
                        width:
                            responsiveValue.isMobile ? maxWidth : maxWidth / 2,
                        child: TextFormField(
                          controller: firstNameTextController,
                          decoration: const InputDecoration(labelText: ""),
                        ),
                      ),
                    ])),
                const ResponsiveRowColumnItem(
                    child: SizedBox(
                        height: textFieldSpacing, width: textFieldSpacing)),
                ResponsiveRowColumnItem(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("Nachname",
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: responsiveValue.isMobile
                            ? maxWidth
                            : maxWidth / 2 - textFieldSpacing,
                        child: TextFormField(
                          controller: lastNameTextController,
                          decoration: const InputDecoration(labelText: ""),
                        ),
                      ),
                    ]))
              ]),
          const SizedBox(height: textFieldSpacing),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Straße und Hausnummer",
                style:
                    themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
            const SizedBox(height: 4),
            SizedBox(
              width: maxWidth,
              child: TextFormField(
                controller: streetTextController,
                decoration: const InputDecoration(labelText: ""),
              ),
            ),
          ]),
          const SizedBox(height: textFieldSpacing),
          ResponsiveRowColumn(
              columnMainAxisSize: MainAxisSize.min,
              layout: responsiveValue.isMobile
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: [
                ResponsiveRowColumnItem(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("PLZ",
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      SizedBox(
                        width:
                            responsiveValue.isMobile ? maxWidth : maxWidth / 2,
                        child: TextFormField(
                          controller: postcodeTextController,
                          decoration: const InputDecoration(labelText: ""),
                        ),
                      ),
                    ])),
                const ResponsiveRowColumnItem(
                    child: SizedBox(
                        height: textFieldSpacing, width: textFieldSpacing)),
                ResponsiveRowColumnItem(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("Ort",
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: responsiveValue.isMobile
                            ? maxWidth
                            : maxWidth / 2 - textFieldSpacing,
                        child: TextFormField(
                          controller: placeTextController,
                          decoration: const InputDecoration(labelText: ""),
                        ),
                      ),
                    ]))
              ]),
        ],
      );
    }));
  }
}
