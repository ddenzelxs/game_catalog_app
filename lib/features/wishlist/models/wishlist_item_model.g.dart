// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistItemAdapter extends TypeAdapter<WishlistItem> {
  @override
  final int typeId = 1;

  @override
  WishlistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistItem(
      gameId: fields[0] as int,
      gameName: fields[1] as String,
      backgroundImage: fields[2] as String,
      rating: fields[3] as double,
      addedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.gameId)
      ..writeByte(1)
      ..write(obj.gameName)
      ..writeByte(2)
      ..write(obj.backgroundImage)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
