import 'package:finanzbegleiter/infrastructure/models/model_helper/boxfit_mapper.dart';
import 'package:flutter/material.dart';

class PagebuilderContentModeDrowdown extends StatelessWidget {
  final String title;
  final BoxFit initialValue;
  final List<BoxFit> values;
  final Function(BoxFit) onSelected;
  const PagebuilderContentModeDrowdown(
      {super.key,
      required this.title,
      required this.initialValue,
      required this.values,
      required this.onSelected});

  List<DropdownMenuEntry<BoxFit>> createDropdownEntries() {
    List<DropdownMenuEntry<BoxFit>> entries = [];
    for (var boxfit in values) {
      var entry = DropdownMenuEntry<BoxFit>(
          value: boxfit, label: BoxFitMapper.getStringFromBoxFit(boxfit) ?? "");
      entries.add(entry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: themeData.textTheme.bodySmall,
      ),
      DropdownMenu<BoxFit>(
        width: 150,
        initialSelection: initialValue,
        enableSearch: false,
        requestFocusOnTap: false,
        dropdownMenuEntries: createDropdownEntries(),
        onSelected: (value) {
          onSelected(value ?? BoxFit.cover);
        },
        menuStyle: MenuStyle(
          elevation: WidgetStateProperty.all(4),
          alignment: AlignmentDirectional.topStart,
        ),
      ),
    ]);
  }
}
