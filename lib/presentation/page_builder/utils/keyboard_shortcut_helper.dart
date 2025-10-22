import "package:flutter/foundation.dart";

class KeyboardShortcutHelper {
  static String getUndoShortcut() {
    return defaultTargetPlatform == TargetPlatform.macOS ? "Cmd+Z" : "Strg+Z";
  }

  static String getRedoShortcut() {
    return defaultTargetPlatform == TargetPlatform.macOS
        ? "Cmd+Shift+Z"
        : "Strg+Shift+Z";
  }
}
