import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/recently_viewed_item_model.dart';

class RecentlyViewedService {
  static const String boxName = 'recently_viewed';

  static Box<RecentlyViewedItem> getBox() {
    return Hive.box<RecentlyViewedItem>(boxName);
  }

  static Future<void> addGame({
    required int gameId,
    required String gameName,
    required String backgroundImage,
    required double rating,
  }) async {
    try {
      final box = getBox();

      // Find if this game is already in the list
      dynamic existingKey;
      for (var key in box.keys) {
        final item = box.get(key);
        if (item != null && item.gameId == gameId) {
          existingKey = key;
          break;
        }
      }

      // If it exists, delete the old one to move it to the top
      if (existingKey != null) {
        await box.delete(existingKey);
      }

      // Add as a new item (newest)
      final newItem = RecentlyViewedItem(
        gameId: gameId,
        gameName: gameName,
        backgroundImage: backgroundImage,
        rating: rating,
        viewedAt: DateTime.now(),
      );
      await box.add(newItem);

      // Enforce limit of 3 items
      if (box.length > 3) {
        final items = box.values.toList();
        // Sort by viewedAt ascending (oldest first)
        items.sort((a, b) => a.viewedAt.compareTo(b.viewedAt));
        final itemsToDelete = box.length - 3;
        for (var i = 0; i < itemsToDelete; i++) {
          await items[i].delete();
        }
      }
    } catch (e) {
      debugPrint('Error adding game to recently viewed: $e');
    }
  }

  static Future<void> clearAll() async {
    try {
      await getBox().clear();
    } catch (e) {
      debugPrint('Error clearing recently viewed box: $e');
    }
  }
}
