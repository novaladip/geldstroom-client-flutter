import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/common/utils/jwt_ops/jwt_ops.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('JwtOps', () {
    const expectedToken =
        // ignore: lines_longer_than_80_chars
        'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAZ21haWwuY29tIiwiZXhwIjoxOTE5NTk1Nzg0LCJpZCI6ImZlYWYxYzA0LTZhNDYtNGRhNi04NDExLTE2OWNiMWYxZjY5ZSIsImlzQWRtaW4iOnRydWV9.Ymu_8Ivv3dtcGRqGMDgAfyldP8-Cfw7TZ-GdjaVDpxvcAMF_phYBCVFA2X4-O8lxOZijIqreYj-8gbxLN4U3Aw';

    JwtOps jwtOps;
    SharedPreferences mockSharedPreferences;
    final dio = Dio();

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      jwtOps = JwtOps(dio, mockSharedPreferences);
    });

    test(
        'setDefaultAuthHeader() '
        'given a token and should change '
        'dio.options.header["Authorization"] base on given token', () {
      jwtOps.setDefaultAuthHeader(expectedToken);
      expect(dio.options.headers['Authorization'], 'Bearer $expectedToken');
    });

    test('getToken() should return string', () {
      when(mockSharedPreferences.getString(any)).thenReturn(expectedToken);
      final token = jwtOps.getToken();
      expect(token, expectedToken);
    });

    test(
        'persistToken() given a token and should call '
        'SharedPreferences.setString with JwtOps.tokenKey and given token', () {
      jwtOps.persistToken(expectedToken);
      verify(mockSharedPreferences.setString(JwtOps.tokenKey, expectedToken));
    });

    test(
        'removeToken() should call SharedPreferences.remove with '
        'JwtOps.tokenKey', () {
      jwtOps.removeToken();
      verify(mockSharedPreferences.remove(JwtOps.tokenKey));
    });

    test('decodeJWT() should decode given token to be Map<String, dynamic>',
        () {
      final decodedJwt = jwtOps.decodeJWT(expectedToken);
      expect(decodedJwt, {
        'email': 'test@gmail.com',
        'exp': 1919595784,
        'id': 'feaf1c04-6a46-4da6-8411-169cb1f1f69e',
        'isAdmin': true
      });
    });
  });
}
