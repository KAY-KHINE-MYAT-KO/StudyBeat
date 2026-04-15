import 'package:flutter_test/flutter_test.dart';
import 'package:studybeat/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    test('formatExamDate returns Today for current date', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      expect(DateFormatter.formatExamDate(today), 'Today');
    });

    test('formatExamDate returns Tomorrow for next day', () {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);

      expect(DateFormatter.formatExamDate(tomorrow), 'Tomorrow');
    });

    test('formatExamDate returns days away when within a week', () {
      final now = DateTime.now();
      final inThreeDays = DateTime(now.year, now.month, now.day + 3);

      expect(DateFormatter.formatExamDate(inThreeDays), '3 days away');
    });

    test('formatTime uses hours and minutes when >= 1 hour', () {
      expect(DateFormatter.formatTime(const Duration(minutes: 90)), '1h 30m');
    });

    test('formatTime uses minutes when under 1 hour', () {
      expect(DateFormatter.formatTime(const Duration(minutes: 45)), '45m');
    });
  });
}
