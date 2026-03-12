import 'dart:async';

import 'package:flutter/material.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  final StreamController<void> _controller =
      StreamController<void>.broadcast();

  AppLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.add(null);
    }
  }

  Stream<void> get onResumed => _controller.stream;
}
