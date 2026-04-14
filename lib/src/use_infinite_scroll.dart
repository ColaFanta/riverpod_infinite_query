import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'infinite_query.dart';

typedef InfiniteQueryRefresh<T, P> =
    Future<InfiniteQueryResponse<T>> Function([List<P> Function(List<P>)?]);

typedef InfiniteRiverScrollResult<T, P> =
    ({AsyncValue<InfiniteQueryResponse<T>> data, InfiniteQueryRefresh<T, P> refresh});

/// Builds an infinite scroll query from a request-generating [next] callback.
///
/// This API assumes future page requests can be derived from the latest loaded
/// request and response alone. That matches request-driven pagination well.
/// Backends that require each intermediate page response to compute the next
/// cursor need a richer page model than `T` and one-page-at-a-time derivation.
InfiniteRiverScrollResult<T, P> useInfiniteScroll<T, P>({
  required WidgetRef ref,
  required InfiniteQueryProvider<T, P> provider,
  required P initial,
  required P? Function(T?, P) next,
  required ScrollController controller,
  double distance = 100.0,
}) {
  final request = useState<InfiniteQueryRequest<P>>(InfiniteQueryRequest<P>([initial]));
  useValueChanged(initial, (_, _) => request.value = InfiniteQueryRequest<P>([initial]));

  final data = ref.watch(provider(request.value));

  final modifiedListIndex = useValueChanged(
    data,
    (previousData, _) => switch ((previousData.value?.data, data.value?.data)) {
      (List previous?, List current?) => _findListModifiedIndex(previous, current),
      (null, _) => null,
      (_, null) => 1,
    },
  );

  useValueChanged(
    modifiedListIndex,
    (_, _) =>
        modifiedListIndex == null
            ? null
            : request.value = request.value.copyWith(
              payload: request.value.payload.sublist(0, max(1, modifiedListIndex)),
            ),
  );

  useEffect(() {
    void loadMore() {
      if (!controller.hasClients) {
        return;
      }
      if (controller.position.pixels < controller.position.maxScrollExtent - distance) {
        return;
      }

      final query = ref.read(provider(request.value));
      final nextRequests = _buildNextRequests(
        query: query,
        request: request.value,
        next: next,
        desiredCount: (query.value?.data.length ?? 0) - request.value.payload.length + 1,
      );
      if (nextRequests.isEmpty) {
        return;
      }

      request.value = InfiniteQueryRequest<P>([...request.value.payload, ...nextRequests]);
    }

    controller.addListener(loadMore);
    return () => controller.removeListener(loadMore);
  }, [controller, data, distance, modifiedListIndex, next, provider, request.value]);

  _usePostFrameEffect((enqueue) {
    if (!controller.hasClients) {
      return null;
    }
    if (controller.position.maxScrollExtent > 0) {
      return null;
    }

    enqueue((_) {
      final query = ref.read(provider(request.value));
      final nextRequests = _buildNextRequests(
        query: query,
        request: request.value,
        next: next,
        desiredCount: 1,
      );
      if (nextRequests.isEmpty) {
        return;
      }

      request.value = InfiniteQueryRequest<P>([...request.value.payload, ...nextRequests]);
    });
    return null;
  }, [controller, data, next, provider, request.value]);

  Future<InfiniteQueryResponse<T>> refresh([List<P> Function(List<P>)? transform]) {
    final nextRequest =
        transform == null
            ? request.value
            : InfiniteQueryRequest<P>(transform(request.value.payload));
    request.value = nextRequest;
    return ref.refresh(provider(nextRequest).future);
  }

  return (data: data, refresh: refresh);
}

// This helper may synthesize multiple future requests from a single latest
// response. If the next cursor depends on every page's response, the API needs
// to carry page metadata and derive requests sequentially instead.
List<P> _buildNextRequests<T, P>({
  required AsyncValue<InfiniteQueryResponse<T>> query,
  required InfiniteQueryRequest<P> request,
  required P? Function(T?, P) next,
  required int desiredCount,
}) {
  final successResponseLength = query.value?.data.length ?? 0;
  if (request.payload.length > successResponseLength) {
    return const [];
  }

  final loopCount = max(0, desiredCount);
  if (loopCount == 0) {
    return const [];
  }

  final latestRequest = request.payload.last;
  final lastResponse = query.value?.data.lastOrNull;

  final nextRequests = <P>[];
  var currentRequest = latestRequest;
  for (var index = 0; index < loopCount; index++) {
    final nextRequest = next(lastResponse, currentRequest);
    if (nextRequest == null) {
      break;
    }

    currentRequest = nextRequest;
    nextRequests.add(nextRequest);
  }

  return nextRequests;
}

void _usePostFrameEffect(
  void Function()? Function(void Function(FrameCallback, {String debugLabel})) effect, [
  List<Object?>? keys,
]) {
  useEffect(() => effect(WidgetsBinding.instance.addPostFrameCallback), keys);
}

int? _findListModifiedIndex(List<dynamic> previous, List<dynamic> current) {
  final minLength = min(previous.length, current.length);
  for (var index = 0; index < minLength; index++) {
    if (previous[index] != current[index]) {
      return index;
    }
  }

  if (previous.length > current.length) {
    return current.length;
  }

  return null;
}
