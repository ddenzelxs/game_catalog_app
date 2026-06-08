import 'dart:async';
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
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  int _selectedCategoryIndex = 0;

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'slug': ''},
    {'name': 'Action', 'slug': 'action'},
    {'name': 'RPG', 'slug': 'role-playing-games-rpg'},
    {'name': 'Adventure', 'slug': 'adventure'},
    {'name': 'Shooter', 'slug': 'shooter'},
    {'name': 'Strategy', 'slug': 'strategy'},
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(gameProvider.notifier).fetchGames();
    });

    _scrollController.addListener(() {
      final state = ref.read(gameProvider);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !state.isLoadingMore &&
          state.hasMore) {
        ref.read(gameProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
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

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "ArcadiaX",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1C24),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2B2D3B),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
                    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                      ref.read(gameProvider.notifier).fetchGames(
                        searchQuery: val,
                        genreSlug: _categories[_selectedCategoryIndex]['slug']!,
                      );
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search ...",
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 42,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,

                    itemBuilder: (context, index) {
                      final isSelected = _selectedCategoryIndex == index;
                      final category = _categories[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                          ref.read(gameProvider.notifier).fetchGames(
                            genreSlug: category['slug']!,
                            searchQuery: _searchController.text,
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(right: 8),

                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFF1B1C24),

                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: const Color(0xFF2B2D3B),
                                    width: 1,
                                  ),
                          ),

                          child: Center(
                            child: Text(
                              category['name']!,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount;
                      double childAspectRatio;

                      if (constraints.maxWidth < 600) {
                        crossAxisCount = 1;
                        childAspectRatio = 1.15;
                      } else if (constraints.maxWidth < 900) {
                        crossAxisCount = 2;
                        childAspectRatio = 1.15;
                      } else {
                        crossAxisCount = 3;
                        childAspectRatio = 1.15;
                      }


                      if (state.isLoading && state.games.isEmpty) {
                        return GridView.builder(
                          itemCount: crossAxisCount * 2,

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),

                          itemBuilder: (context, index) {
                            return const GameCardShimmer();
                          },
                        );
                      }


                      return GridView.builder(
                        controller: _scrollController,

                        itemCount:
                            state.games.length +
                            (state.isLoadingMore ? crossAxisCount : 0),

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,

                          childAspectRatio: childAspectRatio,

                          crossAxisSpacing: 12,

                          mainAxisSpacing: 12,
                        ),

                        itemBuilder: (context, index) {
                          if (index >= state.games.length) {
                            return const GameCardShimmer();
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
      ),
    );
  }
}
