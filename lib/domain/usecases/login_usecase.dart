
import 'package:tourist_guide/domain/repositories/auth_repository.dart';

import '../../data/models/user_model.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  LoginUseCase(this._authRepository);

  Future<UserModel?> execute(String email, String password) {
    return _authRepository.login(email, password);
  }
}