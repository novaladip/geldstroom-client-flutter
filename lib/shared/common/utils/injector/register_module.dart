import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/config.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get pref => SharedPreferences.getInstance();
  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: Env.baseUrl,
        ),
      );
}
