import 'package:flutter_clean_posts_interview/domain/entities/post.dart';

enum PostListStatus { initial, loading, success, failure, empty }

class PostListState {
  final PostListStatus status;
  final List<Post> posts;
  final bool hasMore;
  final String? searchQuery;

  PostListState({
    required this.status,
    required this.posts,
    required this.hasMore,
    this.searchQuery,
  });

  factory PostListState.initial() => PostListState(
    status: PostListStatus.initial,
    posts: const [],
    hasMore: true,
  );

  PostListState copyWith({
    PostListStatus? status,
    List<Post>? posts,
    bool? hasMore,
    String? searchQuery,
  }) {
    return PostListState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
