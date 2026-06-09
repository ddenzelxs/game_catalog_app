// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationHistoryAdapter extends TypeAdapter<RecommendationHistory> {
  @override
  final int typeId = 3;

  @override
  RecommendationHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationHistory(
      userId: fields[0] as String,
      prompt: fields[1] as String,
      timestamp: fields[2] as DateTime,
      results: (fields[3] as List).cast<RecommendationResult>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.prompt)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
