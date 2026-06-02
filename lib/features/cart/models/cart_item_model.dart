import 'package:hive/hive.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  late int gameId;

  @HiveField(1)
  late String gameName;

  @HiveField(2)
  late String backgroundImage;

  @HiveField(3)
  late double price;

  @HiveField(4)
  late double rating;

  @HiveField(5)
  late DateTime addedAt;

  CartItem({
    required this.gameId,
    required this.gameName,
    required this.backgroundImage,
    required this.price,
    required this.rating,
    required this.addedAt,
  });
}
