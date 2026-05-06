import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/game_api_service.dart';
import 'game_state.dart';
import 'game_api_provider.dart';

class GameNotifier extends StateNotifier<GameState> {
  final GameApiService api;

  GameNotifier(this.api) : super(GameState.initial());

  Future<void> fetchGames() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final games = await api.fetchGames(page: 1);

      state = state.copyWith(
        games: games,
        isLoading: false,
        page: 1,
        hasMore: games.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    try {
      state = state.copyWith(isLoadingMore: true);

      final nextPage = state.page + 1;
      final newGames = await api.fetchGames(page: nextPage);

      state = state.copyWith(
        games: [...state.games, ...newGames],
        isLoadingMore: false,
        page: nextPage,
        hasMore: newGames.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await fetchGames();
  }
}

final gameProvider =
    StateNotifierProvider<GameNotifier, GameState>((ref) {
  final api = ref.read(gameApiServiceProvider);
  return GameNotifier(api);
});