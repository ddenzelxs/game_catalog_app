import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';
import '../widgets/game_card_shimmer.dart';
import '../../auth/pages/login_screen.dart';
import '../../auth/pages/register_screen.dart';
import '../../auth/providers/auth_provider.dart';

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
    final currentUser = ref.watch(currentUserProvider);
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(gameProvider.notifier).fetchGames();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ArcadiaX",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(59, 59, 59, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  // controller: searchController,
                                  // onChanged: searchProducts,
                                  decoration: InputDecoration(
                                    hintText: "Search games...",
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(200, 200, 200, 1),
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ======= Auth =====
                      const SizedBox(width: 20),
                      // Conditional Navigation
                      currentUser.when(
                        data: (user) {
                          if (user != null) {
                            // User is logged in
                            return userProfile.when(
                              data: (profile) {
                                final username = profile?['username'] ?? 'User';
                                return Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(59, 59, 59, 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        username,
                                        style: const TextStyle(
                                          color: Color.fromRGBO(200, 200, 200, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Color.fromRGBO(
                                              40,
                                              40,
                                              40,
                                              1,
                                            ),
                                            title: const Text(
                                              'Log Out',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to log out?',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                  200,
                                                  200,
                                                  200,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await ref
                                                      .read(authProvider.notifier)
                                                      .logout();
                                                },
                                                child: const Text(
                                                  'Log Out',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(59, 59, 59, 1),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: const Icon(
                                          Icons.logout,
                                          color: Color.fromRGBO(200, 200, 200, 1),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              loading: () => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(59, 59, 59, 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              error: (error, stack) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(59, 59, 59, 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  'User',
                                  style: TextStyle(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(59, 59, 59, 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      "LOG IN",
                                      style: TextStyle(
                                        color: Color.fromRGBO(200, 200, 200, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(59, 59, 59, 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Color.fromRGBO(200, 200, 200, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                        loading: () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(59, 59, 59, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        error: (error, stack) => Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(59, 59, 59, 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(59, 59, 59, 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ======= Auth =====
                    ],
                  ),
                ),
            
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      late int crossAxisCount;
            
                      if (constraints.maxWidth < 600) {
                        crossAxisCount = 1;
                      } else {
                        const itemWidth = 180;
            
                        crossAxisCount = (constraints.maxWidth / itemWidth)
                            .floor()
                            .clamp(2, 6);
                      }
            
                      if (state.isLoading) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: crossAxisCount * 2,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 1,
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
                        itemCount: state.hasMore
                            ? state.games.length + crossAxisCount
                            : state.games.length,
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
      ),
    );
  }
}
