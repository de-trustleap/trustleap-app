import 'package:flutter/material.dart';

class CustomAppBarNative extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBarNative({super.key, this.title, this.actions, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: leading,
      title: title != null ? Text(title!) : null,
      actions: actions,
    );
  }
}
