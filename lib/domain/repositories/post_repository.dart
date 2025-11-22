import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts(int page, {int limit = 10});
  Future<List<Post>> searchPosts(String query, int page, {int limit = 10});
}

