import 'package:finanzbegleiter/features/auth/presentation/widgets/auth_footer.dart';
import 'package:finanzbegleiter/features/feedback/presentation/feedback_floating_action_button.dart';
import 'package:finanzbegleiter/features/menu/presentation/appbar_native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AuthPageTemplate extends StatelessWidget {
  final Widget child;
  final String? title;

  const AuthPageTemplate({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Scaffold(
        appBar: CustomAppBarNative(title: title),
        body: child,
      );
    }

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
