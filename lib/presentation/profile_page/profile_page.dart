import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/page_template.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/contact_information.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: Container(
          width: double.infinity,
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [ContactInformation()]))),
    );
  }
}
