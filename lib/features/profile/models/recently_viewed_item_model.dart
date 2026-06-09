import 'package:hive/hive.dart';

part 'recently_viewed_item_model.g.dart';

@HiveType(typeId: 4)
class RecentlyViewedItem extends HiveObject {
  @HiveField(0)
  late int gameId;

  @HiveField(1)
  late String gameName;

  @HiveField(2)
  late String backgroundImage;

  @HiveField(3)
  late double rating;

  @HiveField(4)
  late DateTime viewedAt;

  RecentlyViewedItem({
    required this.gameId,
    required this.gameName,
    required this.backgroundImage,
    required this.rating,
    required this.viewedAt,
  });
}
