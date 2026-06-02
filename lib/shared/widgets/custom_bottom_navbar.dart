import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/navigation_provider.dart';

class CustomBottomNavbar extends ConsumerWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0E12),
        border: Border(top: BorderSide(color: Color(0xFF2B2D3B))),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          ref.read(bottomNavProvider.notifier).state = index;
        },

        backgroundColor: Colors.transparent,

        elevation: 0,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Theme.of(context).primaryColor,

        unselectedItemColor: const Color(0xFF9CA3AF),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
