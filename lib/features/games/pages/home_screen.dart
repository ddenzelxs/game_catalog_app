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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    late int crossAxisCount;

                    // HP
                    if (constraints.maxWidth < 600) {
                      crossAxisCount = 1;
                    }
                    // TABLET / WEB / DESKTOP
                    else {
                      const itemWidth = 180;

                      crossAxisCount = (constraints.maxWidth / itemWidth)
                          .floor()
                          .clamp(2, 6);
                    }

                    if (state.isLoading) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: 6,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return const GameCardShimmer();
                        },
                      );
                    }

                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount:
                          state.games.length + (state.isLoadingMore ? 1 : 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1,
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
                    );
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
