import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';
import '../widgets/game_card_shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(gameProvider.notifier).fetchGames();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        ref.read(gameProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("ArcadiaX")),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(gameProvider.notifier).fetchGames();
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Welcome to ArcadiaX!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: state.isLoading
                    ? GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: 6,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          return const GameCardShimmer();
                        },
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount:
                            state.games.length + (state.isLoadingMore ? 1 : 0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          if (index >= state.games.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final game = state.games[index];

                          return GameCard(game: game);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
