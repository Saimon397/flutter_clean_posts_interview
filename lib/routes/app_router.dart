import 'package:flutter_clean_posts_interview/domain/entities/post.dart';
import 'package:flutter_clean_posts_interview/presentation/posts/pages/post_detail_page.dart';
import 'package:flutter_clean_posts_interview/presentation/posts/pages/posts_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'posts',
      builder: (context, state) => const PostsPage(),
    ),
    GoRoute(
      path: '/post/:id',
      name: 'postDetail',
      builder: (context, state) {
        final post = state.extra as Post;
        return PostDetailPage(post: post);
      },
    ),
  ],
);