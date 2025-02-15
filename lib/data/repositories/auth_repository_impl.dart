import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _authService;
  AuthRepositoryImpl(this._authService);

  @override
  Future<UserModel?> login(String email, String password) {
    return _authService.login(email, password);
  }

  @override
  Future<UserModel?> signup(String email, String password, String name, String phone) {
    return _authService.signup(email, password, name, phone);
  }
}