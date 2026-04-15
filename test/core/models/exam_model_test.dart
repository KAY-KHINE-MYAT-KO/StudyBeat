import 'package:flutter_test/flutter_test.dart';
import 'package:studybeat/core/models/exam.dart';

void main() {
  group('Exam', () {
    final exam = Exam(
      id: 'exam-1',
      name: 'Final Exam',
      subject: 'Math',
      examDate: DateTime(2026, 5, 20),
      topics: const ['Algebra', 'Geometry'],
      progress: 0.4,
      userId: 'user-123',
      synced: false,
      deleted: false,
      targetStudyHours: 12.5,
    );

    test('toJson/fromJson roundtrip preserves key fields', () {
      final json = exam.toJson();
      final parsed = Exam.fromJson(json);

      expect(parsed.id, exam.id);
      expect(parsed.name, exam.name);
      expect(parsed.subject, exam.subject);
      expect(parsed.examDate, exam.examDate);
      expect(parsed.topics, exam.topics);
      expect(parsed.progress, exam.progress);
      expect(parsed.userId, exam.userId);
      expect(parsed.targetStudyHours, exam.targetStudyHours);
    });

    test('toFirestore/fromFirestore roundtrip keeps user-owned data', () {
      final firestore = exam.toFirestore();
      final parsed = Exam.fromFirestore(firestore, exam.id);

      expect(parsed.id, exam.id);
      expect(parsed.name, exam.name);
      expect(parsed.subject, exam.subject);
      expect(parsed.examDate, exam.examDate);
      expect(parsed.topics, exam.topics);
      expect(parsed.userId, exam.userId);
      expect(parsed.targetStudyHours, exam.targetStudyHours);
      expect(parsed.synced, isTrue);
    });

    test('copyWith only updates requested fields', () {
      final updated = exam.copyWith(name: 'Updated Name', deleted: true);

      expect(updated.name, 'Updated Name');
      expect(updated.deleted, isTrue);
      expect(updated.subject, exam.subject);
      expect(updated.userId, exam.userId);
      expect(updated.targetStudyHours, exam.targetStudyHours);
    });
  });
}
