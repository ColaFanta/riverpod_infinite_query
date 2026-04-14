import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_infinite_query/riverpod_infinite_query.dart';

import 'test_helpers.dart';

void main() {
  group('createInfiniteQueryProvider', () {
    late FakePaginatedApi<int, String> api;
    late dynamic pageProvider;
    late InfiniteQueryProvider<String, int> provider;
    late ProviderContainer container;

    setUp(() {
      api = FakePaginatedApi<int, String>();
      pageProvider = FutureProvider.autoDispose.family<String, int>((ref, page) => api.fetch(page));
      provider = createInfiniteQueryProvider<String, int>(pageProvider);
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('returns empty data when the request payload is empty', () async {
      final response = await container.read(provider(const InfiniteQueryRequest<int>([])).future);

      expect(response.data, isEmpty);
      expect(api.callCount, isEmpty);
    });

    test('requests pages in order and accumulates state as each page resolves', () async {
      const request = InfiniteQueryRequest<int>([1, 2, 3]);
      final states = <AsyncValue<InfiniteQueryResponse<String>>>[];
      final subscription = container.listen(
        provider(request),
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final responseFuture = container.read(provider(request).future);

      expect(states, hasLength(1));
      expect(states.single.isLoading, isTrue);
      expect(states.single.value?.data, isEmpty);
      expect(api.requestCount(1), 1);
      expect(api.requestCount(2), 0);
      expect(api.requestCount(3), 0);

      api.succeed(1, 'page-1');
      await flushAsyncWork();

      expect(states.last.value?.data, ['page-1']);
      expect(api.requestCount(2), 1);
      expect(api.requestCount(3), 0);

      api.succeed(2, 'page-2');
      await flushAsyncWork();

      expect(states.last.value?.data, ['page-1', 'page-2']);
      expect(api.requestCount(3), 1);

      api.succeed(3, 'page-3');
      final response = await responseFuture;
      await flushAsyncWork();

      expect(response.data, ['page-1']);
      expect(subscription.read().requireValue.data, ['page-1', 'page-2', 'page-3']);
    });

    test('returns partial data and keeps an error state when a later page fails', () async {
      const request = InfiniteQueryRequest<int>([1, 2, 3]);
      final subscription = container.listen(provider(request), (_, _) {}, fireImmediately: true);
      addTearDown(subscription.close);

      final responseFuture = container.read(provider(request).future);

      api.succeed(1, 'page-1');
      await flushAsyncWork();

      final error = StateError('page 2 failed');
      api.fail(2, error);

      final response = await responseFuture;
      await flushAsyncWork();

      final state = subscription.read();
      expect(response.data, ['page-1']);
      expect(state.hasError, isTrue);
      expect(state.value?.data, ['page-1']);
      expect(api.requestCount(3), 0);
    });

    test('refresh starts from page one and transitions through cached state', () async {
      const request = InfiniteQueryRequest<int>([1, 2]);
      final subscription = container.listen(provider(request), (_, _) {}, fireImmediately: true);
      addTearDown(subscription.close);

      final initialFuture = container.read(provider(request).future);

      api.succeed(1, 'page-1');
      await flushAsyncWork();
      api.succeed(2, 'page-2');
      await flushAsyncWork();

      expect((await initialFuture).data, ['page-1']);
      expect(subscription.read().requireValue.data, ['page-1', 'page-2']);
      expect(api.requestCount(1), 1);
      expect(api.requestCount(2), 1);

      container.refresh(provider(request));
      await flushAsyncWork();

      expect(api.requestCount(1), 2);
      expect(subscription.read().value?.data, ['page-1', 'page-2']);

      api.succeed(1, 'page-1 refreshed');
      await flushAsyncWork();

      expect(subscription.read().value?.data, isEmpty);
      expect(api.requestCount(2), 1);
    });
  });
}
