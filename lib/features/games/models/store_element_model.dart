import 'store_model.dart';

class StoreElement {
  final int id;
  final Store store;

  StoreElement({
    required this.id,
    required this.store,
  });

  factory StoreElement.fromJson(Map<String, dynamic> json) {
    return StoreElement(
      id: json['id'] ?? 0,
      store: Store.fromJson(json['store']),
    );
  }
}