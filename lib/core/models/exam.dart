import 'package:hive_flutter/hive_flutter.dart';

part 'exam.g.dart';

@HiveType(typeId: 0)
class Exam extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String subject;

  @HiveField(3)
  final DateTime examDate;

  @HiveField(4)
  final List<String> topics;

  @HiveField(5)
  final double progress;

  @HiveField(6)
  final String userId;

  @HiveField(7)
  final bool synced;

  @HiveField(8)
  final bool deleted;

  @HiveField(9)
  final double targetStudyHours;

  Exam({
    required this.id,
    required this.name,
    required this.subject,
    required this.examDate,
    required this.topics,
    this.progress = 0.0,
    required this.userId,
    this.synced = false,
    this.deleted = false,
    this.targetStudyHours = 10.0,
  });

  Exam copyWith({
    String? id,
    String? name,
    String? subject,
    DateTime? examDate,
    List<String>? topics,
    double? progress,
    String? userId,
    bool? synced,
    bool? deleted,
    double? targetStudyHours,
  }) {
    return Exam(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      examDate: examDate ?? this.examDate,
      topics: topics ?? this.topics,
      progress: progress ?? this.progress,
      userId: userId ?? this.userId,
      synced: synced ?? this.synced,
      deleted: deleted ?? this.deleted,
      targetStudyHours: targetStudyHours ?? this.targetStudyHours,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'subject': subject,
      'examDate': examDate.toIso8601String(),
      'topics': topics,
      'progress': progress,
      'userId': userId,
      'targetStudyHours': targetStudyHours,
    };
  }

  factory Exam.fromFirestore(Map<String, dynamic> json, String docId) {
    return Exam(
      id: docId,
      name: json['name'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      examDate: DateTime.parse(json['examDate'] as String),
      topics: List<String>.from(json['topics'] as List? ?? []),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      userId: json['userId'] as String? ?? '',
      synced: true,
      targetStudyHours: (json['targetStudyHours'] as num?)?.toDouble() ?? 10.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'examDate': examDate.toIso8601String(),
      'topics': topics,
      'progress': progress,
      'userId': userId,
      'targetStudyHours': targetStudyHours,
    };
  }

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      examDate: DateTime.parse(json['examDate'] as String),
      topics: List<String>.from(json['topics'] as List),
      progress: (json['progress'] as num).toDouble(),
      userId: json['userId'] as String? ?? '',
      targetStudyHours: (json['targetStudyHours'] as num?)?.toDouble() ?? 10.0,
    );
  }
}
