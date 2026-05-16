import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

import '../providers/game_detail_provider.dart';

class DetailScreen extends ConsumerWidget {
  final int gameId;

  const DetailScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(gameDetailProvider(gameId));

    return Scaffold(
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (game) {
          return Stack(
            children: [
              // Background Image with Dark Overlay
              Container(
                color: const Color.fromRGBO(30, 30, 30, 1),
              ),
              Positioned.fill(
                child: Image.network(
                  game.backgroundImage,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.3),
                ),
              ),
              // Dark Overlay
              Positioned.fill(
                child: Container(
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
              // Content
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 400,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        game.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      background: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      color: const Color.fromRGBO(0, 0, 0, 0.8),
                                    ),
                                  ),
                                  Center(
                                    child: PhotoView(
                                      imageProvider: NetworkImage(
                                        game.backgroundImage,
                                      ),
                                      minScale:
                                          PhotoViewComputedScale.contained * 0.8,
                                      maxScale:
                                          PhotoViewComputedScale.covered * 2,
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'game_image_$gameId',
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(game.backgroundImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.zoom_in,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: const Color.fromRGBO(30, 30, 30, 1),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rating: ${game.rating}/5',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(200, 200, 200, 1),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            game.description ?? 'No description available',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(200, 200, 200, 1),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
