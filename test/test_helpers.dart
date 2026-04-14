import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

final class FakePaginatedApi<P, T> {
  final callCount = <P, int>{};
  final _pendingRequests = <P, List<Completer<T>>>{};

  Future<T> fetch(P page) {
    callCount.update(page, (count) => count + 1, ifAbsent: () => 1);
    final completer = Completer<T>();
    _pendingRequests.putIfAbsent(page, () => <Completer<T>>[]).add(completer);
    return completer.future;
  }

  int requestCount(P page) => callCount[page] ?? 0;

  void succeed(P page, T value) {
    _takePendingRequest(page).complete(value);
  }

  void fail(P page, Object error, [StackTrace? stackTrace]) {
    _takePendingRequest(page).completeError(error, stackTrace ?? StackTrace.current);
  }

  Completer<T> _takePendingRequest(P page) {
    final requests = _pendingRequests[page];
    if (requests == null || requests.isEmpty) {
      throw StateError('No pending request for $page');
    }

    return requests.removeAt(0);
  }
}

Future<void> flushAsyncWork() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Future<void> pumpHookFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump();
}