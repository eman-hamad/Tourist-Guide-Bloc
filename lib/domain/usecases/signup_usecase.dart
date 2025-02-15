import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _authRepository;
  SignupUseCase(this._authRepository);

  Future<UserModel?> execute(
      String email, String password, String name, String phone) {
    return _authRepository.signup(email, password, name, phone);
  }
}
