import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_bloc.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_event.dart';
import 'package:flutter_clean_posts_interview/blocs/posts/post_list_state.dart';
import 'package:flutter_clean_posts_interview/presentation/posts/widgets/search_bar.dart';
import '../widgets/post_card.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() {
        // forza rebuild per far comparire/sparire la X nella search bar
        setState(() {});
      });
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<PostListBloc>().add(LoadInitialPosts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      context.read<PostListBloc>().add(LoadMorePosts());
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) {
      context.read<PostListBloc>().add(ClearSearch());
      return;
    }
    context.read<PostListBloc>().add(SearchPostsEvent(query.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        title: const Text(
          'Posts',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            // ignore: deprecated_member_use
            color: colorScheme.outlineVariant.withOpacity(0.4),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<PostListBloc, PostListState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PostListStatus.loading:
                      if (state.posts.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _buildList(state, isLoadingMore: true);

                    case PostListStatus.empty:
                      return const Center(child: Text('Nessun post trovato'));

                    case PostListStatus.failure:
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Si è verificato un errore'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                context.read<PostListBloc>().add(
                                  LoadInitialPosts(),
                                );
                              },
                              child: const Text('Riprova'),
                            ),
                          ],
                        ),
                      );

                    case PostListStatus.initial:
                    case PostListStatus.success:
                      return _buildList(state);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return BlocBuilder<PostListBloc, PostListState>(
      builder: (context, state) {
        final isSearching =
            state.searchQuery != null &&
            state.searchQuery!.isNotEmpty &&
            state.status == PostListStatus.loading;

        return PostSearchBar(
          controller: _searchController,
          isLoading: isSearching,
          onSearch: _onSearchSubmitted,
          onClear: () {
            _searchController.clear();
            context.read<PostListBloc>().add(ClearSearch());
          },
        );
      },
    );
  }

  Widget _buildList(PostListState state, {bool isLoadingMore = false}) {
    final posts = state.posts;
    final showBottomLoader = state.hasMore || isLoadingMore;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostListBloc>().add(LoadInitialPosts());
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: posts.length + (showBottomLoader ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= posts.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          final post = posts[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: PostCard(post: post),
          );
        },
      ),
    );
  }
}
