class Exam {
  final String id;
  final String name;
  final String subject;
  final DateTime examDate;
  final List<String> topics;
  final double progress;

  Exam({
    required this.id,
    required this.name,
    required this.subject,
    required this.examDate,
    required this.topics,
    this.progress = 0.0,
  });

  Exam copyWith({
    String? id,
    String? name,
    String? subject,
    DateTime? examDate,
    List<String>? topics,
    double? progress,
  }) {
    return Exam(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      examDate: examDate ?? this.examDate,
      topics: topics ?? this.topics,
      progress: progress ?? this.progress,
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
    );
  }
}