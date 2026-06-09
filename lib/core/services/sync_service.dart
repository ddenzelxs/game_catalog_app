import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';
import 'hive_service.dart';
import '../../features/cart/models/cart_item_model.dart';
import '../../features/wishlist/models/wishlist_item_model.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();

  factory SyncService() {
    return _instance;
  }

  SyncService._internal();

  /// Initialize Auth State Listener for Syncing
  void initAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        print("User signed in. Syncing database from cloud...");
        await fetchAndSyncFromCloud();
      } else if (event == AuthChangeEvent.signedOut) {
        print("User signed out. Clearing local cached data...");
        await clearLocalData();
      }
    });
  }

  /// Sync Wishlist Item to Cloud
  static Future<void> syncWishlistToCloud(WishlistItem item) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('wishlist').upsert({
        'user_id': user.id,
        'game_id': item.gameId,
        'game_name': item.gameName,
        'background_image': item.backgroundImage,
        'rating': item.rating,
        'added_at': item.addedAt.toIso8601String(),
      }, onConflict: 'user_id,game_id');
    } catch (e) {
      print('Error syncing wishlist to cloud: $e');
    }
  }

  /// Delete Wishlist Item from Cloud
  static Future<void> deleteWishlistFromCloud(int gameId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase
          .from('wishlist')
          .delete()
          .match({'user_id': user.id, 'game_id': gameId});
    } catch (e) {
      print('Error deleting wishlist from cloud: $e');
    }
  }

  /// Sync Backlog Item to Cloud
  static Future<void> syncBacklogToCloud(CartItem item) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('backlog').upsert({
        'user_id': user.id,
        'game_id': item.gameId,
        'game_name': item.gameName,
        'background_image': item.backgroundImage,
        'price': item.price,
        'rating': item.rating,
        'status': item.status ?? 'Plan to Play',
        'added_at': item.addedAt.toIso8601String(),
      }, onConflict: 'user_id,game_id');
    } catch (e) {
      print('Error syncing backlog to cloud: $e');
    }
  }

  /// Delete Backlog Item from Cloud
  static Future<void> deleteBacklogFromCloud(int gameId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase
          .from('backlog')
          .delete()
          .match({'user_id': user.id, 'game_id': gameId});
    } catch (e) {
      print('Error deleting backlog from cloud: $e');
    }
  }

  /// Fetch Wishlist and Backlog from Supabase and sync to Hive
  static Future<void> fetchAndSyncFromCloud() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Sync Wishlist
      final List wishlistData = await supabase
          .from('wishlist')
          .select()
          .eq('user_id', user.id);

      final wishlistBox = HiveService.getWishlistBox();
      await wishlistBox.clear();
      for (var row in wishlistData) {
        final item = WishlistItem(
          gameId: row['game_id'] as int,
          gameName: row['game_name'] as String,
          backgroundImage: row['background_image'] as String,
          rating: (row['rating'] as num).toDouble(),
          addedAt: DateTime.parse(row['added_at'] as String),
        );
        await wishlistBox.add(item);
      }

      // Sync Backlog
      final List backlogData = await supabase
          .from('backlog')
          .select()
          .eq('user_id', user.id);

      final cartBox = HiveService.getCartBox();
      await cartBox.clear();
      for (var row in backlogData) {
        final item = CartItem(
          gameId: row['game_id'] as int,
          gameName: row['game_name'] as String,
          backgroundImage: row['background_image'] as String,
          price: (row['price'] as num).toDouble(),
          rating: (row['rating'] as num).toDouble(),
          addedAt: DateTime.parse(row['added_at'] as String),
          status: row['status'] as String? ?? 'Plan to Play',
        );
        await cartBox.add(item);
      }
      print("Database Cloud sync completed successfully.");
    } catch (e) {
      print('Error fetching data from Supabase for sync: $e');
    }
  }

  /// Clear Hive Box Local Cache on Logout
  static Future<void> clearLocalData() async {
    try {
      final wishlistBox = HiveService.getWishlistBox();
      final cartBox = HiveService.getCartBox();
      final aiHistoryBox = HiveService.getAiHistoryBox();
      final recentlyViewedBox = HiveService.getRecentlyViewedBox();
      await wishlistBox.clear();
      await cartBox.clear();
      await aiHistoryBox.clear();
      await recentlyViewedBox.clear();
      print("Local user cache cleared.");
    } catch (e) {
      print('Error clearing local boxes: $e');
    }
  }
}
