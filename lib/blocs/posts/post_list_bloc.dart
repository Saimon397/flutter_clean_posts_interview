import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_event.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_state.dart';
import 'package:flutter_clean_posts_interview/domain/usecases/get_posts.dart';
import 'package:flutter_clean_posts_interview/domain/usecases/search_posts.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final GetPosts getPostsUseCase;
  final SearchPosts searchPostsUseCase;

  static const int _pageSize = 10;
  int _page = 1;
  bool _isLoadingMore = false;

  PostListBloc({
    required this.getPostsUseCase,
    required this.searchPostsUseCase,
  }) : super(PostListState.initial()) {
    on<LoadInitialPosts>(_onLoadInitial);
    on<LoadMorePosts>(_onLoadMore);
    on<SearchPostsEvent>(_onSearch);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadInitial(
    LoadInitialPosts event,
    Emitter<PostListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PostListStatus.loading,
        posts: [],
        hasMore: true,
        searchQuery: null,
      ),
    );

    _page = 1;
    _isLoadingMore = false;

    try {
      final posts = await getPostsUseCase(page: _page, limit: _pageSize);

      emit(
        state.copyWith(
          status:
              posts.isEmpty ? PostListStatus.empty : PostListStatus.success,
          posts: posts,
          hasMore: posts.length == _pageSize,
          searchQuery: null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostListStatus.failure));
    }
  }

  Future<void> _onLoadMore(
    LoadMorePosts event,
    Emitter<PostListState> emit,
  ) async {
    if (_isLoadingMore || !state.hasMore) return;

    _isLoadingMore = true;
    _page++;

    try {
      final more = state.searchQuery == null
          ? await getPostsUseCase(page: _page, limit: _pageSize)
          : await searchPostsUseCase(
              state.searchQuery!,
              page: _page,
              limit: _pageSize,
            );

      emit(
        state.copyWith(
          posts: [...state.posts, ...more],
          hasMore: more.length == _pageSize,
        ),
      );
    } catch (_) {
      // se errore durante loadMore, NON rompiamo lo stato attuale
      emit(state.copyWith(hasMore: false));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> _onSearch(
    SearchPostsEvent event,
    Emitter<PostListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PostListStatus.loading,
        posts: [],
        hasMore: true,
        searchQuery: event.query,
      ),
    );

    _page = 1;
    _isLoadingMore = false;

    try {
      final results = await searchPostsUseCase(
        event.query,
        page: _page,
        limit: _pageSize,
      );

      emit(
        state.copyWith(
          status:
              results.isEmpty ? PostListStatus.empty : PostListStatus.success,
          posts: results,
          hasMore: results.length == _pageSize,
          searchQuery: event.query,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostListStatus.failure));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<PostListState> emit) {
    add(LoadInitialPosts());
  }
}
