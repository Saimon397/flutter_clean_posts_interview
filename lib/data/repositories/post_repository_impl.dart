import 'package:flutter_clean_posts_interview/data/datasources/post_remote_data_source.dart';
import 'package:flutter_clean_posts_interview/data/models/post_model.dart';
import 'package:flutter_clean_posts_interview/domain/entities/post.dart';
import 'package:flutter_clean_posts_interview/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts() async {
    final List<PostModel> models = await remoteDataSource.getPosts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Post>> searchPosts(String query) async {
    final List<PostModel> models = await remoteDataSource.searchPosts(query);
    return models.map((m) => m.toEntity()).toList();
  }
}
