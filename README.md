# riverpod_infinite_query

[![pub package](https://img.shields.io/pub/v/riverpod_infinite_query.svg)](https://pub.dev/packages/riverpod_infinite_query)
[![pub points](https://img.shields.io/pub/points/riverpod_infinite_query)](https://pub.dev/packages/riverpod_infinite_query/score)
[![likes](https://img.shields.io/pub/likes/riverpod_infinite_query)](https://pub.dev/packages/riverpod_infinite_query/score)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Lightweight infinite query utilities for `riverpod`-based Flutter apps.

## Design

This package is built upon `FutureProvider` of `riverpod` and without complex implementation.

It only coordinates multiple `FutureProvider.family` pages so they behave like one infinite query.

- One request payload maps to one page `FutureProvider`
- One infinite query is a list of page providers working together
- Adding a new page only requests the new page
- Cache, refresh, invalidation, and `autoDispose` still come from Riverpod

`InfiniteQueryResponse<T>` is just the collected result of each page response `T`.

```text
request [1]           | page 1 |

request [1, 2]        | page 2 |
											| page 1 |

request [1, 2, 3]     | page 3 |
											| page 2 |
											| page 1 |

append one more page  -> fetch only the new FutureProvider
refresh/invalidate    -> keep Riverpod behavior
```

## Installation

Pubspec [![latest version](https://img.shields.io/pub/v/riverpod_infinite_query.svg)](https://pub.dev/packages/riverpod_infinite_query)

```yaml
dependencies:
	riverpod_infinite_query: ^<latest_version>
```

CLI

```sh
flutter pub add riverpod_infinite_query
```

## Example

```dart
final postsPageProvider = FutureProvider.autoDispose.family<PostPage, int>((ref, page) {
	return api.fetchPage(page);
});

final postsProvider = createInfiniteQueryProvider<PostPage, int>(postsPageProvider);

class PostsScreen extends HookConsumerWidget {
	const PostsScreen({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final controller = useScrollController();
		final result = useInfiniteScroll<PostPage, int>(
			ref: ref,
			provider: postsProvider,
			initial: 1,
			controller: controller,
			next: (lastPage, currentPage) {
				if (lastPage != null && !lastPage.hasMore) {
					return null;
				}
				return currentPage + 1;
			},
		);

		final pages = result.data.value?.data ?? const <PostPage>[];
		final items = [
			for (final page in pages) ...page.items,
		];

		return RefreshIndicator(
			onRefresh: () => result.refresh((_) => [1]),
			child: ListView.builder(
				controller: controller,
				itemCount: items.length + (result.data.isLoading ? 1 : 0),
				itemBuilder: (context, index) {
					if (index == items.length) {
						return const Padding(
							padding: EdgeInsets.all(16),
							child: Center(child: CircularProgressIndicator()),
						);
					}

					return ListTile(title: Text(items[index].title));
				},
			),
		);
	}
}
```

See `example/` for a complete runnable Flutter app.
