import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_clean_posts_interview/data/datasources/post_remote_data_source.dart';
import 'package:flutter_clean_posts_interview/data/repositories/post_repository_impl.dart';
import 'package:flutter_clean_posts_interview/domain/repositories/post_repository.dart';
import 'package:flutter_clean_posts_interview/domain/usecases/get_posts.dart';
import 'package:flutter_clean_posts_interview/domain/usecases/search_posts.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_bloc.dart';
import 'package:flutter_clean_posts_interview/utilities/auth_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 🔹 Dio client
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        contentType: 'application/json',
        headers: const {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Flutter Dio Client)', // non gli piaceva lo user agentn mi tornava 403 quindi lo messo tipo browser
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    ),
  );

  // 🔹 Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(sl<Dio>()),
  );

  // 🔹 Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(sl<PostRemoteDataSource>()),
  );

  // 🔹 Use cases
  sl.registerLazySingleton<GetPosts>(
    () => GetPosts(sl<PostRepository>()),
  );

  sl.registerLazySingleton<SearchPosts>(
    () => SearchPosts(sl<PostRepository>()),
  );

  // 🔹 Services
  sl.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  // 🔹 BLoC
  sl.registerFactory<PostListBloc>(
    () => PostListBloc(
      getPostsUseCase: sl<GetPosts>(),
      searchPostsUseCase: sl<SearchPosts>(),
    ),
  );
}
