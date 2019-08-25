import 'package:dio/dio.dart';

final options = BaseOptions(
  baseUrl: 'https://intense-springs-88456.herokuapp.com',
);

final api = new Dio(options);

class Api {
  static void setDefaultAuthHeader(String jwt) {
    api.options.headers = {
      'Authorization': jwt,
    };
  }

  static void removeDefaultAuthHeader() {
    api.options.headers = {
      'Authorization': '',
    };
  }
}

class Url {
  static final login = '/auth/login';
  static final register = '/auth/register';
}
