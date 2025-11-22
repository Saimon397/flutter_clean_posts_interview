// data/datasources/post_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_clean_posts_interview/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts(int page, {int limit = 10});
  Future<List<PostModel>> searchPosts(String query, int page, {int limit = 10});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio client;

  const PostRemoteDataSourceImpl(this.client);

  @override
  Future<List<PostModel>> getPosts(int page, {int limit = 10}) async {
    final response = await client.get(
      '/posts',
      queryParameters: {
        '_page': page,
        '_limit': limit,
      },
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Errore ${response.statusCode} nel caricamento dei post');
    }

    return (response.data as List)
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PostModel>> searchPosts(
    String query,
    int page, {
    int limit = 10,
  }) async {
    final response = await client.get(
      '/posts',
      queryParameters: {
        'q': query,
        '_page': page,
        '_limit': limit,
      },
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Errore ${response.statusCode} nella ricerca dei post');
    }

    return (response.data as List)
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
