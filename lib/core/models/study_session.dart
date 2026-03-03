import 'package:hive_flutter/hive_flutter.dart';

part 'study_session.g.dart';

@HiveType(typeId: 1)
class StudySession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  final DateTime? endTime;

  @HiveField(3)
  final List<String> topics;

  @HiveField(4)
  final int durationInSeconds;

  @HiveField(5)
  final String userId;

  @HiveField(6)
  final bool synced;

  StudySession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.topics,
    this.durationInSeconds = 0,
    required this.userId,
    this.synced = false,
  });

  Duration get duration => Duration(seconds: durationInSeconds);

  StudySession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? topics,
    int? durationInSeconds,
    String? userId,
    bool? synced,
  }) {
    return StudySession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      topics: topics ?? this.topics,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      userId: userId ?? this.userId,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'topics': topics,
      'durationInSeconds': durationInSeconds,
      'userId': userId,
    };
  }

  factory StudySession.fromFirestore(Map<String, dynamic> json, String docId) {
    return StudySession(
      id: docId,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      topics: List<String>.from(json['topics'] as List? ?? []),
      durationInSeconds: json['durationInSeconds'] as int? ?? 0,
      userId: json['userId'] as String? ?? '',
      synced: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'topics': topics,
      'durationInSeconds': durationInSeconds,
      'userId': userId,
    };
  }

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      topics: List<String>.from(json['topics'] as List),
      durationInSeconds: json['durationInSeconds'] as int,
      userId: json['userId'] as String? ?? '',
    );
  }
}
