import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:game_catalog/features/games/providers/game_detail_provider.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/features/cart/services/cart_service.dart';
import 'package:game_catalog/features/wishlist/models/wishlist_item_model.dart';
import 'package:game_catalog/features/wishlist/services/wishlist_service.dart';
import 'package:game_catalog/core/services/hive_service.dart';
import 'package:game_catalog/features/auth/providers/auth_provider.dart';
import 'package:game_catalog/features/profile/services/recently_viewed_service.dart';
import 'package:game_catalog/features/games/models/game_detail_model.dart';
import 'package:game_catalog/shared/widgets/platform_icons.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final int gameId;

  const DetailScreen({super.key, required this.gameId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  int _selectedTabIndex = 0;
  late CartService _cartService;
  late WishlistService _wishlistService;
  bool _recentlyViewedLogged = false;

  @override
  void initState() {
    super.initState();
    _cartService = CartService();
    _wishlistService = WishlistService();
  }


  Widget _buildTabItem(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : const Color(0xFF181A22),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFF2B2D3B),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$stars ⭐️',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100.0,
                minHeight: 6,
                backgroundColor: const Color(0xFF1E2030),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF8B5CF6),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 36,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(GameDetail game) {
    // Calculate rating percentages
    double pct5 = 0;
    double pct4 = 0;
    double pct3 = 0;
    double pct2 = 0;
    double pct1 = 0;
    for (var r in game.ratings) {
      if (r.id == 5) pct5 = r.percent;
      if (r.id == 4) pct4 = r.percent;
      if (r.id == 3) pct3 = r.percent;
      if (r.id == 2) pct2 = r.percent;
      if (r.id == 1) pct1 = r.percent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // About Card
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF181A22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2B2D3B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                game.description,
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Rating Breakdown Card
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF181A22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2B2D3B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rating Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildRatingBar(5, pct5),
              _buildRatingBar(4, pct4),
              _buildRatingBar(3, pct3),
              _buildRatingBar(2, pct2),
              _buildRatingBar(1, pct1),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Available Stores Card
        if (game.stores.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF181A22),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2B2D3B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Stores',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ...game.stores.map((s) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2030),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2B2D3B)),
                    ),
                    child: ListTile(
                      title: Text(
                        s.store.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF9CA3AF),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Opening ${s.store.name} (${s.store.domain})...',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Tags Card
        if (game.tags.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF181A22),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2B2D3B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tags',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: game.tags.map((t) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2030),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF2B2D3B)),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildScreenshotsTab(GameDetail game) {
    if (game.screenshots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF181A22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2B2D3B)),
        ),
        child: const Center(
          child: Text(
            "No screenshots available for this game.",
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: game.screenshots.length,
      itemBuilder: (context, index) {
        final imageUrl = game.screenshots[index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(color: Colors.black.withAlpha(204)),
                    ),
                    Center(
                      child: PhotoView(
                        imageProvider: NetworkImage(imageUrl),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(128),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildRequirementsTab(GameDetail game) {
    final hasMin =
        game.minimumRequirements != null &&
        game.minimumRequirements!.isNotEmpty;
    final hasRec =
        game.recommendedRequirements != null &&
        game.recommendedRequirements!.isNotEmpty;

    if (!hasMin && !hasRec) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF181A22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2B2D3B)),
        ),
        child: const Column(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF9CA3AF), size: 36),
            SizedBox(height: 12),
            Text(
              "System requirements not specified for this platform.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasMin) ...[
          const Text(
            "Minimum Requirements",
            style: TextStyle(
              color: Color(0xFF8B5CF6),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF181A22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2B2D3B)),
            ),
            child: Text(
              game.minimumRequirements!.replaceAll('Minimum: ', ''),
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (hasRec) ...[
          const Text(
            "Recommended Requirements",
            style: TextStyle(
              color: Color(0xFFEC4899),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF181A22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2B2D3B)),
            ),
            child: Text(
              game.recommendedRequirements!.replaceAll('Recommended: ', ''),
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTabContent(GameDetail game) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildAboutTab(game);
      case 1:
        return _buildScreenshotsTab(game);
      case 2:
        return _buildRequirementsTab(game);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(gameDetailProvider(widget.gameId));

    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      body: detailAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (game) {
          // Log recently viewed game on load (once)
          if (!_recentlyViewedLogged) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              RecentlyViewedService.addGame(
                gameId: game.id,
                gameName: game.name,
                backgroundImage: game.backgroundImage,
                rating: game.rating,
              );
              setState(() {
                _recentlyViewedLogged = true;
              });
            });
          }

          return Stack(
            children: [
              // Cover Image Banner
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 320,
                child: Image.network(game.backgroundImage, fit: BoxFit.cover),
              ),
              // Fade overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 320,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(51),
                        Colors.black.withAlpha(128),
                        const Color(0xFF0D0E12),
                      ],
                    ),
                  ),
                ),
              ),

              // Scrollable Details Content
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 200), // spacing overlay
                      // Floating Header Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF181A22),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFF2B2D3B)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(128),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                game.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Rating, Metacritic, Release Row
                              Row(
                                children: [
                                  // Star Rating
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${game.rating}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const Text(
                                        ' /5',
                                        style: TextStyle(
                                          color: Color(0xFF9CA3AF),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 1,
                                    height: 12,
                                    color: const Color(0xFF374151),
                                  ),
                                  const SizedBox(width: 10),

                                  // Metacritic
                                  if (game.metacritic > 0) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF10B981,
                                        ).withAlpha(30),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF10B981,
                                          ).withAlpha(120),
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${game.metacritic}',
                                        style: const TextStyle(
                                          color: Color(0xFF10B981),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 1,
                                      height: 12,
                                      color: const Color(0xFF374151),
                                    ),
                                    const SizedBox(width: 10),
                                  ],

                                  // Release Year
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        color: Color(0xFF9CA3AF),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        game.released.isNotEmpty
                                            ? game.released.split('-')[0]
                                            : 'TBA',
                                        style: const TextStyle(
                                          color: Color(0xFF9CA3AF),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Genres wrapped
                              Wrap(
                                spacing: 8,
                                children: game.genres.map((g) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E2030),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFF2B2D3B),
                                      ),
                                    ),
                                    child: Text(
                                      g,
                                      style: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),

                              // Available Platforms row
                              Row(
                                children: [
                                  const Text(
                                    "Available on: ",
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  PlatformIcons(slugs: game.parentPlatforms),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 1,
                                color: const Color(0xFF2B2D3B),
                              ),
                              const SizedBox(height: 16),

                              // Price & Action Button Row
                              ValueListenableBuilder(
                                valueListenable: Hive.box<CartItem>(
                                  HiveService.cartBoxName,
                                ).listenable(),
                                builder: (context, Box<CartItem> cartBox, _) {
                                  final isInCart = _cartService.isInCart(
                                    game.id,
                                  );

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Price
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Price',
                                            style: TextStyle(
                                              color: Color(0xFF9CA3AF),
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '\$19.99',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Library Action Button
                                      SizedBox(
                                        height: 44,
                                        child: ElevatedButton.icon(
                                          onPressed: isInCart
                                              ? () {
                                                  _cartService.removeFromCart(
                                                    game.id,
                                                  );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Removed from library',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              : () {
                                                  final cartItem = CartItem(
                                                    gameId: game.id,
                                                    gameName: game.name,
                                                    backgroundImage:
                                                        game.backgroundImage,
                                                    price: 19.99,
                                                    rating: game.rating,
                                                    addedAt: DateTime.now(),
                                                    status: 'Plan to Play',
                                                  );
                                                  _cartService.addToCart(
                                                    cartItem,
                                                  );
                                                  ref
                                                      .read(xpServiceProvider)
                                                      .addXp(10);
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Added to library (+10 XP)',
                                                      ),
                                                    ),
                                                  );
                                                },
                                          icon: Icon(
                                            isInCart
                                                ? Icons.library_add_check
                                                : Icons.library_add,
                                            size: 18,
                                          ),
                                          label: Text(
                                            isInCart
                                                ? 'In Library'
                                                : 'Add to Library',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isInCart
                                                ? const Color(0xFF374151)
                                                : const Color(0xFF8B5CF6),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tabs selector
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            _buildTabItem(0, "About"),
                            const SizedBox(width: 8),
                            _buildTabItem(1, "Screenshots"),
                            const SizedBox(width: 8),
                            _buildTabItem(2, "Requirements"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Content Panel
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildTabContent(game),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Fixed Top Navigation Bar Overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(128),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),

                        // Wishlist Heart Button
                        ValueListenableBuilder(
                          valueListenable: Hive.box<WishlistItem>(
                            HiveService.wishlistBoxName,
                          ).listenable(),
                          builder: (context, Box<WishlistItem> wishlistBox, _) {
                            final isInWishlist = _wishlistService.isInWishlist(
                              game.id,
                            );

                            return GestureDetector(
                              onTap: () {
                                if (isInWishlist) {
                                  _wishlistService.removeFromWishlist(game.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Removed from wishlist'),
                                    ),
                                  );
                                } else {
                                  final wishlistItem = WishlistItem(
                                    gameId: game.id,
                                    gameName: game.name,
                                    backgroundImage: game.backgroundImage,
                                    rating: game.rating,
                                    addedAt: DateTime.now(),
                                  );
                                  _wishlistService.addToWishlist(wishlistItem);
                                  ref.read(xpServiceProvider).addXp(10);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Added to wishlist (+10 XP)',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(128),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isInWishlist
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isInWishlist
                                      ? Colors.red
                                      : Colors.white,
                                  size: 22,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
