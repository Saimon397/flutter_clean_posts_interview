import 'package:flutter_clean_posts_interview/domain/entities/post.dart';
import 'package:flutter_clean_posts_interview/domain/repositories/post_repository.dart';

class SearchPosts {
  final PostRepository repository;

  SearchPosts(this.repository);

  Future<List<Post>> call(String query, {required int page, int limit = 10}) {
    return repository.searchPosts(query, page, limit: limit);
  }
}

