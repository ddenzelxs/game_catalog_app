import 'package:hive/hive.dart';
import 'recommendation_result_model.dart';

part 'recommendation_history_model.g.dart';

@HiveType(typeId: 3)
class RecommendationHistory extends HiveObject {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String prompt;

  @HiveField(2)
  late DateTime timestamp;

  @HiveField(3)
  late List<RecommendationResult> results;

  RecommendationHistory({
    required this.userId,
    required this.prompt,
    required this.timestamp,
    required this.results,
  });
}
