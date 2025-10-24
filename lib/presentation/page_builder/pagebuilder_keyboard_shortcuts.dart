import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderKeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const PagebuilderKeyboardShortcuts({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      canRequestFocus: true,
      child: CallbackShortcuts(
        bindings: {
          // Strg+Z (Windows/Linux) für Undo
          const SingleActivator(LogicalKeyboardKey.keyZ, control: true): () {
            Modular.get<PagebuilderBloc>().add(UndoPagebuilderEvent());
          },
          // Cmd+Z (macOS) für Undo
          const SingleActivator(LogicalKeyboardKey.keyZ, meta: true): () {
            Modular.get<PagebuilderBloc>().add(UndoPagebuilderEvent());
          },
          // Strg+Shift+Z (Windows/Linux) für Redo
          const SingleActivator(LogicalKeyboardKey.keyZ,
              control: true, shift: true): () {
            Modular.get<PagebuilderBloc>().add(RedoPagebuilderEvent());
          },
          // Cmd+Shift+Z (macOS) für Redo
          const SingleActivator(LogicalKeyboardKey.keyZ,
              meta: true, shift: true): () {
            Modular.get<PagebuilderBloc>().add(RedoPagebuilderEvent());
          },
          // Strg+Y (Windows/Linux) für Redo (alternative)
          const SingleActivator(LogicalKeyboardKey.keyY, control: true): () {
            Modular.get<PagebuilderBloc>().add(RedoPagebuilderEvent());
          },
          // Cmd+Y (macOS) für Redo (alternative)
          const SingleActivator(LogicalKeyboardKey.keyY, meta: true): () {
            Modular.get<PagebuilderBloc>().add(RedoPagebuilderEvent());
          },
        },
        child: Focus(
          autofocus: true,
          skipTraversal: true,
          descendantsAreFocusable: true,
          child: child,
        ),
      ),
    );
  }
}
