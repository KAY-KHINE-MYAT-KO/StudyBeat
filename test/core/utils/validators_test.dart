import 'package:flutter_test/flutter_test.dart';
import 'package:studybeat/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validateExamName rejects empty and short values', () {
      expect(Validators.validateExamName(''), 'Please enter an exam name');
      expect(
        Validators.validateExamName('ab'),
        'Exam name must be at least 3 characters',
      );
    });

    test('validateExamName accepts valid value', () {
      expect(Validators.validateExamName('Calculus Final'), isNull);
    });

    test('validateSubject rejects empty and accepts valid subject', () {
      expect(Validators.validateSubject('  '), 'Please enter a subject');
      expect(Validators.validateSubject('Physics'), isNull);
    });

    test('validateDate rejects null and past date', () {
      expect(Validators.validateDate(null), 'Please select a date');
      expect(
        Validators.validateDate(DateTime.now().subtract(const Duration(days: 1))),
        'Date must be in the future',
      );
    });

    test('validateTopicName rejects empty and accepts valid topic', () {
      expect(Validators.validateTopicName(''), 'Please enter a topic name');
      expect(Validators.validateTopicName('Kinematics'), isNull);
    });
  });
}
