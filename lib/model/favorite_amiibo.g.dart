// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_amiibo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteAmiiboAdapter extends TypeAdapter<FavoriteAmiibo> {
  @override
  final int typeId = 0;

  @override
  FavoriteAmiibo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteAmiibo(
      amiiboSeries: fields[0] as String,
      character: fields[1] as String,
      gameSeries: fields[2] as String,
      head: fields[3] as String,
      image: fields[4] as String,
      name: fields[5] as String,
      release: fields[6] as String,
      tail: fields[7] as String,
      type: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteAmiibo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.amiiboSeries)
      ..writeByte(1)
      ..write(obj.character)
      ..writeByte(2)
      ..write(obj.gameSeries)
      ..writeByte(3)
      ..write(obj.head)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.release)
      ..writeByte(7)
      ..write(obj.tail)
      ..writeByte(8)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAmiiboAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
