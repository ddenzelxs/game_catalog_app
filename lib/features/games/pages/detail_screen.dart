import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:game_catalog/features/games/providers/game_detail_provider.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/features/cart/services/cart_service.dart';
import 'package:game_catalog/features/wishlist/models/wishlist_item_model.dart';
import 'package:game_catalog/features/wishlist/services/wishlist_service.dart';
import 'package:game_catalog/core/services/hive_service.dart';

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
              Container(
                color: const Color(0xFF0D0E12),
              ),
              Positioned.fill(
                child: Image.network(
                  game.backgroundImage,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.3),
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withAlpha(128),
                ),
              ),
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
                                      color: Colors.black.withAlpha(204),
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
                                          color: Colors.black.withAlpha(128),
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
                                  color: Colors.black.withAlpha(77),
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
                      color: const Color(0xFF0D0E12),
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
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _ActionButtons(gameId: gameId, game: game),
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
                            game.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9CA3AF),
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

class _ActionButtons extends StatefulWidget {
  final int gameId;
  final dynamic game;

  const _ActionButtons({
    required this.gameId,
    required this.game,
  });

  @override
  State<_ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<_ActionButtons> {
  late CartService _cartService;
  late WishlistService _wishlistService;

  @override
  void initState() {
    super.initState();
    _cartService = CartService();
    _wishlistService = WishlistService();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<CartItem>(HiveService.cartBoxName).listenable(),
      builder: (context, Box<CartItem> cartBox, _) {
        final isInCart = _cartService.isInCart(widget.gameId);

        return ValueListenableBuilder(
          valueListenable: Hive.box<WishlistItem>(HiveService.wishlistBoxName).listenable(),
          builder: (context, Box<WishlistItem> wishlistBox, _) {
            final isInWishlist = _wishlistService.isInWishlist(widget.gameId);

            return Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isInCart
                        ? () {
                            _cartService.removeFromCart(widget.gameId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Removed from cart')),
                            );
                          }
                        : () {
                            final cartItem = CartItem(
                              gameId: widget.gameId,
                              gameName: widget.game.name,
                              backgroundImage: widget.game.backgroundImage,
                              price: 19.99,
                              rating: widget.game.rating,
                              addedAt: DateTime.now(),
                            );
                            _cartService.addToCart(cartItem);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart')),
                            );
                          },
                    icon: Icon(isInCart ? Icons.remove : Icons.add),
                    label: Text(isInCart ? 'Remove' : 'Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart ? Colors.red : Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isInWishlist
                        ? () {
                            _wishlistService.removeFromWishlist(widget.gameId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Removed from wishlist')),
                            );
                          }
                        : () {
                            final wishlistItem = WishlistItem(
                              gameId: widget.gameId,
                              gameName: widget.game.name,
                              backgroundImage: widget.game.backgroundImage,
                              rating: widget.game.rating,
                              addedAt: DateTime.now(),
                            );
                            _wishlistService.addToWishlist(wishlistItem);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to wishlist')),
                            );
                          },
                    icon: Icon(isInWishlist ? Icons.favorite : Icons.favorite_outline),
                    label: Text(isInWishlist ? 'Remove' : 'Wishlist'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInWishlist ? Colors.red : const Color(0xFF1B1C24),
                      foregroundColor: Colors.white,
                      side: isInWishlist ? null : const BorderSide(color: Color(0xFF2B2D3B), width: 1),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
