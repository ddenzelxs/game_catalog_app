import '../models/game_model.dart';

class GameState {
  final List<Game> games;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int page;
  final bool hasMore;

  GameState({
    required this.games,
    required this.isLoading,
    required this.isLoadingMore,
    required this.page,
    required this.hasMore,
    this.error,
  });

  factory GameState.initial() {
    return GameState(
      games: [],
      isLoading: false,
      isLoadingMore: false,
      page: 1,
      hasMore: true,
      error: null,
    );
  }

  GameState copyWith({
    List<Game>? games,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? page,
    bool? hasMore,
  }) {
    return GameState(
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}