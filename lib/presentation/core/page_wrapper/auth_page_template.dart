import 'package:finanzbegleiter/presentation/feedback/feedback_floating_action_button.dart';
import 'package:flutter/material.dart';

class AuthPageTemplate extends StatelessWidget {
  final Widget child;

  const AuthPageTemplate({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: const FeedbackFloatingActionButton(),
    );
  }
}