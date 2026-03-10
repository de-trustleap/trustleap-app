import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomSheetWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const BottomSheetWrapper({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: themeData.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              if (kIsWeb)
                IconButton(
                  onPressed: () => CustomNavigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
          const SizedBox(height: 16),
          PrimaryButton(
            title: localization.pagebuilder_ok,
            onTap: () => CustomNavigator.of(context).pop(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
