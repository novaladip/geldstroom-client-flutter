import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:geldstroom/provider/services/auth_service.dart';

import 'package:geldstroom/models/http_exception.dart';
import 'package:geldstroom/provider/services/jwt_service.dart';
import 'package:geldstroom/utils/api.dart';

class Auth with ChangeNotifier {
  final authService = AuthService();
  final jwtService = JwtService();

  bool _isAuthenticated = false;
  String _email;
  String _userId;

  Auth() {
    _initializing();
  }

  String get email {
    return _email;
  }

  String get userId {
    return _userId;
  }

  bool get isAuthenticated {
    return _isAuthenticated;
  }

  Future<void> login(String email, String password) async {
    try {
      final jwt = await authService.signIn(email, password);
      await jwtService.save(jwt);
      _setStateFromJwt(jwt);
      Api.setDefaultAuthHeader(jwt);
    } on DioError catch (e) {
      if (e.response != null) {
        throw HttpException(e.response.data['message']);
      } else {
        throw HttpException(
            'Login failed, please make sure you connected to internet.');
      }
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await authService.signUp(email, password);
    } on DioError catch (e) {
      if (e.response != null) {
        throw HttpException(e.response.data['message']);
      } else {
        throw HttpException(
            'Login failed, please make sure you connected to internet.');
      }
    }
  }

  Future<void> logout() async {
    await jwtService.removeFromSharedPreferences();
    _email = null;
    _isAuthenticated = false;
    Api.removeDefaultAuthHeader();
    notifyListeners();
  }

  void _setStateFromJwt(String jwt) {
    final payload = jwtService.decode(jwt);
    _isAuthenticated = true;
    _email = payload['email'];
    _userId = payload['id'];
    notifyListeners();
  }

  Future<void> _initializing() async {
    final jwt = await jwtService.getFromSharedPreferences();
    if (jwt != null) {
      final payload = jwtService.decode(jwt);
      final expired =
          DateTime.now().add(Duration(milliseconds: payload['exp']));
      if (expired.isAfter(DateTime.now())) {
        Api.setDefaultAuthHeader(jwt);
        _setStateFromJwt(jwt);
      }
    }
  }
}
