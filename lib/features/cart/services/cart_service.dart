import 'package:hive/hive.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/core/services/hive_service.dart';

class CartService {
  late Box<CartItem> _cartBox;

  CartService() {
    _cartBox = HiveService.getCartBox();
  }

  /// Add item to cart
  Future<void> addToCart(CartItem item) async {
    try {
      final existingKey = _findItemKey(item.gameId);
      if (existingKey != null) {
        return;
      }
      await _cartBox.add(item);
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(int gameId) async {
    try {
      final key = _findItemKey(gameId);
      if (key != null) {
        await _cartBox.delete(key);
      }
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  List<CartItem> getAllCartItems() {
    try {
      return _cartBox.values.toList();
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartBox.clear();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  bool isInCart(int gameId) {
    return _findItemKey(gameId) != null;
  }

  int getCartItemCount() {
    return _cartBox.length;
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in _cartBox.values) {
      total += item.price;
    }
    return total;
  }

  dynamic _findItemKey(int gameId) {
    for (var key in _cartBox.keys) {
      if (_cartBox.get(key)?.gameId == gameId) {
        return key;
      }
    }
    return null;
  }
}
