import 'package:hive/hive.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/features/wishlist/models/wishlist_item_model.dart';
import 'package:game_catalog/features/recommendation/models/recommendation_result_model.dart';
import 'package:game_catalog/features/recommendation/models/recommendation_history_model.dart';
import 'package:game_catalog/features/profile/models/recently_viewed_item_model.dart';

class HiveService {
  static const String cartBoxName = 'cart';
  static const String wishlistBoxName = 'wishlist';
  static const String aiHistoryBoxName = 'ai_history';
  static const String recentlyViewedBoxName = 'recently_viewed';

  static Future<void> initHive() async {
    try {
      // Register Hive adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(CartItemAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(WishlistItemAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(RecommendationResultAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(RecommendationHistoryAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(RecentlyViewedItemAdapter());
      }

      // Open boxes
      await Hive.openBox<CartItem>(cartBoxName);
      await Hive.openBox<WishlistItem>(wishlistBoxName);
      await Hive.openBox<RecommendationHistory>(aiHistoryBoxName);
      await Hive.openBox<RecentlyViewedItem>(recentlyViewedBoxName);
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

  static Box<RecommendationHistory> getAiHistoryBox() {
    return Hive.box<RecommendationHistory>(aiHistoryBoxName);
  }

  static Box<RecentlyViewedItem> getRecentlyViewedBox() {
    return Hive.box<RecentlyViewedItem>(recentlyViewedBoxName);
  }
}
