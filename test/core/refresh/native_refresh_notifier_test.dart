import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/refresh/native_refresh_notifier.dart';

void main() {
  group('NativeRefreshNotifier', () {
    test('requestRefresh notifies listeners', () {
      final notifier = NativeRefreshNotifier();
      bool notified = false;
      notifier.addListener(() => notified = true);

      notifier.requestRefresh();

      expect(notified, isTrue);
      notifier.dispose();
    });

    test('requestRefresh returns a future that completes on complete()', () async {
      final notifier = NativeRefreshNotifier();
      bool completed = false;

      final future = notifier.requestRefresh();
      future.then((_) => completed = true);

      expect(completed, isFalse);

      notifier.complete();
      await future;

      expect(completed, isTrue);
      notifier.dispose();
    });

    test('requestRefresh completes after timeout', () async {
      final notifier = NativeRefreshNotifier(
        timeout: const Duration(milliseconds: 50),
      );

      final future = notifier.requestRefresh();
      await future;

      notifier.dispose();
    });

    test('complete() is safe to call when no pending refresh', () {
      final notifier = NativeRefreshNotifier();

      expect(() => notifier.complete(), returnsNormally);

      notifier.dispose();
    });

    test('complete() is safe to call multiple times', () async {
      final notifier = NativeRefreshNotifier();
      final future = notifier.requestRefresh();

      notifier.complete();
      await future;

      expect(() => notifier.complete(), returnsNormally);

      notifier.dispose();
    });

    test('second requestRefresh replaces the first completer', () async {
      final notifier = NativeRefreshNotifier();

      final future1 = notifier.requestRefresh();
      final future2 = notifier.requestRefresh();

      // complete() should complete future2 (the active one)
      notifier.complete();
      await future2;

      // future1 completes via its own timeout — we just ensure no error is thrown
      notifier.dispose();
    });

    test('dispose completes pending refresh', () async {
      final notifier = NativeRefreshNotifier();
      final future = notifier.requestRefresh();

      notifier.dispose();

      // Should complete without hanging
      await future;
    });
  });
}
