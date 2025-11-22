import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_event.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_state.dart';
import 'package:flutter_clean_posts_interview/domain/entities/post.dart';
import 'package:flutter_clean_posts_interview/domain/usecases/get_posts.dart';
import 'package:flutter_clean_posts_interview/domain/usecases/search_posts.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final GetPosts getPostsUseCase;
  final SearchPosts searchPostsUseCase;

  static const int _pageSize = 10;

  List<Post> _allPosts = [];
  int _currentIndex = 0;
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

    _isLoadingMore = false;
    _currentIndex = 0;

    try {
      _allPosts = await getPostsUseCase();

      if (_allPosts.isEmpty) {
        emit(
          state.copyWith(
            status: PostListStatus.empty,
            posts: [],
            hasMore: false,
          ),
        );
        return;
      }

      final end = _allPosts.length < _pageSize ? _allPosts.length : _pageSize;
      final firstChunk = _allPosts.sublist(0, end);
      _currentIndex = end;

      emit(
        state.copyWith(
          status: PostListStatus.success,
          posts: firstChunk,
          hasMore: _currentIndex < _allPosts.length,
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

    try {
      if (_currentIndex >= _allPosts.length) {
        emit(state.copyWith(hasMore: false));
        return;
      }

      final nextEnd = (_currentIndex + _pageSize) > _allPosts.length
          ? _allPosts.length
          : (_currentIndex + _pageSize);

      final nextChunk = _allPosts.sublist(_currentIndex, nextEnd);
      _currentIndex = nextEnd;

      emit(
        state.copyWith(
          posts: [...state.posts, ...nextChunk],
          hasMore: _currentIndex < _allPosts.length,
        ),
      );
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

    _isLoadingMore = false;
    _currentIndex = 0;

    try {
      _allPosts = await searchPostsUseCase(event.query);

      if (_allPosts.isEmpty) {
        emit(
          state.copyWith(
            status: PostListStatus.empty,
            posts: [],
            hasMore: false,
          ),
        );
        return;
      }

      final end = _allPosts.length < _pageSize ? _allPosts.length : _pageSize;
      final firstChunk = _allPosts.sublist(0, end);
      _currentIndex = end;

      emit(
        state.copyWith(
          status: PostListStatus.success,
          posts: firstChunk,
          hasMore: _currentIndex < _allPosts.length,
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
