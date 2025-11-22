import 'package:flutter_clean_posts_interview/domain/entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<List<Post>> searchPosts(String query);
}
