import 'package:flutter_clean_posts_interview/data/datasources/post_remote_data_source.dart';
import 'package:flutter_clean_posts_interview/domain/entities/post.dart';
import 'package:flutter_clean_posts_interview/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts(int page, {int limit = 10}) async {
    final models = await remoteDataSource.getPosts(page, limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Post>> searchPosts(
    String query,
    int page, {
    int limit = 10,
  }) async {
    final models = await remoteDataSource.searchPosts(query, page, limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }
}
