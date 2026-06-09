import 'package:hive/hive.dart';

part 'recommendation_result_model.g.dart';

@HiveType(typeId: 2)
class RecommendationResult extends HiveObject {
  @HiveField(0)
  late int gameId;

  @HiveField(1)
  late String gameName;

  @HiveField(2)
  late String backgroundImage;

  @HiveField(3)
  late double rating;

  @HiveField(4)
  late int metacritic;

  @HiveField(5)
  late List<String> platforms;

  @HiveField(6)
  late List<String> genres;

  @HiveField(7)
  late String reason;

  RecommendationResult({
    required this.gameId,
    required this.gameName,
    required this.backgroundImage,
    required this.rating,
    required this.metacritic,
    required this.platforms,
    required this.genres,
    required this.reason,
  });
}
