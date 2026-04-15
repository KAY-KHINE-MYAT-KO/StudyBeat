import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studybeat/core/services/auth_service.dart';

void main() {
  group('AuthService.getErrorMessage', () {
    test('maps known FirebaseAuthException codes', () {
      expect(
        AuthService.getErrorMessage(FirebaseAuthException(code: 'user-not-found')),
        'No account found with this email.',
      );
      expect(
        AuthService.getErrorMessage(FirebaseAuthException(code: 'wrong-password')),
        'Incorrect password. Please try again.',
      );
      expect(
        AuthService.getErrorMessage(FirebaseAuthException(code: 'too-many-requests')),
        'Too many attempts. Please try again later.',
      );
    });

    test('falls back to generic message for unknown codes', () {
      final message = AuthService.getErrorMessage(
        FirebaseAuthException(code: 'some-unknown-code'),
      );

      expect(message, 'An error occurred. Please try again.');
    });
  });
}
