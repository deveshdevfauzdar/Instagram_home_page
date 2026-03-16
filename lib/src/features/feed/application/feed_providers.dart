import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/fake_post_repository.dart';
import '../domain/repositories/post_repository.dart';
import 'feed_notifier.dart';
import 'feed_state.dart';

final postRepositoryProvider = Provider<PostRepository>((Ref ref) {
  return FakePostRepository();
});

final feedNotifierProvider = NotifierProvider<FeedNotifier, FeedState>(
  FeedNotifier.new,
);
