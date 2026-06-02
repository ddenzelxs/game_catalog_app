import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_model.dart';
import '../models/platform_element_model.dart';
import '../../../core/utils/image_utils.dart';
import '../pages/detail_screen.dart';
import '../../wishlist/models/wishlist_item_model.dart';
import '../../wishlist/services/wishlist_service.dart';
import '../../../core/services/hive_service.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  Widget _buildPlatformIcons(List<PlatformElement> platforms) {
    bool hasPC = false;
    bool hasConsole = false;

    for (var p in platforms) {
      final slug = p.platform.slug.toLowerCase();
      if (slug.contains('pc')) {
        hasPC = true;
      } else if (slug.contains('playstation') ||
          slug.contains('xbox') ||
          slug.contains('nintendo') ||
          slug.contains('switch')) {
        hasConsole = true;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasPC)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.monitor, color: Color(0xFF9CA3AF), size: 16),
          ),
        if (hasConsole)
          const Icon(Icons.sports_esports, color: Color(0xFF9CA3AF), size: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(gameId: game.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF181A22),
          border: Border.all(
            color: const Color(0xFF2B2D3B),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: ImageUtils.getResizedImage(
                        game.backgroundImage,
                        width: 600,
                      ),
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: const Color(0xFF13151D)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                  // Badge di sudut kiri atas (Metacritic Score)
                  if (game.metacritic > 0)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${game.metacritic}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  // Wishlist icon di sudut kanan atas
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box<WishlistItem>(HiveService.wishlistBoxName).listenable(),
                      builder: (context, Box<WishlistItem> box, _) {
                        final wishlistService = WishlistService();
                        final isInWishlist = wishlistService.isInWishlist(game.id);

                        return GestureDetector(
                          onTap: () async {
                            if (isInWishlist) {
                              await wishlistService.removeFromWishlist(game.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Removed from wishlist'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } else {
                              final wishlistItem = WishlistItem(
                                gameId: game.id,
                                gameName: game.name,
                                backgroundImage: game.backgroundImage,
                                rating: game.rating,
                                addedAt: DateTime.now(),
                              );
                              await wishlistService.addToWishlist(wishlistItem);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to wishlist'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(120),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isInWishlist ? Icons.favorite : Icons.favorite_border,
                              color: isInWishlist ? Colors.red : Colors.white,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${game.rating}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildPlatformIcons(game.platforms),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: game.genres.take(2).map((genre) {
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B1C24),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFF2B2D3B),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                genre.name,
                                style: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const Text(
                        '\$19.99',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
