// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationResultAdapter extends TypeAdapter<RecommendationResult> {
  @override
  final int typeId = 2;

  @override
  RecommendationResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationResult(
      gameId: fields[0] as int,
      gameName: fields[1] as String,
      backgroundImage: fields[2] as String,
      rating: fields[3] as double,
      metacritic: fields[4] as int,
      platforms: (fields[5] as List).cast<String>(),
      genres: (fields[6] as List).cast<String>(),
      reason: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationResult obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.gameId)
      ..writeByte(1)
      ..write(obj.gameName)
      ..writeByte(2)
      ..write(obj.backgroundImage)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.metacritic)
      ..writeByte(5)
      ..write(obj.platforms)
      ..writeByte(6)
      ..write(obj.genres)
      ..writeByte(7)
      ..write(obj.reason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
