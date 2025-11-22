import 'package:flutter_clean_posts_interview/domain/entities/post.dart';
import 'package:flutter_clean_posts_interview/domain/repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);

  Future<List<Post>> call() {
    return repository.getPosts();
  }
}
