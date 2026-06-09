import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:game_catalog/features/wishlist/models/wishlist_item_model.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/core/services/hive_service.dart';
import 'package:game_catalog/features/games/providers/game_provider.dart';
import 'package:game_catalog/features/games/widgets/game_card.dart';
import 'package:game_catalog/features/auth/providers/auth_provider.dart';
import 'package:game_catalog/features/profile/utils/level_system.dart';
import 'package:game_catalog/features/profile/models/recently_viewed_item_model.dart';
import 'package:game_catalog/features/games/models/game_model.dart';
import 'package:game_catalog/features/games/models/added_by_status_model.dart';
import 'package:game_catalog/features/games/pages/detail_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // PROFILE BANNER & AVATAR
            // =========================
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                ),
                // Logout Button on top-right of banner
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Logout',
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF181A22),
                            title: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'Are you sure you want to log out?',
                              style: TextStyle(color: Color(0xFF9CA3AF)),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Color(0xFF9CA3AF)),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await ref.read(authProvider.notifier).logout();
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: -45,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0E12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0D0E12),
                        width: 4,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B1C24),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 55),

            // =========================
            // USER DETAILS (DYNAMIC)
            // =========================
            Center(
              child: profileAsync.when(
                data: (profile) {
                  final username = profile?['username'] ?? 'Gamer';
                  final email = profile?['email'] ?? 'No email';
                  final xp = profile?['xp'] as int? ?? 0;
                  final level = profile?['level'] as int? ?? 1;

                  final title = LevelSystem.getTitle(level);
                  final xpNeeded = LevelSystem.xpNeededForNextLevel(level);
                  final xpProgress = LevelSystem.xpProgressInCurrentLevel(xp);
                  final progressPct = (xpProgress / xpNeeded).clamp(0.0, 1.0);

                  return Column(
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Level Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(80)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.workspace_premium, color: Color(0xFFC084FC), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "Level $level - $title",
                              style: const TextStyle(
                                color: Color(0xFFC084FC),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // XP Progress Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "$xpProgress / $xpNeeded XP",
                                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                                ),
                                Text(
                                  "${(progressPct * 100).toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    color: Color(0xFF8B5CF6),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progressPct,
                                minHeight: 6,
                                backgroundColor: const Color(0xFF1B1C24),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox(
                  height: 45,
                  width: 45,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                  ),
                ),
                error: (err, stack) => const Text(
                  'Error loading profile details',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // STATISTICS ROW (DYNAMIC)
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ValueListenableBuilder(
                valueListenable: Hive.box<WishlistItem>(HiveService.wishlistBoxName).listenable(),
                builder: (context, Box<WishlistItem> wishlistBox, _) {
                  final wishlistCount = wishlistBox.length;

                  return ValueListenableBuilder(
                    valueListenable: Hive.box<CartItem>(HiveService.cartBoxName).listenable(),
                    builder: (context, Box<CartItem> cartBox, _) {
                      final libraryCount = cartBox.length;

                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF181A22),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF2B2D3B)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8B5CF6).withAlpha(30),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: Color(0xFF8B5CF6),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "$wishlistCount",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Wishlist",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF181A22),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF2B2D3B)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEC4899).withAlpha(30),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.sports_esports_outlined,
                                      color: Color(0xFFEC4899),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "$libraryCount",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Library",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // FAVORITE GAMES SECTION
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Favorite Games",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder(
                    valueListenable: Hive.box<WishlistItem>(HiveService.wishlistBoxName).listenable(),
                    builder: (context, Box<WishlistItem> wishlistBox, _) {
                      if (wishlistBox.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181A22),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF2B2D3B)),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(Icons.favorite_outline, color: Color(0xFF9CA3AF), size: 36),
                                SizedBox(height: 8),
                                Text(
                                  "No favorite games added yet",
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final wishlistItems = wishlistBox.values.toList();

                      return SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: wishlistItems.length,
                          itemBuilder: (context, index) {
                            final item = wishlistItems[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(gameId: item.gameId),
                                  ),
                                );
                              },
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF2B2D3B), width: 1),
                                  image: DecorationImage(
                                    image: NetworkImage(item.backgroundImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    // Gradient Overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withAlpha(204),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Rating badge
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.star, color: Colors.white, size: 10),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${item.rating}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Title
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Text(
                                        item.gameName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // RECENTLY VIEWED SECTION
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recently Viewed",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder(
                    valueListenable: HiveService.getRecentlyViewedBox().listenable(),
                    builder: (context, Box<RecentlyViewedItem> box, _) {
                      if (box.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181A22),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF2B2D3B)),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(Icons.history, color: Color(0xFF9CA3AF), size: 36),
                                SizedBox(height: 8),
                                Text(
                                  "No recently viewed games yet",
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Get items sorted by viewedAt descending (limit to 3 max)
                      final items = box.values.toList();
                      items.sort((a, b) => b.viewedAt.compareTo(a.viewedAt));
                      final displayedItems = items.take(3).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayedItems.length,
                        itemBuilder: (context, index) {
                          final item = displayedItems[index];

                          // Find match in current catalog page if available
                          final game = gameState.games.firstWhere(
                            (g) => g.id == item.gameId,
                            orElse: () => Game(
                              id: item.gameId,
                              slug: '',
                              name: item.gameName,
                              released: '',
                              tba: false,
                              backgroundImage: item.backgroundImage,
                              rating: item.rating,
                              ratingTop: 0,
                              ratingsCount: 0,
                              reviewsCount: 0,
                              added: 0,
                              metacritic: 0,
                              playtime: 0,
                              suggestionsCount: 0,
                              updated: '',
                              saturatedColor: '',
                              dominantColor: '',
                              ratings: [],
                              addedByStatus: AddedByStatus(
                                yet: 0,
                                owned: 0,
                                beaten: 0,
                                toplay: 0,
                                dropped: 0,
                                playing: 0,
                              ),
                              platforms: [],
                              genres: [],
                              stores: [],
                              tags: [],
                              shortScreenshots: [],
                            ),
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            height: 250, // fits childAspectRatio 1.15
                            child: GameCard(game: game),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}