import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final PagebuilderContent content;
  final bool isLoading;
  const LandingPageBuilderAppBar({super.key, required this.content, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AppBar(
        title: Text(content.landingPage?.name ?? "",
            style: themeData.textTheme.bodyLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: PrimaryButton(
                title: "Speichern",
                isLoading: isLoading,
                width: 180,
                onTap: () {
                  Modular.get<PagebuilderCubit>().saveLandingPageContent(content.content);
                }),
          )
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
