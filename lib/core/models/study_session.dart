class StudySession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> topics;
  final int durationInSeconds;

  StudySession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.topics,
    this.durationInSeconds = 0,
  });

  Duration get duration => Duration(seconds: durationInSeconds);

  StudySession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? topics,
    int? durationInSeconds,
  }) {
    return StudySession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      topics: topics ?? this.topics,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'topics': topics,
      'durationInSeconds': durationInSeconds,
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
    );
  }
}
