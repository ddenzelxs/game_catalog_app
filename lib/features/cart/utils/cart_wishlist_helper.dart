import 'package:flutter/material.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/features/wishlist/models/wishlist_item_model.dart';
import 'package:game_catalog/features/cart/services/cart_service.dart';
import 'package:game_catalog/features/wishlist/services/wishlist_service.dart';

class CartWishlistHelper {
  static Future<void> addGameToCart({
    required int gameId,
    required String gameName,
    required String backgroundImage,
    required double rating,
    required BuildContext context,
    double price = 29.99,
  }) async {
    try {
      final cartService = CartService();
      final cartItem = CartItem(
        gameId: gameId,
        gameName: gameName,
        backgroundImage: backgroundImage,
        price: price,
        rating: rating,
        addedAt: DateTime.now(),
      );
      await cartService.addToCart(cartItem);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to cart'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  static Future<void> addGameToWishlist({
    required int gameId,
    required String gameName,
    required String backgroundImage,
    required double rating,
    required BuildContext context,
  }) async {
    try {
      final wishlistService = WishlistService();
      final wishlistItem = WishlistItem(
        gameId: gameId,
        gameName: gameName,
        backgroundImage: backgroundImage,
        rating: rating,
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
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  static Future<void> removeFromCart({
    required int gameId,
    required BuildContext context,
  }) async {
    try {
      final cartService = CartService();
      await cartService.removeFromCart(gameId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from cart'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  static Future<void> removeFromWishlist({
    required int gameId,
    required BuildContext context,
  }) async {
    try {
      final wishlistService = WishlistService();
      await wishlistService.removeFromWishlist(gameId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from wishlist'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }
}
