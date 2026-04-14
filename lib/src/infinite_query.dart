// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

part 'infinite_query.freezed.dart';

@freezed
abstract class InfiniteQueryRequest<Req> with _$InfiniteQueryRequest<Req> {
  const factory InfiniteQueryRequest(List<Req> payload) = _InfiniteQueryRequest<Req>;
}

@freezed
abstract class InfiniteQueryResponse<T> with _$InfiniteQueryResponse<T> {
  const factory InfiniteQueryResponse(List<T> data) = _InfiniteQueryResponse<T>;
}

final class _InfiniteQueryNotifier<T, P> extends AsyncNotifier<InfiniteQueryResponse<T>> {
  _InfiniteQueryNotifier({required this.pageProvider, required this.infiniteQueryRequest});

  final FutureProviderFamily<T, P> pageProvider;
  final InfiniteQueryRequest<P> infiniteQueryRequest;

  @override
  FutureOr<InfiniteQueryResponse<T>> build() async {
    final data = <T>[];
    AsyncValue<InfiniteQueryResponse<T>>? nextState;

    loop:
    for (final payload in infiniteQueryRequest.payload) {
      final page = pageProvider(payload);
      if (ref.isRefresh) {
        final _ = await ref.refresh(page.future);
      }

      switch (ref.watch(page)) {
        case AsyncData(:final value):
          data.add(value);
        case AsyncError(:final error, :final stackTrace):
          nextState = AsyncValue<InfiniteQueryResponse<T>>.error(
            error,
            stackTrace,
          ).copyWithPrevious(AsyncData(InfiniteQueryResponse<T>(data)));
          break loop;
        case AsyncLoading():
          nextState = AsyncValue<InfiniteQueryResponse<T>>.loading().copyWithPrevious(
            AsyncData(InfiniteQueryResponse<T>(data)),
            isRefresh: data.isNotEmpty,
          );
          break loop;
      }
    }

    nextState ??= AsyncValue<InfiniteQueryResponse<T>>.data(InfiniteQueryResponse<T>(data));
    state = nextState;
    return future;
  }
}

typedef InfiniteQueryProvider<T, P> =
    AsyncNotifierProviderFamily<
      _InfiniteQueryNotifier<T, P>,
      InfiniteQueryResponse<T>,
      InfiniteQueryRequest<P>
    >;

InfiniteQueryProvider<T, P> createInfiniteQueryProvider<T, P>(
  FutureProviderFamily<T, P> pageProvider,
) {
  return AsyncNotifierProvider.autoDispose.family((InfiniteQueryRequest<P> arg) {
    return _InfiniteQueryNotifier<T, P>(pageProvider: pageProvider, infiniteQueryRequest: arg);
  });
}
