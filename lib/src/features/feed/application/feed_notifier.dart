import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/post.dart';
import '../domain/models/story.dart';
import '../domain/repositories/post_repository.dart';
import 'feed_providers.dart';
import 'feed_state.dart';

class FeedNotifier extends Notifier<FeedState> {
  late final PostRepository _repository;

  static const int _pageSize = 10;

  @override
  FeedState build() {
    _repository = ref.read(postRepositoryProvider);
    Future<void>.microtask(loadInitial);
    return FeedState.initial();
  }

  Future<void> loadInitial() async {
    state = FeedState.initial();

    try {
      final List<dynamic> results = await Future.wait<dynamic>(
        <Future<dynamic>>[
          _repository.fetchStories(),
          _repository.fetchPosts(page: 0, limit: _pageSize),
        ],
      );
      final List<Story> stories = results[0] as List<Story>;
      final List<Post> posts = results[1] as List<Post>;

      state = state.copyWith(
        status: FeedStatus.loaded,
        stories: stories,
        posts: posts,
        page: 1,
        hasMore: posts.length == _pageSize,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        status: FeedStatus.failure,
        errorMessage: 'Could not load feed. Please try again.',
      );
    }
  }

  Future<void> loadMoreIfNeeded() async {
    if (state.isInitialLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(status: FeedStatus.loadingMore, clearError: true);

    try {
      final List<Post> nextPosts = await _repository.fetchPosts(
        page: state.page,
        limit: _pageSize,
      );

      state = state.copyWith(
        status: FeedStatus.loaded,
        posts: <Post>[...state.posts, ...nextPosts],
        page: state.page + 1,
        hasMore: nextPosts.length == _pageSize,
      );
    } catch (_) {
      state = state.copyWith(
        status: FeedStatus.failure,
        errorMessage: 'Could not load more posts. Please try again.',
      );
    }
  }

  void toggleLike(String postId) {
    state = state.copyWith(
      posts: state.posts
          .map((Post post) {
            if (post.id != postId) {
              return post;
            }
            final bool nextLiked = !post.isLiked;
            return post.copyWith(
              isLiked: nextLiked,
              likeCount: nextLiked ? post.likeCount + 1 : post.likeCount - 1,
            );
          })
          .toList(growable: false),
    );
  }

  void toggleSave(String postId) {
    state = state.copyWith(
      posts: state.posts
          .map((Post post) {
            if (post.id != postId) {
              return post;
            }
            return post.copyWith(isSaved: !post.isSaved);
          })
          .toList(growable: false),
    );
  }
}
