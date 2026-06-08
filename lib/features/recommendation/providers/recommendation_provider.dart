import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../games/providers/game_api_provider.dart';
import '../models/recommendation_result_model.dart';
import '../services/recommendation_service.dart';

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

  RecommendationNotifier(this._service) : super(RecommendationState.initial());

  Future<void> fetchRecommendations(String prompt) async {
    if (prompt.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _service.getRecommendations(prompt);
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
  final service = ref.read(recommendationServiceProvider);
  return RecommendationNotifier(service);
});
