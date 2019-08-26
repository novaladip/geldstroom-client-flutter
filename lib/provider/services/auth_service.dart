import 'package:geldstroom/utils/api.dart';

class AuthService {
  Future<String> signIn(String email, String password) async {
    try {
      final response = await api.post(Url.login, data: {
        'email': email,
        'password': password,
      });
      return response.data['accessToken'];
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await api.post(Url.register, data: {
        'email': email,
        'password': password,
      });
    } catch (error) {
      throw error;
    }
  }
}
