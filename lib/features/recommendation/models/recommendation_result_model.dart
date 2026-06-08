import '../../games/models/game_model.dart';

class RecommendationResult {
  final Game game;
  final String reason;

  RecommendationResult({
    required this.game,
    required this.reason,
  });
}
