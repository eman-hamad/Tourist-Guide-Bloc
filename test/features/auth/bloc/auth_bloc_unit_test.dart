
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tourist_guide/core/utils/result.dart';
import 'package:tourist_guide/domain/auth/entities/user_entity.dart';
import 'package:tourist_guide/domain/auth/interfaces/auth_service.dart';
import 'package:tourist_guide/domain/auth/interfaces/biometric_service.dart';

import 'package:tourist_guide/features/auth/bloc/auth_bloc.dart';
import 'package:tourist_guide/features/auth/bloc/auth_event.dart';
import 'package:tourist_guide/features/auth/bloc/auth_states.dart';




import '../mocks/auth_unit_test.mocks.dart';



@GenerateMocks([IAuthService, IBiometricService])
void main() {
  late AuthBloc authBloc;
  late MockIAuthService mockAuthService;
  late MockIBiometricService mockBiometricService;

  setUp(() {
    mockAuthService = MockIAuthService();
    mockBiometricService = MockIBiometricService();
    authBloc = AuthBloc(
      authService: mockAuthService,
      biometricService: mockBiometricService,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  final testUser = UserEntity(
    id: '1',
    name: 'Test User',
    email: 'test@example.com', phone: '1234567890',
  );

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('SignInRequested', () {
      test('emits [AuthLoading, AuthSuccess] when sign in is successful', () {
        when(mockAuthService.signIn(any)).thenAnswer(
              (_) async => Result.success(testUser),
        );

        final expected = [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ];

        expectLater(
          authBloc.stream,
          emitsInOrder(expected),
        );

        authBloc.add(const SignInRequested(
          email: 'test@example.com',
          password: 'password123',
        ));
      });

      test('emits [AuthLoading, AuthError] when sign in fails', () {
        when(mockAuthService.signIn(any)).thenAnswer(
              (_) async => Result.failure('Invalid credentials'),
        );

        final expected = [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ];

        expectLater(
          authBloc.stream,
          emitsInOrder(expected),
        );

        authBloc.add(const SignInRequested(
          email: 'test@example.com',
          password: 'wrong_password',
        ));
      });
    });

    group('SignUpRequested', () {
      test('emits [AuthLoading, AuthSuccess] when sign up is successful', () {
        when(mockAuthService.signUp(any)).thenAnswer(
              (_) async => Result.success(testUser),
        );

        final expected = [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ];

        expectLater(
          authBloc.stream,
          emitsInOrder(expected),
        );

        authBloc.add(const SignUpRequested(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        ));
      });

      test('emits AuthError when passwords do not match', () {
        final expected = [
          isA<AuthError>(),
        ];

        expectLater(
          authBloc.stream,
          emitsInOrder(expected),
        );

        authBloc.add(const SignUpRequested(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'different_password',
        ));
      });
    });

    group('BiometricAuthRequested', () {
      test('emits BiometricAuthSuccess when authentication succeeds', () async {
        when(mockBiometricService.isAvailable()).thenAnswer((_) async => true);
        when(mockBiometricService.authenticate()).thenAnswer((_) async => true);

        final expected = [
          isA<BiometricAuthSuccess>(),
        ];

        expectLater(
          authBloc.stream,
          emitsInOrder(expected),
        );

        authBloc.add(BiometricAuthRequested());
      });

      test('emits BiometricAuthError when biometrics not available', () async {
        when(mockBiometricService.isAvailable()).thenAnswer((_) async => false);

        final expected = [
          isA<BiometricAuthError>(),
        ];

        expectLater(
          authBloc.stream,
          emitsInOrder(expected),
        );

        authBloc.add(BiometricAuthRequested());
      });
    });

    group('ValidateFieldsRequested', () {
      test('emits ValidationSuccess when all fields are filled', () {
        final expected = [
          isA<ValidationSuccess>(),
        ];

        expectLater(
          authBloc.stream,
          emitsInOrder(expected),
        );

        authBloc.add(const ValidateFieldsRequested(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        ));
      });

      test('emits ValidationError when fields are empty', () {
        final expected = [
          isA<ValidationError>(),
        ];

        expectLater(
          authBloc.stream,
          emitsInOrder(expected),
        );

        authBloc.add(const ValidateFieldsRequested(
          name: '',
          email: '',
          password: '',
          confirmPassword: '',
        ));
      });
    });
  });
}