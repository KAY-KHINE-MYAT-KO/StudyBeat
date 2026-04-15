import 'package:flutter_test/flutter_test.dart';
import 'package:studybeat/core/models/study_session.dart';

void main() {
  group('StudySession', () {
    final session = StudySession(
      id: 'session-1',
      startTime: DateTime(2026, 4, 16, 10, 0),
      endTime: DateTime(2026, 4, 16, 10, 30),
      topics: const ['Trigonometry'],
      durationInSeconds: 1800,
      userId: 'user-123',
      synced: false,
    );

    test('toJson/fromJson roundtrip preserves fields', () {
      final json = session.toJson();
      final parsed = StudySession.fromJson(json);

      expect(parsed.id, session.id);
      expect(parsed.startTime, session.startTime);
      expect(parsed.endTime, session.endTime);
      expect(parsed.topics, session.topics);
      expect(parsed.durationInSeconds, session.durationInSeconds);
      expect(parsed.userId, session.userId);
    });

    test('toFirestore/fromFirestore roundtrip keeps user and duration', () {
      final firestore = session.toFirestore();
      final parsed = StudySession.fromFirestore(firestore, session.id);

      expect(parsed.id, session.id);
      expect(parsed.startTime, session.startTime);
      expect(parsed.endTime, session.endTime);
      expect(parsed.topics, session.topics);
      expect(parsed.durationInSeconds, session.durationInSeconds);
      expect(parsed.userId, session.userId);
      expect(parsed.synced, isTrue);
    });

    test('duration getter returns correct Duration', () {
      expect(session.duration, const Duration(seconds: 1800));
    });
  });
}
