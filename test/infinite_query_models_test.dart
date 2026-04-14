import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_infinite_query/riverpod_infinite_query.dart';

void main() {
  group('InfiniteQueryRequest', () {
    test('uses value equality', () {
      expect(const InfiniteQueryRequest<int>([1, 2]), const InfiniteQueryRequest<int>([1, 2]));
    });

    test('copyWith replaces payload', () {
      final request = const InfiniteQueryRequest<int>([1, 2]);

      expect(request.copyWith(payload: [3]).payload, [3]);
    });
  });

  group('InfiniteQueryResponse', () {
    test('exposes an unmodifiable list view', () {
      final response = const InfiniteQueryResponse<int>([1, 2]);

      expect(() => response.data.add(3), throwsUnsupportedError);
    });
  });
}
