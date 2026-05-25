import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game_model.dart';
import '../../../core/utils/image_utils.dart';
import '../pages/detail_screen.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

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
          color: Colors.grey[900],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: ImageUtils.getResizedImage(
                    game.backgroundImage,
                    width: 600,
                  ),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  memCacheWidth: 600,
                  maxWidthDiskCache: 600,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[800]),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                game.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${game.rating}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      game.platforms.isNotEmpty
                          ? game.platforms.first.platform.name
                          : "Unknown",
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: game.genres.map((genre) {
                return Chip(
                  label: Text(
                    genre.name,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: Colors.blueGrey[700],
                );
              }).toList(),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
