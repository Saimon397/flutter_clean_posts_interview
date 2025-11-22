abstract class PostListEvent {}

class LoadInitialPosts extends PostListEvent {}

class LoadMorePosts extends PostListEvent {}

class SearchPostsEvent extends PostListEvent {
  final String query;
  SearchPostsEvent(this.query);
}

class ClearSearch extends PostListEvent {}
