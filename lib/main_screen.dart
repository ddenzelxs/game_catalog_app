import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/navigation_provider.dart';

import 'features/games/pages/home_screen.dart';
import 'features/recommendation/pages/ai_recommendation_screen.dart';
import 'features/cart/pages/cart_screen.dart';
import 'features/profile/pages/profile_screen.dart';
import 'features/wishlist/pages/wishlist_screen.dart';

import 'shared/widgets/custom_bottom_navbar.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    final screens = [
      const HomeScreen(),
      const AiRecommendationScreen(),
      const WishlistScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar:
          const CustomBottomNavbar(),
    );
  }
}