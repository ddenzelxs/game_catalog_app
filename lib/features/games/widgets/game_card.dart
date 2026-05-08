import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game_model.dart';
import '../../../core/utils/image_utils.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailScreen(game: game),
        //   ),
        // );
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "${game.rating}",
                    style: const TextStyle(fontSize: 12, color: Colors.amber),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
