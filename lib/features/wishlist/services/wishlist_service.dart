import 'package:hive/hive.dart';
import 'package:game_catalog/features/wishlist/models/wishlist_item_model.dart';
import 'package:game_catalog/core/services/hive_service.dart';
import 'package:game_catalog/core/services/sync_service.dart';

class WishlistService {
  late Box<WishlistItem> _wishlistBox;

  WishlistService() {
    _wishlistBox = HiveService.getWishlistBox();
  }

  Future<void> addToWishlist(WishlistItem item) async {
    try {
      final existingKey = _findItemKey(item.gameId);
      if (existingKey != null) {
        return;
      }
      await _wishlistBox.add(item);
      await SyncService.syncWishlistToCloud(item);
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(int gameId) async {
    try {
      final key = _findItemKey(gameId);
      if (key != null) {
        await _wishlistBox.delete(key);
        await SyncService.deleteWishlistFromCloud(gameId);
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }

  List<WishlistItem> getAllWishlistItems() {
    try {
      return _wishlistBox.values.toList();
    } catch (e) {
      print('Error getting wishlist items: $e');
      return [];
    }
  }

  Future<void> clearWishlist() async {
    try {
      await _wishlistBox.clear();
    } catch (e) {
      print('Error clearing wishlist: $e');
    }
  }

  bool isInWishlist(int gameId) {
    return _findItemKey(gameId) != null;
  }

  int getWishlistItemCount() {
    return _wishlistBox.length;
  }

  dynamic _findItemKey(int gameId) {
    for (var key in _wishlistBox.keys) {
      if (_wishlistBox.get(key)?.gameId == gameId) {
        return key;
      }
    }
    return null;
  }
}
