import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/feed_providers.dart';
import '../../application/feed_state.dart';
import '../widgets/feed_shimmer.dart';
import '../widgets/instagram_top_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/stories_tray.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    const double preloadThreshold = 900;
    if (_scrollController.position.extentAfter < preloadThreshold) {
      ref.read(feedNotifierProvider.notifier).loadMoreIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FeedState state = ref.watch(feedNotifierProvider);
    final notifier = ref.read(feedNotifierProvider.notifier);

    return Scaffold(
      appBar: const InstagramTopBar(),
      body: switch (state.status) {
        FeedStatus.initialLoading => const FeedShimmer(),
        FeedStatus.failure when state.posts.isEmpty => _ErrorView(
          onRetry: notifier.loadInitial,
        ),
        _ => RefreshIndicator(
          color: const Color(0xFFFAFAFA),
          onRefresh: notifier.loadInitial,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemCount: state.posts.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return StoriesTray(stories: state.stories);
              }

              if (index == state.posts.length + 1) {
                if (state.isLoadingMore) {
                  return const FeedPaginationShimmer(count: 1);
                }
                return const SizedBox(height: 12);
              }

              final int postIndex = index - 1;
              final post = state.posts[postIndex];

              return PostCard(
                key: ValueKey<String>(post.id),
                post: post,
                onToggleLike: () => notifier.toggleLike(post.id),
                onToggleSave: () => notifier.toggleSave(post.id),
              );
            },
          ),
        ),
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Could not load the feed.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF5F5F5),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection and retry.',
              style: TextStyle(color: Color(0xFFB3B3B3)),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFAFAFA),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Color(0xFF000000)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
