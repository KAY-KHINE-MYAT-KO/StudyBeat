import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studybeat/core/services/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockUserCredential mockCredential;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockCredential = MockUserCredential();
    authService = AuthService(auth: mockAuth);
  });

  test('signIn trims email and returns UserCredential from FirebaseAuth', () async {
    when(
      () => mockAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'pw123456',
      ),
    ).thenAnswer((_) async => mockCredential);

    final result = await authService.signIn(
      email: '  test@example.com  ',
      password: 'pw123456',
    );

    expect(result, same(mockCredential));
    verify(
      () => mockAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'pw123456',
      ),
    ).called(1);
    verifyNoMoreInteractions(mockAuth);
  });

  test('sendPasswordResetEmail trims email before forwarding to FirebaseAuth', () async {
    when(
      () => mockAuth.sendPasswordResetEmail(email: 'reset@example.com'),
    ).thenAnswer((_) async {});

    await authService.sendPasswordResetEmail('  reset@example.com  ');

    verify(() => mockAuth.sendPasswordResetEmail(email: 'reset@example.com')).called(1);
    verifyNoMoreInteractions(mockAuth);
  });
}
