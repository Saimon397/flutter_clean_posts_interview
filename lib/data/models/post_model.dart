import 'package:flutter_clean_posts_interview/domain/entities/post.dart';

class PostModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'] is int
          ? json['userId'] as int
          : int.parse(json['userId'].toString()),
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }

  Post toEntity() {
    return Post(
      userId: userId,
      id: id,
      title: title,
      body: body,
    );
  }
}
