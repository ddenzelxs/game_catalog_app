import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_detail_model.dart';
import '../services/game_api_service.dart';

final gameDetailProvider =
    FutureProvider.family<GameDetail, int>((ref, gameId) async {
  final api = GameApiService();

  return api.fetchGameDetail(gameId);
});