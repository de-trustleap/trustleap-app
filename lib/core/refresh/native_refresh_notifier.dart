import 'dart:async';

import 'package:flutter/foundation.dart';

class NativeRefreshNotifier extends ChangeNotifier {
  final Duration timeout;

  NativeRefreshNotifier({this.timeout = const Duration(seconds: 15)});

  Completer<void>? _completer;

  Future<void> requestRefresh() {
    final completer = Completer<void>();
    _completer = completer;
    notifyListeners();
    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        completer.complete();
        if (_completer == completer) _completer = null;
      }
    });
    return completer.future;
  }

  void complete() {
    if (!(_completer?.isCompleted ?? true)) {
      _completer?.complete();
    }
    _completer = null;
  }

  @override
  void dispose() {
    complete();
    super.dispose();
  }
}
