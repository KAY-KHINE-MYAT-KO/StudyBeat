// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamAdapter extends TypeAdapter<Exam> {
  @override
  final int typeId = 0;

  @override
  Exam read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }
    return Exam(
      id: fields[0] as String,
      name: fields[1] as String,
      subject: fields[2] as String,
      examDate: fields[3] as DateTime,
      topics: fields[4] != null ? List<String>.from(fields[4] as List) : [],
      progress: fields[5] as double,
      userId: fields[6] as String,
      synced: fields[7] as bool? ?? false,
      deleted: fields[8] as bool? ?? false,
      targetStudyHours: fields[9] as double? ?? 10.0,
    );
  }

  @override
  void write(BinaryWriter writer, Exam obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.examDate)
      ..writeByte(4)
      ..write(obj.topics)
      ..writeByte(5)
      ..write(obj.progress)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.synced)
      ..writeByte(8)
      ..write(obj.deleted)
      ..writeByte(9)
      ..write(obj.targetStudyHours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
