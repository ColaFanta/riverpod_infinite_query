import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_infinite_query/riverpod_infinite_query.dart';

void main() {
  runApp(const ProviderScope(child: ExampleApp()));
}

final postsPageProvider = FutureProvider.autoDispose.family<PostsPage, int>((ref, page) {
  return DemoApi.instance.fetchPage(page);
});

final postsProvider = createInfiniteQueryProvider<PostsPage, int>(postsPageProvider);

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'riverpod_infinite_query example',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E))),
      home: const PostsScreen(),
    );
  }
}

class PostsScreen extends HookConsumerWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
    final result = useInfiniteScroll<PostsPage, int>(
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

    final pages = result.data.value?.data ?? const <PostsPage>[];
    final posts = [for (final page in pages) ...page.items];

    return Scaffold(
      appBar: AppBar(
        title: const Text('riverpod_infinite_query example'),
        actions: [
          IconButton(
            onPressed: () => unawaited(result.refresh((_) => [1])),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => result.refresh((_) => [1]),
        child: ListView.builder(
          controller: controller,
          padding: const EdgeInsets.symmetric(vertical: 12),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (index == posts.length) {
              return _Footer(result: result.data, hasMore: pages.isEmpty || pages.last.hasMore);
            }

            final post = posts[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
                leading: CircleAvatar(child: Text('${post.id}')),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.result, required this.hasMore});

  final AsyncValue<InfiniteQueryResponse<PostsPage>> result;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (result.hasError) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error while loading more: ${result.error}', textAlign: TextAlign.center),
      );
    }

    if (result.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasMore) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('Scroll to load more')),
      );
    }

    return const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No more pages')));
  }
}

class DemoApi {
  DemoApi._();

  static final instance = DemoApi._();

  Future<PostsPage> fetchPage(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    const pageSize = 10;
    const maxPage = 4;
    final start = (page - 1) * pageSize;

    return PostsPage(
      items: List.generate(pageSize, (index) {
        final id = start + index + 1;
        return Post(id: id, title: 'Post $id', body: 'Fetched by FutureProvider page $page.');
      }),
      hasMore: page < maxPage,
    );
  }
}

class PostsPage {
  const PostsPage({required this.items, required this.hasMore});

  final List<Post> items;
  final bool hasMore;
}

class Post {
  const Post({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;
}
