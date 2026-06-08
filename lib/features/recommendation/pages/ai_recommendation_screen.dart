import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../games/pages/detail_screen.dart';
import '../../games/models/platform_element_model.dart';
import '../models/recommendation_result_model.dart';
import '../providers/recommendation_provider.dart';

class AiRecommendationScreen extends ConsumerStatefulWidget {
  const AiRecommendationScreen({super.key});

  @override
  ConsumerState<AiRecommendationScreen> createState() => _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends ConsumerState<AiRecommendationScreen> {
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER SECTION
              // =========================
              Row(
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
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AI Recommend",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Find games matching your mood",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================
              // PROMPT TEXTFIELD
              // =========================
              TextField(
                controller: _promptController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "E.g., I like Elden Ring but want something easier...",
                  fillColor: const Color(0xFF1B1C24),
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2B2D3B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // ACTION BUTTON / LOADER
              // =========================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    disabledBackgroundColor: const Color(0xFF8B5CF6).withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: state.isLoading
                      ? null
                      : () {
                          ref
                              .read(recommendationProvider.notifier)
                              .fetchRecommendations(_promptController.text);
                        },
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Get Recommendations",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // RECOMMENDATION RESULTS LIST
              // =========================
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                        ),
                      )
                    : state.error != null
                        ? Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444).withAlpha(20),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.error_outline_rounded,
                                      size: 48,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Recommendation Failed",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    state.error!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  if (state.error!.toLowerCase().contains("key") ||
                                      state.error!.toLowerCase().contains("env") ||
                                      state.error!.toLowerCase().contains("missing"))
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B5CF6).withAlpha(15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF8B5CF6).withAlpha(40),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.lightbulb_outline, color: Color(0xFFC084FC), size: 20),
                                              SizedBox(width: 8),
                                              Text(
                                                "Troubleshooting Tip",
                                                style: TextStyle(
                                                  color: Color(0xFFC084FC),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Flutter bundles environment files at build time. Since you recently added your GEMINI_API_KEY in the .env file, please restart the app (terminate/stop and rebuild) for the changes to take effect.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.purple[100],
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: 150,
                                    height: 42,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1B1C24),
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(color: Color(0xFF2B2D3B)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(recommendationProvider.notifier)
                                            .fetchRecommendations(_promptController.text);
                                      },
                                      icon: const Icon(Icons.refresh, size: 18),
                                      label: const Text(
                                        "Retry",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : state.recommendations.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.smart_toy_outlined,
                                      size: 64,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Type a prompt to get AI recommendations!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: state.recommendations.length,
                                itemBuilder: (context, index) {
                                  final result = state.recommendations[index];
                                  return AiRecommendationCard(result: result);
                                },
                              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AiRecommendationCard extends StatelessWidget {
  final RecommendationResult result;

  const AiRecommendationCard({super.key, required this.result});

  Widget _buildPlatformIcons(List<PlatformElement> platforms) {
    bool hasPC = false;
    bool hasConsole = false;

    for (var p in platforms) {
      final slug = p.platform.slug.toLowerCase();
      if (slug.contains('pc')) {
        hasPC = true;
      } else if (slug.contains('playstation') ||
          slug.contains('xbox') ||
          slug.contains('nintendo') ||
          slug.contains('switch')) {
        hasConsole = true;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasPC)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.monitor, color: Color(0xFF9CA3AF), size: 16),
          ),
        if (hasConsole)
          const Icon(Icons.sports_esports, color: Color(0xFF9CA3AF), size: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = result.game;
    final metacritic = game.metacritic > 0 ? game.metacritic : (game.rating * 20).round();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(gameId: game.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF181A22),
          border: Border.all(
            color: const Color(0xFF2B2D3B),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image with rating badge
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      game.backgroundImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: const Color(0xFF13151D)),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$metacritic',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${game.rating}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildPlatformIcons(game.platforms),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Genres wrap
                  Row(
                    children: game.genres.take(2).map((genre) {
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1C24),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF2B2D3B),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          genre.name,
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const Divider(height: 24),

                  // AI Reason container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withAlpha(15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withAlpha(40),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.psychology,
                              color: Color(0xFF8B5CF6),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "AI Recommendation Reason",
                              style: TextStyle(
                                color: Color(0xFF8B5CF6),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          result.reason,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
