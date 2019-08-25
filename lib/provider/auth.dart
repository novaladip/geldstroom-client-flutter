import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geldstroom/models/http_exception.dart';
import 'package:geldstroom/utils/api.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class Auth with ChangeNotifier {
  String _jwtToken;
  String _email;
  int _iat;
  int _exp;

  Auth() {
    // TODO Initializing state with decoded jwt from local storage
  }

  String get email {
    return _email;
  }

  int get iat {
    return _iat;
  }

  int get exp {
    return _exp;
  }

  void setStateFromJson(Map<String, dynamic> data) {
    _email = data['email'];
    _iat = data['iat'];
    _exp = data['exp'];
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      final data = {
        'email': email.toLowerCase(),
        'password': password,
      };

      final response = await api.post(Url.login, data: data);
      _jwtToken = response.data['accessToken'];
      final payload = _jwtDecode(_jwtToken);

      setStateFromJson(payload);
      setDefaultAuthHeader();
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

  Map<String, dynamic> _jwtDecode(String jwt) {
    final parts = jwt.split('.');
    final payload = parts[1];
    final decoded = B64urlEncRfc7515.decodeUtf8(payload);
    final Map<String, dynamic> parsedPayload = json.decode(decoded);
    return parsedPayload;
  }

  void setDefaultAuthHeader() {
    api.options.headers = {
      'Authorization': _jwtToken,
    };
  }
}
