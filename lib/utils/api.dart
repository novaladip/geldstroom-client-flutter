import 'package:dio/dio.dart';

final options = BaseOptions(
  baseUrl: 'https://intense-springs-88456.herokuapp.com',
);

var api = new Dio(options);

class Url {
  static final login = '/auth/login';
  static final register = '/auth/register';
}
