import 'package:finanzbegleiter/core/refresh/native_refresh_notifier.dart';
import 'package:finanzbegleiter/core/refresh/refresh_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin RefreshableStateMixin<T extends StatefulWidget> on State<T> {
  NativeRefreshNotifier? _refreshNotifier;

  /// Override to define what happens when the user pulls to refresh.
  /// Call [notifier.complete()] is handled automatically via try/finally.
  Future<void> onRefresh();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kIsWeb) return;

    final notifier = RefreshScope.maybeOf(context);
    if (notifier != _refreshNotifier) {
      _refreshNotifier?.removeListener(_handleRefresh);
      _refreshNotifier = notifier;
      _refreshNotifier?.addListener(_handleRefresh);
    }
  }

  void _handleRefresh() async {
    try {
      await onRefresh();
    } finally {
      _refreshNotifier?.complete();
    }
  }

  @override
  void dispose() {
    _refreshNotifier?.removeListener(_handleRefresh);
    super.dispose();
  }
}
