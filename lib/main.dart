import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_bloc.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_event.dart';
import 'package:flutter_clean_posts_interview/routes/app_router.dart';
import 'package:flutter_clean_posts_interview/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inizializza get_it
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostListBloc>()..add(LoadInitialPosts()),
      child: MaterialApp.router(
        title: 'Flutter Clean Posts',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
