// test/features/auth/mocks/auth_mocks.dart

import 'package:mockito/annotations.dart';
import 'package:tourist_guide/core/blocs/auth_text_field_bloc/auth_text_field_bloc.dart';
import 'package:tourist_guide/domain/auth/interfaces/auth_service.dart';
import 'package:tourist_guide/domain/auth/interfaces/biometric_service.dart';
import 'package:tourist_guide/features/auth/bloc/auth_bloc.dart';

@GenerateMocks([
  IAuthService,
  IBiometricService,
  AuthBloc,
  AuthTextFieldBloc,
])
void main() {}