import '../domain/models/post.dart';
import '../domain/models/story.dart';

enum FeedStatus { initialLoading, loaded, loadingMore, failure }

class FeedState {
  const FeedState({
    required this.status,
    required this.posts,
    required this.stories,
    required this.page,
    required this.hasMore,
    required this.errorMessage,
  });

  factory FeedState.initial() {
    return const FeedState(
      status: FeedStatus.initialLoading,
      posts: <Post>[],
      stories: <Story>[],
      page: 0,
      hasMore: true,
      errorMessage: null,
    );
  }

  final FeedStatus status;
  final List<Post> posts;
  final List<Story> stories;
  final int page;
  final bool hasMore;
  final String? errorMessage;

  bool get isInitialLoading => status == FeedStatus.initialLoading;
  bool get isLoadingMore => status == FeedStatus.loadingMore;

  FeedState copyWith({
    FeedStatus? status,
    List<Post>? posts,
    List<Story>? stories,
    int? page,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      stories: stories ?? this.stories,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
