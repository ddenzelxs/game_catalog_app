import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:game_catalog/features/wishlist/models/wishlist_item_model.dart';
import 'package:game_catalog/features/wishlist/services/wishlist_service.dart';
import 'package:game_catalog/core/services/hive_service.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/features/cart/services/cart_service.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late WishlistService _wishlistService;
  late CartService _cartService;

  @override
  void initState() {
    super.initState();
    _wishlistService = WishlistService();
    _cartService = CartService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        elevation: 0,
        backgroundColor: Colors.grey[900],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<WishlistItem>(HiveService.wishlistBoxName).listenable(),
        builder: (context, Box<WishlistItem> wishlistBox, _) {
          if (wishlistBox.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Wishlist is Empty',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          final wishlistItems = wishlistBox.values.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              return WishlistItemCard(
                item: item,
                onRemove: () async {
                  await _wishlistService.removeFromWishlist(item.gameId);
                },
                onAddToCart: () async {
                  final cartItem = CartItem(
                    gameId: item.gameId,
                    gameName: item.gameName,
                    backgroundImage: item.backgroundImage,
                    price: 29.99, // dummy
                    rating: item.rating,
                    addedAt: DateTime.now(),
                  );
                  await _cartService.addToCart(cartItem);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.backgroundImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[700],
                      child: const Icon(Icons.broken_image),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.gameName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.shopping_cart, size: 16),
                          label: const Text('Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: onRemove,
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