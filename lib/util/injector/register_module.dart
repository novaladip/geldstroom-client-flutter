import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/env.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get pref => SharedPreferences.getInstance();
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: Env.baseUrl,
        ),
      );
}
