import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// Diese Erweiterung sorgt dafür, dass 'read' von 'flutter_modular' verwendet wird.
extension ModularWatchExtension on BuildContext {
  T watchModular<T extends Object>() {
    return this.watch<T>();
  }
}
