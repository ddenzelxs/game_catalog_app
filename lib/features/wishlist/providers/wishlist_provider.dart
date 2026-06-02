import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/wishlist_service.dart';

final wishlistServiceProvider = Provider((ref) {
  return WishlistService();
});

final wishlistItemCountProvider = Provider((ref) {
  final wishlistService = ref.watch(wishlistServiceProvider);
  return wishlistService.getWishlistItemCount();
});
