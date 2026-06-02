import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cart_service.dart';

final cartServiceProvider = Provider((ref) {
  return CartService();
});

final cartItemCountProvider = Provider((ref) {
  final cartService = ref.watch(cartServiceProvider);
  return cartService.getCartItemCount();
});

final cartTotalPriceProvider = Provider((ref) {
  final cartService = ref.watch(cartServiceProvider);
  return cartService.getTotalPrice();
});
