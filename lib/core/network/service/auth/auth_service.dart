import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/common/config/config.dart';
import '../../dto/login_dto.dart';
import '../../dto/register_dto.dart';
import '../../model/error_model.dart';

abstract class IAuthService {
  Future<Either<ServerError, String>> loginWithEmail(LoginDto dto);
  Future<Either<ServerError, None>> register(RegisterDto dto);
}

@LazySingleton(
  as: IAuthService,
  env: [Env.dev, Env.prod],
)
class AuthService implements IAuthService {
  const AuthService(this._dio);

  final Dio _dio;

  @override
  Future<Either<ServerError, String>> loginWithEmail(LoginDto dto) async {
    try {
      final res = await _dio.post('/user/login', data: dto.toMap);
      final accessToken = res.data['accessToken'];
      return Right(accessToken);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, None>> register(RegisterDto dto) async {
    try {
      await _dio.post('/user/register', data: dto.toMap);
      return Right(None());
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }
}
