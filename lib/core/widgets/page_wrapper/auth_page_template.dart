import 'package:finanzbegleiter/features/auth/presentation/widgets/auth_footer.dart';
import 'package:finanzbegleiter/features/feedback/presentation/feedback_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AuthPageTemplate extends StatelessWidget {
  final Widget child;

  const AuthPageTemplate({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: child),
          const SizedBox(height: 40),
          const AuthFooter(),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: responsiveValue.isMobile ? 40 : 0),
        child: const FeedbackFloatingActionButton(),
      ),
    );
  }
}
