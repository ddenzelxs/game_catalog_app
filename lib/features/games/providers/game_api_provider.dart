import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/game_api_service.dart';

final gameApiServiceProvider = Provider<GameApiService>((ref) {
  return GameApiService();
});