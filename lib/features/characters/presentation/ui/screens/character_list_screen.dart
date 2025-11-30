import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/theme/colors.dart';
import '../../../../../core/ui/widgets/character_card_skeleton.dart';
import '../../../../../injection_container.dart';
import '../../bloc/character_list/character_list_bloc.dart';
import '../../bloc/character_list/character_list_event.dart';
import '../../bloc/character_list/character_list_state.dart';
import '../widgets/list/character_list_loaded_view.dart';
import '../widgets/error_view.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CharacterListBloc>()
        ..add(const LoadCharacters()),
      child: const _CharacterListView(),
    );
  }
}

class _CharacterListView extends StatefulWidget {
  const _CharacterListView();

  @override
  State<_CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<_CharacterListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const scrollLoadMoreThreshold = 0.8; // Load more when 80% scrolled
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * scrollLoadMoreThreshold) {
      context.read<CharacterListBloc>().add(const LoadMoreCharacters());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        title: Image.asset(
          'assets/images/logo.png',
          height: 80,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                AppColors.orange.withValues(alpha: 0.1),
                Colors.black,
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<CharacterListBloc, CharacterListState>(
            builder: (context, state) {
              return switch (state) {
                CharacterListInitial() => const SizedBox.shrink(),
                CharacterListLoading() => ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 8,
                      bottom: 24,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const CharacterCardSkeleton(),
                  ),
                CharacterListError() => ErrorView(
                    title: 'Error loading characters',
                    message: state.message,
                    onRetry: () => context
                        .read<CharacterListBloc>()
                        .add(const LoadCharacters()),
                  ),
                CharacterListLoaded() => CharacterListLoadedView(
                    characters: state.characters,
                    isLoadingMore: state.isLoadingMore,
                    scrollController: _scrollController,
                    onRefresh: () async {
                      context.read<CharacterListBloc>().add(const RefreshCharacters());
                      // Wait for the refresh to complete
                      await context.read<CharacterListBloc>().stream.firstWhere(
                            (state) => state is! CharacterListLoading,
                          );
                    },
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}

