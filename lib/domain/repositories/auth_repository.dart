import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> signup(
      String email, String password, String name, String phone);
}
