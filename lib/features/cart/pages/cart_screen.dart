import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:game_catalog/features/cart/models/cart_item_model.dart';
import 'package:game_catalog/features/cart/services/cart_service.dart';
import 'package:game_catalog/core/services/hive_service.dart';
import 'package:game_catalog/features/auth/providers/auth_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  late CartService _cartService;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _cartService = CartService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<CartItem>(HiveService.cartBoxName).listenable(),
          builder: (context, Box<CartItem> cartBox, _) {
            final cartItems = cartBox.values.toList();

            if (cartItems.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(0),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_esports_outlined,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Your Library is Empty',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add games to track your play progress!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            final filteredItems = cartItems.where((item) {
              if (_selectedFilter == 'All') return true;
              return (item.status ?? 'Plan to Play') == _selectedFilter;
            }).toList();

            final totalCount = cartItems.length;
            final completedCount = cartItems.where((item) => (item.status ?? 'Plan to Play') == 'Completed').length;
            final playingCount = cartItems.where((item) => (item.status ?? 'Plan to Play') == 'Playing').length;
            final planToPlayCount = cartItems.where((item) => (item.status ?? 'Plan to Play') == 'Plan to Play').length;
            final onHoldCount = cartItems.where((item) => (item.status ?? 'Plan to Play') == 'On Hold').length;
            
            final completionPercent = totalCount > 0 ? (completedCount / totalCount) : 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(totalCount),
                  const SizedBox(height: 20),

                  // =========================
                  // CATEGORY FILTERS
                  // =========================
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['All', 'Plan to Play', 'Playing', 'Completed', 'On Hold'].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF1B1C24),
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected ? null : Border.all(color: const Color(0xFF2B2D3B)),
                            ),
                            child: Center(
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // =========================
                  // BACKLOG ITEMS LIST
                  // =========================
                  if (filteredItems.isEmpty)
                    SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          "No games in '$_selectedFilter' status",
                          style: const TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF181A22),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF2B2D3B),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.backgroundImage,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: const Color(0xFF13151D),
                                        child: const Icon(Icons.broken_image),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.gameName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${item.rating}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9CA3AF),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Status Selector Dropdown
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1B1C24),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFF2B2D3B),
                                              width: 1,
                                            ),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: item.status ?? 'Plan to Play',
                                              dropdownColor: const Color(0xFF1B1C24),
                                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF8B5CF6), size: 18),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                              onChanged: (String? newStatus) async {
                                                if (newStatus != null) {
                                                  final oldStatus = item.status;
                                                  await _cartService.updateStatus(item.gameId, newStatus);
                                                  if (newStatus == 'Completed' && oldStatus != 'Completed') {
                                                    await ref.read(xpServiceProvider).addXp(50);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('Congratulations! Game completed (+50 XP) 🏆'),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                  setState(() {});
                                                }
                                              },
                                              items: <String>[
                                                'Plan to Play',
                                                'Playing',
                                                'Completed',
                                                'On Hold'
                                              ].map<DropdownMenuItem<String>>((String value) {
                                                IconData statusIcon = Icons.schedule;
                                                Color statusColor = Colors.blue;
                                                if (value == 'Playing') {
                                                  statusIcon = Icons.play_circle_outline;
                                                  statusColor = const Color(0xFF8B5CF6);
                                                } else if (value == 'Completed') {
                                                  statusIcon = Icons.check_circle_outline;
                                                  statusColor = const Color(0xFF10B981);
                                                } else if (value == 'On Hold') {
                                                  statusIcon = Icons.pause_circle_outline;
                                                  statusColor = Colors.orange;
                                                }

                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      Icon(statusIcon, color: statusColor, size: 14),
                                                      const SizedBox(width: 6),
                                                      Text(value),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
                                          onPressed: () async {
                                            await _cartService.removeFromCart(item.gameId);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // =========================
                  // LIBRARY PROGRESS PANEL
                  // =========================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181A22),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2B2D3B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.analytics_outlined, color: Color(0xFF8B5CF6), size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Library Analytics",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Completion Rate",
                              style: TextStyle(color: Colors.grey[400], fontSize: 13),
                            ),
                            Text(
                              "${(completionPercent * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: completionPercent,
                            backgroundColor: const Color(0xFF1B1C24),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFF2B2D3B)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatColumn("Plan to Play", planToPlayCount, Colors.blue),
                            _buildStatColumn("Playing", playingCount, const Color(0xFF8B5CF6)),
                            _buildStatColumn("Completed", completedCount, const Color(0xFF10B981)),
                            _buildStatColumn("On Hold", onHoldCount, Colors.orange),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // MOTIVATIONAL / LEVEL STATUS
                  // =========================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        totalCount == 0 
                          ? "Add games to start your backlog!" 
                          : completedCount == totalCount
                            ? "🏆 All games completed! Master Gamer!"
                            : "Keep playing! You have ${totalCount - completedCount} games to complete.",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC084FC),
                  Color(0xFF8B5CF6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.video_library,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Library",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "$count games tracked",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}