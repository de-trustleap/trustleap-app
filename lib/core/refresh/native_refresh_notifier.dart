import 'dart:async';

import 'package:flutter/foundation.dart';

class NativeRefreshNotifier extends ChangeNotifier {
  final Duration timeout;

  NativeRefreshNotifier({this.timeout = const Duration(seconds: 15)});

  Completer<void>? _completer;

  Future<void> requestRefresh() {
    _completer = Completer<void>();
    notifyListeners();
    Future.delayed(timeout, () {
      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete();
        _completer = null;
      }
    });
    return _completer!.future;
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
