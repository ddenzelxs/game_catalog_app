import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../games/providers/game_api_provider.dart';
import '../models/recommendation_result_model.dart';
import '../models/recommendation_history_model.dart';
import '../services/recommendation_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/hive_service.dart';

final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  final apiService = ref.read(gameApiServiceProvider);
  return RecommendationService(apiService);
});

class RecommendationState {
  final List<RecommendationResult> recommendations;
  final bool isLoading;
  final String? error;

  RecommendationState({
    required this.recommendations,
    required this.isLoading,
    this.error,
  });

  factory RecommendationState.initial() => RecommendationState(
        recommendations: [],
        isLoading: false,
      );

  RecommendationState copyWith({
    List<RecommendationResult>? recommendations,
    bool? isLoading,
    String? error,
  }) {
    return RecommendationState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RecommendationNotifier extends StateNotifier<RecommendationState> {
  final RecommendationService _service;
  final String? _userId;
  final XpService _xpService;

  RecommendationNotifier(this._service, this._userId, this._xpService) : super(RecommendationState.initial());

  void reset() {
    state = RecommendationState.initial();
  }

  void loadFromHistory(RecommendationHistory history) {
    state = state.copyWith(
      recommendations: history.results,
      isLoading: false,
      error: null,
    );
  }

  Future<void> fetchRecommendations(String prompt) async {
    if (prompt.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _service.getRecommendations(prompt);

      // Save to Hive history
      if (_userId != null && results.isNotEmpty) {
        try {
          final historyBox = HiveService.getAiHistoryBox();
          final historyEntry = RecommendationHistory(
            userId: _userId,
            prompt: prompt,
            timestamp: DateTime.now(),
            results: results,
          );
          await historyBox.add(historyEntry);

          // Reward XP for successful AI Recommendation
          await _xpService.addXp(20);
        } catch (e) {
          print('Error saving recommendation history: $e');
        }
      }

      state = state.copyWith(
        recommendations: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final recommendationProvider =
    StateNotifierProvider<RecommendationNotifier, RecommendationState>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.value;
  final service = ref.read(recommendationServiceProvider);
  final xpService = ref.read(xpServiceProvider);
  return RecommendationNotifier(service, user?.id, xpService);
});
