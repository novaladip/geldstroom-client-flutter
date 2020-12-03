import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class JwtOps {
  const JwtOps(
    this._dio,
    this._preferences,
  );

  static const tokenKey = 'token';
  final Dio _dio;
  final SharedPreferences _preferences;

  /// adding a given token to Authorization header to dio
  ///
  /// pass an empty string to remove
  void setDefaultAuthHeader(String token) {
    _dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
  }

  /// fetch token from shared preferences
  String getToken() {
    return _preferences.getString(tokenKey);
  }

  /// persisting a given token to shared preferences
  Future<void> persistToken(String token) async {
    await _preferences.setString(tokenKey, token);
  }

  /// remove token from shared preferences
  Future<void> removeToken() async {
    await _preferences.remove(tokenKey);
  }

  /// Decoding JWT
  Map<String, dynamic> decodeJWT(String token) {
    return JwtDecoder.decode(token);
  }
}
