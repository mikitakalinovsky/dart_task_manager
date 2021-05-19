// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagsAdapter extends TypeAdapter<Tags> {
  @override
  final int typeId = 1;

  @override
  Tags read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Tags.DART;
      case 1:
        return Tags.FLUTTER;
      case 2:
        return Tags.ALGORITHMS;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Tags obj) {
    switch (obj) {
      case Tags.DART:
        writer.writeByte(0);
        break;
      case Tags.FLUTTER:
        writer.writeByte(1);
        break;
      case Tags.ALGORITHMS:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      fields[0] as String,
      fields[1] as String,
      fields[2] as Tags,
      fields[3] as String,
      fields[4] as String,
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.tag)
      ..writeByte(3)
      ..write(obj.taskCreateTime)
      ..writeByte(4)
      ..write(obj.taskDeadline)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}