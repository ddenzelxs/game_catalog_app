import 'package:hive/hive.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/features/wishlist/models/wishlist_item_model.dart';

class HiveService {
  static const String cartBoxName = 'cart';
  static const String wishlistBoxName = 'wishlist';

  static Future<void> initHive() async {
    try {
      // Register Hive adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(CartItemAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(WishlistItemAdapter());
      }

      // Open boxes
      await Hive.openBox<CartItem>(cartBoxName);
      await Hive.openBox<WishlistItem>(wishlistBoxName);
    } catch (e) {
      print('Error initializing Hive: $e');
    }
  }

  static Box<CartItem> getCartBox() {
    return Hive.box<CartItem>(cartBoxName);
  }

  static Box<WishlistItem> getWishlistBox() {
    return Hive.box<WishlistItem>(wishlistBoxName);
  }
}
