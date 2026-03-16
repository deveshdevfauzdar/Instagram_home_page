import '../models/post.dart';
import '../models/story.dart';

abstract class PostRepository {
  Future<List<Post>> fetchPosts({required int page, required int limit});
  Future<List<Story>> fetchStories();
}
