import 'package:dio/dio.dart';
import 'package:flutter_clean_posts_interview/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<List<PostModel>> searchPosts(String query);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio client;

  const PostRemoteDataSourceImpl(this.client);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await client.get('/posts');

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Errore ${response.statusCode} nel caricamento dei post');
    }

    final data = response.data;
    if (data is! List) {
      throw Exception('Formato risposta non valido');
    }

    return data
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PostModel>> searchPosts(String query) async {
    final response = await client.get('/posts', queryParameters: {'q': query});

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Errore ${response.statusCode} nella ricerca dei post');
    }

    final data = response.data;
    if (data is! List) {
      throw Exception('Formato risposta non valido');
    }

    return data
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
