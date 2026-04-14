import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_infinite_query/riverpod_infinite_query.dart';

import 'test_helpers.dart';

void main() {
  group('useInfiniteRiverScroll', () {
    late FakePaginatedApi<int, String> api;
    late dynamic pageProvider;
    late InfiniteQueryProvider<String, int> provider;

    setUp(() {
      api = FakePaginatedApi<int, String>();
      pageProvider = FutureProvider.autoDispose.family<String, int>((ref, page) => api.fetch(page));
      provider = createInfiniteQueryProvider<String, int>(pageProvider);
    });

    testWidgets(
      'refresh re-fetches the current request and clears rendered items after resolution',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: _InfiniteScrollHarness(
              provider: provider,
              initial: 1,
              next: (_, _) => null,
              viewportHeight: 40,
              itemExtent: 50,
            ),
          ),
        );

        expect(api.requestCount(1), 1);

        api.succeed(1, 'page-1');
        await pumpHookFrames(tester);

        expect(find.text('page-1'), findsOneWidget);

        await tester.tap(find.byKey(const Key('refresh-current')));
        await pumpHookFrames(tester);

        expect(api.requestCount(1), 2);

        api.succeed(1, 'page-1 refreshed');
        await pumpHookFrames(tester);

        expect(_stateText(tester), contains('items:'));
        expect(_stateText(tester), isNot(contains('page-1 refreshed')));
        expect(find.text('page-1'), findsNothing);
      },
    );

    testWidgets('refresh with a transform replaces the request payload after a double fetch', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _InfiniteScrollHarness(
            provider: provider,
            initial: 1,
            next: (_, _) => null,
            viewportHeight: 40,
            itemExtent: 50,
          ),
        ),
      );

      api.succeed(1, 'page-1');
      await pumpHookFrames(tester);

      await tester.tap(find.byKey(const Key('refresh-transform')));
      await pumpHookFrames(tester);

      expect(api.requestCount(11), 2);

      api.succeed(11, 'page-11');
      await pumpHookFrames(tester);
      api.succeed(11, 'page-11');
      await pumpHookFrames(tester);

      expect(find.text('page-11'), findsOneWidget);
      expect(find.text('page-1'), findsNothing);
    });

    testWidgets('auto top-up keeps requesting pages until content becomes scrollable', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _InfiniteScrollHarness(
            provider: provider,
            initial: 1,
            next: (_, current) => current < 3 ? current + 1 : null,
            viewportHeight: 120,
            itemExtent: 50,
          ),
        ),
      );

      expect(api.requestCount(1), 1);

      api.succeed(1, 'page-1');
      await pumpHookFrames(tester);

      expect(find.text('page-1'), findsOneWidget);
      expect(api.requestCount(2), 1);

      api.succeed(2, 'page-2');
      await pumpHookFrames(tester);

      expect(find.text('page-2'), findsOneWidget);
      expect(api.requestCount(3), 1);

      api.succeed(3, 'page-3');
      await pumpHookFrames(tester);

      expect(find.text('page-3'), findsOneWidget);
      expect(api.requestCount(4), 0);
    });

    testWidgets('auto top-up stops when next returns null', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _InfiniteScrollHarness(
            provider: provider,
            initial: 1,
            next: (_, current) => current < 2 ? current + 1 : null,
            viewportHeight: 200,
            itemExtent: 50,
          ),
        ),
      );

      api.succeed(1, 'page-1');
      await pumpHookFrames(tester);

      expect(api.requestCount(2), 1);

      api.succeed(2, 'page-2');
      await pumpHookFrames(tester);

      expect(find.text('page-1'), findsOneWidget);
      expect(find.text('page-2'), findsOneWidget);
      expect(api.requestCount(3), 0);
    });
  });
}

class _InfiniteScrollHarness extends HookConsumerWidget {
  const _InfiniteScrollHarness({
    required this.provider,
    required this.initial,
    required this.next,
    required this.viewportHeight,
    required this.itemExtent,
  });

  final InfiniteQueryProvider<String, int> provider;
  final int initial;
  final int? Function(String? lastItem, int currentRequest) next;
  final double viewportHeight;
  final double itemExtent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
    final result = useInfiniteScroll<String, int>(
      ref: ref,
      provider: provider,
      initial: initial,
      next: next,
      controller: controller,
      distance: 0,
    );
    final items = result.data.value?.data ?? const <String>[];

    return MaterialApp(
      home: Material(
        child: Column(
          children: [
            TextButton(
              key: const Key('refresh-current'),
              onPressed: () => unawaited(result.refresh()),
              child: const Text('refresh-current'),
            ),
            TextButton(
              key: const Key('refresh-transform'),
              onPressed: () => unawaited(result.refresh((payload) => [payload.first + 10])),
              child: const Text('refresh-transform'),
            ),
            Text(
              'items:${items.join('|')} loading:${result.data.isLoading}',
              key: const Key('state'),
            ),
            SizedBox(
              height: viewportHeight,
              child: ListView.builder(
                controller: controller,
                itemExtent: itemExtent,
                itemCount: items.length,
                itemBuilder: (context, index) => Text(items[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _stateText(WidgetTester tester) {
  return tester.widget<Text>(find.byKey(const Key('state'))).data ?? '';
}
