import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:geldstroom/utils/jwt_ops.dart';

import 'package:geldstroom/models/http_exception.dart';
import 'package:geldstroom/utils/api.dart';

class Auth with ChangeNotifier {
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
      final data = {
        'email': email.toLowerCase(),
        'password': password,
      };

      final response = await api.post(Url.login, data: data);
      final jwt = response.data['accessToken'];
      await Jwt.save(jwt);
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
      final data = {
        'email': email.toLowerCase(),
        'password': password.toLowerCase()
      };
      await api.post(Url.register, data: data);
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
    await Jwt.removeFromSharedPreferences();
    _email = null;
    _isAuthenticated = false;
    Api.removeDefaultAuthHeader();
    notifyListeners();
  }

  void _setStateFromJwt(String jwt) {
    final payload = Jwt.decode(jwt);
    _isAuthenticated = true;
    _email = payload['email'];
    _userId = payload['id'];
    notifyListeners();
  }

  Future<void> _initializing() async {
    final jwt = await Jwt.getFromSharedPreferences();
    if (jwt != null) {
      final payload = Jwt.decode(jwt);
      final expired =
          DateTime.now().add(Duration(milliseconds: payload['exp']));
      if (expired.isAfter(DateTime.now())) {
        Api.setDefaultAuthHeader(jwt);
        _setStateFromJwt(jwt);
      }
    }
  }
}
